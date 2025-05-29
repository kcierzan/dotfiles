--[[
_____       __________ ______
___(_)_________(_)_  /____  /___  _______ _
__  /__  __ \_  /_  __/__  /_  / / /  __ `/
_  / _  / / /  / / /____  / / /_/ // /_/ /
/_/  /_/ /_//_/  \__/(_)_/  \__,_/ \__,_/
]]
--
_G.dd = function(...)
  Snacks.debug.inspect(...)
end

-- https://github.com/neovim/neovim/issues/31675
-- "show highlight at point" doesn't work without this for now
vim.hl = vim.highlight

local lib = require("lib")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- TODO: make a table of dark/light ghostty themes
vim.fn.system("ghostty +show-config | rg -q kanso-ink")
vim.opt.background = vim.v.shell_error == 0 and "dark" or "light"

vim.opt.autowriteall = true
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.conceallevel = 0
vim.opt.cursorline = false
vim.opt.expandtab = true
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.pumheight = 10
vim.opt.relativenumber = false
vim.opt.scrolloff = 8
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.showtabline = 1
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.o.linespace = 0
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.opt.undodir = os.getenv("HOME") .. "/.undo"
vim.opt.undolevels = 100000
vim.opt.updatetime = 100
vim.opt.wrap = true
vim.opt.writebackup = false
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor"
vim.opt.shortmess = "astWAcCFo"
vim.opt.shell = "nu"
vim.g.mapleader = " "

vim.highlight.priorities.semantic_tokens = 95

lib.nmap("+", "<Nop>")
vim.g.maplocalleader = "+"

vim.g.neovide_input_macos_option_key_is_meta = "both"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_position_animation_length = 0.1
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_refresh_rate = 60
vim.g.neovide_padding_top = 20
vim.g.neovide_padding_bottom = 20
vim.g.neovide_padding_right = 20
vim.g.neovide_padding_left = 20
vim.opt.linespace = 2

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- these don't do anything useful
lib.nmap("L", "<Nop>")
lib.nmap("H", "<Nop>")
lib.xmap("L", "<Nop>")
lib.xmap("H", "<Nop>")

-- shift + hl replaces ^ and g_
lib.nmap("L", "g_")
lib.nmap("H", "^")
lib.xmap("L", "g_")
lib.xmap("H", "^")
lib.omap("H", "^")
lib.omap("L", "g_")

-- ctrl + hl to cycle buffers
lib.nmap("<C-l>", lib.ex_cmd("bnext"))
lib.nmap("<C-h>", lib.ex_cmd("bprev"))

-- alt + hjkl moves between splits
lib.nmap("<A-h>", "<C-w>h")
lib.nmap("<A-j>", "<C-w>j")
lib.nmap("<A-k>", "<C-w>k")
lib.nmap("<A-l>", "<C-w>l")

-- cmd + v is paste in gui
lib.imap("<D-v>", "<C-r>+")
lib.cmap("<D-v>", "<C-r>+")
lib.nmap("<D-v>", '"+p')

-- TODO: add descriptions via table arg to nvim_set_keymap()
lib.nmap("gh", lib.ex_cmd("lua vim.lsp.buf.hover()"))
lib.nmap("gd", lib.ex_cmd("lua vim.lsp.buf.definition()"))
lib.nmap("gD", lib.ex_cmd("lua vim.lsp.buf.incoming_calls()"))
lib.nmap("gi", lib.ex_cmd("lua vim.lsp.buf.implementation()"))
lib.nmap("gr", lib.ex_cmd("lua vim.lsp.buf.references()"))
lib.nmap("]e", lib.ex_cmd("lua vim.diagnostic.goto_next()"))
lib.nmap("[e", lib.ex_cmd("lua vim.diagnostic.goto_prev()"))
lib.nmap("]g", lib.ex_cmd("Gitsigns next_hunk"))
lib.nmap("[g", lib.ex_cmd("Gitsigns prev_hunk"))

vim.api.nvim_set_keymap("t", "<D-v>", [[<C-\><C-n>:lua require('lib').paste_in_gui_terminal()<CR>]], {
  noremap = true,
  silent = true,
})

-- TODO: move this into luasnip config
vim.api.nvim_set_keymap("i", "<C-,>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "i",
  "<C-,>",
  lib.ex_cmd("lua require('telescope').extensions.luasnip.luasnip()"),
  { noremap = true, silent = true }
)

if not vim.g.vscode then
  -- always display the file as it exists on disk
  vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
    pattern = "*",
    command = [[if &readonly==0 && filereadable(bufname('%')) | silent update | endif]],
  })
  -- reset the cursor to a pipe shape on exit
  vim.api.nvim_create_autocmd("VimLeave", {
    pattern = "*",
    command = "set guicursor=a:ver25",
  })
end

-- map cmd + =/- to increase the neovide text size
if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-=>", function()
    change_scale_factor(1.05)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1 / 1.05)
  end)
end

-- start terminals in insert mode
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.cmd("startinsert")
  end,
})

-- display a message when macro recording stops
local macro_group = vim.api.nvim_create_augroup("MacroRecording", { clear = true })
vim.api.nvim_create_autocmd("RecordingLeave", {
  group = macro_group,
  callback = function()
    print("Macro recording stopped")
  end,
})

-- enable TS features explicitly (these used to be flaky)
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "c",
    "cpp",
    "eruby",
    "go",
    "html",
    "javascript",
    "lua",
    "python",
    "ruby",
    "rust",
    "svelte",
    "typescript",
    "yaml",
  },
  callback = function()
    vim.cmd("TSBufEnable highlight")
    vim.cmd("TSBufEnable endwise")
  end,
})

-- communicate the full mode to vscode
if vim.g.vscode then
  local vscode = require("vscode")

  vim.api.nvim_create_autocmd({ "VimEnter", "ModeChanged" }, {
    callback = function()
      vscode.call("setContext", {
        args = { "neovim.fullMode", vim.fn.mode(1) },
      })
    end,
  })
  -- any other vscode-neovim settings ...
end

-- configure codecompanion chat buffers
-- TODO: move this to the codecompanion configuration
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "\\[CodeCompanion\\]*",
  callback = function()
    -- vim.opt_local.filetype = "markdown"
    vim.cmd("TSBufEnable highlight")
    -- disable completion
    -- vim.opt_local.completefunc = ""
    -- vim.opt_local.omnifunc = ""
    -- vim.opt_local.completeopt = ""
    -- vim.b.completion = false
  end,
})

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
    cond = not vim.g.vscode,
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
})
