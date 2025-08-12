local M = {}

function M.setup()
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
  vim.o.timeoutlen = 400
  vim.opt.undodir = os.getenv("HOME") .. "/.undo"
  vim.opt.undolevels = 100000
  vim.opt.updatetime = 100
  vim.opt.wrap = true
  vim.opt.writebackup = false
  vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor"
  vim.opt.shortmess = "astWAcCFo"
  vim.opt.shell = "nu"
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldenable = false
  vim.opt.foldlevel = 99
  vim.opt.foldnestmax = 3
  vim.opt.foldminlines = 1
  vim.opt.foldcolumn = "1"
  vim.opt.autoread = true
end

return M
