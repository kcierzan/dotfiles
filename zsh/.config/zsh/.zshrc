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
alias lg='lazygit'
alias ..='cd ..'
alias ...="cd ../../"
alias ....="cd ../../../"

emacs-dev() {
    /Applications/Emacs.app/Contents/MacOS/Emacs "$@" --init-directory ~/.custom
}

# interactive cd
icd() {
    zi && zle reset-prompt
}

# initialize direnv
eval "$(direnv hook zsh)"

# initialize starship
eval "$(starship init zsh)"

# initialize zoxide
eval "$(zoxide init zsh)"

#shellcheck source=/dev/null
[ -f ~/.bootstrap/env.sh ] && source "$HOME/.bootstrap/env.sh"

if [[ "$(uname)" = 'Darwin' ]]; then
    eval "$(rbenv init -)"
fi

# initialize mise
eval "$(mise activate zsh)"

# initialize fzf
eval "$(fzf --zsh)"

# load plugin manager
[ -f "$HOMEBREW_ROOT/opt/antidote/share/antidote/antidote.zsh" ] && source "$HOMEBREW_ROOT/opt/antidote/share/antidote/antidote.zsh"
[ -f "/usr/share/zsh-antidote/antidote.zsh" ] && source "/usr/share/zsh-antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# load zsh completion system
[ -f "$ZDOTDIR/completion.zsh" ] && source "$ZDOTDIR/completion.zsh"

# load shell functions
source "$HOME/.functions.sh"

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
