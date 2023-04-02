return {
  "lewis6991/gitsigns.nvim",
  event = "CursorHold",
  config = function()
    require("gitsigns").setup()
  end
}
