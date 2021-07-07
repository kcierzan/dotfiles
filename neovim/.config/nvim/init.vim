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

" Netrw has been removed from neovim HEAD
" augroup Netrw
"   autocmd!
"   " Set all non-netrw buffers to bufhidden=hide
"   autocmd BufWinEnter *
"         \  if &ft != 'netrw'
"         \|     set bufhidden=hide
"         \| endif
" augroup END

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
let g:python3_host_prog = $HOME . '/.virtualenvs/neovim/bin/python3'

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
      \ 'coc-pyright',
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

" indent-blankline
let g:indent_blankline_enabled = v:false

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

lua require('plugins')

let g:fzf_layout = { 'window': '-tabnew' }
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

colorscheme thematic
