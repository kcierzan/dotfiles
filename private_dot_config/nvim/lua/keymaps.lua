-- lua/keymaps.lua
-- Single source of truth for all keybindings.
--
-- Groups are in lazy.nvim `keys` spec format (works in both plugin specs and
-- vim.keymap.set loops). No vim.keymap.set calls here — pure data.
--
-- Conflict resolutions applied here:
--   <C-l>      → nohlsearch only; buffer cycle moved to ]b / [b
--   <leader>Q  → lives here in `windows`, removed from toggleterm
--   <leader>R  → lives in `grugfar`, removed from which-key
--   ga / <leader>ca  → both kept (intentional aliases)
--   gR / <leader>cr  → both kept (intentional aliases)
--   <C-k> insert mode → luasnip only fires when choice_active(); blink owns
--                        the slot when the completion menu is open — coexist

local lib = require("lib")
local pickers = require("pickers")

local M = {}

-- ── Core ──────────────────────────────────────────────────────────────────────
-- Registered at startup by keys.lua (no plugin dependency).

M.core = {
  -- H / L: line-start / line-end motion overrides
  { "H",     "^",                      mode = { "n", "x", "o" }, desc = "line start" },
  { "L",     "g_",                     mode = { "n", "x", "o" }, desc = "line end" },

  -- Buffer cycling (]b / [b replaces the old <C-l> / <C-h> → bnext/bprev)
  { "]b",    lib.ex_cmd("bnext"),      mode = { "n" },           desc = "next buffer" },
  { "[b",    lib.ex_cmd("bprev"),      mode = { "n" },           desc = "prev buffer" },

  -- Window navigation
  { "<A-h>", "<C-w>h",                 mode = { "n" },           desc = "move to left split" },
  { "<A-j>", "<C-w>j",                 mode = { "n" },           desc = "move to lower split" },
  { "<A-k>", "<C-w>k",                 mode = { "n" },           desc = "move to upper split" },
  { "<A-l>", "<C-w>l",                 mode = { "n" },           desc = "move to right split" },

  -- Insert-mode digraph (replaces <C-q> → <C-k>)
  { "<C-q>", "<C-k>",                  mode = { "i" },           desc = "insert digraph" },

  -- Clear search highlight (<C-l> — nohlsearch wins; bnext moved to ]b)
  { "<C-l>", lib.ex_cmd("nohlsearch"), mode = { "n" },           desc = "clear search highlight" },

  -- Buffer-level save / close (no plugin needed)
  { "<C-s>", lib.ex_cmd("w"),          mode = { "n" },           desc = "write buffer" },
  { "<C-c>", lib.ex_cmd("bdelete"),    mode = { "n" },           desc = "close buffer" },

  -- Suppress <C-,> in insert mode (was a luasnip TODO)
  { "<C-,>", "<Nop>",                  mode = { "i" },           desc = "nop (reserved)" },
}

-- ── LSP ───────────────────────────────────────────────────────────────────────
-- Registered at startup by keys.lua. Functions are safe to capture at load
-- time (vim.lsp / vim.diagnostic are always present; LSP just won't respond
-- until a server attaches).

M.lsp = {
  -- g-prefix navigation
  { "gh",         vim.lsp.buf.hover,           mode = { "n" }, desc = "LSP hover" },
  { "gd",         vim.lsp.buf.definition,      mode = { "n" }, desc = "go to definition" },
  { "gD",         vim.lsp.buf.incoming_calls,  mode = { "n" }, desc = "incoming calls" },
  { "gi",         vim.lsp.buf.implementation,  mode = { "n" }, desc = "go to implementation" },
  { "gr",         vim.lsp.buf.references,      mode = { "n" }, desc = "find references" },
  -- gR / ga: intentional short-hand aliases for <leader>cr / <leader>ca below
  { "gR",         vim.lsp.buf.rename,          mode = { "n" }, desc = "LSP rename" },
  { "ga",         vim.lsp.buf.code_action,     mode = { "n" }, desc = "code action" },

  -- Diagnostics
  { "]e",         vim.diagnostic.goto_next,    mode = { "n" }, desc = "next diagnostic" },
  { "[e",         vim.diagnostic.goto_prev,    mode = { "n" }, desc = "prev diagnostic" },

  -- <leader>c* LSP commands
  { "<leader>ca", vim.lsp.buf.code_action,     mode = { "n" }, desc = "code action" }, -- alias of ga
  { "<leader>cr", vim.lsp.buf.rename,          mode = { "n" }, desc = "rename" },      -- alias of gR
  { "<leader>cF", vim.lsp.buf.format,          mode = { "n" }, desc = "format buffer" },
  { "<leader>cI", lib.ex_cmd("LspInfo"),       mode = { "n" }, desc = "info" },
  { "<leader>cL", lib.ex_cmd("LspLog"),        mode = { "n" }, desc = "log" },
  { "<leader>cq", lib.ex_cmd("LspRestart"),    mode = { "n" }, desc = "restart" },
  { "<leader>cs", lib.ex_cmd("LspStart"),      mode = { "n" }, desc = "start" },
  { "<leader>cw", lib.ex_cmd("%s/\\s\\+$//e"), mode = { "n" }, desc = "trim trailing whitespace" },
}

-- ── Windows ───────────────────────────────────────────────────────────────────
-- Registered at startup by keys.lua.
-- Includes quit/save shortcuts, window layout, and Neovim meta bindings.

M.windows = {
  -- Quit / save
  { "<leader>q",  lib.ex_cmd("silent wq"),                    mode = { "n" }, desc = "save and quit" },
  -- <leader>Q: single canonical location (removed from toggleterm)
  { "<leader>Q",  lib.ex_cmd("silent q!"),                    mode = { "n" }, desc = "quit without saving" },
  -- Misc
  { "<leader>y",  lib.ex_cmd("let @+ = expand('%:p')"),       mode = { "n" }, desc = "yank file path" },

  -- Diff helpers
  { "<leader>wC", lib.ex_cmd("diffoff"),                      mode = { "n" }, desc = "diff off" },
  { "<leader>wc", lib.ex_cmd("diffthis"),                     mode = { "n" }, desc = "diff on" },

  -- Buffer / window ops (no plugin)
  { "<leader>wD", lib.ex_cmd("wa | %bd | e#"),                mode = { "n" }, desc = "close other buffers" },
  { "<leader>wR", lib.ex_cmd("edit!"),                        mode = { "n" }, desc = "reload buffer" },

  -- Split layout
  { "<leader>wS", "<C-w>J",                                   mode = { "n" }, desc = "to horizontal split" },
  { "<leader>wV", "<C-w>H",                                   mode = { "n" }, desc = "to vertical split" },
  { "<leader>we", "<C-w>=",                                   mode = { "n" }, desc = "equalize windows" },
  { "<leader>wj", "10<C-w>-",                                 mode = { "n" }, desc = "decrease height" },
  { "<leader>wk", "10<C-w>+",                                 mode = { "n" }, desc = "increase height" },
  { "<leader>wo", "<C-w>o",                                   mode = { "n" }, desc = "delete other windows" },
  { "<leader>wq", "<C-w>q",                                   mode = { "n" }, desc = "close split" },
  { "<leader>wr", "<C-w>r",                                   mode = { "n" }, desc = "rotate windows" },
  { "<leader>ws", lib.ex_cmd("sp"),                           mode = { "n" }, desc = "split horizontal" },
  { "<leader>wv", lib.ex_cmd("vsp"),                          mode = { "n" }, desc = "split vertical" },
  { "<leader>ww", "<C-w>w",                                   mode = { "n" }, desc = "switch windows" },

  -- Neovim meta
  { "<leader>ve", lib.ex_cmd("edit ~/.config/nvim/init.lua"), mode = { "n" }, desc = "edit init.lua" },
  { "<leader>vp", lib.ex_cmd("Lazy"),                         mode = { "n" }, desc = "plugins" },
  { "<leader>vI", lib.ex_cmd("Inspect"),                      mode = { "n" }, desc = "show highlight under cursor" },
  { "<leader>vL", lib.ex_cmd("set cursorline"),               mode = { "n" }, desc = "toggle cursorline" },
  { "<leader>v#", lib.ex_cmd("set invnumber"),                mode = { "n" }, desc = "toggle line numbers" },
  { "<leader>v%", lib.ex_cmd("set invrelativenumber"),        mode = { "n" }, desc = "toggle relative line numbers" },
}

-- ── Git — gitsigns ────────────────────────────────────────────────────────────
-- Consumed by lua/plugins/gitsigns.lua

M.gitsigns = {
  { "<leader>gP", lib.ex_cmd("Gitsigns preview_hunk"),              mode = { "n" }, desc = "preview hunk" },
  { "<leader>gR", lib.ex_cmd("Gitsigns reset_buffer"),              mode = { "n" }, desc = "reset buffer" },
  { "<leader>gB", lib.ex_cmd("Gitsigns stage_buffer"),              mode = { "n" }, desc = "stage buffer" },
  { "<leader>gb", lib.ex_cmd("Gitsigns toggle_current_line_blame"), mode = { "n" }, desc = "toggle blame" },
  { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"),                mode = { "n" }, desc = "stage hunk" },
  { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"),                mode = { "v" }, desc = "stage hunk" },
  { "<leader>gr", lib.ex_cmd("Gitsigns reset_hunk"),                mode = { "n" }, desc = "reset hunk" },
  { "<leader>gr", lib.ex_cmd("'<,'>Gitsigns reset_hunk"),           mode = { "v" }, desc = "reset hunk" },
  { "<leader>gp", lib.ex_cmd("Gitsigns nav_hunk next"),             mode = { "n" }, desc = "next hunk" },
  { "<leader>gn", lib.ex_cmd("Gitsigns nav_hunk prev"),             mode = { "n" }, desc = "prev hunk" },
  -- Bracket-style hunk navigation (intentional aliases of <leader>gp / <leader>gn)
  { "]g",         lib.ex_cmd("Gitsigns nav_hunk next"),             mode = { "n" }, desc = "next git hunk" },
  { "[g",         lib.ex_cmd("Gitsigns nav_hunk prev"),             mode = { "n" }, desc = "prev git hunk" },
}

-- ── Git — diffview ────────────────────────────────────────────────────────────
-- Consumed by lua/plugins/diffview.lua

M.diffview = {
  { "<leader>gD", lib.ex_cmd("DiffviewOpen"),          mode = { "n" }, desc = "open index diff" },
  { "<leader>gH", lib.ex_cmd("DiffviewFileHistory %"), mode = { "n" }, desc = "open file history" },
}

-- ── Files — oil ───────────────────────────────────────────────────────────────
-- Consumed by lua/plugins/oil.lua

M.oil = {
  { "<leader>E", lib.ex_cmd("Oil"), mode = { "n" }, desc = "open editable parent directory" },
}

-- ── Search — grug-far ─────────────────────────────────────────────────────────
-- Consumed by lua/plugins/grug-far.lua
-- (<leader>R was duplicated in which-key.lua; the plugin spec is the sole owner.)

M.grugfar = {
  { "<leader>R", lib.ex_cmd("GrugFar"), mode = { "n" }, desc = "replace" },
}

-- ── Editor — treesj ───────────────────────────────────────────────────────────
-- Consumed by lua/plugins/treesj.lua

M.treesj = {
  {
    "gS",
    function() require("treesj").split() end,
    mode = { "n" },
    desc = "split multiline expression",
  },
  {
    "gJ",
    function() require("treesj").join() end,
    mode = { "n" },
    desc = "join multiline expression",
  },
}

-- ── Terminal — toggleterm ─────────────────────────────────────────────────────
-- Consumed by lua/plugins/toggleterm.lua
-- <C-;> is NOT listed here — it is handled by toggleterm's `open_mapping` opt
--   and must remain as a bare string entry in the plugin spec for lazy-load.
-- <leader>Q removed from here; it lives in M.windows above.

M.toggleterm = {
  {
    "<leader>:",
    lib.ex_cmd("ToggleTerm direction=float name='nu'"),
    mode = { "n" },
    desc = "toggle floating terminal",
  },
  {
    "<leader>;",
    lib.ex_cmd("ToggleTerm direction=horizontal name='nu'"),
    mode = { "n" },
    desc = "toggle terminal drawer",
  },
  -- RSpec runners (toggleterm-powered)
  {
    "<leader>t,",
    function() require("rails").Spec.new():run({ at_point = true }) end,
    mode = { "n" },
    desc = "run rspec test at point",
  },
  {
    "<leader>t;",
    function() require("rails").Spec.new():run({ at_point = false }) end,
    mode = { "n" },
    desc = "run rspec file",
  },
}

-- ── Test — neotest ────────────────────────────────────────────────────────────
-- Consumed by lua/plugins/neotest.lua

M.neotest = {
  {
    "<leader>tf",
    function() require("neotest").run.run(vim.fn.expand("%")) end,
    mode = { "n" },
    desc = "run tests for file",
  },
  {
    "<leader>tt",
    function() require("neotest").run.run() end,
    mode = { "n" },
    desc = "run nearest test",
  },
  {
    "<leader>ts",
    function() require("neotest").run.stop() end,
    mode = { "n" },
    desc = "stop test",
  },
  {
    "<leader>td",
    function() require("neotest").run.run({ strategy = "dap" }) end,
    mode = { "n" },
    desc = "debug nearest test",
  },
  {
    "<leader>tD",
    function() require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" }) end,
    mode = { "n" },
    desc = "debug tests for file",
  },
  {
    "<leader>to",
    function() require("neotest").output.open({ enter = true, auto_close = true }) end,
    mode = { "n" },
    desc = "show test output",
  },
  {
    "<leader>tO",
    function() require("neotest").output_panel.toggle() end,
    mode = { "n" },
    desc = "toggle output panel",
  },
  {
    "<leader>tS",
    function() require("neotest").summary.toggle() end,
    mode = { "n" },
    desc = "toggle summary",
  },
  {
    "<leader>tl",
    function() require("neotest").run.run_last() end,
    mode = { "n" },
    desc = "run last test",
  },
  {
    "<leader>tL",
    function() require("neotest").run.run_last({ strategy = "dap" }) end,
    mode = { "n" },
    desc = "debug last test",
  },
}

-- ── Test — vim-projectionist ──────────────────────────────────────────────────
-- Consumed by lua/plugins/vim-projectionist.lua

M.projectionist = {
  { "<leader>tg", lib.ex_cmd("A"), mode = { "n" }, desc = "show alternate / test file" },
}

-- ── Debug — nvim-dap ──────────────────────────────────────────────────────────
-- Consumed by lua/plugins/nvim-dap.lua

M.dap = {
  -- Breakpoints
  {
    "<leader>cdb",
    function() require("dap").toggle_breakpoint() end,
    mode = { "n" },
    desc = "toggle breakpoint",
  },
  {
    "<leader>cdB",
    function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
    mode = { "n" },
    desc = "conditional breakpoint",
  },
  {
    "<leader>cdL",
    function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log message: ")) end,
    mode = { "n" },
    desc = "log point",
  },
  {
    "<leader>cdx",
    function() require("dap").clear_breakpoints() end,
    mode = { "n" },
    desc = "clear all breakpoints",
  },

  -- Execution control
  {
    "<leader>cdc",
    function() require("dap").continue() end,
    mode = { "n" },
    desc = "continue",
  },
  {
    "<leader>cdn",
    function() require("dap").step_over() end,
    mode = { "n" },
    desc = "step over (next)",
  },
  {
    "<leader>cdi",
    function() require("dap").step_into() end,
    mode = { "n" },
    desc = "step into",
  },
  {
    "<leader>cdo",
    function() require("dap").step_out() end,
    mode = { "n" },
    desc = "step out",
  },
  {
    "<leader>cdC",
    function() require("dap").run_to_cursor() end,
    mode = { "n" },
    desc = "run to cursor",
  },
  {
    "<leader>cdl",
    function() require("dap").run_last() end,
    mode = { "n" },
    desc = "run last",
  },
  {
    "<leader>cdq",
    function() require("dap").terminate() end,
    mode = { "n" },
    desc = "terminate",
  },
  {
    "<leader>cdQ",
    function()
      require("dap").terminate()
      require("dapui").close()
    end,
    mode = { "n" },
    desc = "terminate and close UI",
  },

  -- UI and inspection
  {
    "<leader>cdu",
    function() require("dapui").toggle() end,
    mode = { "n" },
    desc = "toggle UI",
  },
  {
    "<leader>cdr",
    function() require("dap").repl.toggle() end,
    mode = { "n" },
    desc = "toggle REPL",
  },
  {
    "<leader>cdh",
    function() require("dap.ui.widgets").hover() end,
    mode = { "n" },
    desc = "hover (inspect)",
  },
  {
    "<leader>cdp",
    function() require("dap.ui.widgets").preview() end,
    mode = { "n" },
    desc = "preview expression",
  },
  {
    "<leader>cdf",
    function()
      local w = require("dap.ui.widgets")
      w.centered_float(w.frames)
    end,
    mode = { "n" },
    desc = "frames (stack)",
  },
  {
    "<leader>cds",
    function()
      local w = require("dap.ui.widgets")
      w.centered_float(w.scopes)
    end,
    mode = { "n" },
    desc = "scopes",
  },
  {
    "<leader>cde",
    function() require("dapui").eval(nil, { enter = true }) end,
    mode = { "n" },
    desc = "evaluate expression",
  },
  {
    "<leader>cde",
    function() require("dapui").eval() end,
    mode = { "v" },
    desc = "evaluate selection",
  },
}

-- ── AI — sidekick ─────────────────────────────────────────────────────────────
-- Consumed by lua/plugins/sidekick.lua

M.sidekick = {
  {
    "<tab>",
    function()
      if not require("sidekick").nes_jump_or_apply() then
        return "<Tab>"
      end
    end,
    expr = true,
    mode = { "n" },
    desc = "goto/apply next edit suggestion",
  },
  {
    "<leader>aa",
    function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
    mode = { "n" },
    desc = "toggle sidekick CLI",
  },
  {
    "<leader>as",
    function() require("sidekick.cli").select() end,
    mode = { "n" },
    desc = "select sidekick CLI",
  },
  {
    "<leader>at",
    function() require("sidekick.cli").send({ msg = "{this}" }) end,
    mode = { "n", "x" },
    desc = "send this to sidekick",
  },
  {
    "<leader>av",
    function() require("sidekick.cli").send({ msg = "{selection}" }) end,
    mode = { "x" },
    desc = "send visual selection to sidekick",
  },
  {
    "<leader>ap",
    function() require("sidekick.cli").prompt() end,
    mode = { "n", "x" },
    desc = "focus sidekick prompt",
  },
  {
    "<C-.>",
    function() require("sidekick.cli").focus() end,
    mode = { "n", "x", "i", "t" },
    desc = "switch sidekick focus",
  },
}

-- ── Neovim meta — legendary ───────────────────────────────────────────────────
-- Consumed by lua/plugins/legendary.lua

M.legendary = {
  { "<leader>?", lib.ex_cmd("Legendary"), mode = { "n" }, desc = "search commands" },
}

-- ── Neovim meta — sniprun ─────────────────────────────────────────────────────
-- Consumed by lua/plugins/sniprun.lua

M.sniprun = {
  { "<leader>vr", lib.ex_cmd("Sniprun"),      mode = { "n" }, desc = "run line" },
  { "<leader>vr", lib.ex_cmd("'<,'>Sniprun"), mode = { "v" }, desc = "run block" },
}

-- ── Snacks — all snacks.nvim bindings ────────────────────────────────────────
-- Consumed by lua/plugins/snacks.lua
-- Snacks is eager (lazy = false), so no lazy-load concerns here.

local function toggle_indent()
  if Snacks.indent.enabled then
    Snacks.indent.disable()
  else
    Snacks.indent.enable()
  end
end

M.snacks = {
  -- Buffer management
  {
    "<leader>wd",
    function() Snacks.bufdelete() end,
    mode = { "n" },
    desc = "delete buffer",
  },
  {
    "<leader>b",
    function() Snacks.picker.buffers() end,
    mode = { "n" },
    desc = "open a buffer picker",
  },

  -- Scratch buffers
  {
    "<leader>w.",
    function() Snacks.scratch() end,
    mode = { "n" },
    desc = "open scratch buffer",
  },
  {
    "<leader>w/",
    function() Snacks.scratch.select() end,
    mode = { "n" },
    desc = "select a scratch buffer",
  },

  -- Git
  {
    "<leader>gl",
    function() Snacks.lazygit.open() end,
    mode = { "n" },
    desc = "open lazygit",
  },
  {
    "<leader>gL",
    function() Snacks.lazygit.log_file() end,
    mode = { "n" },
    desc = "open lazygit log for current file",
  },
  {
    "<leader>go",
    lib.ex_cmd("'<,'>lua Snacks.gitbrowse()"),
    mode = { "x" },
    desc = "open in github",
  },
  {
    "<leader>go",
    function() Snacks.gitbrowse() end,
    mode = { "n" },
    desc = "open in github",
  },

  -- File / project pickers
  {
    "<leader> ",
    function() Snacks.picker() end,
    mode = { "n" },
    desc = "open a picker picker",
  },
  {
    "<leader><CR>",
    pickers.with_dynamic_excludes({
      picker_func = function(...) require("snacks").picker.smart(...) end,
      use_pattern = true,
    }),
    mode = { "n" },
    desc = "open a smart file picker",
  },
  {
    "<leader>f",
    pickers.with_dynamic_excludes({
      picker_func = function(...) require("snacks").picker.files(...) end,
      use_pattern = true,
    }),
    mode = { "n" },
    desc = "open a project file picker",
  },
  {
    "<leader>r",
    pickers.with_dynamic_excludes({
      picker_func = function(...) require("snacks").picker.recent(...) end,
      use_pattern = true,
    }),
    mode = { "n" },
    desc = "open a frecent file picker",
  },
  {
    "<leader>d",
    function() Snacks.picker.zoxide() end,
    mode = { "n" },
    desc = "open a zoxide picker",
  },
  {
    "<leader>e",
    function() Snacks.picker.explorer() end,
    mode = { "n" },
    desc = "open an explorer picker",
  },
  {
    "<leader>j",
    function() Snacks.picker.jumplist() end,
    mode = { "n" },
    desc = "open a jumplist picker",
  },

  -- Search / grep pickers
  {
    "<leader>/",
    pickers.with_dynamic_excludes({
      picker_func = function(...) require("snacks").picker.grep(...) end,
    }),
    mode = { "n" },
    desc = "open a text search picker",
  },
  {
    "<leader>*",
    pickers.with_dynamic_excludes({
      picker_func = function(...) require("snacks").picker.grep_word(...) end,
    }),
    mode = { "n", "x" },
    desc = "word under cursor",
  },
  {
    "<leader>*",
    pickers.with_dynamic_excludes({
      picker_func = lib.search_visual_selection,
    }),
    mode = { "v" },
    desc = "search visual selection",
  },
  {
    "<leader>'",
    function() Snacks.picker.resume() end,
    mode = { "n" },
    desc = "open the last picker",
  },

  -- LSP symbol pickers
  {
    "<leader>l",
    function() Snacks.picker.lines() end,
    mode = { "n" },
    desc = "open a line picker",
  },
  {
    "<leader>s",
    function() Snacks.picker.lsp_symbols() end,
    mode = { "n" },
    desc = "open a buffer symbol picker",
  },
  {
    "<leader>S",
    function() Snacks.picker.lsp_workspace_symbols() end,
    mode = { "n" },
    desc = "open a workspace symbol picker",
  },

  -- Neovim meta pickers
  {
    "<leader>vi",
    function() Snacks.notifier.show_history() end,
    mode = { "n" },
    desc = "show notification history",
  },
  {
    "<leader>v|",
    toggle_indent,
    mode = { "n" },
    desc = "toggle indent markers",
  },
  {
    "<leader>vh",
    function() Snacks.picker.help() end,
    mode = { "n" },
    desc = "open a help tag picker",
  },
  {
    "<leader>vk",
    function() Snacks.picker.keymaps() end,
    mode = { "n" },
    desc = "open a keymap picker",
  },
  {
    "<leader>va",
    function() Snacks.picker.autocmds() end,
    mode = { "n" },
    desc = "open an autocommands picker",
  },
  {
    "<leader>vc",
    function() Snacks.picker.highlights() end,
    mode = { "n" },
    desc = "open a highlight picker",
  },
}

-- ── Completion — luasnip ──────────────────────────────────────────────────────
-- NOT used as a lazy `keys` spec (Tab as a lazy-load trigger would interfere
-- with normal typing). Instead, luasnip.lua's config() calls
-- require("keymaps").register("luasnip") after luasnip is loaded.
--
-- <C-k> conflict note: fires only when ls.choice_active(); blink.cmp owns
-- <C-k> in the completion menu context. They coexist safely.

M.luasnip = {
  {
    "<Tab>",
    function()
      local ls = require("luasnip")
      if ls.jumpable(1) then
        ls.jump(1)
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
          "n",
          false
        )
      end
    end,
    mode = { "i", "s" },
    desc = "jump forward in snippet",
  },
  {
    "<S-Tab>",
    function()
      local ls = require("luasnip")
      if ls.jumpable(-1) then
        ls.jump(-1)
      else
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true),
          "n",
          false
        )
      end
    end,
    mode = { "i", "s" },
    desc = "jump backward in snippet",
  },
  {
    "<C-j>",
    function()
      local ls = require("luasnip")
      if ls.choice_active() then ls.change_choice(1) end
    end,
    mode = { "i", "s" },
    desc = "next snippet choice",
  },
  {
    "<C-k>",
    function()
      local ls = require("luasnip")
      if ls.choice_active() then ls.change_choice(-1) end
    end,
    mode = { "i", "s" },
    desc = "prev snippet choice",
  },
}

-- ── Helpers ───────────────────────────────────────────────────────────────────

--- Returns the keybinding list for a given group, in lazy.nvim `keys` format.
--- Plugin specs call: keys = require("keymaps").for_plugin("gitsigns")
---@param group string
---@return table
function M.for_plugin(group)
  return M[group] or {}
end

--- Registers a group's bindings directly via vim.keymap.set.
--- Used for groups whose bindings cannot be lazy-loaded (e.g. luasnip).
---@param group string
function M.register(group)
  for _, mapping in ipairs(M[group] or {}) do
    local key    = mapping[1]
    local action = mapping[2]
    local modes  = mapping.mode or { "n" }
    local opts   = {
      noremap = true,
      silent  = true,
      desc    = mapping.desc,
    }
    if mapping.expr then opts.expr = mapping.expr end
    vim.keymap.set(modes, key, action, opts)
  end
end

--- Detects duplicate {key, mode} pairs across all groups and emits a warning.
--- Call once at startup: require("keymaps").validate()
function M.validate()
  local seen = {}
  local dupes = {}

  for group_name, group in pairs(M) do
    if type(group) == "table" and type(group[1]) == "table" then
      for _, mapping in ipairs(group) do
        local key   = mapping[1]
        local modes = mapping.mode or { "n" }
        if type(modes) == "string" then modes = { modes } end
        for _, mode in ipairs(modes) do
          local id = mode .. ":" .. key
          if seen[id] then
            table.insert(dupes, string.format("DUPE %s  group=%s  prev=%s", id, group_name, seen[id]))
          else
            seen[id] = group_name
          end
        end
      end
    end
  end

  if #dupes > 0 then
    vim.notify(
      "keymaps.lua: duplicate bindings detected\n" .. table.concat(dupes, "\n"),
      vim.log.levels.WARN,
      { title = "keymaps" }
    )
  end
end

return M
