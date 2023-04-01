return {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
  cmd = "Mason",
  config = function()
    require("mason").setup()
  end
}
