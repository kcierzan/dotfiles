# use emacs keybinds
bindkey -e

# do not write duplicate events to the history file
setopt HIST_SAVE_NO_DUPS

# set up aliases
alias g='git'
alias la='lsd -lah'
alias be='bundle exec'
alias gs='git status'
alias reload="exec zsh"
alias ..='cd ..'
alias ...="cd ../../"
alias ....="cd ../../../"
alias vim='nvim'

# interactive cd
icd() {
    zi && zle reset-prompt
}

lg() {
    lazygit && zle reset-prompt
}

# initialize starship
eval "$(starship init zsh)"

# initialize zoxide
eval "$(zoxide init zsh)"
#
# initialize fzf
source <(fzf --zsh)

# load shell functions
source "$HOME/.functions.sh"

# load plugin manager
[ -f "$HOMEBREW_ROOT/opt/antidote/share/antidote/antidote.zsh" ] && source "$HOMEBREW_ROOT/opt/antidote/share/antidote/antidote.zsh"
[ -f "/usr/share/zsh-antidote/antidote.zsh" ] && source "/usr/share/zsh-antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# load zsh completion system
[ -f "$ZDOTDIR/completion.zsh" ] && source "$ZDOTDIR/completion.zsh"

zle -N ifile
zle -N igrep
zle -N lg
zle -N icd

bindkey '^[p' ifile
bindkey '^[g' igrep
bindkey '^[v' lg
bindkey '^[j' icd

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
