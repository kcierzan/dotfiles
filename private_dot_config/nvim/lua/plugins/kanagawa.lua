return {
  "rebelot/kanagawa.nvim",
  enabled = false,
  lazy = false,
  name = "kanagawa",
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      transparent = false,
      theme = "dragon",
      overrides = function(colors)
        return {
          CursorLineNr = { fg = colors.theme.syn.identifier },
          CursorLine = { bg = "none" },
        }
      end,
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    })
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
