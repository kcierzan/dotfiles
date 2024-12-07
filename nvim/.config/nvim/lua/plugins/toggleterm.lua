local lib = require("lib")
local rails = require("rails")

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    "<C-;>",
    {
      "<leader>it",
      lib.ex_cmd("ToggleTerm direction=float name='zsh'"),
      desc = "toggle floating terminal",
    },
    {
      "<leader>Q",
      lib.ex_cmd("silent q!"),
      desc = "quit without saving",
    },
    {
      "<leader>:",
      lib.ex_cmd("ToggleTerm direction=horizontal name='zsh'"),
      desc = "toggle terminal drawer",
    },
    {
      "<leader>iT",
      lib.ex_cmd("ToggleTerm direction=horizontal"),
      desc = "toggle drawer terminal",
    },
    { "<leader>gl", lib.ex_cmd("TermExec direction=float cmd=lazygit"), desc = "open lazygit" },
    { "<leader>tt", rails.run_rspec_thing_at_point_in_toggleterm, desc = "run rspec test" },
    { "<leader>tf", rails.run_rspec_file_in_toggleterm, desc = "run rspec file" },
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
