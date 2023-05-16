--[[
_____       __________ ______
___(_)_________(_)_  /____  /___  _______ _
__  /__  __ \_  /_  __/__  /_  / / /  __ `/
_  / _  / / /  / / /____  / / /_/ // /_/ /
/_/  /_/ /_//_/  \__/(_)_/  \__,_/ \__,_/
gotta go fast...
]]--

vim.opt.autowriteall = true
vim.opt.backup = false
vim.opt.clipboard = "unnamedplus"
vim.opt.cmdheight = 0
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
vim.opt.pumheight = 6
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
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.opt.undodir = os.getenv("HOME") .. "/.undo"
vim.opt.undolevels = 100000
vim.opt.updatetime = 300
vim.opt.wrap = true
vim.opt.writebackup = false
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor"
vim.opt.shortmess:append("cW")
vim.g.mapleader = " "
vim.api.nvim_set_keymap("n", "+", "<Nop>", { noremap = true, silent = true })
vim.g.maplocalleader = "+"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end

local function cmd(command)
  return "<cmd>" .. command .. "<cr>"
end

local function nmap(key, command)
  vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
end

local function xmap(key, command)
  vim.api.nvim_set_keymap("x", key, command, { noremap = true, silent = true })
end

nmap("L","<Nop>")
nmap("H", "<Nop>")
xmap("L", "<Nop>")
xmap("H", "<Nop>")

nmap("L", "g_")
nmap("H", "^")
xmap("L", "g_")
xmap("H", "^")

nmap("<C-l>", cmd("bnext"))
nmap("<C-h>", cmd("bprev"))

nmap("<A-h>", "<C-w>h")
nmap("<A-j>", "<C-w>j")
nmap("<A-k>", "<C-w>k")
nmap("<A-l>", "<C-w>l")

nmap("gh", cmd("lua vim.lsp.buf.hover()"))
nmap("gd", cmd("lua vim.lsp.buf.definition()"))
nmap("gD", cmd("lua vim.lsp.buf.incoming_calls()"))

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
  "plugins",
  {
    defaults = {
      lazy = true
    },
    performance = {
      cache = {
        enabled = true
      }
    }
  }
)
