#                __
#    ____  _____/ /_  ___  ____ _   __
#   /_  / / ___/ __ \/ _ \/ __ \ | / /
#  _ / /_(__  ) / / /  __/ / / / |/ /
# (_)___/____/_/ /_/\___/_/ /_/|___/

# Remeber to comment out the annoying shenanigans going on in /etc/zprofile
# Just place anything in /etc/paths.d into $PATH as defined here
export PATH="$HOME/.pyenv/shims:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin"

export EDITOR='nvim'
export GIT_EDITOR='nvim'

export PYENV_ROOT=~/.pyenv
export NVM_DIR="$HOME/.nvm"
export ZPLUG_HOME="/usr/local/opt/zplug"

export FZF_COMPLETION_TRIGGER='**'

# the silver searcher - for when ripgrep is busted.
# export FZF_DEFAULT_COMMAND='ag --hidden --follow --ignore="**.pyc" --ignore="**.min.*" -g ""'

# ripgrep has issues with writing output to a broken pipe - it is 'fixed' for now...
# https://github.com/BurntSushi/ripgrep/issues/200
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" -g "!*.pyc"'

# One Dark Theme for FZF
export FZF_DEFAULT_OPTS='
--color=fg:#bbc2cf,bg:-1,fg+:4,bg+:-1,header:3
--color=hl:241,hl+:12,prompt:6,spinner:5,pointer:2,marker:4,info:2'

# Fast key repeat
export KEYTIMEOUT=1

# Geometry ZSH prompt theme settings

# You're going to want a patched font. I like Iosevka.
# Available here: https://github.com/ryanoasis/nerd-fonts
export GEOMETRY_PROMPT_PLUGINS=(git tag virtualenv vi_mode)
export GEOMETRY_COLOR_VIRTUALENV=4
export GEOMETRY_SYMBOL_PROMPT=' '
# export GEOMETRY_SYMBOL_PROMPT=' '
# export GEOMETRY_SYMBOL_PROMPT=''
# export GEOMETRY_SYMBOL_PROMPT=''
# export GEOMETRY_SYMBOL_PROMPT='λ'
export GEOMETRY_SYMBOL_EXIT_VALUE=''
export GEOMETRY_SYMBOL_GIT_CLEAN=''
export GEOMETRY_COLOR_GIT_CLEAN=2
export GEOMETRY_SYMBOL_GIT_DIRTY=''
export GEOMETRY_COLOR_GIT_DIRTY=1
export GEOMETRY_SYMBOL_GIT_CONFLICTS_SOLVED=''
export GEOMETRY_COLOR_GIT_CONFLICTS_SOLVED=2
export GEOMETRY_SYMBOL_GIT_CONFLICTS_UNSOLVED=''
export GEOMETRY_COLOR_GIT_CONFLICTS_UNSOLVED=1
export GEOMETRY_COLOR_PROMPT=6
export GEOMETRY_COLOR_EXIT_VALUE=1
export GEOMETRY_COLOR_DIR=5
export PROMPT_GEOMETRY_GIT_TIME=false
export GEOMETRY_SYMBOL_GIT_REBASE="\ue726"
export GEOMETRY_COLOR_GIT_BRANCH=3

# One Dark LSCOLORS
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedxbxgxcxd

# Now in GNU flavor
export LS_COLORS="di=1;34:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"

# This is the default setting but lets make sure
export ZSH_AUTOSUGGEST_USE_ASYNC='1'

export VIRTUAL_ENV_DISABLE_PROMPT=1

# Lazy load pyenv... yeah...
if [[ -d ~/.pyenv ]] && ! (( $+functions[zsh_setup_pyenv] )); then # only once!
  if ! (( $+PYENV_ROOT )); then
    export PYENV_ROOT="$HOME/.pyenv"
  fi

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
