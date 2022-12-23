if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_unknown underscore

    # bind commonly-used functions to keys
    bind -M insert \cf findfile
    bind -M insert \cG grepfiles
    bind -M insert \ce forward-char
    bind -M insert \co xplr-key
    bind -M insert \cr fzf-history
    bind -M insert \cp fkill
    bind -M insert \cb fzf-git-checkout

    starship init fish | source
    zoxide init fish | source 
    direnv hook fish | source
end

fish_add_path "$HOME/.local/bin" "$HOME/.local/bin-jetbrains" '/opt/homebrew/bin' '/usr/local/bin' '/usr/local/sbin' '/usr/bin' '/usr/sbin' '/sbin' '/opt/X11/bin' "$HOME/.cargo/bin" "$HOME/.composer/vendor/bin" '/Library/TeX/Distributions/Programs/texbin'

set -gx LESS '-F -g -i -M -R -S -w -X -z-4'
set -gx KEYTIMEOUT 1
set -gx CLICOLOR 1
set -gx LSCOLORS 'ExFxBxDxCxegedxbxgxcxd'
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set fish_color_param normal
set fish_color_error red --bold
set fish_color_command 'a0c980' --bold

source "$(brew --prefix)/opt/asdf/libexec/asdf.fish"
