return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        -- compile = true,
        colors = {
          theme = {
            all = {
              ui = {
                bg_gutter = "none",
              },
            },
          },
        },
        overrides = function(colors)
          return {
            Normal = { bg = "None", fg = colors.theme.ui.fg },
          }
        end,
      })
      vim.cmd("colorscheme kanagawa")
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require("nordic").setup({
        transparent_bg = false,
      })
      require("nordic").load()
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "storm",
        transparent = false,
      })
      vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    enabled = true,
    config = function()
      require("monokai-pro").setup({
        transparent_background = false,
        -- filter = "octagon",
        filter = "pro",
      })

      vim.cmd("colorscheme monokai-pro")
    end
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    enabled = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("dracula")
    end,
  },
}
