local lib = require("lib")
local rails = require("rails")

local function generate_toggle_term_command(command, cwd)
  local term_name = string.format("rspec = %s", vim.fn.fnamemodify(cwd, ":t"))
  return string.format('TermExec direction=float name="%s" cmd="%s" dir="%s"', term_name, command, cwd)
end

local function run_rspec_thing_at_point()
  local path, line_number = rails.current_path_and_line_number()
  local cwd = rails.top_level_rails_dir(path)
  local command = rails.generate_test_command(path, line_number)
  vim.cmd(generate_toggle_term_command(command, cwd))
end

local function run_rspec_file()
  local path, _ = rails.current_path_and_line_number()
  local cwd = rails.top_level_rails_dir(path)
  local command = rails.generate_test_command(path)
  vim.cmd(generate_toggle_term_command(command, cwd))
end

return {
  "akinsho/toggleterm.nvim",
  enabled = false,
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
    { "<leader>tt", run_rspec_thing_at_point, desc = "run rspec test" },
    { "<leader>tf", run_rspec_file, desc = "run rspec file" },
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
