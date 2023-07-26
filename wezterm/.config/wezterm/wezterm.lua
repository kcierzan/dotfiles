local wezterm = require("wezterm")
local tn = wezterm.get_builtin_color_schemes()["tokyonight_storm"]

return {
  color_scheme = "tokyonight_moon",
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  default_cursor_style = "BlinkingBar",
  font = wezterm.font_with_fallback({ "Iosevka Comfy", "Roboto Mono Nerd Font" }),
  command_palette_bg_color = tn.tab_bar.inactive_tab.bg_color,
  command_palette_fg_color = tn.foreground,
  warn_about_missing_glyphs = false,
  command_palette_font_size = 16.0,
  colors = {
    cursor_border = tn.ansi[3],
  },
  window_padding = {
    bottom = -5,
  },
  leader = { key = "Space", mods = "META" },
  font_size = 18.0,
  scrollback_lines = 50000,
  window_decorations = "RESIZE",
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {
      key = "v",
      mods = "LEADER",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "s",
      mods = "LEADER",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "o",
      mods = "LEADER",
      action = wezterm.action.PaneSelect,
    },
    {
      key = "p",
      mods = "LEADER",
      action = wezterm.action.ActivateCommandPalette,
    },
    {
      key = "UpArrow",
      mods = "CTRL|SHIFT|META",
      action = wezterm.action.ScrollByPage(-1),
    },
    {
      key = "DownArrow",
      mods = "CTRL|SHIFT|META",
      action = wezterm.action.ScrollByPage(1),
    },
  },
}
