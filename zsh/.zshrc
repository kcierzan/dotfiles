#                __
#    ____  _____/ /_  __________
#   /_  / / ___/ __ \/ ___/ ___/
#  _ / /_(__  ) / / / /  / /__
# (_)___/____/_/ /_/_/   \___/

fasd_cache="$HOME/.fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

rbenv() { eval "$( command rbenv init - --no-rehash )" && rbenv "$@" }

# Lazy load pyenv-virtualenv
pyenv-virtualenv-init() {
    eval "$( command pyenv virtualenv-init - )"
    pyenv-virtualenv-init "$@"
}

# Lazy load nvm
# nvm() {
#     (( $+commands[brew] )) && {
#         local pfx=$(brew --prefix)
#         [[ -f "$pfx/opt/nvm/nvm.sh" ]] && source "$pfx/opt/nvm/nvm.sh"
#         nvm "$@"
#   }
# }

# export NVM_DIR="$HOME/.nvm"
# . "/usr/local/opt/nvm/nvm.sh"

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .bashrc gets sourced multiple times
# by checking whether __init_nvm is a function.
if [ -s "/usr/local/opt/nvm/nvm.sh" ] && [ ! "$(whence -w __init_nvm)" = function ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  declare -a __node_commands=('nvm' 'node' 'npm' 'yarn' 'gulp' 'grunt' 'webpack')
  function __init_nvm() {
    for i in "${__node_commands[@]}"; do unalias $i; done
    . /usr/local/opt/nvm/nvm.sh
    unset __node_commands
    unset -f __init_nvm
  }
  for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

# Initialize fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source ~/.zsh/aliases.zsh
source ~/.zsh/extra.zsh

echo -en "\033]6;1;bg;red;brightness;40\a"
echo -en "\033]6;1;bg;green;brightness;44\a"
echo -en "\033]6;1;bg;blue;brightness;52\a"

if [[ -z "$TMUX" ]] ;then
    ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        tmux new-session
    else
        tmux attach-session -t "$ID" # if available attach to it
    fi
fi
