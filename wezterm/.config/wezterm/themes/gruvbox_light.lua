local M = {}

local base_30 = {
  white = "#504945",
  darker_black = "#e8dbb2",
  black = "#F2E5BC", --  nvim bg
  black2 = "#e3d6ad",
  one_bg = "#e5d8af",
  one_bg2 = "#d8cba2",
  one_bg3 = "#cabd94",
  grey = "#c0b38a",
  grey_fg = "#b6a980",
  grey_fg2 = "#ac9f76",
  light_grey = "#a2956c",
  red = "#d65d0e",
  baby_pink = "#af3a03",
  pink = "#9d0006",
  line = "#ded1a8", -- for lines like vertsplit
  green = "#79740e",
  vibrant_green = "#7f7a14",
  nord_blue = "#7b9d90",
  blue = "#458588",
  yellow = "#d79921",
  sun = "#dd9f27",
  purple = "#8f3f71",
  dark_purple = "#853567",
  teal = "#749689",
  orange = "#b57614",
  cyan = "#82b3a8",
  statusline_bg = "#e9dcb3",
  lightbg = "#ddd0a7",
  pmenu_bg = "#739588",
  folder_bg = "#746d69",
}

local base_16 = {
  base00 = "#F2E5BC",
  base01 = "#e3d6ad",
  base02 = "#e5d8af",
  base03 = "#d8cba2",
  base04 = "#cabd94",
  base05 = "#504945",
  base06 = "#3c3836",
  base07 = "#282828",
  base08 = "#9d0006",
  base09 = "#af3a03",
  base0A = "#b57614",
  base0B = "#79740e",
  base0C = "#427b58",
  base0D = "#076678",
  base0E = "#8f3f71",
  base0F = "#d65d0e",
}

M.wezterm_colors = {
  background = base_30.one_bg,
  foreground = base_30.white,
  cursor_bg = base_30.orange,
  cursor_fg = base_30.one_bg,
  cursor_border = base_30.orange,
  ansi = {
    base_16.base00,
    base_16.base08,
    base_16.base0C,
    base_16.base0A,
    base_16.base0D,
    base_16.base0E,
    base_16.base0B,
    base_16.base04,
  },
  brights = {
    base_16.base00,
    base_16.base08,
    base_16.base0C,
    base_16.base0A,
    base_16.base0D,
    base_16.base0E,
    base_16.base0B,
    base_16.base04,
  },

  tab_bar = {
    background = base_30.statusline_bg,
  },
}

M.tab_colors = {
  tab = {
    active = {
      background = base_30.green,
      foreground = base_30.statusline_bg,
    },
    inactive = {
      background = base_30.one_bg2,
      foreground = base_30.green,
    },
  },
  left_separator = {
    active = {
      background = base_30.green,
      foreground = base_30.one_bg2,
    },
    active_tab_before = {
      background = base_30.one_bg2,
      foreground = base_30.green,
    },
    inactive = {
      background = base_30.one_bg2,
      foreground = base_30.one_bg2,
    },
  },
  right_separator = {
    active = {
      background = base_30.statusline_bg,
      foreground = base_30.green,
    },
    inactive = {
      background = base_30.statusline_bg,
      foreground = base_30.one_bg2,
    },
  },
  new = {
    background = base_30.statusline_bg,
    foreground = base_30.blue,
    hover = {
      background = base_30.statusline_bg,
      foreground = base_30.yellow,
    },
  },
}

return M
