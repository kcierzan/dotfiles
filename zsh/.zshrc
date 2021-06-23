# Fire up direnv
eval "$(direnv hook zsh)"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -d ~/.zinit ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz zinit
(( ${+_comps} )) && _comps[zinit]=zinit

# avoid fancy prompt stuff when in emacs
if [[ $TERM == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    PS1="%(?..[%?])%~ ❯ "
fi

if [[ "$OSTYPE" = 'linux-gnu' ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi

# set zsh preferences
zinit ice silent wait
zinit snippet ~/.zsh/prefs.zsh

### Added by Zplugin's installer
zinit ice silent wait
zinit snippet "$HOME/.zsh/vi_cursor.zsh"
### End of Zplugin's installer chunk

# install plugins
zinit light romkatv/powerlevel10k
zinit ice silent wait
zinit light zdharma/fast-syntax-highlighting
zinit ice silent wait svn
zinit snippet PZT::modules/completion
zinit ice silent wait atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# set up some aliases
zinit ice silent wait
zinit snippet ~/.zsh/aliases.zsh

# configure powerlevel10k prompt
zinit ice silent
[ -f ~/.p10k.zsh ] && zinit snippet ~/.p10k.zsh
#
# initialize fzf
zinit ice silent wait
[ -f ~/.fzf.zsh ] && zinit snippet ~/.fzf.zsh

# load fasd from cache
fasd_cache="$HOME/.fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi

zinit ice silent wait atload"unset fasd_cache"
zinit snippet "$fasd_cache"

zinit ice silent wait
zinit snippet /usr/local/opt/asdf/asdf.sh

# enable completions from homebrew
if type brew &>/dev/null; then
    FPATH=/usr/local/share/zsh/site-functions:$FPATH
    autoload -Uz compinit
    compinit
fi

zinit cdreplay -q
