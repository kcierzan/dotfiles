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
set number
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
set timeoutlen=500
set ttimeoutlen=0
set autoread
set ttyfast
set undodir=~/.undo
set undofile
set undolevels=100000
set foldlevelstart=20
set termguicolors
set showtabline=0
set inccommand=nosplit

" Enable blinking underline cursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:hor20-Cursor/lCursor

" FIXME: Use system clipboard on macOS and both clipboards on linux
set clipboard=unnamed
set clipboard+=unnamedplus

" Set :grep to use ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Virtualenv for python-dependent plugins
let g:python3_host_prog = $HOME . '/.pyenv/versions/main/bin/python3'

"-------------------------------- AUTOCOMMANDS --------------------------------

" Trigger autoread when files change on disk and display a notification
augroup AutoRevert
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() != 'c' | checktime | endif | set fillchars+=vert:\│
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup END

" " Vim autosaves and reflects changes to files on disk
augroup AutoSave
  autocmd!
  autocmd FocusGained,BufEnter * :silent! !
  autocmd FocusLost,WinLeave * :silent! w
augroup END

augroup Crontab
  autocmd!
  autocmd filetype crontab setlocal nobackup nowritebackup
augroup END

augroup HTML
  autocmd!
  autocmd BufNewFile,BufRead *.thtml setlocal syntax=phtml
augroup END

" " Keep markdown file lines to 100 characters
augroup Markdown
  autocmd!
  autocmd FileType markdown setlocal textwidth=100
augroup END

" augroup NetrwBufHiddenFix
augroup Netrw
  autocmd!
  " Set all non-netrw buffers to bufhidden=hide
  autocmd BufWinEnter *
        \  if &ft != 'netrw'
        \|     set bufhidden=hide
        \| endif
augroup END

augroup SwitchPanesCursorlineOff
  autocmd!
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

" " set the cursor back when we exit nvim
augroup CursorShape
  autocmd!
  autocmd VimLeave * set guicursor=a:hor20-Cursor/lCursor
augroup END

augroup FZF
  autocmd!
  autocmd FileType fzf set laststatus=0 noruler
        \| autocmd BufLeave <buffer> set laststatus=2 ruler
augroup END

augroup Handlebars
  autocmd!
  autocmd BufNewFile,BufRead *.hbs let b:ale_fix_on_save = 0
augroup END

augroup NerdTree
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

augroup CocSymbolHighlight
  " highlight symbol under cursor on CursorHold
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

augroup RegisterWhichKey
  autocmd!
  autocmd User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
augroup END

" Install missing plugins on startup
augroup InstallMissingPlugins
  autocmd!
  autocmd VimEnter *
        \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | q
        \| endif
augroup END

"-------------------------------- EX COMMANDS --------------------------------
function! FormatJson()
  %!python -m json.tool
  set syntax=json
endfunction

"json pretty print
command! Tojson :call FormatJson()

" Remove trailing whitespace
command! Trimws :%s/\s\+$//

" Format file with prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

"-------------------------------- PLUGINS -----------------------------------
call plug#begin('~/.local/share/nvim/plugged')
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
Plug 'yuttie/comfortable-motion.vim'
Plug 'easymotion/vim-easymotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'janko-m/vim-test' , {'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit']}
Plug 'benmills/vimux'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'terryma/vim-expand-region', {'on': ['<Plug>(expand_region_expand)', '<Plug>(expand_region_shrink)']}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'jiangmiao/auto-pairs'
Plug 'adelarsq/vim-matchit'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}
Plug 'michaeljsmith/vim-indent-object'
Plug 'AndrewRadev/sideways.vim', {'on': ['SidewaysLeft', 'SidewaysRight']}
Plug 'kh3phr3n/python-syntax', {'for': 'python'}
Plug 'haya14busa/vim-keeppad'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'blueyed/vim-diminactive'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
Plug 'airblade/vim-rooter'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'metakirby5/codi.vim'
Plug 'lervag/vimtex'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/neomru.vim'
Plug 'sainnhe/edge'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/sonokai'
Plug 'mcchrish/nnn.vim', {'on': 'Np'}
Plug 'moll/vim-bbye'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'dsznajder/vscode-es7-javascript-react-snippets', { 'do': 'yarn install --frozen-lockfile && yarn compile' }
Plug 'dracula/vim'
Plug 'lifepillar/vim-solarized8'
Plug 'liuchengxu/vim-which-key', {'on': ['WhichKey', 'WhichKey!']}
Plug 'editorconfig/editorconfig'
call plug#end()

"-------------------------------- Plugin Config -----------------------------------

" ayu-theme
let ayucolor='mirage'

" startify
let g:ascii = [
      \ '  __   __  ______  ______  __   ____  __    __   ',
      \ ' /\ "-.\ \/\  ___\/\  __ \/\ \ / /\ \/\ "-./  \  ',
      \ " \\ \\ \\-.  \\ \\  __\\\\ \\ \\/\\ \\ \\ \\'/\\ \\ \\ \\ \\-./\\ \\ ",
      \ '  \ \_\\"\_\ \_____\ \_____\ \__| \ \_\ \_\ \ \_\',
      \ '   \/_/ \/_/\/_____/\/_____/\/_/   \/_/\/_/  \/_/',
      \ '                                                 ',
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
let g:indentLine_enabled = 0
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_bufTypeExclude = ['terminal']
let g:indentLine_setColors = 1

" vim-gitgutter
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
let g:goyo_width = 100
let g:goyo_linenr = 0

" comfortable-motion
let g:comfortable_motion_friction = 70.0
let g:comfortable_motion_air_drag = 10.0

" vim-tmux-navigator
" Map alt + hjkl to navigation
let g:tmux_navigator_no_mappings = 1

" ALE
let g:ale_completion_enabled = 0
filetype off
filetype plugin indent on
let g:ale_linters = {
      \ 'python': ['pylint', 'mypy'],
      \ 'javascript': ['eslint'],
      \ 'css': ['prettier'],
      \ 'php': ['php'],
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
      \}

" let g:ale_python_flake8_options = "--import-order-style=google"
let g:ale_javascript_eslint_use_global = 1
let g:ale_vim_vint_executable = $HOME . '/.pyenv/versions/main/bin/vint'
let g:ale_javascript_eslint_executable   = '/usr/local/lib/node_modules/eslint/bin/eslint.js'
let g:ale_javascript_eslint_options = '-c ~/.eslintrc.yml'
let g:ale_echo_msg_format = '[%severity%] %s [%linter%]'
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_statusline_format = ['✖ %d', ' %d', '']
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_set_highlights = 0
let g:ale_fix_on_save = 0
highlight ALEErrorSign ctermfg=1
highlight ALEWarningSign ctermfg=3

" vim-test
let g:test#strategy = 'vimux'
let g:test#python#runner = 'nose'
let g:test#python#nose#options = '-xvs --with-coverage'

" utilsnips
let g:UltiSnipsExpandTrigger="<C-y>"

" vim-expand-region
vmap e <Plug>(expand_region_expand)
vmap E <Plug>(expand_region_shrink)

" fzf.vim
let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_buffers_jump = 1

" set the find executable name by os
if has('macunix') == 1
  let s:findcmd = 'gfind'
else
  let s:findcmd = 'find'
endif

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --smart-case --line-number --column --no-heading --hidden --color=never -g "!TAGS" -g "!node-modules/*" -g"!.git/*" '.shellescape(<q-args>), 0,
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
      \ {'source': s:findcmd . ' '. (empty(<q-args>) ? '~/git' : <q-args>).' -maxdepth 1 -type d',
      \  'sink': 'cd'}))

"vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_conceal = 0

" Polyglot
let g:polyglot_disabled = [ 'javascript', 'javascript.jsx', 'python' ]
let g:python_highlight_all = 1

" NERDTree
let g:NERDTreeShowHidden = 1

" vim-devicons
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_startify = 1

" windowswap
let g:windowswap_map_keys = 0

" emmet-vim
let g:user_emmet_settings = {
      \ 'javascript.jsx': {
      \   'extends': 'jsx',
      \  },
      \}

" vim-rest-console
let g:vrc_include_response_header = 1

" coc.nvim
let g:coc_global_extensions = [
      \ 'coc-css',
      \ 'coc-emmet',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-python',
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-lua',
      \ 'coc-prettier',
      \ ]
set cmdheight=2
set updatetime=400

" Tab selects completion, expands snippet, and moves through snippet fields
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>"  :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" vim-rooter
" let g:rooter_use_lcd = 1
let g:rooter_cd_cmd = "lcd"
let g:rooter_resolve_links = 1
let g:rooter_silent_chdir = 1

" nnn
let g:nnn#command = 'nnn -ednH'
let $DISABLE_FILE_OPEN_ON_NAV=1
let $NNN_RESTRICT_NAV_OPEN=1
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

" diminactive
let g:diminactive_enable_focus = 1

" animate
let g:animate#duration = 200.0

" nvim-colorizer
lua require'colorizer'.setup()

"-------------------------------- KEYBINDINGS --------------------------------

let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>
nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>

" resolve confilicts easier
nnoremap grl :diffget<CR>
nnoremap grh :diffput<CR>
vnoremap grl :diffget<CR>
vnoremap grh :diffput<CR>

" Select all text
noremap vA ggVG

" Align stuff
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Sideways
nmap gsh :SidewaysLeft<CR>
nmap gsl :SidewaysRight<CR>

" Tags
nnoremap gT g<C-]>
nnoremap gt g<C-]>

xmap K <Plug>(expand_region_expand)
xmap J <Plug>(expand_region_shrink)

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

nmap ]z :call GoToOpenFold("next")<CR>
nmap [z :call GoToOpenFold("prev")<CR>

" Jump to next error message
nnoremap ge :ALENextWrap<CR>

" Show syntax highlight at point
map gi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

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
nnoremap L g_
nnoremap H ^
xnoremap L g_
xnoremap H ^
onoremap L g_
onoremap H ^

" unbind Q for another binding
nmap Q <Nop>
xmap Q <Nop>
omap Q <Nop>

" buffer navigation
nmap <C-L> <Nop>
nmap <C-H> <Nop>

nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

nnoremap <silent> <Space>q :q<Return>
nnoremap <silent> <Space>Q :q!<Return>

" Easymotion
let g:EasyMotion_smartcase = 1
map \ <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-overwin-f2)

" Animate.vim
nnoremap <silent> <Up>    :call animate#window_delta_height(10)<CR>
nnoremap <silent> <Down>  :call animate#window_delta_height(-10)<CR>
nnoremap <silent> <Left>  :call animate#window_delta_width(10)<CR>
nnoremap <silent> <Right> :call animate#window_delta_width(-10)<CR>

" ------------ interface ----------------
let g:which_key_map = {}
let g:which_key_map.q = 'write and quit'
let g:which_key_map.Q = 'quit without writing'
let g:which_key_map.i = {
 \ 'name': '+interface'
 \ }
nnoremap <silent> <Space>i% :set invrelativenumber<CR>
" let g:which_key_map.i['%'] = 'toggle relative line numbers'
nnoremap <silent> <Space>i# :set invnumber<CR>
" let g:which_key_map.i['#'] = 'toggle line numbers'
nnoremap <silent> <Space>il :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
let g:which_key_map.i.l = 'disable cursorline'
nnoremap <silent> <Space>ii :IndentLinesToggle<CR>
let g:which_key_map.i.i = 'toggle indentation lines'
nnoremap <silent> <Space>iu :UndotreeToggle<CR>
let g:which_key_map.i.u = 'toggle undotree'
nnoremap <silent> <Space>ic :nohlsearch<CR>
let g:which_key_map.i.c = 'toggle search highlight'
nnoremap <silent> <Space>iz :Goyo<CR>
let g:which_key_map.i.z = 'toggle zen mode'
nnoremap <silent> <Space>ih :ColorizerAttachToBuffer<CR>
let g:which_key_map.i.h = 'highlight colors in buffer'
nnoremap <silent> <Space>it :NERDTreeToggle<CR>
let g:which_key_map.i.t = 'toggle NERDTree'
nnoremap <silent> <Space>in :Np<CR>
let g:which_key_map.i.n = 'launch nnn'

" ------------ buffers ------------------
let g:which_key_map['b'] = {
 \ 'name': '+buffers'
 \ }
nnoremap <silent> <Space>be :SudoEdit<CR>
let g:which_key_map.b.e = 'edit with sudo'
nnoremap <silent> <Space>bs :w<CR>
let g:which_key_map.b.s = 'write buffer'
nnoremap <silent> <Space>bn :vsplit
let g:which_key_map.b.n = 'new buffer and file'
nnoremap <silent> <Space>bd :Bdelete<CR>
let g:which_key_map.b.d = 'close buffer'
nnoremap <silent> <Space>bD :Bdelete!<CR>
let g:which_key_map.b.D = 'close buffer without saving'
nnoremap <silent> <Space>bc :windo diffthis<CR>
let g:which_key_map.b.c = 'diff buffer'
nnoremap <silent> <Space>bC :windo diffoff<CR>
let g:which_key_map.b.C = 'diff off'
nnoremap <silent> <Space>br :edit!<CR>
let g:which_key_map.b.r = 'force reload buffer'

" ------------- windows ------------------
let g:which_key_map['w'] = {
 \ 'name': '+windows'
 \ }
nnoremap <silent> <Space>wv :vsp<CR>
let g:which_key_map.w.v = 'split window vertically'
nnoremap <silent> <Space>ws :sp<CR>
let g:which_key_map.w.s = 'split window horizontally'
nnoremap <silent> <Space>wk 10<C-w>+
let g:which_key_map.w.k = 'decrease window height'
nnoremap <silent> <Space>wj 10<C-w>-
let g:which_key_map.w.j = 'increase window height'
nnoremap <silent> <Space>wl 10<C-w>>
let g:which_key_map.w.l = 'increase right window width'
nnoremap <silent> <Space>wh 10<C-w><
let g:which_key_map.w.h = 'increase left window width'
nnoremap <silent> <Space>wr <C-w>r
let g:which_key_map.w.r = 'rotate windows'
nnoremap <silent> <Space>wo <C-w>o
let g:which_key_map.w.r = 'kill other windows'
nnoremap <silent> <Space>we <C-w>=
let g:which_key_map.w.e = 'equalize windows'
nnoremap <silent> <Space>wV <C-w>H
let g:which_key_map.w.V = 'to vertical split'
nnoremap <silent> <Space>wS <C-w>J
let g:which_key_map.w.s = 'to horizontal split'

" ------------- nvim --------------------------
let g:which_key_map['v'] = {
 \ 'name': '+(neo)vim'
 \ }
nnoremap <silent> <Space>vr :so ~/.config/nvim/init.vim<CR>
let g:which_key_map.v.r = 'reload init.vim'
nnoremap <silent> <Space>ve :edit ~/.config/nvim/init.vim<CR>
let g:which_key_map.v.e = 'edit init.vim'
nnoremap <silent> <Space>vs :Startify<CR>
let g:which_key_map.v.s = 'go to start page'
nnoremap <silent> <Space>vu :PlugUpdate<CR>
let g:which_key_map.v.u = 'update plugins'
nnoremap <silent> <Space>vi :PlugInstall<CR>
let g:which_key_map.v.i = 'install plugins'
nnoremap <silent> <Space>vc :PlugClean<CR>
let g:which_key_map.v.c = 'cleanup plugins'

" ------------ code ---------------------------
let g:which_key_map['c'] = {
 \ 'name': '+coc'
 \ }
nnoremap <silent> <Space>ca <Plug>(coc-codeaction)
let g:which_key_map.c.a = 'code action'
vnoremap <silent> <Space>ca <Plug>(coc-codeaction-selected)
nnoremap <silent> <Space>cf <Plug>(coc-fix-current)
let g:which_key_map.c.f = 'fix current'
nnoremap <silent> <Space>cF <Plug>(coc-format-selected)
let g:which_key_map.c.F = 'format selected'
vnoremap <silent> <Space>cF <Plug>(coc-format-selected)
let g:which_key_map.c.F = 'format selected'
nnoremap <silent> <Space>cc :CocRestart<CR>
let g:which_key_map.c.c = 'restart'
nnoremap <silent> <Space>ce :CocConfig<CR>
let g:which_key_map.c.e = 'edit config'
nnoremap <silent> <Space>cr <Plug>(coc-rename)
let g:which_key_map.c.r = 'rename'

" ------------ functions ---------------------
let g:which_key_map['F'] = {
 \ 'name': '+functions'
 \ }
nnoremap <silent> <Space>Ft :Trimws<CR>
let g:which_key_map.F.t = 'Trim whitespace'
nnoremap <silent> <Space>Fc :!rm tags && ctags<CR>
let g:which_key_map.F.c = 'create/refresh ctags'

" ------------ testing -----------------------
let g:which_key_map['t'] = {
 \ 'name': '+test'
 \ }
nnoremap <silent> <Space>tn :TestNearest<CR>
let g:which_key_map.t.n = 'test nearest'
nnoremap <silent> <Space>tf :TestFile<CR>
let g:which_key_map.t.f = 'test current file'
nnoremap <silent> <Space>ts :TestSuite<CR>
let g:which_key_map.t.s = 'test suite'
nnoremap <silent> <Space>tl :TestLast<CR>
let g:which_key_map.t.l = 'test last'
nnoremap <silent> <Space>tv :TestVisit<CR>
let g:which_key_map.t.v = 'test visit'

" ------------- git ------------------------
let g:which_key_map['g'] = {
 \ 'name': '+git'
 \ }
nnoremap <silent> <Space>gs :Gstatus<CR>
let g:which_key_map.g.s = 'status'
nnoremap <silent> <Space>gb :Gblame<CR>
let g:which_key_map.g.b = 'blame'
nnoremap <silent> <Space>gn :GitGutterNextHunk<CR>
let g:which_key_map.g.n = 'next hunk'
nnoremap <silent> <Space>gN :GitGutterPrevHunk<CR>
let g:which_key_map.g.N = 'previous hunk'
nnoremap <silent> <Space>gh :GitGutterStageHunk<CR>
let g:which_key_map.g.h = 'state hunk'
nnoremap <silent> <Space>g] :call <SID>NextHunkAllBuffers()<CR>
let g:which_key_map.g[']'] = 'next hunk (all buffers)'
nnoremap <silent> <Space>g[ :call <SID>PrevHunkAllBuffers()<CR>
let g:which_key_map.g['['] = 'previous hunk (all buffers)'
nnoremap <silent> <Space>gu :GitGutterUndoHunk<CR>
let g:which_key_map.g.u = 'reset hunk'
nnoremap <silent> <Space>gp :GitGutterPreviewHunk<CR>
let g:which_key_map.g.p = 'preview hunk'
nnoremap <silent> <Space>gd :Gvdiff<CR>
let g:which_key_map.g.d = 'diff'
nnoremap <silent> <Space>gl :GV<CR>
let g:which_key_map.g.l = 'log'
vnoremap <silent> <Space>go :Gbrowse<CR>
let g:which_key_map.g.o = 'open in browser'
nnoremap <silent> <Space>gc :Gcommit<CR>
let g:which_key_map.g.c = 'commit'
nnoremap <silent> <Space>gr :Gvdiffsplit!<CR>
let g:which_key_map.g.c = 'start three-way merge'
nnoremap <silent> <Space>gt :diffget //2<CR>
let g:which_key_map.g.t = 'keep changes from target buffer'
nnoremap <silent> <Space>gm :diffget //3<CR>
let g:which_key_map.g.m = 'keep changes from merge buffer'

" ------------ FZF -------------------------
let g:which_key_map['f'] = {
 \ 'name': '+find'
 \ }
nnoremap <silent> <Space><Space> :GFiles<CR>
nnoremap <silent> <Space>ff :GFiles<CR>
let g:which_key_map.f.f = 'find git files'
nnoremap <silent> <Space>fa :Files<CR>
let g:which_key_map.f.a = 'find all files'
nnoremap <silent> <Space>fi :Helptags<CR>
let g:which_key_map.f.i = 'find help tag'
nnoremap <silent> <Space>fb :Buffers<CR>
let g:which_key_map.f.b = 'find buffer'
nnoremap <silent> <Space>fl :BLines<CR>
let g:which_key_map.f.l = 'find line in current buffer'
nnoremap <silent> <Space>fL :Lines<CR>
let g:which_key_map.f.L = 'find line in all buffers'
nnoremap <silent> <Space>fh :HHistory<CR>
let g:which_key_map.f.h = 'find recent buffer'
nnoremap <silent> <Space>fg :Rg<CR>
let g:which_key_map.f.g = 'find in buffers'
nnoremap <silent> <Space>ft :Filetypes<CR>
let g:which_key_map.f.t = 'find and set filetype'
nnoremap <silent> <Space>fc :Commits<CR>
let g:which_key_map.f.c = 'find commit'
nnoremap <silent> <Space>fO :Tags<CR>
let g:which_key_map.f.O = 'find tag in project'
nnoremap <silent> <Space>fo :BTags<CR>
let g:which_key_map.f.o = 'find tag in buffer'
nnoremap <silent> <Space>fe :Commands<CR>
let g:which_key_map.f.e = 'find command'
nnoremap <silent> <Space>fp :GGrep<CR>
let g:which_key_map.f.p = 'find in git files'
nnoremap <silent> <Space>fj :Cd<CR>
let g:which_key_map.f.j = 'find recent directory'
nnoremap <silent> <Space>fs :Snippets<CR>
let g:which_key_map.f.s = 'find snippet'

source $HOME/.thematic/theme.vim
source $HOME/.thematic/status.vim
source $HOME/.thematic/bars.vim
