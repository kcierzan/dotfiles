local wezterm = require("wezterm")
local is_linux <const> = wezterm.target_triple:find("linux")
local config = {}

local theme_name = "oxocarbon_dark" -- kanagawa
-- local font = "RecMonoDuotone Nerd Font"
local font = "BerkeleyMono Nerd Font"
local tab_theme_name = "gradient" -- round, arrows

local theme = require("themes/" .. theme_name)
local tab_theme = require("tabs/" .. tab_theme_name).new({ theme = theme })

config.font = wezterm.font(font)
config.colors = theme.wezterm_colors
config.window_background_opacity = 1
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", "dlig=1", "ss01=1" }
config.max_fps = 120
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal,
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.SplitVertical,
  },
  {
    key = " ",
    mods = "LEADER",
    action = wezterm.action.ActivateCommandPalette,
  },
}

config.window_padding = {
  bottom = 0,
  left = 0,
  right = 0,
  top = 0,
}

config.front_end = "WebGpu"
config.freetype_load_target = "Light"
config.font_size = 14.0
config.line_height = 1.1
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

config.tab_bar_style = {
  new_tab = wezterm.format({
    { Background = { Color = theme.tab_colors.statusline_bg } },
    { Foreground = { Color = theme.tab_colors.active } },
    { Text = " " },
  }),
  new_tab_hover = wezterm.format({
    { Background = { Color = theme.tab_colors.statusline_bg } },
    { Foreground = { Color = theme.tab_colors.accent } },
    { Text = " " },
  }),
}

wezterm.on("format-tab-title", tab_theme:create_tab_formatter())

if not is_linux then
  config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"
  config.macos_window_background_blur = 30
end

return config
