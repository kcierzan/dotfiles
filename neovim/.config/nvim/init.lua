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
  completeopt = { "menuone", "noselect" },
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
  python3_host_prog = os.getenv("HOME") .. "/.asdf/installs/python/3.10-dev/bin/python",
  tex_flavor = "latex",
  user_emmet_settings = {
    ["javascript.jsx"] = {
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

vim.g.mapleader = " "

Nmap = function(key, cmd)
  vim.api.nvim_set_keymap("n", key, cmd, { noremap = true, silent = true })
end

Xmap = function(key, cmd)
  vim.api.nvim_set_keymap("x", key, cmd, { noremap = true, silent = true })
end

-- set signs for lsp diagnostics
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local fn = vim.fn
local packer_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_installed = fn.empty(fn.glob(packer_path)) == 0

-- don't require plugins if packer isn't set up yet
if packer_installed then
  -- impatient should be loaded before any other plugins
  pcall(require, "impatient")
  pcall(require, "plugin.packer_compiled")
end

-- this module will bootstrap packer if it is missing
require("plugins")

vim.cmd("colorscheme thematic")
