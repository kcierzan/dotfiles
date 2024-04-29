# use emacs keybinds
bindkey -e

# do not write duplicate events to the history file
setopt HIST_SAVE_NO_DUPS

# initialize direnv
eval "$(direnv hook zsh)"

# initialize fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# initialize starship
eval "$(starship init zsh)"

# initialize zoxide
eval "$(zoxide init zsh)"

# initialize mise
eval "$(mise activate zsh)"

# set up aliases
alias g='git'
alias gr='grepfiles'
alias ff='findfile'
alias la='lsd -lah'
alias be='bundle exec'
alias gs='git status'
alias reload="exec zsh"

#shellcheck source=/dev/null
[ -f ~/.bootstrap/env.sh ] && source "$HOME/.bootstrap/env.sh"

# load plugin manager
[ -f "$HOMEBREW_ROOT/opt/antidote/share/antidote/antidote.zsh" ] && source "$HOMEBREW_ROOT/opt/antidote/share/antidote/antidote.zsh"
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# load zsh completion system
[ -f "$ZDOTDIR/completion.zsh" ] && source "$ZDOTDIR/completion.zsh"

source "$HOME/.functions.sh"
