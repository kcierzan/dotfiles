return {
  "kylechui/nvim-surround",
  keys = { "ys", "ds", "cs" },
  config = function()
    require("nvim-surround").setup()
  end
}
