local lib = require("lib")

-- TODO: replace like with grug-far?
return {
  "nvim-pack/nvim-spectre",
  keys = {
    { "<leader>fR", lib.ex_cmd("Spectre"), desc = "replace" },
  },
  cmd = { "Spectre" },
  config = true,
}
