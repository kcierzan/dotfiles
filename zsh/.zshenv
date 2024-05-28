export ZDOTDIR="$HOME/.config/zsh"
export HISTFILE=10000
export SAVEHIST=10000

export GOPATH=$HOME/go

if [ "$(uname)" = 'Darwin' ]; then
    export EDITOR='open -a /Applications/Emacs.app --args'
    export VISUAL='open -a /Applications/Emacs.app --args'
else
    export EDITOR='emacs'
    export VISUAL='emacs'
fi

export LESS='-F -g -i -M -R -S -w -X -z-4'
export CLICOLOR=1
export LSCOLORS='ExFxBxDxCxegedxbxgxcxd'
export VIRTUAL_ENV_DISABLE_PROMPT=1
export BAT_THEME='base16'
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always {}'
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS='--color=fg:-1,bg:-1,fg+:4,bg+:-1,header:3,hl:-1,hl+:3,prompt:4,spinner:5,pointer:5,marker:4,info:4'
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export HISTFILE="$ZDOTDIR/.zhistory"
