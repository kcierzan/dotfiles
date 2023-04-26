return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function()
      require("gitsigns").setup()
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = function()
      require("indent_blankline").setup({
        buftype_exclude = { "terminal" },
        filetype_exclude = { "alpha" },
        use_treesitter = true,
        enabled = false
      })
    end
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end
  },
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete" }
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("colorizer").setup()
    end
  },
  {
    "folke/noice.nvim",
    event = { "BufReadPre" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function()
      require("notify").setup({ timeout = 800 })
      require("noice").setup({
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written"
            },
            opts = { skip = true }
          },
          {
            view = "notify",
            filter = {
              event = "msg_showmode",
            }
          },
          {
            filter = {
              error = true,
              find = "Pattern"
            },
            opts = { skip = true }
          },
          {
            filter = {
              warning = true,
              find = "search hit"
            },
            opts = { skip = true }
          },
          {
            filter = {
              find = "go up one level"
            },
            opts = { skip = true }
          },
          {
            filter = {
              find = "quit with exit code",
              warning = true
            },
            opts = { skip = true }
          }
        }
      })
    end
  },
  {
    "akinsho/bufferline.nvim",
    branch = "main",
    event = { "BufReadPre" },
    config = function()
      require("bufferline").setup({
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
              separator = true
            }
          }
        }

      })
    end

  }
}
