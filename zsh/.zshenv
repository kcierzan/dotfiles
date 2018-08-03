export PATH="$HOME/.pyenv/shims:$HOME/.rbenv/shims:$HOME/.scripts:/usr/local/bin:/usr/local/sbin:$JAVA_HOME:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/.cargo/bin"

export LESS_TERMCAP_mb=$(printf "\e[1;34m")
export LESS_TERMCAP_md=$(printf "\e[1;34m")
export LESS_TERMCAP_me=$(printf "\e[0m")
export LESS_TERMCAP_so=$(printf "\e[1;47;33m")
export LESS_TERMCAP_se=$(printf "\e[0m")
export LESS_TERMCAP_us=$(printf "\e[1;32m")
export LESS_TERMCAP_ue=$(printf "\e[0m")
export PAGER="${commands[less]:-$PAGER}"

export FZF_COMPLETION_TRIGGER='**'

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" -g "!*.pyc" -g "!tags" -g "!TAGS" 2> /dev/null'

export FZF_DEFAULT_OPTS='
--color=fg:#839496,bg:-1,fg+:2,bg+:-1,header:3
--color=hl:3,hl+:13,prompt:6,spinner:5,pointer:4,marker:4,info:6'

export KEYTIMEOUT=1

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedxbxgxcxd

export LS_COLORS="di=1;34:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"

export VIRTUAL_ENV_DISABLE_PROMPT=1

export ZSH_AUTOSUGGEST_USE_ASYNC=1

# lazy load pyenv... yeah...
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

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
