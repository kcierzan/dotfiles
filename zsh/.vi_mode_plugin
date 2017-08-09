GEOMETRY_VI_MODE_SYMBOL_INSERT=${GEOMETRY_VI_MODE_SYMBOL_INSERT:-""}
GEOMETRY_VI_MODE_SYMBOL_NORMAL=${GEOMETRY_VI_MODE_SYMBOL_NORMAL:-""}

GEOMETRY_VI_MODE_COLOR_INSERT=${GEOMETRY_VI_MODE_COLOR_INSERT:-green}
GEOMETRY_VI_MODE_COLOR_NORMAL=${GEOMETRY_VI_MODE_COLOR_NORMAL:-blue}

# Enable changing cursor shapes and blinking

geometry_prompt_vi_mode_setup() {
  bindkey -v

  function zle-keymap-select zle-line-init {
    case $KEYMAP in
      vicmd)
        set_cursor_shape 0 # block cursor
        # RPROMPT="$(prompt_geometry_colorize $GEOMETRY_VI_MODE_COLOR_NORMAL $GEOMETRY_VI_MODE_SYMBOL_NORMAL)"
        ;;
      viins|main)
        set_cursor_shape 1 # line cursor
        # RPROMPT="$(prompt_geometry_colorize $GEOMETRY_VI_MODE_COLOR_INSERT $GEOMETRY_VI_MODE_SYMBOL_INSERT)"
        ;;
    esac
    VIMODE="${${KEYMAP/vicmd/$(prompt_geometry_colorize $GEOMETRY_VI_MODE_COLOR_NORMAL $GEOMETRY_VI_MODE_SYMBOL_NORMAL)}/(main|viins)/$(prompt_geometry_colorize $GEOMETRY_VI_MODE_COLOR_INSERT $GEOMETRY_VI_MODE_SYMBOL_INSERT)}"
    RPROMPT=${VIMODE}
    zle reset-prompt
    zle -R
  }

  function print_dcs {
    print -n -- "\EP$1;\E$2\E\\"
  }

  function set_cursor_shape {
    if [ -n "$TMUX" ]; then
      # tmux will only forward escape sequences to the terminal if surrounded by
      # a DCS sequence
      print_dcs tmux "\E]50;CursorShape=$1\C-G"
    else
      print -n -- "\E]50;CursorShape=$1\C-G"
    fi
  }

  function zle-line-finish {
    set_cursor_shape 0 # block cursor
  }

  zle -N zle-line-init
  zle -N zle-line-finish
  zle -N zle-keymap-select

  # Vi mode breaks uparrow completion. Fix it.
  # start typing + [Up-Arrow] - fuzzy find history forward
  if [[ "${terminfo[kcuu1]}" != "" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
    bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
  fi
  # start typing + [Down-Arrow] - fuzzy find history backward
  if [[ "${terminfo[kcud1]}" != "" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
  fi
}


geometry_prompt_vi_mode_check() {}

geomtry_prompt_vi_mode_render() {}

geometry_plugin_register vi_mode
