export PATH="$HOME/.jenv/bin:$HOME/.pyenv/bin:$HOME/.pyenv/shims:$HOME/.rbenv/shims:$HOME/.local/bin:$HOME/.scripts:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:$HOME/.cargo/bin:$HOME/.composer/vendor/bin:/Library/TeX/Distributions/Programs/texbin"

export LESS='-F -g -i -M -R -S -w -X -z-4'
export LESS_TERMCAP_mb=$'\E[01;31m'      # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'      # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'          # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'          # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m'   # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'          # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'      # Begins underline.
export PAGER="${commands[less]:-$PAGER}"

export FZF_COMPLETION_TRIGGER='**'

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" -g "!*.pyc" --iglob "!tags" 2> /dev/null'

export FZF_DEFAULT_OPTS='--color=fg:#839496,bg:-1,fg+:4,bg+:-1,header:3,hl:-1,hl+:3,prompt:4,spinner:5,pointer:5,marker:4,info:4'

export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always {}'

export KEYTIMEOUT=1

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedxbxgxcxd

export LS_COLORS="di=1;34:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"

export VIRTUAL_ENV_DISABLE_PROMPT=1

export ZSH_AUTOSUGGEST_USE_ASYNC=1

export CM_LAUNCHER=rofi

export HV_SRC_PART="git"
export HV_SRC="$HOME/$HV_SRC_PART"

export NVIM_LISTEN_ADDRESS=/tmp/nvimsocket

# Lazy load pyenv
if type pyenv > /dev/null; then
    function pyenv() {
        unset -f pyenv
        eval "$(command pyenv init -)"
        if [[ -n "${ZSH_PYENV_LAZY_VIRTUALENV}" ]]; then
            eval "$(command pyenv virtualenv-init -)"
        fi
        pyenv $@
    }
fi

# lazy load jenv
if type jenv > /dev/null; then
  function jenv() {
    unset -f jenv
    eval "$(command jenv init -)"
    jenv $@
  }
fi

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# source colorscheme-related envvars
source "$HOME/.zsh/zshcolors"
source "$HOME/.thematic/theme.zsh"

source ~/.zsh/extra.zsh
