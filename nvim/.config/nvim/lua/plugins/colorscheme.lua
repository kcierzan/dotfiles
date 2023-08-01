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
    enabled = true,
    config = function()
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
        style = "night",
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
}
