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
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 800,
      background_colour = "#000000",
    },
  },
  {
    "folke/noice.nvim",
    event = { "BufReadPre" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
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
    branch = "main",
    event = { "BufReadPre" },
    opts = {
      options = {
        show_close_icon = false,
        show_buffer_close_icons = false,
        indicator = { style = "none" },
        separator_style = { "", "" },
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },
}
