# Path
export PATH="~/.pyenv/shims:$HOME/.rbenv/shims:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"

export EDITOR='nvim'

export PYENV_ROOT=~/.pyenv
export NVM_DIR="$HOME/.nvm"
export ZPLUG_HOME="/usr/local/opt/zplug"

export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" -g "!*.pyc"'

export KEYTIMEOUT=1

export VIRTUAL_ENV_DISABLE_PROMPT=1

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

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

export ZSH_AUTOSUGGEST_USE_ASYNC='1'

# Lazy load pyenv
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
