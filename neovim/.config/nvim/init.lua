--[[
 __         __ __          __
|__|.-----.|__|  |_       |  |.--.--.---.-.
|  ||     ||  |   _|  __  |  ||  |  |  _  |
|__||__|__||__|____| |__| |__||_____|___._|

--]]
local options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 2,
  completeopt = {"menuone", "noselect"},
  conceallevel = 0,
  cursorline = true,
  expandtab = true,
  fileencoding = "utf-8",
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  number = true,
  numberwidth = 4,
  pumheight = 10,
  relativenumber = false,
  scrolloff = 8,
  shiftround = true,
  shiftwidth = 2,
  showmode = false,
  showtabline = 2,
  sidescrolloff = 8,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 2,
  termguicolors = true,
  timeoutlen = 500,
  undodir = os.getenv("HOME") .. "/.undo",
  undofile = true,
  undolevels = 100000,
  updatetime = 300,
  wrap = false,
  writebackup = false,
  guicursor = "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:hor20-Cursor/lCursor",
}

local variables = {
  python3_host_prog = os.getenv("HOME") .. '/.asdf/installs/python/3.10-dev/bin/python',
  tex_flavor = "latex",
  user_emmet_settings = {
    ['javascript.jsx'] = {
      extends = "jsx"
    }
  },
}

vim.opt.shortmess:append "c"

for k, v in pairs(options) do
  vim.opt[k] = v
end

for _, v in pairs(variables) do
  vim.g.k = v
end

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]]

vim.g.mapleader = ' '

local nmap = function(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

local xmap = function(key, cmd)
  vim.api.nvim_set_keymap("x", key, cmd, { noremap = true, silent = true })
end

nmap('<Leader>i%', '<cmd>set invrelativenumber<cr>')
nmap('<Leader>i#', '<cmd>set invnumber<cr>')
nmap('<Leader>il', '<cmd>IndentBlanklineToggle<cr>')
nmap('<Leader>ic', '<cmd>nohlsearch<cr>')
nmap('<Leader>ih', '<cmd>ColorizerAttachToBuffer<cr>')

nmap('<Leader>wv', '<cmd>vsp<cr>')
nmap('<Leader>ws', '<cmd>sp<cr>')
nmap('<Leader>wk', '10<C-w>+')
nmap('<Leader>wj', '10<C-w>-')
nmap('<Leader>wr', '<C-w>r')
nmap('<Leader>wo', "<C-w>o")
nmap('<Leader>we', "<C-w>=")
nmap('<Leader>wV', "<C-w>H")
nmap('<Leader>wS', "<C-w>J")

nmap('<Leader>gs', "<cmd>Git<cr>")
nmap('<Leader>gb', "<cmd>Git blame<cr>")
nmap('<Leader>gn', "<Plug>(signify-next-hunk)")
nmap('<Leader>gN', "<Plug>(signify-prev-hunk)")
nmap('<Leader>gd', "<cmd>Gvdiff<cr>")
nmap('<Leader>gl', "<cmd>GV<cr>")
nmap('<Leader>go', "<cmd>Gbrowse<cr>")
nmap('<Leader>gc', "<cmd>Gcommit<cr>")
nmap('<Leader>gr', "<cmd>Gvdiffsplit!<cr>")
nmap('<Leader>gt', "<cmd>diffget //2<cr>")
nmap('<Leader>gm', "<cmd>diffget //3<cr>")

nmap("grl", "<cmd>diffget<cr>")
nmap("grh", "<cmd>diffput<cr>")
xmap("grl", "<cmd>diffget<cr>")
xmap("grh", "<cmd>diffput<cr>")
nmap("L", "<Nop>")
nmap("H", "<Nop>")
xmap("H", "<Nop>")
xmap("L", "<Nop>")
nmap("L", "g_")
nmap("H", "^")
xmap("L", "g_")
xmap("H", "^")
nmap("<Leader>q", "<cmd>q<cr>")
nmap("<Leader>Q", "<cmd>q!<cr>")

nmap("<C-l>", "<cmd>bnext<cr>")
nmap("<C-h>", "<cmd>bprev<cr>")

-- set signs for lsp diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local fn = vim.fn
local packer_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_installed = fn.empty(fn.glob(packer_path)) == 0

-- don't require plugins if packer isn't set up yet
if packer_installed then
  -- impatient should be loaded before any other plugins
  require('impatient')
  require('plugin.packer_compiled')
end

-- this module will bootstrap packer if it is missing
require('plugins')

vim.cmd("colorscheme thematic")
