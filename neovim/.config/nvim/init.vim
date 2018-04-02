"     _       _ __        _
"    (_)___  (_) /__   __(_)___ ___
"   / / __ \/ / __/ | / / / __ `__ \
"  / / / / / / /__| |/ / / / / / / /
" /_/_/ /_/_/\__(_)___/_/_/ /_/ /_/

scriptencoding utf-8
set shell=/usr/local/bin/zsh
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
set textwidth=0
set ignorecase
set smartcase
set gdefault
set scrolloff=3
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nowrap
set shiftround
set smartindent
set autoindent
set hidden
set completeopt-=preview
set pumheight=10
set conceallevel=2
set timeoutlen=1000
set ttimeoutlen=0

" Enable blinking cursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor

" Enable system clipboard
set clipboard=unnamed

" Disable annoying automatic comments
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn |

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

"autocmds
autocmd BufNewFile,BufRead *.py
      \ setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 fileformat=unix expandtab autoindent |

autocmd BufNewFile,BufRead *.md
      \ setlocal wrap tabstop=2 softtabstop=2 shiftwidth=2 textwidth=100 fileformat=unix expandtab smartindent |

autocmd filetype crontab setlocal nobackup nowritebackup

autocmd BufNewFile,BufRead *.thtml
      \ setlocal syntax=phtml

augroup SwitchPanes
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

"ex commands
function! JSONify()
  %!python -m json.tool
  set syntax=json
endfunction

"json pretty print
command J :call JSONify()

" Remove trailing whitespace
command Nows :%s/\s\+$//

call plug#begin('~/.local/share/nvim/plugged')

Plug '~/git/termina'

"vim-startify
Plug 'mhinz/vim-startify'

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

"vim-sneak
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#s_next =1
autocmd Colorscheme * hi Sneak ctermfg=black ctermbg=red

"vim-tmux-navigator
" Map alt + hjkl to navigation
let g:tmux_navigator_no_mappings = 1
Plug 'christoomey/vim-tmux-navigator'      " Vim Tmux navigation harmony

"nvim-completion-manager
Plug 'roxma/nvim-completion-manager'
set shortmess+=c

"ALE
Plug 'w0rp/ale'
filetype off
filetype plugin on
let g:ale_linters = {
      \ 'python': ['pylint', 'flake8'],
      \ 'javascript': ['eslint'],
      \ 'css': ['stylelint'],
      \ 'php': ['phpcs'],
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
" let g:ale_python_flake8_executable = $HOME . '/.virtualenvs/neovim/bin/flake8'
let g:ale_vim_vint_executable = $HOME . '/.virtualenvs/neovim/bin/vint'
" let g:ale_python_pylint_executable = $HOME . '/.virtualenvs/neovim/bin/pylint'
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

"indentLine
Plug 'Yggdroot/indentLine'                 " indent lines
let g:indentLine_enabled = 1
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_bufTypeExclude = ['terminal']
let g:indentLine_setColors = 1

"vim-test
Plug 'janko-m/vim-test'                    " Run tests
Plug 'benmills/vimux'                      " Interact with tmux from vim
let g:test#python#runner = 'nose'
let g:test#strategy = 'vimux'
let g:test#python#nose#options = '-x -v -s --with-coverage'

"rainbow_parentheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
let g:rainbow_conf = { 'ctermfgs': ['blue', 'cyan', 'magenta', 'red', 'yellow', 'green'] }

"vim-gitgutter
Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 5000

"goyo
Plug 'junegunn/goyo.vim' " Remove distractions
let g:goyo_width = 100
let g:goyo_linenr = 0

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowcmd
  set noshowmode
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

"limelight
Plug 'junegunn/limelight.vim'              " Draw attention to code
let g:limelight_conceal_ctermfg = 238
let g:limelight_default_coefficient = 0.5
let g:limelight_paragraph_span = 1

"neosnippet
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

"vim-expand-region
Plug 'terryma/vim-expand-region'
vmap e <Plug>(expand_region_expand)
vmap E <Plug>(expand_region_shrink)

"comfortable-motion
Plug 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_friction = 15.0
let g:comfortable_motion_air_drag = 5.0

"fzf.vim
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'right': '~66%' }
let g:fzf_buffers_jump = 1

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --line-number --no-heading --color=always '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview('right:50%'))

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0,
  \ fzf#vim#with_preview('right:50%'))

command! -bang -nargs=* HHistory
  \ call fzf#vim#history(fzf#vim#with_preview('right:50%'))

command! -bang -nargs=* GFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%'))

command! -nargs=* -complete=dir Cd call fzf#run(fzf#wrap(
  \ {'source': 'gfind '.(empty(<q-args>) ? '~/git' : <q-args>).' -maxdepth 1 -type d',
  \  'sink': 'cd'}))

"jedi-vim
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

"vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

"vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
" let g:airline_left_sep=''
" let g:airline_right_sep=''
let g:airline_theme='termina'
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = ' '
let airline#extensions#ale#warning_symbol = ' '
let g:airline#extensions#tabline#enabled = 1

"misc plugins
let g:polyglot_disabled = [ 'javascript', 'javascript.jsx', 'python' ]

let g:python_highlight_all = 1

Plug 'Shougo/neomru.vim'                   " recent files
Plug 'tpope/vim-vinegar'                   " make netrw better
Plug 'tpope/vim-repeat'                    " use . to repeat some stuff
Plug 'jiangmiao/auto-pairs'                " automatic deliminters
Plug 'tpope/vim-surround'                  " surround with brackets, quotes etc
Plug 'tpope/vim-commentary'                " comment for great success
Plug 'wellle/targets.vim'                  " provide additional text objects
Plug 'mbbill/undotree'                     " undo Tree
Plug 'moll/vim-bbye'                       " delete and close buffers without closing windows
Plug 'mkitt/tabline.vim'                   " better looking tabs
Plug 'tpope/vim-fugitive'                  " git Wrapper
Plug 'sheerun/vim-polyglot'                " lots of language packs
Plug 'junegunn/vim-easy-align'             " align stuff
Plug 'michaeljsmith/vim-indent-object'     " indentation objects
Plug 'tpope/vim-abolish'                   " correct common misspellings
Plug 'AndrewRadev/sideways.vim'            " move stuff sideways
Plug 'hecal3/vim-leader-guide'             " which-key style leader guide
Plug 'tpope/vim-rhubarb'                   " access GitHub
Plug 'mattn/emmet-vim'                     " markup Expansion
Plug 'majutsushi/tagbar'                   " show some tags
Plug 'vim-python/python-syntax',           { 'for': ['python'] } " Make python look a little better
Plug 'haya14busa/vim-keeppad'              " keep padding when line nums go away
Plug 'othree/es.next.syntax.vim',          { 'for': ['javascript', 'javascript.jsx'] } " ES next syntax
Plug 'othree/yajs.vim',                    { 'for': ['javascript', 'javascript.jsx'] } " improved JS syntax highlighting
Plug 'wesQ3/vim-windowswap'                " swap windows around
Plug 'jrebert/vimagit'                     " magit for vim
call plug#end()

syntax enable
set background=dark
colorscheme termina

" Keep search results in the center of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Select all text
noremap vA ggVG

" Align stuff
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Move stuff left and right
nmap gsh :SidewaysLeft<CR>
nmap gsl :SidewaysRight<CR>

" Jump to tag in new window
nnoremap gT g<C-]>
" Jump to tag
nnoremap gt g<C-]>

" Jump to next error message
nnoremap ge :ALENextWrap<CR>

" Show syntax highlight at point
map gi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Replace f and t with sneak equivalents
nmap f <Plug>Sneak_f
nmap F <Plug>Sneak_F
nmap t <Plug>Sneak_t
nmap T <Plug>Sneak_T

" Universal nvim split / Tmux navigation
nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-b> :TmuxNavigatePrevious<cr>

imap <expr> <CR>  (pumvisible() ?  "\<c-y>\<Plug>(expand_or_nl)" : "\<CR>")
imap <expr> <Plug>(expand_or_nl) (cm#completed_is_snippet() ? "\<C-k>":"")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" H and L move to start and end of lines
nmap L <Nop>
nmap H <Nop>
xmap L <Nop>
xmap H <Nop>
omap L <Nop>
omap H <Nop>
nnoremap L $
nnoremap H ^
xnoremap L $
xnoremap H ^
onoremap L $
onoremap H ^

" unbind Q for another binding
nmap Q <Nop>
xmap Q <Nop>
omap Q <Nop>

"buffer navigation
nmap <C-L> <Nop>
nmap <C-H> <Nop>
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

" Define leader guide dictionary
let g:lmap = {}

" -----Top Level Commands -------
" Set leader key
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>

let g:lmap[' '] = ['', 'Exit']
nnoremap <Leader>q :q<CR>
let g:lmap.q = [':q', 'Close window']
" Force close window
nnoremap <Leader>Q :q!<CR>
let g:lmap.Q = [':q!', 'Force close window']

"------ Windows -------
let g:lmap.w = { 'name' : 'Windows' }

nnoremap <leader>wv :vsp<CR>
let g:lmap.w.v = [':vsp', 'Split vertical']
nnoremap <leader>ws :sp<CR>
let g:lmap.w.s = [':sp', 'Split horizontal']
nnoremap <leader>wk 10<C-w>+
let g:lmap.w.k = ['<C-w>+', 'Expand split vertically']
nnoremap <leader>wj 10<C-w>-
let g:lmap.w.j = ['<C-w>-', 'Shrink split vertically']
nnoremap <leader>wl 10<C-w>>
let g:lmap.w.l = ['<C-w>>', 'Expand split right']
nnoremap <leader>wh 10<C-w><
let g:lmap.w.h = ['<C-w><', 'Expand split left']
nnoremap <leader>wu :windo diffthis<CR>
let g:lmap.w.u = ['windo diffthis', 'Vim diff']
nnoremap <leader>wy :windo diffoff<CR>
let g:lmap.w.y = ['windo diffoff', 'Diff off']
nnoremap <leader>wr <C-w>r
let g:lmap.w.r = ['<C-w>r', 'Rotate buffers']
nnoremap <leader>wo <C-w>o
let g:lmap.w.o = ['<C-w>o', 'Close splits']
nnoremap <leader>we <C-w>=
let g:lmap.w.e = ['<C-w>e', 'Equalize splits']
nnoremap <leader>wV <C-w>H
let g:lmap.w.V = ['<C-w>H', 'To vertical splits']
nnoremap <leader>wS <C-w>J
let g:lmap.w.S = ['<C-w>J', 'To horizontal splits']

"---------Buffers ---------------
let g:lmap.b = { 'name' : 'Buffers' }
nnoremap <Leader>bd :Bdelete<CR>
let g:lmap.b.d = [':Bdelete', 'Close buffer']
nnoremap <Leader>bD :Bdelete!<CR>
let g:lmap.b.D = [':Bdelete', 'Close buffer force']
nnoremap <leader>bn :new<CR>
let g:lmap.b.n = ['new', 'New buffer']
nnoremap <leader>b% :set invrelativenumber<CR>
let g:lmap.b['%'] = ['set invrelativenumber', 'Toggle relative numbers']
nnoremap <leader>b# :set invnumber<CR>
let g:lmap.b['#'] = ['set invnumber', 'Toggle line numbers']
nnoremap <leader>bs :w<CR>
let g:lmap.b.s = ['w', 'Save buffer']
nnoremap <leader>br :edit!<CR>
let g:lmap.b.r = ['edit!', 'Revert changes']
nnoremap <leader>bh :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
let g:lmap.b.h = ['invcursorline', 'Toggle cursorline']
nnoremap <leader>bi :IndentLinesToggle<CR>
let g:lmap.b.i = [':IndentLinesToggle', 'Toggle indent lines']
nnoremap <leader>bw :Nows<CR>
let g:lmap.b.w = [':Nows', 'Remove trailing whitespace']

"-------- Neovim -----------------
let g:lmap.n = { 'name' : 'Neovim' }
nnoremap <Leader>nr :so ~/.config/nvim/init.vim<CR>
let g:lmap.n.r = ['so ~/.config/nvim/init.vim', 'Source dotfile']
nnoremap <Leader>ns :Startify<CR>
let g:lmap.n.s = ['Startify', 'Open start menu']
nnoremap <Leader>nu :PlugUpdate<CR>
let g:lmap.n.u = ['Plug Update', 'Update plugins']
nnoremap <Leader>ni :PlugInstall<CR>
let g:lmap.n.i = ['Plug Install', 'Install plugins']
nnoremap <Leader>nc :PlugClean<CR>
let g:lmap.n.c = ['Plug Clean', 'Remove unmanaged plugins']

"-------Extensions-------------------
let g:lmap.e = { 'name' : 'Extensions' }
nnoremap <leader>el :Limelight<CR>
let g:lmap.e.l = ['Limelight', 'Focus code On']
nnoremap <leader>eL :Limelight!<CR>
let g:lmap.e.L = ['Limelight!', 'Focus code Off']
nnoremap <leader>ez :Goyo<CR>
let g:lmap.e.z = ['Goyo', 'Toggle zen mode']
nnoremap <leader>eu :UndotreeToggle<CR>
let g:lmap.e.u = ['UndoTree', 'Toggle UndoTree']
nnoremap <leader>ea :ALEToggle<CR>
let g:lmap.e.a = ['ALEToggle', 'Toggle linter']
nnoremap <leader>et :TagbarToggle<CR>
let g:lmap.e.t = ['TagbarToggle', 'Toggle tag bar']

"-------Test-----------------
let g:lmap.t = { 'name' : 'Test' }
nnoremap <silent> <leader>tn :TestNearest<CR>
let g:lmap.t.n = ['TestNearest', 'Run nearest test']
nnoremap <silent> <leader>tf :TestFile<CR>
let g:lmap.t.f = ['TestFile', 'Run tests for file']
nnoremap <silent> <leader>ts :TestSuite<CR>
let g:lmap.t.s = ['TestSuite', 'Run test suite']
nnoremap <silent> <leader>tl :TestLast<CR>
let g:lmap.t.l = ['TestLast', 'Run last test']
nnoremap <silent> <leader>tv :TestVisit<CR>
let g:lmap.t.v = ['TestVisit', 'Last run test']

"-------Version Control-----------
let g:lmap.g = { 'name' : 'Git' }
nnoremap <silent> <leader>gs :Gstatus<CR>
let g:lmap.g.s = ['Gstatus', 'Git status']
nnoremap <silent> <leader>gb :Gblame<CR>
let g:lmap.g.b = ['Gblame', 'Git blame']
nnoremap <silent> <leader>gn :GitGutterNextHunk<CR>
let g:lmap.g.n = ['GitGutterNextHunk', 'Next hunk']
nnoremap <silent> <leader>gN :GitGutterPrevHunk<CR>
let g:lmap.g.N = ['GitGutterPrevHunk', 'Previous hunk']
nnoremap <silent> <leader>gh :GitGutterStageHunk<CR>
let g:lmap.g.h = ['GitGutterStageHunk', 'Stage hunk']
nnoremap <silent> <leader>gu :GitGutterUndoHunk<CR>
let g:lmap.g.u = ['GitGutterUndoHunk', 'Undo hunk']
nnoremap <silent> <leader>gp :GitGutterPreviewHunk<CR>
let g:lmap.g.p = ['GitGutterPreviewHunk', 'Preview hunk']

"--------FZF-----------
let g:lmap['<C-_>'] = { 'name' : 'FZF' }
nnoremap <silent> <C-_>f :GFiles<CR>
let g:lmap['<C-_>']['f'] = ['fzf ripgrep', 'Git files']
nnoremap <silent> <C-_>a :Files<CR>
let g:lmap['<C-_>']['a'] = ['fzf find files', 'All files']
nnoremap <silent> <C-_>h :Helptags<CR>
let g:lmap['<C-_>']['h'] = ['fzf help', 'Help']
nnoremap <silent> <C-_>b :Buffers<CR>
let g:lmap['<C-_>']['b'] = ['fzf buffer', 'Buffers']
nnoremap <silent> <C-_>l :BLines<CR>
let g:lmap['<C-_>']['l'] = ['fzf line', 'Lines']
nnoremap <silent> <C-_>r :HHistory<CR>
let g:lmap['<C-_>']['r'] = ['fzf file_mru', 'Recent files']
nnoremap <silent> <C-_>g :Rg<CR>
let g:lmap['<C-_>']['g'] = ['fzf grep', 'Rg']
nnoremap <silent> <C-_>t :Filetypes<CR>
let g:lmap['<C-_>']['t'] = ['fzf filetype', 'Filetypes']
nnoremap <silent> <C-_>c :Colors<CR>
let g:lmap['<C-_>']['c'] = ['fzf coloscheme', 'Colorschemes']
nnoremap <silent> <C-_>O :Tags<CR>
let g:lmap['<C-_>']['O'] = ['fzf outline', 'Project tags']
nnoremap <silent> <C-_>o :BTags<CR>
let g:lmap['<C-_>']['o'] = ['fzf outline', 'Buffer tags']
nnoremap <silent> <C-_>e :Commands<CR>
let g:lmap['<C-_>']['e'] = ['fzf command', 'Commands']
nnoremap <silent> <C-_>p :GGrep<CR>
let g:lmap['<C-_>']['p'] = ['fzf command', 'Git grep']
nnoremap <silent> <C-_>d :Cd<CR>
let g:lmap['<C-_>']['d'] = ['fzf command', 'Directories']
"
" Clear search highlight
nnoremap <leader>c :nohlsearch<CR>
let g:lmap.c = [':nohlsearch', 'Clear highlight']


"***** None of this works *****
"------- Terminal-------------
let g:lmap['\'] = { 'name': 'Debug' }
let g:lmap['\']['r'] = ['pry', 'Pry']
nnoremap <leader>\r :call DebugInTerminal('pry')<CR>
let g:lmap['\']['p'] = ['pdb', 'Pdb']
nnoremap <leader>\p :call DebugInTerminal('python -m pdb')<CR>
let g:lmap['\']['n'] = ['node-debug', 'Node Debug']
nnoremap <leader>\n :call DebugInTerminal('node-debug')<CR>

function! DebugInTerminal(args)
  botright split
  execute 'terminal' a:args expand('%:p')
endfunction

" ------ Leader guide --------
call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

