#               __
#   ____  _____/ /_  __________
#  /_  / / ___/ __ \/ ___/ ___/
# _ / /_(__  ) / / / /  / /__
#(_)___/____/_/ /_/_/   \___/

source ~/.zsh_config

# jump around
f() {
    eval "$( command fasd --init auto )"
    fasd -f "$@"
}
a() {
    eval "$( command fasd --init auto )"
    fasd -a "$@"
}
s() {
    eval "$( command fasd --init auto )"
    fasd -si "$@"
}
d() {
    eval "$( command fasd --init auto )"
    fasd -d "$@"
}
z() {
    eval "$( command fasd --init auto )"
    fasd_cd -d "$@"
}

# Enable rbenv
rbenv() {
    eval "$( command rbenv init - --no-rehash )"
    rbenv "$@"
}

pyenv-virtualenv-init() {
    eval "$( command pyenv virtualenv-init - )"
    pyenv-virtualenv-init "$@"
}

prepend_path_if_not_in_already() {
  local i
  for i; do
    (( ${path[(i)$i]} <= ${#path} )) && continue
    path=($i $path)
  done
}

if [[ -d ~/.pyenv ]] && ! (( $+functions[zsh_setup_pyenv] )); then # only once!
  if ! (( $+PYENV_ROOT )); then
    export PYENV_ROOT="$HOME/.pyenv"
  fi
  # TODO: Prepend paths always?! (https://github.com/yyuu/pyenv/issues/492).
  #       Would allow for using PYENV_VERSION in (Zsh) scripts always.
  #       But already done in ~/.profile?!
  prepend_path_if_not_in_already $PYENV_ROOT/bin
  # Prepend pyenv shims path always, it gets used also for lookup in
  # VIRTUAL_ENV, and ~/.local/bin should not override it (e.g. for vint).
  path=($PYENV_ROOT/shims $path)

  # Setup pyenv completions always.
  # (it is useful to have from the beginning, and using it via zsh_setup_pyenv
  # triggers a job control bug in Zsh).
  source $PYENV_ROOT/completions/pyenv.zsh

  zsh_setup_pyenv() {
    # Manual pyenv init, without "source", which triggers a bug in zsh.
    # Adding shims to $PATH etc has been already also.
    # eval "$(command pyenv init - --no-rehash | grep -v '^source')"
    export PYENV_SHELL=zsh
    pyenv() {
      local command
      command="$1"
      if [ "$#" -gt 0 ]; then
        shift
      fi

      case "$command" in
        activate|deactivate|rehash|shell|virtualenvwrapper|virtualenvwrapper_lazy)
          eval "`pyenv "sh-$command" "$@"`";;
        *)
          command pyenv "$command" "$@";;
      esac
    }
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    unfunction zsh_setup_pyenv
  }
  pyenv() {
    if [[ -n ${commands[pyenv]} ]]; then
      zsh_setup_pyenv
      pyenv "$@"
    fi
  }
fi

# Setup pyenv (with completion for zsh).
# It gets done also in ~/.profile, but that does not cover completion and
# ~/.profile is not sourced for real virtual consoles (VTs).
autoload -U add-zsh-hook
_pyenv_lazy_load() {
  if (( $+functions[zsh_setup_pyenv] )); then
    if [[ -f $PWD/.python-version ]]; then
      zsh_setup_pyenv
    else
      return
    fi
  fi
  add-zsh-hook -d chpwd _pyenv_lazy_load
}
add-zsh-hook chpwd _pyenv_lazy_load

# setup nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
    (( $+commands[brew] )) && {
        local pfx=$(brew --prefix)
        [[ -f "$pfx/opt/nvm/nvm.sh" ]] && source "$pfx/opt/nvm/nvm.sh"
        nvm "$@"
  }
}

# fzf initialization
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# POWERLEVEL9K_MODE='nerdfont-complete'

# Run zplug
export ZPLUG_HOME="/usr/local/opt/zplug"
source $ZPLUG_HOME/init.zsh

# ------------ ZPLUG ------------------------
# zplug "bhilburn/powerlevel9k",           from:github,   use:powerlevel9k.zsh-theme, as:theme
zplug "zsh-users/zsh-autosuggestions",   use:zsh-autosuggestions.zsh
zplug "frmendes/geometry"
zplug "unixorn/warhol.plugin.zsh"
zplug "zsh-users/zsh-syntax-highlighting"

export GEOMETRY_PROMPT_PLUGINS=(git tag virtualenv vi_mode)
export GEOMETRY_COLOR_VIRTUALENV=blue
export GEOMETRY_SYMBOL_PROMPT=''
export GEOMETRY_SYMBOL_EXIT_VALUE=''
export GEOMETRY_COLOR_PROMPT='yellow'
export GEOMETRY_COLOR_EXIT_VALUE='red'
export GEOMETRY_COLOR_DIR='magenta'
export PROMPT_GEOMETRY_GIT_TIME=false
export GEOMETRY_SYMBOL_GIT_REBASE="\ue726"
export GEOMETRY_COLOR_GIT_BRANCH=6

zplug load
# Source additional dotfiles
source ~/.exports
source ~/.aliases
source ~/.functions
source ~/.extra
source ~/.tag_plugin
source ~/.vi_mode_plugin
