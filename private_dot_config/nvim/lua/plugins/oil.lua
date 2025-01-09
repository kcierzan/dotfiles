local lib = require("lib")

return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  cmd = { "Oil" },
  keys = {
    { "<leader>if", lib.ex_cmd("Oil"), desc = "open parent dir" },
  },
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
