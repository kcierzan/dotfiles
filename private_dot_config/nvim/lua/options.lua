local M = {}

function M.setup()
  vim.o.linespace = 0
  vim.o.timeout = true
  vim.o.timeoutlen = 400
  vim.opt.autoread = true
  vim.opt.autowriteall = true
  vim.opt.backup = false
  vim.opt.clipboard = "unnamedplus"
  vim.opt.colorcolumn = "0"
  vim.opt.completeopt = { "menu", "menuone", "noselect" }
  vim.opt.conceallevel = 2
  vim.opt.cursorline = false
  vim.opt.expandtab = true
  vim.opt.fileencoding = "utf-8"
  vim.opt.foldcolumn = "1"
  vim.opt.foldenable = false
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldlevel = 99
  vim.opt.foldmethod = "expr"
  vim.opt.foldminlines = 1
  vim.opt.foldnestmax = 3
  vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor"
  vim.opt.hidden = true
  vim.opt.hlsearch = true
  vim.opt.iminsert = 1
  vim.opt.ignorecase = true
  vim.opt.laststatus = 3 -- only one statusline
  vim.opt.mouse = "a"
  vim.opt.number = true
  vim.opt.numberwidth = 4
  vim.opt.pumheight = 10
  vim.opt.relativenumber = false
  vim.opt.scrolloff = 8
  -- Nushell configuration
  -- See: https://www.kiils.dk/en/blog/2024-06-22-using-nushell-in-neovim/
  -- vim.opt.shell = "nu"
  -- vim.opt.shellcmdflag = "--login --stdin --no-newline -c"
  -- vim.opt.shellredir = "out+err> %s"
  -- vim.opt.shellpipe = "| complete | update stderr { ansi strip } | tee { get stderr | save --force --raw %s } | into record"
  -- vim.opt.shelltemp = false
  -- vim.opt.shellxescape = ""
  -- vim.opt.shellxquote = ""
  -- vim.opt.shellquote = ""
  vim.opt.shiftround = true
  vim.opt.shiftwidth = 2
  vim.opt.shortmess = "astWAcCFo"
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
  vim.opt.undodir = os.getenv("HOME") .. "/.undo"
  vim.opt.undolevels = 100000
  vim.opt.updatetime = 100
  vim.opt.wrap = true
  vim.opt.writebackup = false
end

return M
