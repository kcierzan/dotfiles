" ██╗███╗   ██╗██╗████████╗██╗   ██╗██╗███╗   ███╗
" ██║████╗  ██║██║╚══██╔══╝██║   ██║██║████╗ ████║
" ██║██╔██╗ ██║██║   ██║   ██║   ██║██║██╔████╔██║
" ██║██║╚██╗██║██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
" ██║██║ ╚████║██║   ██║██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
" ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝

"-------------------------------- SETTINGS --------------------------------
scriptencoding utf-8
set autoindent
set completeopt-=preview
set conceallevel=2
set cursorline
set expandtab
set gdefault
set hidden
set ignorecase
set noerrorbells
set nolazyredraw
set noshowmode
set noswapfile
set nowrap
set nonumber
set pumheight=10
set scrolloff=3
set shell=/usr/local/bin/zsh
set shiftround
set shiftwidth=2
set showcmd
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set textwidth=0
set timeoutlen=1000
set ttimeoutlen=0
set autoread
set ttyfast
set undodir=~/.undo
set undofile
set undolevels=100000
set foldlevelstart=20
set termguicolors

" Enable blinking cursor
" set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:hor20-Cursor/lCursor
" Enable system clipboard
set clipboard=unnamed

" Set :grep to use ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Virtualenv for python-dependent plugins
let g:python3_host_prog = $HOME . '/.pyenv/versions/neovim3/bin/python3'

"-------------------------------- AUTOCOMMANDS --------------------------------
" Disable annoying automatic comments
autocmd BufNewFile,BufRead * setlocal formatoptions+=cqn 

" Trigger autoread when files change on disk
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif | set fillchars+=vert:\ 

" Notification after file change
autocmd FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Vim autosaves and reflects changes to files on disk
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

autocmd filetype crontab setlocal nobackup nowritebackup

autocmd BufNewFile,BufRead *.thtml
      \ setlocal syntax=phtml

augroup netrw_buf_hidden_fix
  autocmd!
  " Set all non-netrw buffers to bufhidden=hide
  autocmd BufWinEnter *
        \  if &ft != 'netrw'
        \|     set bufhidden=hide
        \| endif
augroup end

augroup SwitchPanes
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

"-------------------------------- EX COMMANDS --------------------------------
function! JSONify()
  %!python -m json.tool
  set syntax=json
endfunction

"json pretty print
command J :call JSONify()

" Remove trailing whitespace
command Nows :%s/\s\+$//

"-------------------------------- PLUGINS -----------------------------------
call plug#begin('~/.local/share/nvim/plugged')

Plug 'joshdick/onedark.vim'

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

" indentLine
Plug 'Yggdroot/indentLine'
let g:indentLine_enabled = 0
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_bufTypeExclude = ['terminal']
let g:indentLine_setColors = 1

" rainbow_parentheses
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

" TODO: set colors for onedark gui colorscheme
let g:rainbow_conf = { 'ctermfgs': ['blue', 'cyan', 'magenta', 'red', 'yellow', 'green'] }

" vim-gitgutter
Plug 'airblade/vim-gitgutter'
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 5000

function! s:NextHunkAllBuffers()
  let line = line('.')
  GitGutterNextHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bnext
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! 1G
      GitGutterNextHunk
      return
    endif
  endwhile
endfunction

function! s:PrevHunkAllBuffers()
  let line = line('.')
  GitGutterPrevHunk
  if line('.') != line
    return
  endif

  let bufnr = bufnr('')
  while 1
    bprevious
    if bufnr('') == bufnr
      return
    endif
    if !empty(GitGutterGetHunks())
      normal! G
      GitGutterPrevHunk
      return
    endif
  endwhile
endfunction

" goyo
Plug 'junegunn/goyo.vim' " Remove distractions
let g:goyo_width = 100
let g:goyo_linenr = 0

function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowcmd
  set noshowmode
  set nocursorline
  vunmap <silent> <leader>
  nunmap <silent> <leader>
  IndentLinesDisable
  ALEDisable
endfunction

function! s:goyo_leave()
  silent !tmux set status on
  silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  set showcmd
  set showmode
  set cursorline
  colorscheme onedark
  nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
  ALEEnable
endfunction

augroup GoyoToggle
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" comfortable-motion
Plug 'yuttie/comfortable-motion.vim'
let g:comfortable_motion_friction = 15.0
let g:comfortable_motion_air_drag = 5.0

" vim-sneak
Plug 'justinmk/vim-sneak'
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#s_next =1
autocmd Colorscheme * hi Sneak ctermfg=black ctermbg=red

"vim-multiple-cursors
Plug 'terryma/vim-multiple-cursors'

" vim-tmux-navigator
" Map alt + hjkl to navigation
"TODO: why doesn't this work on linux?
let g:tmux_navigator_no_mappings = 1
Plug 'christoomey/vim-tmux-navigator'

" ALE
Plug 'w0rp/ale'
filetype off
filetype plugin on
let g:ale_linters = {
      \ 'python': ['pyls'],
      \ 'javascript': ['eslint'],
      \ 'css': ['prettier'],
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
let g:ale_fixers = {
      \ '*': ['trim_whitespace'],
      \ 'python': ['yapf', 'black'],
      \ 'javascript': ['prettier', 'eslint'],
      \ 'css': ['prettier'],
      \ 'html': ['tidy'],
      \}
let g:ale_python_pylint_options = '--rcfile=~/.pylintrc'
let g:ale_python_pylint_use_global = 1
let g:ale_python_flake8_use_global = 1
let g:ale_javascript_eslint_use_global = 1
let g:ale_vim_vint_executable = $HOME . '/.pyenv/versions/neovim3/bin/vint'
let g:ale_javascript_eslint_executable   = '/usr/local/lib/node_modules/eslint/bin/eslint.js'
let g:ale_javascript_eslint_options = '-c ~/.eslintrc.yml'
let g:ale_echo_msg_format = '[%severity%] %s [%linter%]'
let g:ale_sign_error = '✖'
let g:ale_sign_warning = '⚠'
let g:ale_statusline_format = ['✖ %d', '⚠ %d', '']
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_lint_on_text_changed = 'normal'
let g:ale_set_highlights = 0
highlight ALEErrorSign ctermfg=1
highlight ALEWarningSign ctermfg=3

command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1

"vim-test
Plug 'janko-m/vim-test'
Plug 'benmills/vimux'
let g:test#python#runner = 'nose'
let g:test#strategy = 'vimux'
let g:test#python#nose#options = '-xvs --with-coverage'

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<C-y>"
Plug 'honza/vim-snippets'

"vim-expand-region
Plug 'terryma/vim-expand-region'
vmap e <Plug>(expand_region_expand)
vmap E <Plug>(expand_region_shrink)

"fzf.vim
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_buffers_jump = 1

autocmd! FileType fzf
autocmd FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --smart-case --line-number --column --no-heading --color=always -g "!TAGS" -g "!node-modules/*" -g"!.git/*" '.shellescape(<q-args>), 0,
      \   (winwidth(0) > 175 ? fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}, 'right:50%')
      \                      : fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}, 'up:80%')))

command! -bang -nargs=* GGrep
      \ call fzf#vim#grep('git grep --line-number '.shellescape(<q-args>), 0,
      \ (winwidth(0) > 175 ? fzf#vim#with_preview('right:50%') : fzf#vim#with_preview('up:80%')))

command! -bang -nargs=* HHistory
      \ call fzf#vim#history((winwidth(0) > 175 ? fzf#vim#with_preview('right:50%') : fzf#vim#with_preview('up:80%')))

command! -bang -nargs=* GFiles
      \ call fzf#vim#files(<q-args>, (winwidth(0) > 175 ? fzf#vim#with_preview('right:50%') : fzf#vim#with_preview('up:80%')))

command! -nargs=* -complete=dir Cd call fzf#run(fzf#wrap(
      \ {'source': 'gfind '.(empty(<q-args>) ? '~/git' : <q-args>).' -maxdepth 1 -type d',
      \  'sink': 'cd'}))

"vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep=''
let g:airline_right_alt_sep=''
let g:airline_symbols = {}
let g:airline_theme='onedark'
let g:airline_extensions = ['ale', 'coc', 'tabline']
let g:airline#extensions#ale#enabled = 1
let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
let airline#extensions#ale#error_symbol = ' '
let airline#extensions#ale#warning_symbol = ' '
let airline#extensions#coc#error_symbol = ' '
let airline#extensions#coc#warning_symbol = ' '
let g:airline#extensions#tabline#enabled = 1

Plug 'sheerun/vim-polyglot'                " lots of language packs
let g:polyglot_disabled = [ 'javascript', 'javascript.jsx', 'python' ]
let g:python_highlight_all = 1

"misc plugins
Plug 'Shougo/neomru.vim'                   " recent files
Plug 'tpope/vim-vinegar'                   " make netrw better
Plug 'tpope/vim-eunuch'                    " unix tools
Plug 'tpope/vim-repeat'                    " use . to repeat some stuff
Plug 'tpope/vim-sleuth'                    " detect indentation
Plug 'jiangmiao/auto-pairs'                " automatic deliminters
Plug 'adelarsq/vim-matchit'                " extend the % operator
Plug 'tpope/vim-surround'                  " surround with brackets, quotes etc
Plug 'tpope/vim-commentary'                " comment for great success
Plug 'wellle/targets.vim'                  " provide additional text objects
Plug 'mbbill/undotree'                     " undo Tree
Plug 'moll/vim-bbye'                       " delete and close buffers without closing windows
Plug 'mkitt/tabline.vim'                   " better looking tabs
Plug 'tpope/vim-fugitive'                  " git Wrapper
Plug 'junegunn/gv.vim'                     " git commit browser
Plug 'junegunn/vim-easy-align'             " align stuff
Plug 'michaeljsmith/vim-indent-object'     " indentation objects
Plug 'tpope/vim-abolish'                   " correct common misspellings
Plug 'AndrewRadev/sideways.vim'            " move stuff sideways
Plug 'majutsushi/tagbar'                   " show some tags
Plug 'vim-python/python-syntax',           { 'for': ['python'] } " Make python look a little better
Plug 'haya14busa/vim-keeppad'              " keep padding when line nums go away
Plug 'pangloss/vim-javascript'             " syntax highlighting for javascript
Plug 'mxw/vim-jsx'                         " syntax highlighting for jsx
Plug 'vimwiki/vimwiki'                     " notes
Plug 'blueyed/vim-diminactive'             " change the color of inactive panes
Plug 'tmux-plugins/vim-tmux-focus-events'  " add focus events to vim

Plug 'wesQ3/vim-windowswap'
let g:windowswap_map_keys = 0

Plug 'tpope/vim-rhubarb'
let g:github_enterprise_urls = ['https://github.aweber.io']

Plug 'shumphrey/fugitive-gitlab.vim'
let g:fugitive_gitlab_domaines = ['https://gitlab.aweber.io']

Plug 'mattn/emmet-vim'
let g:user_emmet_settings = {
      \ 'javascript.jsx': {
      \   'extends': 'jsx',
      \  },
      \}

" vim-rest-console
Plug 'diepm/vim-rest-console'
let g:vrc_include_response_header = 1

" coc.nvim
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
set cmdheight=2
set updatetime=300

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" don't give |ins-completion-menu| messages
set shortmess+=c

set signcolumn=yes

" accept completion with tab
" inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<TAB>"
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

" highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" vim-rooter
Plug 'airblade/vim-rooter'
let g:rooter_use_lcd = 1
let g:rooter_resolve_links = 1
let g:rooter_silent_chdir = 1

"-------------------------------- KEYBINDINGS -----------------------------------

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

function! GoToOpenFold(direction)
  let start = line('.')
  if (a:direction == "next")
    while (foldclosed(start) != -1)
      let start = start + 1
    endwhile
  else
    while (foldclosed(start) != -1)
      let start = start - 1
    endwhile
  endif
  call cursor(start, 0)
endfunction
nmap ]z :cal GoToOpenFold("next")
nmap [z :cal GoToOpenFold("prev")

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

" -----Top Level Commands -------
Plug 'hecal3/vim-leader-guide'
let g:lmap = {}
let g:lmap.f = { 'name': 'Find' }
let g:lmap.t = { 'name': 'Test' }
" Set leader key
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>

nnoremap <Leader>q :q<CR>
" Force close window
nnoremap <Leader>Q :q!<CR>

"---------Interface-------------
let g:lmap.i = {'name': 'Interface',
      \ '%': ['set invrelativenumber', 'relative lines'],
      \ '#': ['set invnumber', 'toggle line numbers'],
      \ 'h': ['set invcursorline', 'toggle cursorline'],
      \ 'i': ['IndentLinesToggle', 'toggle indent lines'],
      \ 'u': ['UndotreeToggle', 'toggle undo tree'],
      \ 'c': ['nohlsearch', 'clear search highlight'],
      \ 'z': ['Goyo', 'zen mode'],
      \ 'l': ['Limelight', 'highlight sections on'],
      \ 'L': ['Limelight!', 'highlight sections off'],
      \ }
nnoremap <leader>i% :set invrelativenumber<CR>
nnoremap <leader>i# :set invnumber<CR>
nnoremap <leader>ih :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
nnoremap <leader>ii :IndentLinesToggle<CR>
nnoremap <leader>iu :UndotreeToggle<CR>
nnoremap <leader>ic :nohlsearch<CR>
nnoremap <leader>iz :Goyo<CR>
nnoremap <leader>il :Limelight<CR>
nnoremap <leader>iL :Limelight!<CR>

"---------Buffers ---------------
let g:lmap.b = { 'name': 'Buffers',
      \ 's': ['w', 'write buffer'],
      \ 'n': ['new', 'new buffer'],
      \ 'd': ['Bdelete', 'kill buffer'],
      \ 'D': ['Bdelete!', 'force kill buffer'],
      \ 'c': ['windo diffthis', 'show diff'],
      \ 'C': ['windo diffoff', 'hide diff'],
      \ 'r': ['edit!', 'revert buffer'],
      \ 'w': ['Nows', 'whitespace cleanup'],
      \}
nnoremap <leader>bs :w<CR>
nnoremap <leader>bn :new<CR>
nnoremap <Leader>bd :Bdelete<CR>
nnoremap <Leader>bD :Bdelete!<CR>
nnoremap <leader>bc :windo diffthis<CR>
nnoremap <leader>bC :windo diffoff<CR>
nnoremap <leader>br :edit!<CR>
nnoremap <leader>bw :Nows<CR>

"-----------Splits---------------
let g:lmap.w = { 'name': 'Windows',
      \ 'v': ['vsp', 'vertical split'],
      \ 's': ['sp', 'horizontal split'],
      \ 'e': ['<C-w>e', 'equalize buffers'],
      \ 'k': ['10<C-w>+', 'increase buffer height'],
      \ 'j': ['10<C-w>-', 'decrease buffer height'],
      \ 'l': ['10<C-w>>', 'increase width right'],
      \ 'h': ['10<C-w><', 'increase width left'],
      \ 'r': ['<C-w>r', 'swap buffers'],
      \ 'o': ['<C-w>o', 'close other panes'],
      \ 'c': ['call WindowSwap#EasyWindowSwap', 'swap buffer with...'],
      \ 'V': ['<C-w>H', 'to vertical splits'],
      \ 'S': ['<C-w>J', 'to horizontal splits'],
      \}

nnoremap <leader>wv :vsp<CR>
nnoremap <leader>ws :sp<CR>
nnoremap <leader>we <C-w>e
nnoremap <leader>wk 10<C-w>+
nnoremap <leader>wj 10<C-w>-
nnoremap <leader>wl 10<C-w>>
nnoremap <leader>wh 10<C-w><
nnoremap <leader>wr <C-w>r
nnoremap <leader>wo <C-w>o
nnoremap <leader>we <C-w>=
nnoremap <leader>wV <C-w>H
nnoremap <leader>wS <C-w>J
nnoremap <leader>wc :call WindowSwap#EasyWindowSwap()<CR>

"-------- Neovim -----------------
let g:lmap.v = { 'name': 'Neovim',
      \ 'r': ['so ~/.config/nvim/init.vim', 'reload init.vim'],
      \ 'e': ['edit ~/.config/nvim/init.vim', 'edit init.vim'],
      \ 's': ['Startify', 'homepage'],
      \ 'u': ['PlugUpdate', 'update plugins'],
      \ 'U': ['PlugUpgrade', 'update vim-plug'],
      \ 'i': ['PlugInstall', 'install plugins'],
      \ 'c': ['PlugClean', 'clean up plugins'],
      \}
nnoremap <Leader>vr :so ~/.config/nvim/init.vim<CR>
nnoremap <Leader>ve :edit ~/.config/nvim/init.vim<CR>
nnoremap <Leader>vs :Startify<CR>
nnoremap <Leader>vu :PlugUpdate<CR>
nnoremap <Leader>vi :PlugInstall<CR>
nnoremap <Leader>vc :PlugClean<CR>

"-------Code-------------------
let g:lmap.c = {'name': 'Code',
      \ 't': ['TagbarToggle', 'toggle tagbar'],
      \ 'r': ['!rm ctags && ctags', 'regenerate tags'],
      \ 'T': ['!ctags', 'generate ctags'],
      \ 'a': ['<Plug>(coc-codeaction)', 'code action'],
      \ 'f': ['<Plug>(coc-fix-current)', 'fix current'],
      \ 'F': ['<Plug>(coc-format-selected)', 'format selected'],
      \ 'c': ['CocRestart', 'restart coc'],
      \ 'R': ['CocRename', 'rename']
      \}
nnoremap <leader>ct :TagbarToggle<CR>
nnoremap <leader>cT :!ctags<CR>
nnoremap <leader>cr :!rm tags && ctags<CR>
nnoremap <leader>ca <Plug>(coc-codeaction)
vnoremap <leader>ca <Plug>(coc-codeaction-selected)
nnoremap <leader>cf <Plug>(coc-fix-current)
nnoremap <leader>cF <Plug>(coc-format-selected)
vnoremap <leader>cF <Plug>(coc-format-selected)
nnoremap <leader>cc :CocRestart<CR>
nnoremap <leader>cR <Plug>(coc-rename)

"-------Test-----------------
let g:lmap.t = {'name': 'Test',
      \ 'n': ['TestNearest', 'test nearest'],
      \ 'f': ['TestFile', 'test file'],
      \ 's': ['TestSuite', 'test suite'],
      \ 'l': ['TestLast', 'test last'],
      \ 'v': ['TestVisit', 'test visit'],
      \}
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>

"------------Git--------------
let g:lmap.g = { 'name': 'Git',
      \ 's': ['Gstatus', 'git status'],
      \ 'c': ['Gcommit', 'git commit'],
      \ 'b': ['Gblame', 'git blame'],
      \ 'P': ['Gpush', 'git push'],
      \ 'l': ['GV', 'git log'],
      \ 'n': ['GitGutterNextHunk', 'next hunk'],
      \ 'N': ['GitGutterPrevHunk', 'previous hunk'],
      \ '[': ['PrevHunkAllBuffers', 'previous hunk all buffers'],
      \ ']': ['NextHunkAllBuffers', 'next hunk all buffers'],
      \ 'h': ['GitGutterStageHunk', 'stage hunk'],
      \ 'u': ['GitGutterUndoHunk', 'undo hunk'],
      \ 'p': ['GitGutterPreviewHunk', 'preview hunk'],
      \ 'o': ['Gbrowse', 'open file in browser'],
      \}
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gn :GitGutterNextHunk<CR>
nnoremap <silent> <leader>gN :GitGutterPrevHunk<CR>
nnoremap <silent> <leader>gh :GitGutterStageHunk<CR>
nnoremap <silent> <leader>g] :call <SID>NextHunkAllBuffers()<CR>
nnoremap <silent> <leader>g[ :call <SID>PrevHunkAllBuffers()<CR>
nnoremap <silent> <leader>gu :GitGutterUndoHunk<CR>
nnoremap <silent> <leader>gp :GitGutterPreviewHunk<CR>
nnoremap <silent> <leader>gd :Gvdiff<CR>
nnoremap <silent> <leader>gl :GV<CR>
nnoremap <silent> <leader>go :Gbrowse<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>

"--------FZF-----------
let g:lmap.f = { 'name': 'Find',
      \ 'f': ['GFiles', 'git files'],
      \ 'h': ['HHistory', 'file history'],
      \ 'a': ['Files', 'all files'],
      \ 'c': ['Colors', 'colorschemes'],
      \ 'i': ['Helptags', 'information'],
      \ 'b': ['Buffers', 'buffers'],
      \ 'l': ['Blines', 'buffer lines'],
      \ 'L': ['Lines', 'all open buffer lines'],
      \ 'g': ['Rg', 'ripgrep'],
      \ 't': ['Filetypes', 'filetypes'],
      \ 'O': ['Tags', 'tags'],
      \ 'o': ['BTags', 'buffer tags'],
      \ 'e': ['Commands', 'commands'],
      \ 'p': ['GGrep', 'git grep'],
      \ 'j': ['Cd', 'projects'],
      \}
nnoremap <silent> <leader>ff :GFiles<CR>
nnoremap <silent> <leader>fa :Files<CR>
nnoremap <silent> <leader>fi :Helptags<CR>
nnoremap <silent> <leader>fb :Buffers<CR>
nnoremap <silent> <leader>fl :BLines<CR>
nnoremap <silent> <leader>fL :Lines<CR>
nnoremap <silent> <leader>fh :HHistory<CR>
nnoremap <silent> <leader>fg :Rg<CR>
nnoremap <silent> <leader>ft :Filetypes<CR>
nnoremap <silent> <leader>fc :Colors<CR>
nnoremap <silent> <leader>fO :Tags<CR>
nnoremap <silent> <leader>fo :BTags<CR>
nnoremap <silent> <leader>fe :Commands<CR>
nnoremap <silent> <leader>fp :GGrep<CR>
nnoremap <silent> <leader>fj :Cd<CR>

"--------VimWiki-------------
let g:lmap.n = {'name': 'Notes',
      \ 'i': ['<leader>ni', 'open index'],
      \ 't': ['<leader>nt', 'tab index'],
      \ 's': ['<leader>ns', 'select and open'],
      \ 'd': ['<leader>nd', 'delete current file'],
      \ 'r': ['<leader>nr', 'rename current file'],
      \ 'c': ['VimwikiToggleListItem', 'toggle todo'],
      \ 'h': ['Vimwiki2HTML', 'export to html'],
      \}
let g:lmap.n['l'] = {'name': 'Log',
      \ 'i': ['<leader>wi', 'diary index'],
      \ 'l': ['<leader>w<leader>l', 'generate links'],
      \ 'w': ['<leader>w<leader>w', 'make note'],
      \ 't': ['<leader>w<leader>t', 'make note in new tab'],
      \ 'm': ['<leader>w<leader>m', 'make diary note for tomorrow'],
      \ 'y': ['<leader>w<leader>y', 'make diary note for yesterday'],
      \}

nmap <silent> <leader>ni <Plug>VimwikiIndex
nmap <silent> <leader>nt <Plug>VimwikiTabIndex
nmap <silent> <leader>ns <Plug>VimwikiUISelect
nmap <silent> <leader>nd <Plug>VimwikiDeleteLink
nmap <silent> <leader>nr <Plug>VimwikiRenameLink
nmap <silent> <leader>nc <Plug>VimwikiToggleListItem
nmap <silent> <leader>nh <Plug>Vimwiki2HTML

nmap <silent> <leader>nli <Plug>VimwikiDiaryIndex
nmap <silent> <leader>nll <Plug>VimwikiDiaryGenerateLinks
nmap <silent> <leader>nlw <Plug>VimwikiMakeDiaryNote
nmap <silent> <leader>nlt <Plug>VimwikiTabMakeDiaryNote
nmap <silent> <leader>nlm <Plug>VimwikiMakeTomorrowDiaryNote
nmap <silent> <leader>nly <Plug>VimwikiMakeYesterdayDiaryNote

call plug#end()

syntax enable
set background=dark
colorscheme onedark

" don't let onedark mess with the background color
hi Normal ctermfg=none ctermbg=none guibg=none guifg=none
" or the colorcolumn for diminactive
hi  ColorColumn ctermfg=none ctermbg=0
hi ALEErrorSign                   ctermfg=1 guifg='#e06c75'
hi ALEWarningSign                 ctermfg=3 guifg='#e5c07b'
hi ALEError                       ctermbg=0
hi ALEWarning                     ctermbg=0

call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
