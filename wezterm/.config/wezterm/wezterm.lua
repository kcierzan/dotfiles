local wezterm = require 'wezterm'

return {
  color_scheme = 'kanagawabones',
  default_cursor_style = 'BlinkingBlock',
  font = wezterm.font('FiraCode Nerd Font'),
  font_size = 18.0,
  scrollback_lines = 50000,
  window_decorations = 'RESIZE',
  hide_tab_bar_if_only_one_tab = true,
  window_frame = {
    active_titlebar_bg = '#303446',
    active_titlebar_fg = '#c6d0f5',
    button_fg = '#c6d0f5',
    button_bg = '#414559',
    button_hover_bg = '#737994',
    font = wezterm.font { family = 'Liga SFMono Nerd Font', weight = 'Bold' },
    font_size = 14.0,
  },
  colors = {
    tab_bar = {
      active_tab = {
        bg_color = '#626880',
        fg_color = '#c6d0f5'
      },
      inactive_tab = {
        bg_color = '#414559',
        fg_color = '#838ba7'
      },
      new_tab = {
        bg_color = '#303446',
        fg_color = '#c6d0f5'
      },
      new_tab_hover = {
        bg_color = '#626880',
        fg_color = '#c6d0f5'
      }
    }
  }
}
