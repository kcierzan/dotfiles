local M = {}

local base_30 = {
  white = "#DCD7BA",
  darker_black = "#191922",
  black = "#1F1F28", --  nvim bg
  black2 = "#25252e",
  one_bg = "#272730",
  one_bg2 = "#2f2f38",
  one_bg3 = "#363646",
  grey = "#43434c",
  grey_fg = "#4c4c55",
  grey_fg2 = "#53535c",
  light_grey = "#5c5c65",
  red = "#d8616b",
  baby_pink = "#D27E99",
  pink = "#c8748f",
  line = "#31313a", -- for lines like vertsplit
  green = "#98BB6C",
  vibrant_green = "#a3c677",
  nord_blue = "#7E9CD8",
  blue = "#7FB4CA",
  yellow = "#FF9E3B",
  sun = "#FFA066",
  purple = "#a48ec7",
  dark_purple = "#9c86bf",
  teal = "#7AA89F",
  orange = "#fa9b61",
  cyan = "#A3D4D5",
  statusline_bg = "#24242d",
  lightbg = "#33333c",
  pmenu_bg = "#a48ec7",
  folder_bg = "#7E9CD8",
}

local base_16 = {
  base00 = "#1f1f28",
  base01 = "#2a2a37",
  base02 = "#223249",
  base03 = "#363646",
  base04 = "#4c4c55",
  base05 = "#c8c3a6",
  base06 = "#d2cdb0",
  base07 = "#DCD7BA",
  base08 = "#d8616b",
  base09 = "#ffa066",
  base0A = "#dca561",
  base0B = "#98bb6c",
  base0C = "#7fb4ca",
  base0D = "#7e9cd8",
  base0E = "#9c86bf",
  base0F = "#d8616b",
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
