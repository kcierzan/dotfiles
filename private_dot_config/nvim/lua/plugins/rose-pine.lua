return {
  "rose-pine/neovim",
  lazy = false,
  priority = 1000,
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      variant = "auto",
      dark_variant = "moon",
      dim_inactive_windows = true,
      styles = {
        italic = false,
      },
      highlight_groups = {
        Cursor = { fg = "surface", bg = "iris" },
      },
    })

    vim.cmd.colorscheme("rose-pine")
  end,
}
