"                      _____             _         
"    _________  ____  / __(_)___ __   __(_)___ ___ 
"   / ___/ __ \/ __ \/ /_/ / __ `/ | / / / __ `__ \
" / /__/ /_/ / / / / __/ / /_/ /| |/ / / / / / / /
" \___/\____/_/ /_/_/ /_/\__, (_)___/_/_/ /_/ /_/ 
"                       /____/                    
set splitright
set splitbelow
set showcmd
set termguicolors
set noerrorbells

" Allow cursor changing with tmux
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Enable system clipboard
set clipboard=unnamed

" Disbale annoying automatic comments
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn


" Flag unnecessary whitespace
au BufRead, BufNewFile *.py, *.pyw, *.c, *.h match BadWhiteSpace /\s\+$/


" Set :grep to use ripgrep
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Start scrolling 3 lines before horizontal border
set scrolloff=5

" Set a persistent undo file
set undodir=~/.config/nvim/undo
set undofile
set undolevels=100000

" Copy and pasting to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Set up standard indentation
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

" Set up Python indentation
au BufNewFile, BufRead *.py
      \ set tabstop=4
      \ set softtabstop=4
      \ set shiftwidth=4
      \ set textwidth=79
      \ set expandtab
      \ set autoindent
      \ set fileformat=unix
      \ set colorcolumn=80

" With this option set, v will match both v and V, but V will match V only.
let g:EasyMotion_use_smartsign_us = 1 " US layout

" Use vim smartcase for global searches
let g:EasyMotion_smartcase = 1

" Use deoplete for completion
let g:jedi#completions_enabled = 0

" set ack.vim to use ripgrep
let g:ackprg = 'rg --vimgrep --no-heading'

" Map alt + hjkl to navigation
let g:tmux_navigator_no_mappings = 1

" Point to python neovim virtualenvs
let g:python_host_prog = '/usr/local/var/pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/usr/local/var/pyenv/versions/neovim3/bin/python'

" Enable deoplete at startup
let g:deoplete#enable_at_startup = 1

" Use smartcase.
let g:deoplete#enable_smart_case = 1

" <C-h>, <BS>: close popup and delete backword char.
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif

" Close the completion buffer once completion is done
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Lint as you type - WRITES TO FILE CONSTANTLY
autocmd InsertChange,TextChanged,InsertLeave * update | Neomake
let g:neomake_python_enabled_makers = ['flake8']

syntax enable
let g:gruvbox_termcolors = 256
let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gitgutter_override_sign_column_highlight = 1
colorscheme gruvbox
set background=dark
" let g:nord_italic_comments = 1

" Set base16 theme from the commandline
" if filereadable(expand("~/.vimrc_background"))
"   source ~/.vimrc_background
" endif

" Fix colors and enable transparency in terminal
hi! EndOfBuffer ctermbg=None
hi Normal guibg=NONE ctermbg=NONE
hi! NonText ctermbg=None
hi! LineNr ctermbg=None
hi! Comment cterm=italic

" configure vim-test
let test#python#runner = "nose"
let test#python#nose#options = "-xvs"
let test#strategy = "neovim"
