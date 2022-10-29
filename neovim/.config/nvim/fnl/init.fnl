;; _____       __________ ________      ______
;; ___(_)_________(_)_  /____  __/_________  /
;; __  /__  __ \_  /_  __/__  /_ __  __ \_  /
;; _  / _  / / /  / / /____  __/ _  / / /  /
;; /_/  /_/ /_//_/  \__/(_)_/    /_/ /_//_/
;; lisp? in my vim configuration? it's more likely than you think...
(import-macros {: require*} :macros)
(require* colorscheme [:utils :colorscheme]
          opt [:utils :opt]
          plugins [:plugins]
          vim-global [:utils :vim-global])
(local home-dir (os.getenv :HOME))

(opt :autowriteall true)
(opt :backup false)
(opt :clipboard :unnamedplus)
(opt :cmdheight 1)
(opt :completeopt [:menu :menuone :noselect])
(opt :conceallevel 0)
(opt :cursorline true)
(opt :expandtab true)
(opt :fileencoding :utf-8)
(opt :hlsearch true)
(opt :ignorecase true)
(opt :mouse :a)
(opt :number true)
(opt :numberwidth 4)
(opt :pumheight 0)
(opt :relativenumber false)
(opt :scrolloff 8)
(opt :shiftround true)
(opt :shiftwidth 2)
(opt :showmode false)
(opt :showtabline 2)
(opt :sidescrolloff 8)
(opt :signcolumn :yes)
(opt :smartcase true)
(opt :smartindent true)
(opt :splitbelow true)
(opt :splitright true)
(opt :swapfile false)
(opt :tabstop 2)
(opt :termguicolors true)
(opt :timeoutlen 500)
(opt :undodir (.. home-dir "/.undo"))
(opt :undofile true)
(opt :undolevels 100_000)
(opt :updatetime 300)
(opt :wrap true)
(opt :writebackup false)
(opt :guicursor "n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor")

(vim-global :python3_host_prog (.. home-dir "./.asdf/installs/python/3.10.4/bin/python"))
(vim-global :tex_flavor :latex)
(vim-global :mapleader " ")
(vim-global :maplocalleader "+")
(vim-global :user_emmet_settings {:javascript.jsx {:extends :jsx}})

(vim.opt.shortmess:append :c)

(vim.cmd "set whichwrap+=<,>,[,],h,l")
(vim.cmd "set iskeyword+=-")
(vim.cmd "set formatoptions-=cro")

(fn create-autowrite-augroup []
  (let [group-id (vim.api.nvim_create_augroup :AutoWrite {:clear true})]
    (vim.api.nvim_create_autocmd [:BufEnter :FocusLost]
                                 {:pattern "*"
                                  :command "if &buftype == '' | silent update | endif"
                                  :group group-id})))
(create-autowrite-augroup)
(plugins.use!)
(colorscheme :inkd)
