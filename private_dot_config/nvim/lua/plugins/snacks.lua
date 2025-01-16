local lib = require("lib")
local rails = require("rails")

local function run_rspec_file()
  local path, _ = rails.current_path_and_line_number()
  local cwd = rails.top_level_rails_dir(path)
  local command = rails.generate_test_command(path)
  Snacks.terminal.toggle(command, { cwd = cwd, win = { position = "bottom" } })
end

local function run_rspec_thing_at_point()
  local path, line_number = rails.current_path_and_line_number()
  local cwd = rails.top_level_rails_dir(path)
  local command = rails.generate_test_command(path, line_number)
  Snacks.terminal.toggle(command, { cwd = cwd, win = { position = "bottom" } })
end

local function toggle_indent()
  if Snacks.indent.enabled then
    Snacks.indent.disable()
  else
    Snacks.indent.enable()
  end
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
    -- {
    --   "<leader>tf",
    --   run_rspec_file,
    --   desc = "run rspec file",
    -- },
    -- {
    --   "<leader>tt",
    --   run_rspec_thing_at_point,
    --   desc = "run rspec test at cursor",
    -- },
    -- {
    --   "<C-;>",
    --   function()
    --     Snacks.terminal.toggle()
    --   end,
    --   desc = "toggle terminal",
    -- },
    -- {
    --   "<C-;>",
    --   function()
    --     Snacks.terminal.toggle()
    --   end,
    --   desc = "toggle terminal",
    --   mode = "t",
    -- },
    {
      "<leader>vi",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "show notification history",
    },
    {
      "<leader>iI",
      toggle_indent,
      desc = "toggle indent markers",
    },
  },
  --@type snacks.Config
  opts = {
    animate = { enabled = true, fps = 120, easing = "expo", duration = 10 },
    bigfile = { enabled = true },
    bufdelete = { enabled = true },
    gitbrowse = { enabled = true },
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
      enabled = false,
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    picker = {
      enabled = true,
      formatters = {
        file = {
          filename_first = true,
        },
      },
      layout = {
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.5,
          border = "top",
          title = " {source} {live}",
          title_pos = "left",
          { win = "input", height = 1, border = "bottom" },
          {
            box = "horizontal",
            { win = "list", border = "none" },
            { win = "preview", width = 0.6, border = "left" },
          },
        },
      },
    },
    scope = {
      enabled = true,
      char = "▎",
    },
    scratch = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    terminal = { enabled = false },
    words = { enabled = true },
    zen = { enabled = true },
  },
}
