return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = { "terminal" },
      filetype_exclude = { "alpha" },
      use_treesitter = true,
      enabled = false,
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete" },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost" },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    dependencies = { "folke/tokyonight.nvim" },
    config = function()
      local tn = require("tokyonight.colors").setup()
      require("notify").setup({
        timeout = 800,
        background_colour = tn.bg,
        fps = 60,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = { "BufReadPre" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        hover = {
          enabled = false,
        },
      },
      routes = {
        {
          filter = {
            warning = true,
            find = "Failed to attach",
          },
          opts = { skip = true },
        },
        {
          view = "notify",
          filter = {
            event = "msg_showmode",
          },
        },
        {
          filter = {
            error = true,
            find = "Pattern",
          },
          opts = { skip = true },
        },
        {
          filter = {
            warning = true,
            find = "search hit",
          },
          opts = { skip = true },
        },
        {
          filter = {
            find = "go up one level",
          },
          opts = { skip = true },
        },
        {
          filter = {
            find = "quit with exit code",
            warning = true,
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = { "VimEnter" },
    config = function()
      require("bufferline").setup({
        options = {
          show_close_icon = false,
          show_buffer_close_icons = false,
          indicator = { style = "none" },
          -- separator_style = { "", "" },
          separator_style = "slant",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    event = { "VimEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
    config = function()
      local lib = require("lib")
      local telescope = require("telescope.builtin")
      require("dashboard").setup({
        config = {
          shortcut = {
            { desc = "Find Files", key = "f", group = "@function", action = lib.fast_find_file },
            { desc = "Grep", key = "g", group = "@character", action = lib.live_grep_from_git_root },
            { desc = "Help", key = "h", group = "@boolean", action = telescope.help_tags },
            { desc = "Quit", key = "q", group = "@variable.builtin", action = "q!" },
          },
          header = {
            "",
            "⠀⠀⢀⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⢸⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠘⠉⠉⠙⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀ ",
            "⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⣴⣿⣿⣿⠟⣿⣿⣿⣷⠀⠀⠀⠀",
            "⠀⠀⠀⣰⣿⣿⣿⡏⠀⠸⣿⣿⣿⣇⠀⠀⠀",
            "⠀⠀⢠⣿⣿⣿⡟⠀⠀⠀⢻⣿⣿⣿⡆⠀⠀",
            "⠀⢠⣿⣿⣿⡿⠀⠀⠀⠀⠀⢿⣿⣿⣷⣤⡄",
            "⢀⣾⣿⣿⣿⠁⠀⠀⠀⠀⠀⠈⠿⣿⣿⣿⡇",
            "",
          },
          footer = {
            "",
            "",
            "Programming is not about typing, it's about thinking.",
            "                              - Rich Hickey"
          }
        },
      })
    end,
  },
}
