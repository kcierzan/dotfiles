return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      -- compile = true,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            }
          }
        }
      },
      overrides = function(colors)
        return {
          Normal = { bg = "None", fg = colors.theme.ui.fg }
        }
      end
    })
    vim.cmd("colorscheme kanagawa")
  end
}
