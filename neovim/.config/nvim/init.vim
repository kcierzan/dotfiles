"  ██╗███╗   ██╗██╗████████╗██╗   ██╗██╗███╗   ███╗
"  ██║████╗  ██║██║╚══██╔══╝██║   ██║██║████╗ ████║
"  ██║██╔██╗ ██║██║   ██║   ██║   ██║██║██╔████╔██║
"  ██║██║╚██╗██║██║   ██║   ╚██╗ ██╔╝██║██║╚██╔╝██║
"  ██║██║ ╚████║██║   ██║██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
"  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
  
" -------------------------------- SETTINGS --------------------------------
scriptencoding utf-8
set autoindent
set autoread
set clipboard=unnamed
set clipboard+=unnamedplus
set cmdheight=2
set completeopt-=preview
set conceallevel=2
set cursorline
set expandtab
set foldlevelstart=20
set gdefault
set hidden
set ignorecase
set inccommand=nosplit
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
set shortmess+=c
set showcmd
set showtabline=0
set signcolumn=yes
set smartcase
set smartindent
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set termguicolors
set textwidth=0
set timeoutlen=500
set ttimeoutlen=0
set undodir=~/.undo
set undofile
set undolevels=100000
set updatetime=100

" Enable blinking underline cursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:hor20-Cursor/lCursor

filetype off
filetype plugin indent on

" Set :grep to use ripgrep
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" set the find executable name by os
if has('macunix') == 1
  let s:findcmd = 'gfind'
else
  let s:findcmd = 'find'
endif

" Enable lua-in-vimscript syntax highlighting
let g:vimsyn_embed = "l"

" -------------------------------- AUTOCOMMANDS --------------------------------

" Trigger autoread when files change on disk and display a notification
augroup AutoRevert
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() != 'c' | checktime | endif | set fillchars+=vert:\│
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
augroup END

augroup AutoSave
  autocmd!
  " Vim autosaves and reflects changes to files on disk
  autocmd FocusGained,BufEnter * :silent! !
  autocmd FocusLost,WinLeave * :silent! w
augroup END

augroup Crontab
  autocmd!
  " disable backups when editing cron files
  autocmd filetype crontab setlocal nobackup nowritebackup
augroup END

augroup HTML
  autocmd!
  " teach vim about the horrors of php template files
  autocmd BufNewFile,BufRead *.thtml setlocal syntax=phtml
augroup END

augroup Markdown
  autocmd!
  " Keep markdown file lines to 100 characters
  autocmd FileType markdown setlocal textwidth=100
augroup END

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
  " turn off the cursorline in inactive buffers
  autocmd WinEnter * set cursorline
  autocmd WinLeave * set nocursorline
augroup END

augroup CursorShape
  autocmd!
  " reset the cursor shape when nvim exits
  autocmd VimLeave * set guicursor=a:hor20-Cursor/lCursor
augroup END

augroup CocSymbolHighlight
  autocmd!
  " highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

augroup RegisterWhichKey
  autocmd!
  autocmd User vim-which-key call which_key#register('<Space>', 'g:which_key_map')
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

" ----------------------------- Pre plugin config -----------------------
" Virtualenv for python-dependent plugins
let g:python3_host_prog = $HOME . '/.pyenv/versions/main/bin/python3'

let g:tex_flavor = 'latex'

" dashboard
let g:ascii = [
      \ '  __   __  ______  ______  __   ____  __    __   ',
      \ ' /\ "-.\ \/\  ___\/\  __ \/\ \ / /\ \/\ "-./  \  ',
      \ " \\ \\ \\-.  \\ \\  __\\\\ \\ \\/\\ \\ \\ \\'/\\ \\ \\ \\ \\-./\\ \\ ",
      \ '  \ \_\\"\_\ \_____\ \_____\ \__| \ \_\ \_\ \ \_\',
      \ '   \/_/ \/_/\/_____/\/_____/\/_/   \/_/\/_/  \/_/',
      \ '                                                 ',
      \]
let g:scroll =
      \ map(split(system('fortune -s | fmt -42 | boxes -k 1 -p h2 -d parchment'), '\n'), '"  ". v:val')

let g:dashboard_custom_header = map(g:ascii + g:scroll, '"   ".v:val')

" indentLine
let g:indentLine_enabled = 0
let g:indentLine_char = '│'
let g:indentLine_first_char = '│'
let g:indentLine_showFirstIndentLevel = 1
let g:indentLine_fileTypeExclude = ['text', 'sh', 'startify', 'man', 'help']
let g:indentLine_bufTypeExclude = ['terminal']
let g:indentLine_setColors = 1

" goyo
let g:goyo_width = 100
let g:goyo_linenr = 0

" vim-tmux-navigator
" Map alt + hjkl to navigation
let g:tmux_navigator_no_mappings = 1

" vim-test
let g:test#strategy = 'vimux'
let g:test#python#runner = 'nose'
let g:test#python#nose#options = '-xvs --with-coverage'

" utilsnips
let g:UltiSnipsExpandTrigger="<C-y>"

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_conceal = 0

" vim-devicons
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_startify = 1

" windowswap
let g:windowswap_map_keys = 0

" emmet-vim
imap <silent> <C-l>l <C-y>,
vmap <silent> <C-l>l <C-y>,
imap <silent> <C-l>d <C-y>d
imap <silent> <C-l>D <C-y>D
imap <silent> <C-l>n <C-y>n
imap <silent> <C-l>N <C-y>N
imap <silent> <C-l>m <C-y>m
imap <silent> <C-l>m <C-y>m
imap <silent> <C-l>k <C-y>k
imap <silent> <C-l>j <C-y>j
imap <silent> <C-l>/ <C-y>/
imap <silent> <C-l>/ <C-y>/
imap <silent> <C-l>a <C-y>a
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
      \ 'coc-pairs',
      \ ]

" Easymotion
let g:EasyMotion_smartcase = 1

" accept completion with tab
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" vim-rooter
let g:rooter_cd_cmd = "lcd"
let g:rooter_resolve_links = 1
let g:rooter_silent_chdir = 1

" diminactive
let g:diminactive_enable_focus = 1

" dashboard.nvim
let g:dashboard_default_executive = "fzf"

"-------------------------------- Post Plugin config  -----------------------------------
" vim-expand-region
vmap e <Plug>(expand_region_expand)
vmap E <Plug>(expand_region_shrink)

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
nnoremap <silent> gh :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

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

nmap <silent> ]z :call GoToOpenFold("next")<CR>
nmap <silent> [z :call GoToOpenFold("prev")<CR>

" Jump to next error message
" TODO: make a coc version of this
nnoremap ge <Plug>(coc-diagnostic-next)<CR>
nnoremap gE <Plug>(coc-diagnostic-prev)<CR>

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

map \ <Plug>(easymotion-prefix)
nmap s <Plug>(easymotion-overwin-f2)

" ------------ interface ----------------
let g:which_key_map = {}
let g:which_key_map.q = 'write and quit'
let g:which_key_map.Q = 'quit without writing'
let g:which_key_map.i = {
 \ 'name': '+interface'
 \ }
nnoremap <silent> <Space>i% :set invrelativenumber<CR>
let g:which_key_map.i['%'] = 'toggle relative line numbers'
nnoremap <silent> <Space>i# :set invnumber<CR>
let g:which_key_map.i['#'] = 'toggle line numbers'
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
nnoremap <silent> <Space>it :NvimTreeToggle<CR>
let g:which_key_map.i.t = 'toggle file browser'
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
nnoremap <silent> <Space>bd :BufferClose<CR>
let g:which_key_map.b.d = 'close buffer'
nnoremap <silent> <Space>bD :BufferClose!<CR>
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
nnoremap <silent> <Space>vs :Dashboard<CR>
let g:which_key_map.v.s = 'go to start page'
nnoremap <silent> <Space>vu :PackerUpdate<CR>
let g:which_key_map.v.u = 'update plugins'
nnoremap <silent> <Space>vi :PackerInstall<CR>
let g:which_key_map.v.i = 'install plugins'
nnoremap <silent> <Space>vc :PackerClean<CR>
let g:which_key_map.v.c = 'compile plugins'

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
nmap <silent> <Space>gn <Plug>(signify-next-hunk)
let g:which_key_map.g.n = 'next hunk'
nmap <silent> <Space>gN <Plug>(signify-prev-hunk)
let g:which_key_map.g.N = 'previous hunk'
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

" ------------ Telescope -------------------------
let g:which_key_map['f'] = {
 \ 'name': '+find'
 \ }
" nnoremap <silent> <Space><Space> :Telescope git_files<CR>
" nnoremap <silent> <Space>ff :Telescope git_files<CR>
" let g:which_key_map.f.f = 'find git files'
" nnoremap <silent> <Space>fa :lua require('telescope').extensions.fzf_writer.files()<CR>
" let g:which_key_map.f.a = 'find all files'
" nnoremap <silent> <Space>fi :Telescope help_tags<CR>
" let g:which_key_map.f.i = 'find help tag'
" nnoremap <silent> <Space>fb :Telescope buffers<CR>
" let g:which_key_map.f.b = 'find buffer'
" nnoremap <silent> <Space>fl :Telescope current_buffer_fuzzy_find<CR>
" let g:which_key_map.f.l = 'find line in current buffer'
" nnoremap <silent> <Space>fh :Telescope oldfiles<CR>
" let g:which_key_map.f.h = 'find recent buffer'
" noremap <silent> <Space>fg :lua require('telescope').extensions.fzf_writer.staged_grep()<CR>
" let g:which_key_map.f.g = 'find in buffers'
" nnoremap <silent> <Space>ft :Telescope filetypes<CR>
" let g:which_key_map.f.t = 'find and set filetype'
" nnoremap <silent> <Space>fO :Telescope tags<CR>
" let g:which_key_map.f.O = 'find tag in project'
" nnoremap <silent> <Space>fo :Telescope current_buffer_tags<CR>
" let g:which_key_map.f.o = 'find tag in buffer'
" nnoremap <silent> <Space>fe :Telescope commands<CR>
" let g:which_key_map.f.e = 'find command'


" ------------ FZF -------------------------
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

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
nnoremap <silent> <Space>fh :History<CR>
let g:which_key_map.f.h = 'find recent buffer'
noremap <silent> <Space>fg :RG<CR>
let g:which_key_map.f.g = 'find in buffers'
nnoremap <silent> <Space>ft :Filetypes<CR>
let g:which_key_map.f.t = 'find and set filetype'
nnoremap <silent> <Space>fO :Tags<CR>
let g:which_key_map.f.O = 'find tag in project'
nnoremap <silent> <Space>fo :BTags<CR>
let g:which_key_map.f.o = 'find tag in buffer'
nnoremap <silent> <Space>fe :Commands<CR>
let g:which_key_map.f.e = 'find command'

lua require('plugins')

source $HOME/.thematic/theme.vim

" source $HOME/.thematic/status.vim
" source $HOME/.thematic/bars.vim
