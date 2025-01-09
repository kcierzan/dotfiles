return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  enabled = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      compile = false,
      commentStyle = { italic = true },
      dimInactive = true,
      theme = "wave", -- dragon, lotus
      background = {
        dark = "wave",
        light = "lotus",
      },
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
    vim.cmd.colorscheme("kanagawa")
  end,
}
