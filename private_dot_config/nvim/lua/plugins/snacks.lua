local lib = require("lib")
local rails = require("rails")
-- local ignore_pickers = require("dynamic_ignore_pickers")
local pickers = require("pickers")

-- snacks terminal not working great for running specs
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
    { "<leader>go", lib.ex_cmd("'<,'>lua Snacks.gitbrowse()"), desc = "open in github", mode = "x" },
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
      "<leader>fs",
      pickers.with_dynamic_excludes({
        picker_func = require("snacks").picker.smart,
        use_pattern = true,
      }),
      desc = "smart files",
    },
    {
      "<leader>ff",
      -- ignore_pickers.with_dynamic_ignore_patterns(require("snacks").picker.files, { use_pattern = true }),
      pickers.with_dynamic_excludes({
        picker_func = require("snacks").picker.files,
        use_pattern = true,
      }),
      desc = "files in repo",
    },
    {
      "<leader>fg",
      -- ignore_pickers.with_dynamic_ignore_patterns(require("snacks").picker.grep),
      pickers.with_dynamic_excludes({
        picker_func = require("snacks").picker.grep,
      }),
      desc = "text in git files",
    },
    {
      "<leader>fh",
      -- ignore_pickers.with_dynamic_ignore_patterns(require("snacks").picker.recent, { use_pattern = true }),
      pickers.with_dynamic_excludes({
        picker_func = require("snacks").picker.recent,
        use_pattern = true,
      }),
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
        Snacks.picker.buffers({ focus = "list" })
      end,
      desc = "open buffers",
    },
    {
      "<leader>fw",
      -- ignore_pickers.with_dynamic_ignore_patterns(require("snacks").picker.grep_word),
      pickers.with_dynamic_excludes({
        picker_func = require("snacks").picker.grep_word,
      }),
      desc = "word under cursor",
      mode = { "n", "x" },
    },
    {
      "<leader>ff",
      -- ignore_pickers.with_dynamic_ignore_patterns(lib.search_visual_selection),
      pickers.with_dynamic_excludes({
        picker_func = lib.search_visual_selection,
      }),
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
    animate = { enabled = not vim.g.vscode, fps = 120, easing = "expo", duration = 10 },
    bigfile = { enabled = true },
    bufdelete = { enabled = not vim.g.vscode },
    gitbrowse = { enabled = not vim.g.vscode },
    dashboard = { enabled = not vim.g.vscode },
    debug = { enabled = not vim.g.vscode },
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
    input = { enabled = not vim.g.vscode },
    lazygit = { enabled = not vim.g.vscode },
    notifier = { enabled = not vim.g.vscode },
    quickfile = { enabled = true },
    picker = {
      enabled = not vim.g.vscode,
      ui_select = true,
      win = {
        input = {
          keys = {
            ["<a-Up>"] = { "history_back", mode = { "i", "n" } },
            ["<a-Down>"] = { "history_forward", mode = { "i", "n" } },
          },
        },
      },
      formatters = {
        file = {
          truncate = 120, -- shorten the file path to roughly this length
          filename_first = false,
        },
      },
      matcher = {
        frecency = true,
      },
      layout = {
        preview = "main",
        layout = {
          box = "vertical",
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.35,
          border = "top",
          title = "{title} {live} {flags}",
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
      enabled = not vim.g.vscode,
      char = "▎",
    },
    scratch = { enabled = not vim.g.vscode },
    scroll = { enabled = not vim.g.vscode },
    statuscolumn = { enabled = not vim.g.vscode },
    terminal = { enabled = false },
    words = { enabled = not vim.g.vscode },
    zen = { enabled = not vim.g.vscode },
  },
}
