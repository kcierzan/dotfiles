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
set timeoutlen=1000
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

" Use system clipboard on macOS and both clipboards on linux
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
" Disable annoying automatic comments
autocmd! BufNewFile,BufRead * setlocal formatoptions+=cqn

" Trigger autoread when files change on disk
autocmd! FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif | set fillchars+=vert:\│

" Notification after file change
autocmd! FileChangedShellPost *
      \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" Vim autosaves and reflects changes to files on disk
au FocusGained,BufEnter * :silent! !
au FocusLost,WinLeave * :silent! w

autocmd! filetype crontab setlocal nobackup nowritebackup

autocmd! BufNewFile,BufRead *.thtml
      \ setlocal syntax=phtml

augroup netrw_buf_hidden_fix
  autocmd!
  " Set all non-netrw buffers to bufhidden=hide
  autocmd! BufWinEnter *
        \  if &ft != 'netrw'
        \|     set bufhidden=hide
        \| endif
augroup end

augroup SwitchPanes
  autocmd! WinEnter * set cursorline
  autocmd! WinLeave * set nocursorline
augroup END

" set the cursor back when we exit nvim
au VimLeave * set guicursor=a:hor20-Cursor/lCursor

" Keep markdown file lines to 100 characters
autocmd! BufNewFile,BufRead *.md setlocal textwidth=100

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
" Plug 'joshdick/onedark.vim'
" Plug 'dracula/vim'
" Plug 'morhetz/gruvbox'
" Plug 'patstockwell/vim-monokai-tasty'
" Plug 'lifepillar/vim-solarized8'
" Plug 'liuchengxu/space-vim-theme'
" Plug 'ayu-theme/ayu-vim'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim'
Plug 'yuttie/comfortable-motion.vim'
Plug 'justinmk/vim-sneak'
Plug 'christoomey/vim-tmux-navigator'
Plug 'w0rp/ale'
Plug 'janko-m/vim-test'
Plug 'benmills/vimux'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'terryma/vim-expand-region'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'plasticboy/vim-markdown'
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
Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-abolish'
Plug 'AndrewRadev/sideways.vim'
Plug 'kh3phr3n/python-syntax'
Plug 'haya14busa/vim-keeppad'
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'
" Plug 'vimwiki/vimwiki'
Plug 'blueyed/vim-diminactive'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-rhubarb'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'mattn/emmet-vim'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
Plug 'airblade/vim-rooter'
Plug 'chrisbra/Colorizer'
Plug 'metakirby5/codi.vim'
" Plug 'sunaku/vim-shortcut'
" Plug 'lervag/vimtex'
Plug 'terryma/vim-multiple-cursors'
Plug 'Shougo/neomru.vim'
Plug 'sainnhe/edge'
Plug 'sainnhe/gruvbox-material'
Plug 'sainnhe/sonokai'
Plug 'mcchrish/nnn.vim'
call plug#end()

" ayu-theme
let ayucolor='mirage'

" startify
"
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
let g:comfortable_motion_friction = 15.0
let g:comfortable_motion_air_drag = 5.0

" vim-sneak
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 1
autocmd! Colorscheme * hi Sneak ctermfg=black ctermbg=red

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
      \ 'python': ['black'],
      \ 'javascript': ['prettier'],
      \ 'css': ['prettier'],
      \ 'html': ['tidy'],
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
let g:ale_fix_on_save = 1
highlight ALEErrorSign ctermfg=1
highlight ALEWarningSign ctermfg=3

command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1

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


autocmd! FileType fzf
autocmd FileType fzf set laststatus=0 noshowmode noruler
      \| autocmd! BufLeave <buffer> set laststatus=2 showmode ruler

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
autocmd! StdinReadPre * let s:std_in=1
autocmd! VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd! bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" vim-devicons
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_startify = 1

" windowswap
let g:windowswap_map_keys = 0

" fugitive
let g:github_enterprise_urls = ['https://github.aweber.io']
let g:fugitive_gitlab_domains = ['https://gitlab.aweber.io', 'git@gitlab.aweber.io']

" emmet-vim
let g:user_emmet_settings = {
      \ 'javascript.jsx': {
      \   'extends': 'jsx',
      \  },
      \}

" vim-rest-console
let g:vrc_include_response_header = 1

" coc.nvim
let g:coc_global_extensions = ['coc-json', 'coc-python', 'coc-snippets', 'coc-emmet', 'coc-css', 'coc-tsserver', 'coc-html']
set cmdheight=2
set updatetime=400


inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

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
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" highlight symbol under cursor on CursorHold
autocmd! CursorHold * silent call CocActionAsync('highlight')

" vim-rooter
let g:rooter_use_lcd = 1
let g:rooter_resolve_links = 1
let g:rooter_silent_chdir = 1

" nnn
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }

" source the generated colorscheme
source $HOME/.config/nvim/colorscheme.vim

" set up the statusline
source $HOME/.config/nvim/statusline.vim

"-------------------------------- KEYBINDINGS --------------------------------
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>
"
" resolve confilicts easier
nnoremap grl :diffget<CR>
nnoremap grh :diffput<CR>
vnoremap grl :diffget<CR>
vnoremap grh :diffput<CR>

" Select all text
noremap vA ggVG

" Align stuff
      \ nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

      \ nmap gsh :SidewaysLeft<CR>
      \ nmap gsl :SidewaysRight<CR>

      \ nnoremap gT g<C-]>

      \ nnoremap gt g<C-]>

      \ xmap K <Plug>(expand_region_expand)
      \ xmap J <Plug>(expand_region_shrink)

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

"buffer navigation
nmap <C-L> <Nop>
nmap <C-H> <Nop>

nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

nnoremap <silent> <Space>q :q<Return>
nnoremap <silent> <Space>Q :q!<Return>

" ------------ interface ----------------
nnoremap <silent> <Space>i% :set invrelativenumber<CR>
nnoremap <silent> <Space>i# :set invnumber<CR>
nnoremap <silent> <Space>il :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
nnoremap <silent> <Space>ii :IndentLinesToggle<CR>
nnoremap <silent> <Space>iu :UndotreeToggle<CR>
nnoremap <silent> <Space>ic :nohlsearch<CR>
nnoremap <silent> <Space>iz :Goyo<CR>
nnoremap <silent> <Space>ih :ColorHighlight<CR>
nnoremap <silent> <Space>it :NERDTreeToggle<CR>

" ------------ buffers ------------------
nnoremap <silent> <Space>be :SudoEdit<CR>
nnoremap <silent> <Space>bs :w<CR>
nnoremap <silent> <Space>bn :new<CR>
nnoremap <silent> <Space>bd :bd<CR>
nnoremap <silent> <Space>bD :bd!<CR>
nnoremap <silent> <Space>bc :windo diffthis<CR>
nnoremap <silent> <Space>bC :windo diffoff<CR>
nnoremap <silent> <Space>br :edit!<CR>
nnoremap <silent> <Space>bw :Trimws<CR>

" ------------- windows ------------------
nnoremap <silent> <Space>wv :vsp<CR>
nnoremap <silent> <Space>ws :sp<CR>
nnoremap <silent> <Space>wk 10<C-w>+
nnoremap <silent> <Space>wj 10<C-w>-
nnoremap <silent> <Space>wl 10<C-w>>
nnoremap <silent> <Space>wh 10<C-w><
nnoremap <silent> <Space>wr <C-w>r
nnoremap <silent> <Space>wo <C-w>o
nnoremap <silent> <Space>we <C-w>=
nnoremap <silent> <Space>wV <C-w>H
nnoremap <silent> <Space>wS <C-w>J

" ------------- nvim --------------------------
nnoremap <silent> <Space>vr :so ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Space>ve :edit ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Space>vs :Startify<CR>
nnoremap <silent> <Space>vu :PlugUpdate<CR>
nnoremap <silent> <Space>vi :PlugInstall<CR>
nnoremap <silent> <Space>vc :PlugClean<CR>

" ------------ code ---------------------------
nnoremap <silent> <Space>cT :!ctags<CR>
nnoremap <silent> <Space>cr :!rm tags && ctags<CR>
nnoremap <silent> <Space>ca <Plug>(coc-codeaction)
vnoremap <silent> <Space>ca <Plug>(coc-codeaction-selected)
nnoremap <silent> <Space>cf <Plug>(coc-fix-current)
nnoremap <silent> <Space>cF <Plug>(coc-format-selected)
vnoremap <silent> <Space>cF <Plug>(coc-format-selected)
nnoremap <silent> <Space>cc :CocRestart<CR>
nnoremap <silent> <Space>cR <Plug>(coc-rename)

" ------------ testing -----------------------
nnoremap <silent> <Space>tn :TestNearest<CR>
nnoremap <silent> <Space>tf :TestFile<CR>
nnoremap <silent> <Space>ts :TestSuite<CR>
nnoremap <silent> <Space>tl :TestLast<CR>
nnoremap <silent> <Space>tv :TestVisit<CR>

" ------------- git ------------------------
nnoremap <silent> <Space>gs :Gstatus<CR>
nnoremap <silent> <Space>gb :Gblame<CR>
nnoremap <silent> <Space>gn :GitGutterNextHunk<CR>
nnoremap <silent> <Space>gN :GitGutterPrevHunk<CR>
nnoremap <silent> <Space>gh :GitGutterStageHunk<CR>
nnoremap <silent> <Space>g] :call <SID>NextHunkAllBuffers()<CR>
nnoremap <silent> <Space>g[ :call <SID>PrevHunkAllBuffers()<CR>
nnoremap <silent> <Space>gu :GitGutterUndoHunk<CR>
nnoremap <silent> <Space>gp :GitGutterPreviewHunk<CR>
nnoremap <silent> <Space>gd :Gvdiff<CR>
nnoremap <silent> <Space>gl :GV<CR>
nnoremap <silent> <Space>go :Gbrowse<CR>
vnoremap <silent> <Space>go :Gbrowse<CR>
nnoremap <silent> <Space>gc :Gcommit<CR>

" ------------ FZF -------------------------
nnoremap <silent> <Space>ff :GFiles<CR>
nnoremap <silent> <Space><Space> :GFiles<CR>
nnoremap <silent> <Space>fa :Files<CR>
nnoremap <silent> <Space>fi :Helptags<CR>
nnoremap <silent> <Space>fb :Buffers<CR>
nnoremap <silent> <Space>fl :BLines<CR>
nnoremap <silent> <Space>fL :Lines<CR>
nnoremap <silent> <Space>fh :HHistory<CR>
nnoremap <silent> <Space>fg :Rg<CR>
nnoremap <silent> <Space>ft :Filetypes<CR>
nnoremap <silent> <Space>fc :Commits<CR>
nnoremap <silent> <Space>fO :Tags<CR>
nnoremap <silent> <Space>fo :BTags<CR>
nnoremap <silent> <Space>fe :Commands<CR>
nnoremap <silent> <Space>fp :GGrep<CR>
nnoremap <silent> <Space>fj :Cd<CR>
nnoremap <silent> <Space>fs :Snippets<CR>
