local lib = require("lib")
local Spec = require("rails").Spec

return {
  "akinsho/toggleterm.nvim",
  enabled = true,
  version = "*",
  keys = {
    "<C-;>",
    {
      "<leader>it",
      lib.ex_cmd("ToggleTerm direction=float name='nu'"),
      desc = "toggle floating terminal",
    },
    {
      "<leader>Q",
      lib.ex_cmd("silent q!"),
      desc = "quit without saving",
    },
    {
      "<leader>:",
      lib.ex_cmd("ToggleTerm direction=horizontal name='nu'"),
      desc = "toggle terminal drawer",
    },
    {
      "<leader>iT",
      lib.ex_cmd("ToggleTerm direction=horizontal"),
      desc = "toggle drawer terminal",
    },
    {
      "<leader>tt",
      function()
        Spec.new():run({ at_point = true })
      end,
      desc = "run rspec test",
    },
    {
      "<leader>tf",
      function()
        Spec.new():run({ at_point = false })
      end,
      desc = "run rspec file",
    },
  },
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    open_mapping = "<C-;>",
    persist_mode = true,
    size = 20,
    float_opts = {
      border = "curved",
    },
  },
}
