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
    lazy = false,
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
              filetype = "NvimTree",
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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = true,
  },
}
