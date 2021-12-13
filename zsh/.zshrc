# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# if we don't have zinit already installed, install it
if [[ ! -d ~/.local/share/zinit/ ]]; then
  sh -c "$(curl -fsSL https://git.io/zinit-install)"
fi

# set up zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# avoid fancy prompt stuff when in emacs
if [[ $TERM == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    PS1="%(?..[%?])%~ ❯ "
fi

# direnv
zinit as"program" make"!" atclone'./direnv hook zsh > zhook.zsh' \
  atpull'%atclone' pick"direnv" src"zhook.zsh" for \
  direnv/direnv

# LS_COLORS
zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    atpull'%atclone' pick"clrs.zsh" nocompile'!' \
    atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zinit light trapd00r/LS_COLORS

# set zsh preferences
zinit ice silent wait
zinit snippet ~/.zsh/prefs.zsh

# zvm configuration
function zvm_config() {
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE
}

# vi mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# install powerlevel10k prompt
zinit light romkatv/powerlevel10k

# highlight shell commands if they exist in $PATH
zinit ice silent wait
zinit light zdharma-continuum/fast-syntax-highlighting

# prezto completion
zinit ice silent wait svn
zinit snippet PZT::modules/completion

# autosuggestions
zinit ice silent wait atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# os-specific aliases, functions, and keybindings
zinit ice silent wait
zinit snippet ~/.zsh/aliases.zsh

zinit ice silent wait
zinit snippet ~/.zsh/completion.zsh

# configure powerlevel10k prompt
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
#
# initialize fzf
[ -f ~/.fzf.zsh ] && zinit ice silent wait && zinit snippet ~/.fzf.zsh

# load fasd from cache
fasd_cache="$HOME/.fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi

# set up fasd
zinit ice silent wait atload"unset fasd_cache"
zinit snippet "$fasd_cache"
