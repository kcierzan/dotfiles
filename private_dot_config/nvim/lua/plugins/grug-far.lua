local lib = require("lib")

return {
  "MagicDuck/grug-far.nvim",
  keys = {
    { "<leader>fR", lib.ex_cmd("GrugFar"), desc = "replace" },
  },
  cmd = "GrugFar",
  config = {},
}
