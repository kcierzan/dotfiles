"                     _____             _
"   _________  ____  / __(_)___ __   __(_)___ ___
"  / ___/ __ \/ __ \/ /_/ / __ `/ | / / / __ `__ \
" / /__/ /_/ / / / / __/ / /_/ /| |/ / / / / / / /
" \___/\____/_/ /_/_/ /_/\__, (_)___/_/_/ /_/ /_/
"                       /____/
" ======= Set up Defaults ==============
set splitright
set splitbelow
set showcmd
set noshowmode
set noerrorbells
set relativenumber
set lazyredraw
set noswapfile
set cursorline
set nu
" disable auto break long lines
set textwidth=0
set ignorecase
set smartcase
set gdefault
" Start scrolling 3 lines before horizontal border
set scrolloff=3
"
" Set up standard indentation
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set shiftround

" Allow cursor changing with tmux
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Enable system clipboard
set clipboard=unnamed,unnamedplus

" Disable annoying automatic comments
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn |

" Set a persistent undo file
set undodir=~/.undo
set undofile
set undolevels=100000

" Set :grep to use ripgrep
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" ============ COLORSCHEME ======================

syntax enable
set background=dark
colorscheme termina

" Fix colors and enable transparency in terminal
" hi! EndOfBuffer ctermbg=None
" hi Normal guibg=NONE ctermbg=NONE
" hi! NonText ctermbg=None
" hi! LineNr ctermbg=None
" hi! Comment cterm=italic

" ============ FILETYPE SETTINGS ==================

" Set up Python style
autocmd BufNewFile,BufRead *.py
  \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 fileformat=unix colorcolumn=80 expandtab autoindent |

" ============= PLUGIN CONFIGURATION ==============

" ------------- EasyMotion ----------------
" With this option set, v will match both v and V, but V will match V only.
let g:EasyMotion_use_smartsign_us = 1 " US layout

" Use vim smartcase for global searches
let g:EasyMotion_smartcase = 1

" Remove annoying prefix
au VimEnter *  nmap <leader><leader> <Nop> |

" ------------- Jedi ----------------------
" Use deoplete for completion
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

" ------------- Tmux Navigator ------------
" Map alt + hjkl to navigation
let g:tmux_navigator_no_mappings = 1

" ------------- Deoplete ------------------
" Point to python neovim virtualenvs
let g:python_host_prog = '/Users/kylec/.pyenv/versions/neovim2/bin/python'
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

" -------------- Neomake ---------------------
" Lint as you type - WRITES TO FILE CONSTANTLY
autocmd InsertChange,TextChanged,InsertLeave * silent! update | Neomake

" Configure linters
let g:neomake_python_enabled_makers = ['flake8', 'pylint']
let g:neomake_python_pylint_maker = {
      \ 'args': ['--disable=all', '-enable=import-self, reimported, wildcard-import, misplaced-future, relative-import, deprecated-module, unpacking-non-sequence, invalid-all-object, undefined-all-variable, used-before-assignment, cell-var-from-loop, global-variable-undefined, redefined-builtin, redefine-in-handler, unused-import, unused-wildcard-import, global-variable-not-assigned, undefined-loop-variable, global-statement, global-at-module-level, bad-open-mode, redundant-unittest-assert, boolean-datetime, unused-variable', '--output-format=text', '--msg-template="{path}:{line}:{column}:{C}: [{symbol}] {msg} [{msg_id}]"', '--reports=no'],
      \ 'errorformat':
          \ '%A%f:%l:%c:%t: %m,' .
          \ '%A%f:%l: %m,' .
          \ '%A%f:(%l): %m,' .
          \ '%-Z%p^%.%#,' .
          \ '%-G%.%#',
      \ 'postprocess': [
          \   function('neomake#postprocess#GenericLengthPostprocess'),
          \   function('neomake#makers#ft#python#PylintEntryProcess')],
      \ 'exe': 'pylint',}

"----------- indentLine -----------------
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_setColors = 1

" ----------- vim-test -------------------
let test#python#runner = 'nose'
let test#strategy = "vimux"
let test#python#nose#options = '-x -v -s --with-coverage'

"----------- rainbow_parentheses ---------
let g:rainbow_active = 1

let g:rainbow_conf = { 'ctermfgs': ['magenta', 'blue', 'cyan', 'green', 'yellow', 'red'] }

"------------- abolish --------------------
if exists(":Abolish")
  Abolish {,un}su{bcr,bsrc,scr,bs,cr,sbcr,sci}ibe{,r,s,rs} {}su{bscri}be{}
  Abolish r{i,e}c{e,i}p{ei,i,e}nt r{e}c{i}p{ie}nt
endif

" ------------- Gitgutter ------------------
let g:gitgutter_map_keys = 0

" ------------- NERD Tree ------------------
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeWinSize = 31
let g:NERDTreeChDirMode = 2
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeShowBookmarks = 1
let NERDTreeShowHidden = 1

" NERDTree Colorscheme
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
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
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTreeToggle' argv()[0] | wincmd p | ene | endif

" ------------ Goyo -----------------------
function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowcmd
  set scrolloff=999
  set nocursorline
  Limelight
  nunmap <silent> <leader>
  vunmap <silent> <leader>
  IndentLinesDisable
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showcmd
  set scrolloff=3
  set cursorline
  Limelight!
  colorscheme termina
  nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
  IndentLinesEnable
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"----------- Limelight ---------------------
let g:limelight_conceal_ctermfg = 238
let g:limelight_default_coefficient = 0.5
let g:limelight_paragraph_span = 1

" ---------- Buftabline --------------------
set showtabline=2
