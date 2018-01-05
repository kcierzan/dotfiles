set -x PATH $HOME/.rbenv/shims /usr/local/bin /usr/local/sbin $JAVA_HOME /usr/bin /bin /usr/sbin /sbin

set -x JAVA_HOME "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Home/bin"
set -x EDITOR nvim
set -x VISUAL nvim
set -x GIT_EDITOR nvim
set -x PYENV_ROOT ~/.pyenv
set -x NVM_DIR "$HOME/.nvm"
set -x FZF_COMPLETION_TRIGGER "**"
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*" -g "!*.pyc"'
set -x FZF_DEFAULT_OPTS "--color=fg:#839496,bg:-1,fg+:6,bg+:-1,header:3,hl:3,hl+:13,prompt:6,spinner:5,pointer:2,marker:4,info:2"
set -x KEYTIMEOUT 1
set -x CLICOLOR 1
set -x LSCOLORS ExFxBxDxCxegedxbxgxcxd
set -x LS_COLORS "di=1;34:ln=1;35:so=1;31:pi=1;33:ex=1;32:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x SHELL "/usr/local/bin/zsh"
set -x ESHELL "/usr/loca/bin/zsh"
