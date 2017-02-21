" ##########################################################################
" #                                                                        #
" #                           F I X E S                                    #
" #                                                                        #
" ##########################################################################

" Enable terminal truecolors
set termguicolors

" Disable bells
set noerrorbells
set visualbell t_vb=

" Allow cursor changing with tmux
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Enable system clipboard
set clipboard=unnamed

" Enable powerline fonts
" let g:airline_powerline_fonts = 1

" stop airline from messing with tmuxline
" let g:airline#extensions#tmuxline#enabled = 0

" Disbale annoying automatic comments
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn

" ##########################################################################
" #                                                                        #
" #                              B A S I C                                 #
" #                           D E F A U L T S                              #
" #                                                                        #
" ##########################################################################

" Show what keys you are pressing
set showcmd

" Flag unnecessary whitespace
au BufRead, BufNewFile *.py, *.pyw, *.c, *.h match BadWhiteSpace /\s\+$/

" Set current line highlight
set cursorline

" Set :grep to use ripgrep
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Set up WM style splitting
set splitright
set splitbelow

" Start scrolling 3 lines before horizontal border
set scrolloff=3

" Set a persistent undo file
set undodir=~/.config/nvim/undo
set undofile
set undolevels=10000

" ##########################################################################
" #                                                                        #
" #                              L E A D E R                               #
" #                            M A P P I N G S                             #
" #                                                                        #
" ##########################################################################

" Set leader key
let mapleader = "\<Space>"

" Space + w saves a buffer
nnoremap <Leader>W :w<CR>

" Close window
nnoremap <Leader>q :q<CR>

" Force close window
nnoremap <Leader>Q :q!<CR>

" Close buffer
nnoremap <Leader>d :bd<CR>

" Clean search highlight
nnoremap <Leader>sc :noh<CR>

" Source dotfile
nnoremap <Leader>fer :so ~/.config/nvim/init.vim<CR>

" Edit Dotfile
nnoremap <Leader>fed :tabedit ~/.config/nvim/init.vim<CR>

" start changing directories
nnoremap <Leader>cd :cd<space>

" 
" Copy and pasting to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" ##########################################################################
" #                                                                        #
" #                            F I L E T Y P E                             #
" #                            S E T T I N G S                             #
" #                                                                        #
" ##########################################################################

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

" ##########################################################################
" #                                                                        #
" #                             P L U G I N S                              #
" #                                                                        #
" ##########################################################################

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.local/share/nvim/plugged')

" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
" &                                 &
" &        E D I T I N G            &
" &                                 &
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

" Automatic deliminters
Plug 'Raimondi/delimitMate'

" Surround with brackets, quotes etc
Plug 'tpope/vim-surround'

" Comment for great success
Plug 'tpope/vim-commentary'

" Provide additional text objects
Plug 'wellle/targets.vim'

" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
" &                                 &
" &         J U M P I N G           &
" &       S E A R C H I N G         &
" &         G R E P I N G           &
" &                                 &
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

" Easymotion
Plug 'easymotion/vim-easymotion'

" <Leader>f{char} to move to {char}
  map  <Leader>f <Plug>(easymotion-bd-f)
  nmap <Leader>f <Plug>(easymotion-overwin-f)

  " s{char}{char} to move to {char}{char}
  nmap s <Plug>(easymotion-overwin-f2)

  " Move to line
  map <Leader>L <Plug>(easymotion-bd-jk)
  nmap <Leader>L <Plug>(easymotion-overwin-line)

  " Move to word
  map  <Leader>w <Plug>(easymotion-bd-w)
  nmap <Leader>w <Plug>(easymotion-overwin-w)

  " With this option set, v will match both v and V, but V will match V only.
  let g:EasyMotion_use_smartsign_us = 1 " US layout

  " Use vim smartcase for global searches
  let g:EasyMotion_smartcase = 1

" MRU Source for Denite
Plug 'Shougo/neomru.vim'

" Unite all interfaces
Plug 'Shougo/denite.nvim'
" Vim Jedi for definition jumping and code navigation
Plug 'davidhalter/jedi-vim'
  " Use deoplete for completion
  let g:jedi#completions_enabled = 0

" Search in files
Plug 'mileszs/ack.vim'
  " set ack.vim to use ripgrep
  let g:ackprg = 'rg --vimgrep --no-heading'

" FZF already installed via homebrew
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
  " Search files in current dir
  nnoremap <Leader><tab> :FZF<CR>

" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
" &                                 &
" &       I N T E R F A C E         &
" &                                 &
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

" Git gutter
Plug 'airblade/vim-gitgutter'

" Undo Tree
Plug 'mbbill/undotree'

" Fancy start screen
Plug 'mhinz/vim-startify'

" Delete and close buffers without closing windows
Plug 'moll/vim-bbye'

" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
" &                                  &
" &           T H E M E              &
" &                                  &
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

" Airline for neovim
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'

" Lightline for more speed
Plug 'itchyny/lightline.vim'

" Tmuxline
Plug 'edkolev/tmuxline.vim'

" Better looking tabs
Plug 'mkitt/tabline.vim'
  " Make the tabline look dank
  " let g:airline#extensions#tabline#enabled = 1

" base16 colorscheme
Plug 'chriskempson/base16-vim'
  let base16colorspace=256

" Improve python syntax highlighting
" Plug 'vim-python/python-syntax'
 
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
" &                                   &
" &     I N T E G R A T I O N         &
" &                                   &
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

" Git Wrapper
Plug 'tpope/vim-fugitive'

"Vim Tmux navigation harmony
Plug 'christoomey/vim-tmux-navigator'
" Hack to stop vim from eating Ctrl-h and preventing vim-tmux navigation
" nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
  " Map alt + hjkl to navigation
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
  nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>

" Interact with tmux from vim
Plug 'benmills/vimux'

" Run tests
Plug 'janko-m/vim-test'

" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
" &                                    &
" &            L I N T I N G           &
" &          C O M P L E T I O N       &
" &                                    &
" &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

" Lots of language packs
Plug 'sheerun/vim-polyglot'

" Deoplete completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " Point to python neovim virtualenvs
  let g:python_host_prog = '/usr/local/var/pyenv/versions/neovim2/bin/python'
  let g:python3_host_prog = '/usr/local/var/pyenv/versions/neovim3/bin/python'

  " Enable deoplete at startup
  let g:deoplete#enable_at_startup = 1

  " Use smartcase.
  let g:deoplete#enable_smart_case = 1

  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
  endfunction

  if !exists('g:deoplete#omni#input_patterns')
    let g:deoplete#omni#input_patterns = {}
  endif

" Close the completion buffer once completion is done
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" Deoplete Jedi for great python success
Plug 'zchee/deoplete-jedi'

" Async linting courtesy of neomake
" IMPORTANT: This will write to the file on every change. You may hate this.
Plug 'neomake/neomake'
  autocmd InsertChange,TextChanged,InsertLeave * update | Neomake
  let g:neomake_python_enabled_makers = ['flake8', 'pylint']

" Tab menu for completion
Plug 'ervandew/supertab'

call plug#end()

" ##########################################################################
" #                                                                        #
" #                             T H E M E                                  #
" #                            T W E A K S                                 #
" #                                                                        #
" ##########################################################################

" Set Theme and syntax highlight - Will get overridden by base16 helper
syntax enable

" Set base16 theme from the commandline
if filereadable(expand("~/.vimrc_background"))
  source ~/.vimrc_background
endif

" Fix colors and enable transparency in terminal
hi! EndOfBuffer ctermbg=None
hi Normal guibg=NONE ctermbg=NONE
hi! NonText ctermbg=None
hi! LineNr ctermbg=None

" Denite uses ripgrep
call denite#custom#var('file_rec', 'command',
      \ ['rg', '--files', '--glob', '!.git', ''])

" ##########################################################################
" #                                                                        #
" #                         L I G H T L I N E                              #
" #                            C O N F I G                                 #
" #                                                                        #
" ##########################################################################

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ],
      \             [ 'neomake' ] ],
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlilneFilename',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ 'component_expand': {
      \   'neomake': 'LightlineNeomake',
      \ },
      \ 'component_type': {
      \   'neomake': 'error',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }

function! LightlineModified()
  if &filetype == "help" 
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'denite' ? denite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? "\ue0a0 ".branch : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "\ue0a2"
  else
    return ""
  endif
endfunction

function! LightlineNeomake()
  return '%{neomake#statusline#LoclistStatus()}'
endfunction

augroup LightlineNeomake
  autocmd!
  autocmd BufWritePost *.py call lightline#update()
augroup END

" Denite config
autocmd FileType unite call s:uniteinit()
  function! s:uniteinit()
      set nonumber
      set norelativenumber
      nunmap <buffer> d
      nunmap <buffer> a
      nunmap <buffer> <c-n>
      nunmap <buffer> <c-k>
      nunmap <buffer> <c-p>

      nmap <silent> <Esc> <Plug>(unite_all_exit)
      nmap <silent> <c-n> <Plug>(unite_loop_cursor_down)
      nmap <silent> <c-p> <Plug>(unite_loop_cursor_up)

    endfunction

  call denite#custom#option('default', 'prompt', '❯')
  "  \     'rg', '--glob', '!.git', ''

  call denite#custom#source(
	\ 'file_rec', 'vars', {
	\   'command': [
  \      'ag', '--follow','--nogroup','--hidden', '-g', '', '--ignore', '.git', '--ignore', '*.png'
	\   ] })
  let s:menus = {}
	call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('grep', 'default_opts',
			\ ['--vimgrep', '--no-heading'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
  " call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
  " call denite#custom#option('default', 'statusline', 0)
  call denite#custom#option('default', 'highlight-matched-char', '')
  call denite#custom#option('default', 'highlight-matched-range', '')
  hi deniteMatched guibg=None
  hi deniteMatchedChar guibg=None

  nnoremap <silent> <c-p> :Denite file_rec<CR>
  nnoremap <silent> <leader>h :Denite  help<CR>
  nnoremap <silent> <leader>c :Denite colorscheme<CR>
  nnoremap <silent> <leader>u :call dein#update()<CR>
  nnoremap <silent> <leader>b :Denite buffer<CR>
  call denite#custom#map(
      \ 'insert',
      \ '<C-n>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
	call denite#custom#map(
	      \ 'insert',
	      \ '<C-p>',
	      \ '<denite:move_to_previous_line>',
	      \ 'noremap'
	      \)

  call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

  call denite#custom#var('menu', 'menus', s:menus)
  nnoremap <silent> <Leader>i :Denite -auto-resize menu:ionic <CR>

" Git from denite...ERMERGERD
  let s:menus.git = {
    \ 'description' : 'Fugitive interface',
    \}
  let s:menus.git.command_candidates = [
    \[' git status', 'Gstatus'],
    \[' git diff', 'Gvdiff'],
    \[' git commit', 'Gcommit'],
    \[' git stage/add', 'Gwrite'],
    \[' git checkout', 'Gread'],
    \[' git rm', 'Gremove'],
    \[' git cd', 'Gcd'],
    \[' git push', 'exe "Git! push " input("remote/branch: ")'],
    \[' git pull', 'exe "Git! pull " input("remote/branch: ")'],
    \[' git pull rebase', 'exe "Git! pull --rebase " input("branch: ")'],
    \[' git checkout branch', 'exe "Git! checkout " input("branch: ")'],
    \[' git fetch', 'Gfetch'],
    \[' git merge', 'Gmerge'],
    \[' git browse', 'Gbrowse'],
    \[' git head', 'Gedit HEAD^'],
    \[' git parent', 'edit %:h'],
    \[' git log commit buffers', 'Glog --'],
    \[' git log current file', 'Glog -- %'],
    \[' git log last n commits', 'exe "Glog -" input("num: ")'],
    \[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
    \[' git log until date', 'exe "Glog --until=" input("day: ")'],
    \[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
    \[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
    \[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
    \[' git mv', 'exe "Gmove " input("destination: ")'],
    \[' git grep',  'exe "Ggrep " input("string: ")'],
    \[' git prompt', 'exe "Git! " input("command: ")'],
    \] " Append ' --' after log to get commit info commit buffers
