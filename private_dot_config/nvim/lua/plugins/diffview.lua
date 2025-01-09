local lib = require("lib")

return {
  "sindrets/diffview.nvim",
  keys = {
    {
      "<leader>gD",
      lib.ex_cmd("DiffviewOpen"),
      desc = "open index diff",
    },
    {
      "<leader>gH",
      lib.ex_cmd("DiffviewFileHistory %"),
      desc = "open file history",
    },
  },
  opts = {},
}
