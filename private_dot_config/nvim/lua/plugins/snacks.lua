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

local excludes = { ".git/", "node_modules", "**/*migration*/**/*", "**/vendor/**/*", "**/migrate/**/*" }

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
      "<leader> ",
      function()
        Snacks.picker()
      end,
      desc = "pickers",
    },
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
    {
      "<leader>fd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "definitions",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.git_files()
      end,
      desc = "files in repo",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "text in git files",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.recent()
      end,
      desc = "frecent files",
    },
    {
      "<leader>fi",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "implementations",
    },
    {
      "<leader>fq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "quickfix",
    },
    {
      "<leader>fj",
      function()
        Snacks.picker.zoxide()
      end,
      desc = "recent dirs",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.lines()
      end,
      desc = "line in buffer",
    },
    {
      "<leader>fo",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "workspace symbols",
    },
    {
      "<leader>fu",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "usages",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "open buffers",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "word under cursor",
    },
    {
      "<leader>ff",
      lib.search_visual_selection,
      desc = "search visual selection",
      mode = "v",
    },
    { "<leader>fr", group = "+rails" },
    {
      "<leader>frm",
      function()
        local picker = require("snacks").picker
        picker.files({
          args = {
            "--full-path",
            "--glob",
            "**/app/models/**/*.{erb,rb}",
            "-E",
            table.concat(excludes, ","),
          },
        })
      end,
      desc = "models",
    },
    {
      "<leader>frf",
      function()
        local picker = require("snacks").picker
        picker.files({
          args = {
            "--full-path",
            "--glob",
            "**/app/**/*.{erb,rb}",
            "-E",
            table.concat(excludes, ","),
          },
        })
      end,
      desc = "app files",
    },
    {
      "<leader>frc",
      function()
        local picker = require("snacks").picker
        picker.files({
          args = {
            "--full-path",
            "--glob",
            "**/app/controllers/**/*.{erb,rb}",
            "-E",
            table.concat(excludes, ","),
          },
        })
      end,
      desc = "controllers",
    },
    {
      "<leader>frv",
      function()
        local picker = require("snacks").picker
        picker.files({
          args = {
            "--full-path",
            "--glob",
            "**/app/views/**/*.{erb,rb}",
            "-E",
            table.concat(excludes, ","),
          },
        })
      end,
      desc = "views",
    },
    {
      "<leader>frs",
      function()
        local picker = require("snacks").picker
        picker.files({
          args = {
            "--full-path",
            "--glob",
            "**/app/views/**/*.{erb,rb}",
            "-E",
            table.concat(excludes, ","),
          },
        })
      end,
      desc = "specs",
    },
    {
      "<leader>frF",
      function()
        local picker = require("snacks").picker
        picker.files({
          args = {
            "--full-path",
            "--glob",
            "**/spec/factories/**/*.{erb,rb}",
            "-E",
            table.concat(excludes, ","),
          },
        })
      end,
      desc = "factories",
    },
    {
      "<leader>vh",
      function()
        Snacks.picker.help()
      end,
      desc = "help tags",
    },
    {
      "<leader>vk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "keymaps",
    },
    {
      "<leader>vm",
      function()
        Snacks.picker.man()
      end,
      desc = "man pages",
    },
    {
      "<leader>va",
      function()
        Snacks.picker.autocommands()
      end,
      desc = "autocommands",
    },
    {
      "<leader>vc",
      function()
        Snacks.picker.highlights()
      end,
      desc = "highlights",
    },
    {
      "<leader><CR>",
      function()
        Snacks.picker.resume()
      end,
      desc = "resume picker",
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
          height = 0.4,
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
