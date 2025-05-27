return {
  "webhooked/kanso.nvim",
  lazy = false,
  name = "kanso",
  priority = 1000,
  config = function()
    require("kanso").setup({
      theme = "zen",
      background = {
        dark = "ink",
        light = "pearl",
      },
      overrides = function(colors)
        return {
          WinSeparator = { fg = colors.palette.inkBlack2 },
          WhichKey = { fg = colors.palette.fujiGray },
        }
      end,
    })
    vim.cmd.colorscheme("kanso")
  end,
}
