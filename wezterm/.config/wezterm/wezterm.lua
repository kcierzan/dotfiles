local wezterm = require 'wezterm'

return {
  color_scheme = 'tokyonight_storm',
  -- color_scheme = 'Kanagawa (Gogh)',
  -- color_scheme = 'nord',
  default_cursor_style = 'BlinkingBar',
  -- font = wezterm.font_with_fallback { 'Iosevka Comfy', 'Iosevka Nerd Font Complete' },
  font = wezterm.font_with_fallback { 'Iosevka Comfy', 'Iosevka NF' },
  command_palette_bg_color = '#363646',
  -- window_background_opacity = 0.75,
  leader = { key = 'Space', mods = 'META' },
  -- macos_window_background_blur = 30,
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
    font = wezterm.font { family = 'Iosevka Comfy', weight = 'Bold' },
    font_size = 14.0,
  },
  keys = {
    {
      key = 'v',
      mods = 'LEADER',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }
    },
    {
      key = 's',
      mods = 'LEADER',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' }
    },
    {
      key = 'o',
      mods = 'LEADER',
      action = wezterm.action.PaneSelect
    },
    {
      key = 'p',
      mods = 'LEADER',
      action = wezterm.action.ActivateCommandPalette
    },
    {
      key = 'UpArrow',
      mods = 'CTRL|SHIFT|META',
      action = wezterm.action.ScrollByPage(-1)
    },
    {
      key = 'DownArrow',
      mods = 'CTRL|SHIFT|META',
      action = wezterm.action.ScrollByPage(1)
    }
  },
}
