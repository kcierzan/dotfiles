local lib = require("lib")

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    {
      "<leader>le",
      lib.ex_cmd("Trouble diagnostics toggle filter.buf=0 focus=true"),
      desc = "show errors and warnings",
    },
  },
  opts = {
    auto_open = false,
    auto_preview = false,
  },
}
