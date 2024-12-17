local lib = require("lib")
local rails = require("rails")

local function run_rspec_file()
  local path, _ = rails.current_path_and_line_number()
  local cwd = rails.top_level_rails_dir(path)
  local command = rails.generate_test_command(path)
  Snacks.terminal.get(command, { cwd = cwd })
end

local function run_rspec_thing_at_point()
  local path, line_number = rails.current_path_and_line_number()
  local cwd = rails.top_level_rails_dir(path)
  local command = rails.generate_test_command(path, line_number)
  Snacks.terminal.get(command, { cwd = cwd })
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  keys = {
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "delete buffer",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.open()
      end,
      desc = "open lazygit",
    },
    {
      "<leader>gL",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "open lazygit log for current file",
    },
    { "<leader>go", lib.ex_cmd("'<,'>lua Snacks.gitbrowse()"), desc = "open in github", mode = "v" },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "open in github",
    },
    {
      "<leader>b.",
      function()
        Snacks.scratch()
      end,
      desc = "open scratch buffer",
    },
    {
      "<leader>b/",
      function()
        Snacks.scratch.select()
      end,
      desc = "select a scratch buffer",
    },
    {
      "<leader>tf",
      run_rspec_file,
      desc = "run rspec file",
    },
    {
      "<leader>tt",
      run_rspec_thing_at_point,
      desc = "run rspec test at cursor",
    },
    {
      "<C-;>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "toggle terminal",
    },
    {
      "<C-;>",
      function()
        Snacks.terminal.toggle()
      end,
      desc = "toggle terminal",
      mode = "t",
    },
  },
  --@type snacks.Config
  opts = {
    animate = { enabled = true, fps = 120, easing = "expo", duration = 10 },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    gitbrowse = { enabled = true },
    -- replace dashboard.nvim
    dashboard = { enabled = true },
    debug = { enabled = true },
    indent = {
      indent = {
        only_scope = true,
        only_current = true,
        enabled = false,
        char = "▎",
      },
      scope = {
        char = "▎",
      },
      blank = {
        char = "▎",
      },
      enabled = true,
    },
    -- TODO: replace dressing.nvim
    input = { enabled = true },
    -- TODO: replace toggleterm implementation
    lazygit = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = {
      enabled = true,
      char = "▎",
    },
    scratch = { enabled = true },
    -- TODO: disable neoscroll
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    -- TODO: look into replacing toggleterm
    terminal = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  },
}
