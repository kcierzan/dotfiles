local lib = require("lib")

return {
  "NvChad/nvim-colorizer.lua",
  keys = {
    {
      "<leader>vH",
      lib.ex_cmd("ColorizerAttachToBuffer"),
      desc = "colorize buffer",
    },
  },
  opts = {},
  -- opts = {
  --   "css",
  --   "javascript",
  -- },
}
