return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = false,
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      background = {
        light = "latte",
        dark = "mocha",
      },
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
