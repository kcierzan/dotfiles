local M = {}

local lib = require("lib")

M.normal_mode_mappings = {
  {
    "<leader>:",
    lib.ex_cmd("ToggleTerm direction=horizontal"),
    desc = "toggle terminal drawer",
  },
  {
    "<leader>Q",
    lib.ex_cmd("silent q!"),
    desc = "quit without saving",
  },
  {
    "<leader>q",
    lib.ex_cmd("silent wq"),
    desc = "save and quit",
  },
  -- LSP
  { "<leader>l", group = "+lsp" },
  {
    "<leader>lF",
    vim.lsp.buf.format,
    desc = "format buffer",
  },
  { "<leader>lI", lib.ex_cmd("LspInfo"), desc = "info" },
  { "<leader>lL", lib.ex_cmd("LspLog"), desc = "log" },
  {
    "<leader>la",
    lib.ex_cmd("lua require('navigator.codeAction').code_action()"),
    desc = "code action",
  },
  {
    "<leader>le",
    lib.ex_cmd("Trouble"),
    desc = "show errors and warnings",
  },
  {
    "<leader>lo",
    lib.ex_cmd("LspSymbols"),
    desc = "toggle outline",
  },
  { "<leader>lq", lib.ex_cmd("LspRestart"), desc = "restart" },
  { "<leader>lr", lib.ex_cmd("lua vim.lsp.buf.rename()"), desc = "rename" },
  { "<leader>ls", lib.ex_cmd("LspStart"), desc = "start" },
  -- Find
  { "<leader>f", group = "+find" },
  {
    "<leader>fG",
    lib.super_fuzzy_grep,
    desc = "super fuzzy grep",
  },
  { "<leader>fb", lib.telescope_builtin("buffers"), desc = "buffers" },
  { "<leader>fc", lib.telescope_builtin("git_commits"), desc = "commits" },
  {
    "<leader>fd",
    lib.telescope_builtin("lsp_definitions"),
    desc = "definitions",
  },
  {
    "<leader>ff",
    lib.fast_find_file,
    desc = "files in repo",
  },
  { "<leader>fR", lib.ex_cmd("Spectre"), desc = "replace" },
  {
    "<leader>fg",
    lib.live_grep_from_git_root,
    desc = "text in git files",
  },
  { "<leader>fh", lib.telescope_builtin("oldfiles"), desc = "oldfiles" },
  {
    "<leader>fi",
    lib.telescope_builtin("lsp_implementations"),
    desc = "implementations",
  },
  {
    "<leader>fj",
    lib.ex_cmd(":lua require('telescope').extensions.zoxide.list()"),
    desc = "recent dirs",
  },
  {
    "<leader>fl",
    lib.telescope_builtin("current_buffer_fuzzy_find"),
    desc = "line in buffer",
  },
  {
    "<leader>fo",
    lib.telescope_builtin("lsp_workspace_symbols"),
    desc = "workspace symbols",
  },
  {
    "<leader>fs",
    lib.lsp_document_symbols,
    desc = "buffer symbols",
  },
  { "<leader>fu", lib.telescope_builtin("lsp_references"), desc = "usages" },
  {
    "<leader>fw",
    lib.grep_word_under_cursor,
    desc = "word under cursor",
  },
  -- Find -> Rails
  { "<leader>fr", group = "+rails" },
  { "<leader>frf", lib.find_rails_app_file, desc = "app files" },
  { "<leader>frm", lib.find_rails_model, desc = "models" },
  {
    "<leader>frc",
    lib.find_rails_controller,
    desc = "controllers",
  },
  { "<leader>frv", lib.find_rails_view, desc = "views" },
  { "<leader>frs", lib.find_specs, desc = "specs" },
  {
    "<leader>frg",
    lib.live_grep_rails_app_files,
    desc = "find in app files",
  },
  -- Vim
  { "<leader>v", group = "+vim" },
  { "<leader>vT", lib.telescope_builtin("filetypes"), desc = "filetypes" },
  {
    "<leader>va",
    lib.telescope_builtin("autocommands"),
    desc = "autocommands",
  },
  { "<leader>vc", lib.telescope_builtin("highlights"), desc = "highlights" },
  {
    "<leader>ve",
    lib.ex_cmd("edit ~/.config/nvim/init.lua"),
    desc = "edit init.lua",
  },
  { "<leader>vh", lib.telescope_builtin("help_tags"), desc = "help tags" },
  { "<leader>vk", lib.telescope_builtin("keymaps"), desc = "keymaps" },
  { "<leader>vm", lib.telescope_builtin("man_pages"), desc = "man pages" },
  {
    "<leader>vo",
    lib.telescope_builtin("vim_options"),
    desc = "vim options",
  },
  { "<leader>vp", lib.ex_cmd("Lazy"), desc = "plugins" },
  { "<leader>vt", lib.ex_cmd("Mason"), desc = "tools" },
  -- Buffer
  { "<leader>b", desc = "+buffer" },
  { "<leader>bC", lib.ex_cmd("window diffoff"), desc = "diff off" },
  { "<leader>bc", lib.ex_cmd("window diffthis"), desc = "diff on" },
  { "<leader>bd", lib.ex_cmd("Bdelete"), desc = "delete" },
  {
    "<leader>bf",
    lib.ex_cmd('silent exec "!bundle exec rubocop -A %:p"'),
    desc = "run rubocop on buffer",
  },
  -- {
  --   "<leader>bm",
  --   lib.open_in_rubymine,
  --   desc = "open in rubymine",
  -- },
  { "<leader>br", lib.ex_cmd("edit!"), desc = "reload" },
  { "<leader>bs", lib.ex_cmd("silent! w"), desc = "write" },
  {
    "<leader>bw",
    lib.ex_cmd("%s/\\s\\+$//e"),
    desc = "trim trailing whitespace",
  },
  { "<leader>by", lib.ex_cmd('let @+ = expand("%:p")'), desc = "yank name" },
  -- Window
  { "<leader>w", group = "+window" },
  {
    "<leader>wS",
    "<C-w>J",
    desc = "to horizontal split",
  },
  {
    "<leader>wV",
    "<C-w>H",
    desc = "to vertical split",
  },
  {
    "<leader>we",
    "<C-w>=",
    desc = "equalize windows",
  },
  {
    "<leader>wj",
    "10<C-w>-",
    desc = "decrease size",
  },
  {
    "<leader>wk",
    "10<C-w>+",
    desc = "increase size",
  },
  {
    "<leader>wo",
    "<C-w>o",
    desc = "delete other windows",
  },
  {
    "<leader>wr",
    "<C-w>r",
    desc = "rotate windows",
  },
  {
    "<leader>ws",
    lib.ex_cmd("sp"),
    desc = "split horizontal",
  },
  {
    "<leader>wv",
    lib.ex_cmd("vsp"),
    desc = "split vertical",
  },
  {
    "<leader>wq",
    "<C-w>q",
    desc = "close split",
  },
  -- Interface
  { "<leader>i", group = "+interface" },
  {
    "<leader>iF",
    lib.ex_cmd("NvimTreeFindFile"),
    desc = "show current file in tree",
  },
  {
    "<leader>iH",
    lib.ex_cmd("TSHighlightCapturesUnderCursor"),
    desc = "show highlights under cursor",
  },
  {
    "<leader>it",
    lib.ex_cmd("ToggleTerm direction=float"),
    desc = "toggle floating terminal",
  },
  {
    "<leader>iT",
    lib.ex_cmd("ToggleTerm direction=horizontal"),
    desc = "toggle drawer terminal",
  },
  {
    "<leader>i#",
    lib.ex_cmd("set invnumber"),
    desc = "toggle line numbers",
  },
  {
    "<leader>i%",
    lib.ex_cmd("set invrelativenumber"),
    desc = "toggle relative line numbers",
  },
  {
    "<leader>ic",
    lib.ex_cmd("nohlsearch"),
    desc = "clear search highlight",
  },
  {
    "<leader>if",
    lib.ex_cmd("NvimTreeToggle"),
    desc = "toggle tree",
  },
  {
    "<leader>ih",
    lib.ex_cmd("ColorizerAttachToBuffer"),
    desc = "colorize buffer",
  },
  {
    "<leader>il",
    lib.ex_cmd("IBLToggle"),
    desc = "toggle indentation lines",
  },
  {
    "<leader>iL",
    lib.ex_cmd("set cursorline"),
    desc = "toggle cursorline",
  },
  -- Filetree
  { "<leader>o", group = "+filetree" },
  {
    "<leader>iL",
    lib.ex_cmd("set cursorline"),
    desc = "toggle cursorline",
  },
  {
    "<leader>ot",
    lib.ex_cmd("NvimTreeFindFile"),
    desc = "show file in tree",
  },
  {
    "<leader>oo",
    lib.ex_cmd("NvimTreeToggle"),
    desc = "open filetree",
  },
  -- Test
  { "<leader>t", group = "+test" },
  { "<leader>tb", lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b')"), desc = "b4b suite" },
  {
    "<leader>tc",
    lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/clinic')"),
    desc = "clinic suite",
  },
  { "<leader>tf", lib.test_file_from_engine_root, desc = "file" },
  { "<leader>tg", lib.ex_cmd("A"), desc = "show test file" },
  {
    "<leader>tm",
    lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b_core')"),
    desc = "b4b_core suite",
  },
  { "<leader>to", lib.ex_cmd("lua require('neotest').output_panel.toggle()"), desc = "toggle output" },
  { "<leader>ts", lib.stop_test, desc = "stop test run" },
  { "<leader>tt", lib.test_test_from_engine_root, desc = "test" },
  -- Git
  { "<leader>g", group = "+git" },
  { "<leader>gB", lib.ex_cmd("Gitsigns stage_buffer"), desc = "stage buffer" },
  { "<leader>gR", lib.ex_cmd("Gitsigns reset_buffer"), desc = "reset bufffer" },
  { "<leader>gb", lib.ex_cmd("Gitsigns toggle_current_line_blame"), desc = "toggle blame" },
  { "<leader>gc", lib.ex_cmd("Gvdiffsplit!"), desc = "3 way merge" },
  {
    "<leader>gd",
    lib.ex_cmd("Gvdiffsplit"),
    desc = "diff staged & working tree",
  },
  { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"), desc = "stage hunk" },
  { "<leader>gl", lib.ex_cmd("TermExec direction=float cmd=lazygit"), desc = "open lazygit" },
  { "<leader>go", lib.ex_cmd("GBrowse"), desc = "open in github" },
  { "<leader>gp", lib.ex_cmd("Gitsigns preview_hunk"), desc = "preview hunk" },
  { "<leader>gr", lib.ex_cmd("Gitsigns reset_hunk"), desc = "reset hunk" },
  { "<leader>gs", lib.ex_cmd("Git"), desc = "status" },
  -- Debug
  { "<leader>d", group = "+debug" },
  { "<leader>db", lib.ex_cmd("lua require('dap').toggle_breakpoint()"), desc = "toggle breakpoint" },
  { "<leader>dc", lib.ex_cmd("lua require('dap').continue()"), desc = "continue" },
  { "<leader>do", lib.ex_cmd("lua require('dap').step_over()"), desc = "step over" },
  { "<leader>di", lib.ex_cmd("lua require('dap').step_into()"), desc = "step into" },
  { "<leader>du", lib.ex_cmd("lua require('dapui').toggle()"), desc = "toggle UI" },
  { "<leader>dr", lib.ex_cmd("lua require('dap').repl.toggle()"), desc = "toggle repl" },
  {
    "<leader>df",
    lib.ex_cmd(
      "lua require('dapui').float_element('repl', { height = 40, width = 140, position = 'center', enter = true })"
    ),
    desc = "toggle floating repl",
  },
}

M.visual_mode_mappings = {
  { "<leader>go", lib.ex_cmd("'<,'>GBrowse"), desc = "open in github", mode = "v" },
  { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"), desc = "stage hunk", mode = "v" },
  { "<leader>gr", lib.ex_cmd("'<,'>Gitsigns reset_hunk"), desc = "reset hunk", mode = "v" },
  { "<leader>ff", lib.search_visual_selection, desc = "search visual selection", mode = "v" },
}

return M
