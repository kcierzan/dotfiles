"                     _____             _
"   _________  ____  / __(_)___ __   __(_)___ ___
"  / ___/ __ \/ __ \/ /_/ / __ `/ | / / / __ `__ \
" / /__/ /_/ / / / / __/ / /_/ /| |/ / / / / / / /
" \___/\____/_/ /_/_/ /_/\__, (_)___/_/_/ /_/ /_/
"                       /____/
" ======= Set up Defaults ==============
scriptencoding utf-8

set splitright
set splitbelow
set showcmd
set noshowmode
set noerrorbells
set number
set lazyredraw
set noswapfile
set cursorline
set number
" disable auto break long lines
set textwidth=0
set ignorecase
set smartcase
set gdefault
" Start scrolling 3 lines before horizontal border
set scrolloff=3
" Set up standard indentation
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set shiftround
set hidden
" Always show tabline
set showtabline=2

" Allow cursor changing with tmux
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Enable blinking cursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
"
" Enable system clipboard
set clipboard=unnamed

" Disable annoying automatic comments
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn |

" Set a persistent undo file
set undodir=~/.undo
set undofile
set undolevels=100000

" Set :grep to use ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" ============ COLORSCHEME ======================
syntax enable
set background=dark
colorscheme termina

" highlight current window
augroup SwitchPanes
  autocmd WinEnter * set cursorline | set nu | IndentLinesEnable
  autocmd WinLeave * set nocursorline | set nonumber | IndentLinesDisable
augroup END

" ============ FILETYPE SETTINGS ==================

" Set up Python style
autocmd BufNewFile,BufRead *.py
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 fileformat=unix colorcolumn=80 expandtab autoindent |

" Edit macos cron jobs
autocmd filetype crontab setlocal nobackup nowritebackup

autocmd BufNewFile,BufRead *.thtml
  \ setlocal syntax=phtml

" ============= PLUGIN CONFIGURATION ==============

" ------------- EasyMotion ----------------
" With this option set, v will match both v and V, but V will match V only.
let g:EasyMotion_use_smartsign_us = 1 " US layout

" Use vim smartcase for global searches
let g:EasyMotion_smartcase = 1

" Remove annoying prefix
augroup RemoveEasyMotionPrefix
  au VimEnter *  nmap <leader><leader> <Nop> |
augroup END

" ------------- Tmux Navigator ------------
" Map alt + hjkl to navigation
let g:tmux_navigator_no_mappings = 1

" ------------- Deoplete ------------------
" Point to python neovim virtualenvs
"
" Depends on the existence of a pyenv virtualenv for python2.7 and 3.6
let g:python_host_prog  = '/Users/kylec/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/kylec/.pyenv/versions/neovim3/bin/python'

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

"---------- ALE ----------------------
filetype off
filetype plugin on

" Depends on the existence of a pyenv virtualenv with pylint >= 1.7.1 and
" flake8 installed
"
" let g:ale_history_log_output = 1
let g:ale_linters                        = { 'python': ['pylint', 'flake8'],
                                           \ 'javascript': ['eslint'],
                                           \ 'css': ['stylelint'],
                                           \ 'php': ['phpstan'],
                                           \ 'bash': ['shellcheck'],
                                           \ 'html': ['tidy'],
                                           \ 'vim': ['vint'],
                                           \ 'yaml': ['yamllint'],
                                           \ }
let g:ale_linter_aliases                 = { 'javascript.jsx': 'javascript', 'jsx': 'javascript', 'thtml': 'html', 'phtml': 'html' }
let g:ale_python_pylint_options          = '--rcfile=/Users/kylec/.pylintrc'
let g:ale_python_pylint_use_global       = 1
let g:ale_python_flake8_use_global       = 1
let g:ale_javascript_eslint_use_global   = 1
let g:ale_python_flake8_executable       = '/Users/kylec/.pyenv/versions/neovim3/bin/flake8'
let g:ale_vim_vint_executable            = '/Users/kylec/.pyenv/versions/neovim3/bin/vint'
let g:ale_python_pylint_executable       = '/Users/kylec/.pyenv/versions/neovim3/bin/pylint'
let g:ale_javascript_eslint_executable   = '/usr/local/lib/node_modules/eslint/bin/eslint.js'
let g:ale_javascript_eslint_options      = '-c ~/.eslintrc.yml'
let g:ale_echo_msg_format                = '[%severity%] %s [%linter%]'
let g:ale_sign_error                     = '✖'
let g:ale_sign_warning                   = '⚠'
let g:ale_statusline_format              = ['✖ %d', '⚠ %d', '']
let g:ale_warn_about_trailing_whitespace = 1
highlight ALEErrorSign   ctermfg=1
highlight ALEWarningSign ctermfg=3

"----------- indentLine -----------------
let g:indentLine_enabled              = 1
let g:indentLine_char                 = '│'
let g:indentLine_first_char           = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude      = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_setColors            = 1

" ----------- vim-test -------------------
let g:test#python#runner       = 'nose'
let g:test#strategy            = 'vimux'
let g:test#python#nose#options = '-x -v -s --with-coverage'

"----------- rainbow_parentheses ---------
let g:rainbow_active = 1
let g:rainbow_conf   = { 'ctermfgs': ['magenta', 'blue', 'cyan', 'green', 'yellow', 'red'] }

" ------------- Gitgutter ------------------
let g:gitgutter_map_keys = 0

" ------------- NERD Tree ------------------
let g:NERDTreeHijackNetrw      = 1
let g:NERDTreeWinSize          = 31
let g:NERDTreeChDirMode        = 2
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowBookmarks    = 1
let g:NERDTreeShowHidden         = 1

" NERDTree Colorscheme
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'green', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('py', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'Magenta', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')

" Open directories with NERDTree
augroup OpenDirInNerdTree
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTreeToggle' argv()[0] | wincmd p | ene | endif
augroup END

" ------------ Goyo -----------------------
let g:goyo_width = 120
let g:goyo_linenr = 0

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowcmd
  set scrolloff=999
  set nocursorline
  nunmap <silent> <leader>
  vunmap <silent> <leader>
  IndentLinesDisable
  call deoplete#disable()
  ALEDisable
  set nonumber
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showcmd
  set scrolloff=3
  set cursorline
  colorscheme termina
  nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
  call deoplete#enable()
  IndentLinesEnable
  ALEEnable
  set number
endfunction

augroup GoyoToggle
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

"----------- Limelight ---------------------
let g:limelight_conceal_ctermfg     = 238
let g:limelight_default_coefficient = 0.5
let g:limelight_paragraph_span      = 1

"------------ neosnippet -------------------
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = '~/.local/share/nvim/plugged/vim-snippets/snippets'
let g:AutoPairsMapCR=0
let g:deoplete#auto_complete_start_length = 1 
" weird hack to close completion popup/expand snippets (expand with <C-k>)
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> pumvisible() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

"----------- CleverF ------------------------
let g:clever_f_across_no_line = 1
let g:clever_f_smart_case = 1
