-- foobar
local wezterm = require("wezterm")
local config = {}

local carbon = {
  gray10 = "#f4f4f4",
  gray100 = "#161616",
  gray20 = "#e0e0e0",
  gray30 = "#c6c6c6",
  gray40 = "#a8a8a8",
  gray50 = "#8d8d8d",
  gray60 = "#6f6f6f",
  gray70 = "#525252",
  gray80 = "#393939",
  gray90 = "#262626",
  purple50 = "#a56eff",
  black = "#000000",
  red = "#fa4d56",
  green = "#6fdc8c",
  yellow = "#fddc69",
  blue = "#a6c8ff",
  magenta = "#ff7eb6",
  cyan = "#82cfff",
  white = "#ffffff",
  black_bright = "#393939",
  red_bright = "#fa4d56",
  green_bright = "#24a148",
  yellow_bright = "#d2a106",
  blue_bright = "#4589ff",
  magenta_bright = "#d02679",
  cyan_bright = "#1192e8",
  white_bright = "#c6c6c6",
}

config.colors = {
  background = carbon.gray100,
  foreground = carbon.gray10,
  cursor_bg = carbon.gray30,
  cursor_fg = carbon.gray100,
  cursor_border = carbon.blue_bright,
  ansi = {
    carbon.black,
    carbon.red,
    carbon.green,
    carbon.yellow,
    carbon.blue,
    carbon.magenta,
    carbon.cyan,
    carbon.white,
  },
  brights = {
    carbon.black_bright,
    carbon.red_bright,
    carbon.green_bright,
    carbon.yellow_bright,
    carbon.blue_bright,
    carbon.magenta_bright,
    carbon.cyan_bright,
    carbon.white_bright,
  },
  tab_bar = {
    background = carbon.gray100,
    active_tab = {
      bg_color = carbon.gray80,
      fg_color = carbon.purple50,
    },
    inactive_tab = {
      bg_color = carbon.gray90,
      fg_color = carbon.gray60,
    },
    new_tab = {
      bg_color = carbon.gray80,
      fg_color = carbon.gray10,
    },
  },
}

config.font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Regular" })
config.font_rules = {
  {
    italic = false,
    intensity = "Normal",
    font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Regular" }),
  },
  {
    intensity = "Bold",
    font = wezterm.font("MonaspiceNe Nerd Font", { weight = "Bold" }),
  },
  {
    italic = true,
    font = wezterm.font("MonaspiceRn Nerd Font", { style = "Italic", weight = "Bold" }),
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
config.font_size = 16.0
config.line_height = 1.2
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE | MACOS_FORCE_DISABLE_SHADOW"

return config
