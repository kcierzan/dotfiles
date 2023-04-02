return {
  "lukas-reineke/indent-blankline.nvim",
  event = "CursorHold",
  config = function()
    require("indent_blankline").setup({
      buftype_exclude = { "terminal" },
      filetype_exclude = { "alpha" }
    })
  end
}
