local M = {}
local foreground = "#ffffff"
local cursor_bg = "#ffffff"
local cursor_border = "#ffffff"
local background = "#161616"
local base01 = "#16161D"
local base04 = "#1F1F28"
local base05 = "#262626"
local base09 = "#78a9ff"

local ansi = { "#262626", "#ee5396", "#42be65", "#FAE3B0", "#33b1ff", "#be95ff", "#3ddbd9", "#dde1e6" }
local brights = { "#393939", "#ee5396", "#42be65", "#FAE3B0", "#33b1ff", "#be95ff", "#3ddbd9", "#ffffff" }

M.base_30 = {
  white = "#f2f4f8",
  darker_black = "#0f0f0f",
  black = "#161616", --  nvim bg
  black2 = "#202020",
  one_bg = "#2a2a2a", -- real bg of onedark
  one_bg2 = "#343434",
  one_bg3 = "#3c3c3c",
  grey = "#464646",
  grey_fg = "#4c4c4c",
  grey_fg2 = "#555555",
  light_grey = "#5f5f5f",
  red = "#ee5396",
  baby_pink = "#ff7eb6",
  pink = "#be95ff",
  line = "#383747", -- for lines like vertsplit
  green = "#42be65",
  vibrant_green = "#08bdba",
  nord_blue = "#78a9ff",
  blue = "#33b1ff",
  yellow = "#FAE3B0",
  sun = "#ffe9b6",
  purple = "#d0a9e5",
  dark_purple = "#c7a0dc",
  teal = "#B5E8E0",
  orange = "#F8BD96",
  cyan = "#3ddbd9",
  statusline_bg = "#202020",
  lightbg = "#2a2a2a",
  pmenu_bg = "#3ddbd9",
  folder_bg = "#78a9ff",
  lavender = "#c7d1ff",
}

M.wezterm_colors = {
  background = background,
  foreground = ansi[8],
  cursor_bg = base09,
  cursor_fg = ansi[1],
  cursor_border = base09,
  ansi = ansi,
  brights = brights,
  tab_bar = {
    background = base01,
  },
}

M.tab_colors = {
  statusline_bg = base01,
  segment_bg = base05,
  active = ansi[8],
  accent = ansi[6],
}

return M
