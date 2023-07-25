--[[
_____       __________ ______
___(_)_________(_)_  /____  /___  _______ _
__  /__  __ \_  /_  __/__  /_  / / /  __ `/
_  / _  / / /  / / /____  / / /_/ // /_/ /
/_/  /_/ /_//_/  \__/(_)_/  \__,_/ \__,_/
gotta go fast...
]]
--
local lib = require("lib")

vim.opt.autowriteall = true
vim.opt.hidden = true
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
vim.opt.shortmess = "astWAcCFSo"
vim.g.mapleader = " "
lib.nmap("+", "<Nop>")
vim.g.maplocalleader = "+"

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

-- lib.tmap("<Esc>", "<C-\\><C-n>")
lib.nmap("L", "<Nop>")
lib.nmap("H", "<Nop>")
lib.xmap("L", "<Nop>")
lib.xmap("H", "<Nop>")

lib.nmap("L", "g_")
lib.nmap("H", "^")
lib.xmap("L", "g_")
lib.xmap("H", "^")

lib.nmap("<C-l>", lib.ex_cmd("bnext"))
lib.nmap("<C-h>", lib.ex_cmd("bprev"))

lib.nmap("<A-h>", "<C-w>h")
lib.nmap("<A-j>", "<C-w>j")
lib.nmap("<A-k>", "<C-w>k")
lib.nmap("<A-l>", "<C-w>l")

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  pattern = "*",
  command = [[if &readonly==0 && filereadable(bufname('%')) | silent update | endif]],
})

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
})
