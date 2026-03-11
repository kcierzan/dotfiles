local lib = require("lib")

return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Trouble" },
  keys = {
    -- {
    --   "<leader>vt",
    --   lib.ex_cmd("Trouble diagnostics toggle filter.buf=0 focus=true"),
    --   desc = "show errors and warnings",
    -- },
    -- {
    --   "<leader>ll",
    --   lib.ex_cmd("Trouble quickfix toggle focus=true"),
    --   desc = "toggle quickfix list",
    -- }
  },
  opts = {
    auto_open = false,
    auto_preview = false,
  },
}
