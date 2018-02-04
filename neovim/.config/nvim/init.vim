"     _       _ __        _
"    (_)___  (_) /__   __(_)___ ___
"   / / __ \/ / __/ | / / / __ `__ \
"  / / / / / / /__| |/ / / / / / / /
" /_/_/ /_/_/\__(_)___/_/_/ /_/ /_/

" ======= Set up Defaults ==============

" Fix $PATH issues from using Fish
set shell=/bin/sh

scriptencoding utf-8
set splitright
set splitbelow
set showcmd
set noshowmode
set noerrorbells
set number
set nolazyredraw
set ttyfast
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

" Completion options
set completeopt-=preview
set pumheight=10

" Enable blinking cursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

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

" Vim autosaves and reflects changes to files on disk
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

" Virtualenv for python-dependent plugins
let g:python3_host_prog = $HOME . '/.virtualenvs/neovim/bin/python3'

" Load plugins
call plug#begin('~/.local/share/nvim/plugged')

" ============ COLORSCHEME ======================
Plug '~/git/termina'

" highlight current window
augroup SwitchPanes
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

" ============ FILETYPE SETTINGS ==================

" Set up Python style
autocmd BufNewFile,BufRead *.py
      \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 fileformat=unix expandtab autoindent |

" Edit macos cron jobs
autocmd filetype crontab setlocal nobackup nowritebackup

autocmd BufNewFile,BufRead *.thtml
      \ setlocal syntax=phtml

" ============= PLUGIN CONFIGURATION ==============

" ------------- Startify ----------------
" The cow says...
Plug 'mhinz/vim-startify'

" ------------- EasyMotion ----------------
Plug 'easymotion/vim-easymotion'

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

"----------nvim-completion-manager---------
Plug 'roxma/nvim-completion-manager'
set shortmess+=c

"---------- ALE ----------------------
Plug 'w0rp/ale'                            " Asynchronous linting engine
filetype off
filetype plugin on

" Depends on the existence of a virtualfish virtualenv with pylint >= 1.7.1 and flake8 installed

" let g:ale_history_log_output = 1
let g:ale_linters = {
      \ 'python': ['pylint', 'flake8'],
      \ 'javascript': ['eslint'],
      \ 'css': ['stylelint'],
      \ 'php': ['phpstan'],
      \ 'bash': ['shellcheck'],
      \ 'html': ['tidy'],
      \ 'vim': ['vint'],
      \ 'yaml': ['yamllint'],
      \ 'jsx': ['eslint']
      \ }
let g:ale_linter_aliases = {
      \ 'jsx': 'javascript',
      \ 'thtml': 'html',
      \ 'phtml': 'html',
      \ }
let g:ale_python_pylint_options = '--rcfile=~/.pylintrc'
let g:ale_python_pylint_use_global = 1
let g:ale_python_flake8_use_global = 1
let g:ale_javascript_eslint_use_global = 1
let g:ale_python_flake8_executable = $HOME . '/.virtualenvs/neovim/bin/flake8'
let g:ale_vim_vint_executable = $HOME . '/.virtualenvs/neovim/bin/vint'
let g:ale_python_pylint_executable = $HOME . '/.virtualenvs/neovim/bin/pylint'
let g:ale_javascript_eslint_executable   = '/usr/local/lib/node_modules/eslint/bin/eslint.js'
let g:ale_javascript_eslint_options = '-c ~/.eslintrc.yml'
let g:ale_echo_msg_format = '[%severity%] %s [%linter%]'
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['✖ %d', '⚠ %d', '']
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_lint_on_text_changed = 'normal'
highlight ALEErrorSign ctermfg=1
highlight ALEWarningSign ctermfg=3

"----------- indentLine -----------------
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_setColors = 1

" ----------- vim-test -------------------
Plug 'janko-m/vim-test'                    " Run tests
Plug 'benmills/vimux'                      " Interact with tmux from vim

let g:test#python#runner = 'nose'
let g:test#strategy = 'vimux'
let g:test#python#nose#options = '-x -v -s --with-coverage'

"----------- rainbow_parentheses ---------
let g:rainbow_active = 1
let g:rainbow_conf = { 'ctermfgs': ['blue', 'cyan', 'magenta', 'red', 'yellow', 'green'] }

" ------------- Gitgutter ------------------
Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0

" ------------ Goyo -----------------------
Plug 'junegunn/goyo.vim' " Remove distractions

let g:goyo_width = 100
let g:goyo_linenr = 0

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowcmd
  set noshowmode
  set scrolloff=999
  set nocursorline
  nunmap <silent> <leader>
  vunmap <silent> <leader>
  IndentLinesDisable
  ALEDisable
  set nonumber
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showcmd
  set showmode
  set scrolloff=3
  set cursorline
  colorscheme termina
  nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
  IndentLinesEnable
  ALEEnable
  set number
endfunction

augroup GoyoToggle
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

"----------- Limelight ---------------------
Plug 'junegunn/limelight.vim'              " Draw attention to code

let g:limelight_conceal_ctermfg = 238
let g:limelight_default_coefficient = 0.5
let g:limelight_paragraph_span = 1

"------------ neosnippet -------------------
Plug 'Shougo/neosnippet.vim'               " Snippet functionality
Plug 'honza/vim-snippets'                  " Snippet collection
Plug 'Shougo/neosnippet-snippets'          " Snippet collection
 
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory = '~/.local/share/nvim/plugged/vim-snippets/snippets'
let g:AutoPairsMapCR = 0
let g:deoplete#auto_complete_start_length = 1
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" ---------- Expand Region -------------------
Plug 'terryma/vim-expand-region'
vmap e <Plug>(expand_region_expand)
vmap E <Plug>(expand_region_shrink)

" ----------- Comfortable Motion ------------
Plug 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_friction = 20.0
let g:comfortable_motion_air_drag = 4.0

"------------fzf.vim----------------
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

let g:fzf_buffers_jump = 1

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 1,
  \ <bang>0 ? fzf#vim#with_preview('up:60%')
  \         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \ <bang>0)
"------------- Jedi -------------------------
Plug 'davidhalter/jedi-vim'

let g:jedi#auto_vim_configuration = 0
let g:jedi#use_splits_not_buffers = 1
let g:jedi#goto_command = 'gd'
let g:jedi#goto_assignments_command = ""
let g:jedi#goto_definitions_command = ""
let g:jedi#goto_usages_command = 'gn'
let g:jedi#completions_command = ""
let g:jedi#rename_command = 'gr'
let g:jedi#documentation_command = "gk"
let g:jedi#completions_enabled = 0

"------------- Misc Plugins -----------------
let g:polyglot_disabled = [ 'javascript', 'python' ]

let g:python_highlight_all = 1

Plug 'Shougo/neomru.vim'                   " Recent files
Plug 'tpope/vim-vinegar'                   " Make netrw better
Plug 'tpope/vim-repeat'                    " Use . to repeat some stuff
Plug 'jiangmiao/auto-pairs'                " Automatic deliminters
Plug 'tpope/vim-surround'                  " Surround with brackets, quotes etc
Plug 'tpope/vim-commentary'                " Comment for great success
Plug 'wellle/targets.vim'                  " Provide additional text objects
Plug 'mbbill/undotree'                     " Undo Tree
Plug 'moll/vim-bbye'                       " Delete and close buffers without closing windows
Plug 'itchyny/lightline.vim'               " Lightline for more speed
Plug 'mkitt/tabline.vim'                   " Better looking tabs
Plug 'tpope/vim-fugitive'                  " Git Wrapper
Plug 'christoomey/vim-tmux-navigator'      " Vim Tmux navigation harmony
Plug 'sheerun/vim-polyglot'                " Lots of language packs
Plug 'Yggdroot/indentLine'                 " indent lines
Plug 'junegunn/vim-easy-align'             " align stuff
Plug 'michaeljsmith/vim-indent-object'     " indentation objects
Plug 'tpope/vim-abolish'                   " correct common misspellings
Plug 'AndrewRadev/sideways.vim'            " Move stuff sideways
Plug 'hecal3/vim-leader-guide'             " Spacemacs style leader guide
Plug 'othree/yajs.vim',                    { 'for': ['javascript', 'javascript.jsx'] } " improved JS syntax highlighting
Plug 'othree/es.next.syntax.vim',          { 'for': ['javascript', 'javascript.jsx'] } " ES next syntax
Plug 'tpope/vim-rhubarb'                   " Access GitHub
Plug 'mattn/emmet-vim'                     " Markup Expansion
Plug 'majutsushi/tagbar'                   " show some tags
Plug 'vim-python/python-syntax',           { 'for': ['python'] } " Make python look a little better
Plug 'luochen1990/rainbow'                 " Rainbow Parens
Plug 'altercation/vim-colors-solarized'    " Termina sucks with solarized
Plug 'scrooloose/vim-slumlord'             " Diagrams are cool
Plug 'aklt/plantuml-syntax'                " Draw diagrams via annoying Java dependency...
Plug 'haya14busa/vim-keeppad'              " Keep padding when line nums go away
call plug#end()

" ---------- Post Plugin Config ----------
syntax enable
set background=dark
colorscheme termina

let g:ascii = [
      \ '    ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓',
      \ '    ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒',
      \ '   ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░',
      \ '   ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ ',
      \ '   ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒',
      \ '   ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░',
      \ '   ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░',
      \ '      ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   ',
      \ '            ░    ░  ░    ░ ░        ░   ░         ░   ',
      \ '                                   ░                  '
      \]
let g:scroll =
      \ map(split(system('fortune -s | fmt -42 | boxes -k 1 -p h2 -d parchment'), '\n'), '"   ". v:val')

let g:drip_header =
      \ map(g:ascii + g:scroll, '"   ".v:val')

function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:filter_header(g:drip_header)

" ----------- Load additional config ----------------
if filereadable(expand('~/.config/nvim/binding.vim'))
  source ~/.config/nvim/binding.vim
endif

if filereadable(expand('~/.config/nvim/lightline.vim'))
  source ~/.config/nvim/lightline.vim
endif
