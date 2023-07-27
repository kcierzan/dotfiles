if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_cursor_default line
    fish_default_key_bindings
    bind \eg grepfiles
    bind \ep findfile
    bind \ej zoxide-fzf
    bind \ev lazygit
    bind \ei br

    if command --query starship
        starship init fish | source
    else
        echo "starship not found!"
    end

    if command --query zoxide
        zoxide init fish | source
    else
        echo "zoxide not found!"
    end

    if command --query rtx
      rtx activate fish | source
    else
      echo "rtx not found!"
    end

    if command --query direnv
        direnv hook fish | source
    else
        echo "direnv not found!"
    end
end

fish_add_path "$HOME/.local/bin" /opt/homebrew/bin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin /sbin "$HOME/.cargo/bin"

set -gx LESS '-F -g -i -M -R -S -w -X -z-4'
set -gx KEYTIMEOUT 1
set -gx CLICOLOR 1
set -gx LSCOLORS ExFxBxDxCxegedxbxgxcxd
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set fish_color_param normal
set fish_color_error red --bold
set fish_color_command a0c980 --bold
