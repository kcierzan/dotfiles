if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    set fish_cursor_default underscore
    set fish_cursor_insert underscore
    set fish_cursor_unknown underscore
    starship init fish | source
    zoxide init fish | source 
end

fish_add_path "$HOME/.local/bin" "$HOME/.scripts" '/usr/local/bin' '/usr/local/sbin' '/usr/bin' '/usr/sbin' '/sbin' '/opt/X11/bin' "$HOME/.cargo/bin" "$HOME/.composer/vendor/bin" '/Library/TeX/Distributions/Programs/texbin'
set -gx EDITOR 'nvim'
set -gx VISUAL 'nvim'
set -gx PAGER 'less'
set -gx LANG 'en_US.UTF-8'
set -gx LESS '-F -g -i -M -R -S -w -X -z-4'

set -gx FZF_COMPLETION_TRIGGER '**'
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob "!.git/*" -g "!*.pyc" --iglob "!tags" 2> /dev/null"
set -gx FZF_DEFAULT_OPTS '--color=fg:-1,bg:-1,fg+:4,bg+:-1,header:3,hl:-1,hl+:3,prompt:4,spinner:5,pointer:5,marker:4,info:4'
set -gx FZF_PREVIEW_COMMAND 'bat --style=numbers --color=always {}'
set -gx KEYTIMEOUT 1
set -gx CLICOLOR 1
set -gx LSCOLORS 'ExFxBxDxCxegedxbxgxcxd'
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx ZSH_AUTOSUGGEST_USE_ASYNC 1
set -gx CM_LAUNCHER 'rofi'
set -gx HV_SRC_PART "git"
set -gx HV_SRC "$HOME/$HV_SRC_PART"
set -gx NVIM_LISTEN_ADDRESS '/tmp/nvimsocket'
set -gx BAT_THEME 'base16'

set fish_color_param normal
set fish_color_error red --bold
set fish_color_command 'a0c980' --bold

abbr -a vim nvim
abbr -a vi nvim
abbr -a sed gsed
abbr -a awk gawk
abbr -a find gfind
abbr -a e subl
abbr -a xargs gxargs
abbr -a tar gtar
abbr -a tl 'tmux list-sessions'
abbr -a ta 'tmux attach'
abbr -a tn 'tmux new-session'

bind -M insert \cF findfile
bind -M insert \cG grepfiles
bind -M insert \cE forward-char

if test (uname) = "Darwin"
  source /usr/local/opt/asdf/libexec/asdf.fish
else
  source /opt/asdf-vm/asdf.fish
end
