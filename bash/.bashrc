eval "$(direnv hook bash)"
eval "$(mise activate bash)"

command -v fzf > /dev/null 2>&1 && eval "$(fzf --bash)"

eval "$(starship init bash)"
eval "$(zoxide init bash)"

alias g='git'
alias gr='grepfiles'
alias lg='lazygit'
alias ff='findfile'
alias la='lsd -lah'
alias be='bundle exec'
alias gs='git status'
alias reload='source ~/.bash_profile'

#shellcheck source=/dev/null
[ -f "$HOME/.boostrap/env.sh" ] && source "$HOME/.bootstrap/env.sh"

source ~/.functions.sh
