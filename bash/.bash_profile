export PATH="$HOME/.local/bin:/opt/homebrew/opt/postgresql@15/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/sbin:$HOME/.cargo/bin:/bin:$HOME/.emacs.d/bin"

export GOPATH=$HOME/go
export EDITOR=nvim
export VISUAL=nvim

export LESS='-F -g -i -M -R -S -w -X -z-4'
export CLICOLOR=1
export LSCOLORS='ExFxBxDxCxegedxbxgxcxd'
export VIRTUAL_ENV_DISABLE_PROMPT=1
export BAT_THEME='base16'
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always {}'
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS='--color=fg:-1,bg:-1,fg+:4,bg+:-1,header:3,hl:-1,hl+:3,prompt:4,spinner:5,pointer:5,marker:4,info:4'
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

[ -f ~/.bashrc ] && source ~/.bashrc
