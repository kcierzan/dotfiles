local lib = require("lib")

return {
  "NvChad/nvim-colorizer.lua",
  keys = {
    {
      "<leader>ih",
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
