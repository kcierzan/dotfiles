local M = {}

local base_30 = {
  white = "#c7b89d",
  darker_black = "#1a1d1e",
  black = "#1e2122", --  nvim bg
  black2 = "#242728",
  one_bg = "#282b2c",
  one_bg2 = "#393c3d",
  one_bg3 = "#404344",
  grey = "#484b4c",
  grey_fg = "#575a5b",
  grey_fg2 = "#545758",
  light_grey = "#606364",
  red = "#ec6b64",
  baby_pink = "#ce8196",
  pink = "#ff75a0",
  line = "#323536", -- for lines like vertsplit
  green = "#89b482",
  vibrant_green = "#a9b665",
  nord_blue = "#6f8faf",
  blue = "#6d8dad",
  yellow = "#d6b676",
  sun = "#d1b171",
  purple = "#9385b4",
  dark_purple = "#887aa9",
  teal = "#749689",
  orange = "#e78a4e",
  cyan = "#82b3a8",
  statusline_bg = "#222526",
  lightbg = "#2d3031",
  pmenu_bg = "#89b482",
  folder_bg = "#6d8dad",
}

local base_16 = {
  base00 = "#1e2122",
  base01 = "#2c2f30",
  base02 = "#36393a",
  base03 = "#404344",
  base04 = "#d4be98",
  base05 = "#c0b196",
  base06 = "#c3b499",
  base07 = "#c7b89d",
  base08 = "#ec6b64",
  base09 = "#e78a4e",
  base0A = "#e0c080",
  base0B = "#a9b665",
  base0C = "#86b17f",
  base0D = "#7daea3",
  base0E = "#d3869b",
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
