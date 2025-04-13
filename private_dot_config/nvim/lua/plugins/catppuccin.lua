local overrides = require("catppuccin_xcode")

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  config = function()
    require("catppuccin").setup({
      custom_highlights = function(colors)
        return {
          SnacksPickerBorder = { bg = colors.mantle },
        }
      end,
      color_overrides = overrides.color_overrides,
    })

    vim.cmd.colorscheme("catppuccin")
  end,
}
