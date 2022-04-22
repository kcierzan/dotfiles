if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    set fish_cursor_default underscore
    set fish_cursor_insert underscore
    set fish_cursor_unknown underscore

    # bind commonly-used functions to keys
    bind -M insert \cF findfile
    bind -M insert \cG grepfiles
    bind -M insert \cE forward-char
    bind -M insert \cO nnn-browser
    bind -M insert \cR fzf-history
    bind -M insert \cP fkill
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
set -gx ZSH_AUTOSUGGEST_USE_ASYNC 1
set -gx CM_LAUNCHER 'rofi'

set fish_color_param normal
set fish_color_error red --bold
set fish_color_command 'a0c980' --bold

# asdf works a little differently across environments
if test (uname) = "Darwin"
  set -l is_m1 (sysctl -a | rg 'machdep.cpu.brand_string: Apple M1')
  if test -n "$is_m1"
    source /opt/homebrew/opt/asdf/libexec/asdf.fish
  else
    source /usr/local/opt/asdf/libexec/asdf.fish
  end
else
  source /opt/asdf-vm/asdf.fish
end
