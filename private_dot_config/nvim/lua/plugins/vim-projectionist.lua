local lib = require("lib")

return {
  "tpope/vim-projectionist",
  keys = {
    { "<leader>tg", lib.ex_cmd("A"), desc = "show test file" },
  },
  lazy = false,
}
