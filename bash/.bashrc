eval "$(direnv hook bash)"

eval "$(mise activate bash)"

#shellcheck source=/dev/null
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

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
source "$HOME/.bootstrap/env.sh"

