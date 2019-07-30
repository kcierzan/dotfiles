#                __
#    ____  _____/ /_  __________
#   /_  / / ___/ __ \/ ___/ ___/
#  _ / /_(__  ) / / / /  / /__
# (_)___/____/_/ /_/_/   \___/

# avoid fancy prompt stuff when in emacs
if [[ $TERM == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    PS1="%(?..[%?])%~ ❯ "
else
  # source prezto if its installed
  if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
      source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
  fi
fi

# load fasd from cache
fasd_cache="$HOME/.fasd-init-cache"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# lazy load rbenv
rbenv() { eval "$( command rbenv init - --no-rehash )" && rbenv "$@" }

# lazy load pyenv-virtualenv
pyenv-virtualenv-init() {
    eval "$( command pyenv virtualenv-init - )"
    pyenv-virtualenv-init "$@"
}

# Defer initialization of nvm until nvm, node or a node-dependent command is
# run. Ensure this block is only run once if .zshrc gets sourced multiple times
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

# initialize fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.zsh/aliases.zsh
source ~/.zsh/extra.zsh

if [[ "$OSTYPE" == darwin* ]]; then
  source ~/.zsh/vi_cursor.zsh
fi

if [[ "$OSTYPE" = 'linux-gnu' ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
fi
