local config = {}

config.base46 = {
  theme = "kanagawa",
  theme_toggle = { "kanagawa", "gruvbox_light" },
  hl_override = {
    Visual = { bg = "grey_fg2" },
    -- Normal = { bg = "NONE" },
    Comment = { fg = "purple" },
    ["@comment"] = { fg = "light_grey" },
    TelescopeNormal = { bg = "NONE" },
    TelescopePromptNormal = { bg = "NONE" },
    TelescopePromptPrefix = { bg = "NONE" },
    TelescopeBorder = { bg = "NONE" },
    TelescopePromptBorder = { bg = "NONE" },
    TelescopeResultsTitle = { bg = "purple" },
    NotifyBackground = { bg = "one_bg" },
  },
}

config.ui = {
  statusline = {
    theme = "default",
    separator_style = "arrow",
  },
  cmp = {
    lspkind_text = true,
    style = "atom",
    icons_left = false,
  },
}

config.nvdash = {
  load_on_startup = true,
  -- header = {
  --   "",
  --   "⠀⠀⢀⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  --   "⠀⠀⢸⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀",
  --   "⠀⠀⠘⠉⠉⠙⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀ ",
  --   "⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀",
  --   "⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀",
  --   "⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀",
  --   "⠀⠀⠀⠀⣴⣿⣿⣿⠟⣿⣿⣿⣷⠀⠀⠀⠀",
  --   "⠀⠀⠀⣰⣿⣿⣿⡏⠀⠸⣿⣿⣿⣇⠀⠀⠀",
  --   "⠀⠀⢠⣿⣿⣿⡟⠀⠀⠀⢻⣿⣿⣿⡆⠀⠀",
  --   "⠀⢠⣿⣿⣿⡿⠀⠀⠀⠀⠀⢿⣿⣿⣷⣤⡄",
  --   "⢀⣾⣿⣿⣿⠁⠀⠀⠀⠀⠀⠈⠿⣿⣿⣿⡇",
  --   "",
  -- },
  header = {
    "   ⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡀⠀⠀⠀",
    "⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀",
    "⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀",
    "⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀",
    "⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀",
    "⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀",
    "⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀⣀⣿⣿⡇⠀⠀⡀",
    "⠀⠀⠀⣿⣿⣿⣷⣤⣀⣠⣤⡾⠋⣿⣿⣷⣀⣠⠇",
    "⠀⠀⠀⣿⡏⠛⠿⠿⠟⠛⠁⠀⠀⠈⠻⠿⠿⠋⠀",
    "⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
    "⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
  },
}

return config
