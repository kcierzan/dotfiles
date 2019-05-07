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
" set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:hor20-Cursor/lCursor
set guicursor=n-v-c:block-Cursor/lCursor-blinkon1,i-ci-r-cr:ver25-Cursor/lCursor

" Use system clipboard on macOS
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
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif | set fillchars+=vert:\│

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
Plug 'morhetz/gruvbox'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'kcierzan/termina'
Plug 'lifepillar/vim-solarized8'
Plug 'liuchengxu/space-vim-theme'
Plug 'ayu-theme/ayu-vim'
Plug 'mhinz/vim-startify'
Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/goyo.vim'
Plug 'yuttie/comfortable-motion.vim'
Plug 'justinmk/vim-sneak'
Plug 'terryma/vim-multiple-cursors'
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
Plug 'itchyny/lightline.vim'
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
Plug 'moll/vim-bbye'
Plug 'mkitt/tabline.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tpope/vim-abolish'
Plug 'AndrewRadev/sideways.vim'
Plug 'majutsushi/tagbar'
Plug 'vim-python/python-syntax'
Plug 'haya14busa/vim-keeppad'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'vimwiki/vimwiki'
Plug 'blueyed/vim-diminactive'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-rhubarb'
Plug 'wesQ3/vim-windowswap'
Plug 'shumphrey/fugitive-gitlab.vim'
Plug 'mattn/emmet-vim'
Plug 'diepm/vim-rest-console'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install() }}
Plug 'airblade/vim-rooter'
Plug 'hecal3/vim-leader-guide'
call plug#end()

"-------------------------------- PLUGIN CONFIG -----------------------------------
" ayu-theme
let ayucolor='mirage'
" hi SignColumn guifg=none guibg='#212632'
" hi  ColorColumn guifg=none guibg='#272f3d'

" startify
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
  colorscheme solarized8
  nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
  ALEEnable
endfunction

augroup GoyoToggle
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" comfortable-motion
let g:comfortable_motion_friction = 15.0
let g:comfortable_motion_air_drag = 5.0

" vim-sneak
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
let g:sneak#s_next = 1
autocmd Colorscheme * hi Sneak ctermfg=black ctermbg=red

" vim-tmux-navigator
" Map alt + hjkl to navigation
" TODO: why doesn't this work on linux?
let g:tmux_navigator_no_mappings = 1

" ALE
filetype off
filetype plugin on
let g:ale_linters = {
      \ 'python': ['pyls'],
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
let g:ale_lint_on_text_changed = 'always'
let g:ale_set_highlights = 0
highlight ALEErrorSign ctermfg=1
highlight ALEWarningSign ctermfg=3

command! ALEDisableFixers       let g:ale_fix_on_save=0
command! ALEEnableFixers        let g:ale_fix_on_save=1

" vim-test
let g:test#python#runner = 'nose'
let g:test#strategy = 'vimux'
let g:test#python#nose#options = '-xvs --with-coverage'

let g:UltiSnipsExpandTrigger="<C-y>"

" vim-expand-region
vmap e <Plug>(expand_region_expand)
vmap E <Plug>(expand_region_shrink)

" fzf.vim
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
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_frontmatter = 1

" lightline
let g:lightline = {
      \ 'colorscheme': 'darcula',
      \ 'separator': {
      \   'left': "\ue0b0",
      \   'right': "\ue0b2"
      \ },
      \ 'subseparator': {
      \   'left': "\ue0b1",
      \   'right': "\ue0b3"
      \ },
      \ 'enable': {
      \   'statusline': 1
      \ },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], ['filename', 'modified'], ['gitbranch'] ],
      \   'right': [ ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok' ], ['cwd', 'filetype' ], [ 'lineinfo', 'percent'], ['coc'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'cwd': 'LightlineCwd',
      \   'coc': 'CocCollapse',
      \   'filetype': 'IconFiletype',
      \   'filename': 'LightLineFilename',
      \ },
      \ 'component_expand': {
      \   'linter_warnings': 'LightlineLinterWarnings',
      \   'linter_errors': 'LightlineLinterErrors',
      \   'linter_ok': 'LightlineLinterOK',
      \ },
      \ 'component_type': {
      \   'readonly': 'error',
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \ }
      \}

function! CocCollapse()
  return winwidth(0) > 100 ? coc#status() : ''
endfunction

function! IconFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! IconFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! LightlineCwd()
  return fnamemodify(getcwd(), ':t')
endfunction

function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('  %d', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf(' %d', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? ' ' : ''
endfunction

function LightLineFilename()
  return expand('%')
endfunction

function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction

augroup LightLineOnALE
  autocmd!
  autocmd User ALEFixPre   call lightline#update()
  autocmd User ALEFixPost  call lightline#update()
  autocmd User ALELintPre  call lightline#update()
  autocmd User ALELintPost call lightline#update()
augroup end
autocmd! BufWrite,TextChanged,TextChangedI,BufEnter,WinEnter,BufWinEnter,FileType,ColorScheme,SessionLoadPost * call lightline#update()

" Polyglot
let g:polyglot_disabled = [ 'javascript', 'javascript.jsx', 'python' ]
let g:python_highlight_all = 1

" NERDTree
let g:NERDTreeShowHidden = 1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" vim-devicons
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_startify = 1

" windowswap
let g:windowswap_map_keys = 0

" fugitive
let g:github_enterprise_urls = ['https://github.aweber.io']
let g:fugitive_gitlab_domaines = ['https://gitlab.aweber.io', 'gitlab.aweber.io']

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

"-------------------------------- LEADER GUIDE -----------------------------------
let g:lmap = {}
let g:lmap.f = { 'name': 'Find' }
let g:lmap.t = { 'name': 'Test' }
" Set leader key
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>

nnoremap <Leader>q :q<CR>
" Force close window
nnoremap <Leader>Q :q!<CR>

" Leader Guide - Interface
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
      \ 't': ['NERDTreeToggle', 'open file browser'],
      \ }
nnoremap <silent> <leader>i% :set invrelativenumber<CR>
nnoremap <silent> <leader>i# :set invnumber<CR>
nnoremap <silent> <leader>ih :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
nnoremap <silent> <leader>ii :IndentLinesToggle<CR>
nnoremap <silent> <leader>iu :UndotreeToggle<CR>
nnoremap <silent> <leader>ic :nohlsearch<CR>
nnoremap <silent> <leader>iz :Goyo<CR>
nnoremap <silent> <leader>il :Limelight<CR>
nnoremap <silent> <leader>iL :Limelight!<CR>
nnoremap <silent> <leader>it :NERDTreeToggle<CR>

" Leader Guide - Buffers
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
nnoremap <silent> <leader>bs :w<CR>
nnoremap <silent> <leader>bn :new<CR>
nnoremap <silent> <Leader>bd :Bdelete<CR>
nnoremap <silent> <Leader>bD :Bdelete!<CR>
nnoremap <silent> <leader>bc :windo diffthis<CR>
nnoremap <silent> <leader>bC :windo diffoff<CR>
nnoremap <silent> <leader>br :edit!<CR>
nnoremap <silent> <leader>bw :Nows<CR>

" Leader Guide - Windows
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

nnoremap <silent> <leader>wv :vsp<CR>
nnoremap <silent> <leader>ws :sp<CR>
nnoremap <silent> <leader>we <C-w>e
nnoremap <silent> <leader>wk 10<C-w>+
nnoremap <silent> <leader>wj 10<C-w>-
nnoremap <silent> <leader>wl 10<C-w>>
nnoremap <silent> <leader>wh 10<C-w><
nnoremap <silent> <leader>wr <C-w>r
nnoremap <silent> <leader>wo <C-w>o
nnoremap <silent> <leader>we <C-w>=
nnoremap <silent> <leader>wV <C-w>H
nnoremap <silent> <leader>wS <C-w>J
nnoremap <silent> <leader>wc :call WindowSwap#EasyWindowSwap()<CR>

" Leader Guide - Neovim
let g:lmap.v = { 'name': 'Neovim',
      \ 'r': ['so ~/.config/nvim/init.vim', 'reload init.vim'],
      \ 'e': ['edit ~/.config/nvim/init.vim', 'edit init.vim'],
      \ 's': ['Startify', 'homepage'],
      \ 'u': ['PlugUpdate', 'update plugins'],
      \ 'U': ['PlugUpgrade', 'update vim-plug'],
      \ 'i': ['PlugInstall', 'install plugins'],
      \ 'c': ['PlugClean', 'clean up plugins'],
      \}
nnoremap <silent> <Leader>vr :so ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>ve :edit ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>vs :Startify<CR>
nnoremap <silent> <Leader>vu :PlugUpdate<CR>
nnoremap <silent> <Leader>vi :PlugInstall<CR>
nnoremap <silent> <Leader>vc :PlugClean<CR>

" Leader Guide - Code
let g:lmap.c = {'name': 'Code',
      \ 't': ['TagbarToggle', 'toggle tagbar'],
      \ 'r': ['!rm tags && ctags', 'regenerate tags'],
      \ 'T': ['!ctags', 'generate ctags'],
      \ 'a': ['<Plug>(coc-codeaction)', 'code action'],
      \ 'f': ['<Plug>(coc-fix-current)', 'fix current'],
      \ 'F': ['<Plug>(coc-format-selected)', 'format selected'],
      \ 'c': ['CocRestart', 'restart coc'],
      \ 'R': ['CocRename', 'rename']
      \}
nnoremap <silent> <leader>ct :TagbarToggle<CR>
nnoremap <silent> <leader>cT :!ctags<CR>
nnoremap <silent> <leader>cr :!rm tags && ctags<CR>
nnoremap <silent> <leader>ca <Plug>(coc-codeaction)
vnoremap <silent> <leader>ca <Plug>(coc-codeaction-selected)
nnoremap <silent> <leader>cf <Plug>(coc-fix-current)
nnoremap <silent> <leader>cF <Plug>(coc-format-selected)
vnoremap <silent> <leader>cF <Plug>(coc-format-selected)
nnoremap <silent> <leader>cc :CocRestart<CR>
nnoremap <silent> <leader>cR <Plug>(coc-rename)

" Leader Guide - Testing
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

" Leader Guide - Git
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
vnoremap <silent> <leader>go :Gbrowse<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>

" Leader Guide - FZF
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

" Leader Guide - Notes
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

call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>

"-------------------------------- COLORSCHEMES -----------------------------------

syntax enable
set background=dark
colorscheme space_vim_theme

" Space-vim-theme
hi Normal guibg=none guifg=none
hi ColorColumn guifg=none guibg='#313337'
hi SignColumn guibg='#282a2e'
hi VertSplit guifg = '#282a2e' guibg='#282a2e'

" Onedark
" hi Normal ctermfg=none ctermbg=none guibg=none guifg=none
" " or the colorcolumn for diminactive
" hi  ColorColumn ctermfg=none ctermbg=0
" hi ALEErrorSign                   ctermfg=1 guifg='#e06c75'
" hi ALEWarningSign                 ctermfg=3 guifg='#e5c07b'
" hi ALEError                       ctermbg=0
" hi ALEWarning                     ctermbg=0
" hi VertSplit guifg = '#272c33'
" hi Comment cterm=italic
" hi CocHighlightText guibg = '#404754'

"Solarized Light
" hi SignColumn guibg = '#fdf6e3'
" hi Normal guibg=none guifg=none
" hi LineNr guibg = '#fdf6e3'
" hi VertSplit guibg = '#fdf6e3' guifg = '#fdf6e3'
" hi GitGutterAdd guibg = '#fdf6e3' guifg = '#859900'
" hi GitGutterChange guibg = '#fdf6e3' guifg = '#b58900'
" hi GitGutterDeleteLine guibg = '#fdf6e3' guifg = '#cb4b16'
" hi GitGutterDelete guibg = '#fdf6e3' guifg = '#cb4b16'
" hi GitGutterChangeDeleteLine guibg = '#fdf6e3' guifg = '#cb4b16'
" hi GitGutterChangeDeleteLine guibg = '#fdf6e3' guifg = '#cb4b16'

"Solarized Dark
" hi SignColumn guibg = '#002b36'
" hi Normal guibg=none guifg=none
" hi LineNr guibg = '#002b36'
" hi VertSplit guibg = '#002b36' guifg = '#002b36'
" hi GitGutterAdd guibg = '#002b36' guifg = '#859900'
" hi GitGutterChange guibg = '#002b36' guifg = '#b58900'
" hi GitGutterDeleteLine guibg = '#002b36' guifg = '#cb4b16'
" hi GitGutterDelete guibg = '#002b36' guifg = '#cb4b16'
" hi GitGutterChangeDeleteLine guibg = '#002b36' guifg = '#cb4b16'
" hi GitGutterChangeDeleteLine guibg = '#002b36' guifg = '#cb4b16'

" Monokai Tasty
" let g:vim_monokai_tasty_italic = 1
" hi SignColumn guibg='#212121'
" let g:terminal_color_1=  "#f82a71"
" let g:terminal_color_2 = "#a6e12d"
" let g:terminal_color_3 = "#fd971e"
" let g:terminal_color_4 = "#ae80fe"
" let g:terminal_color_5 = "#f82a71"
" let g:terminal_color_6 = "#66d8ee"
" let g:terminal_color_7 = "#cfcfc1"
" let g:terminal_color_8 = "#74705d"
" let g:terminal_color_9=  "#d32461"
" let g:terminal_color_10 = "#a6e12d"
" let g:terminal_color_11 = "#fd971e"
" let g:terminal_color_12 = "#ae80fe"
" let g:terminal_color_13=  "#d32461"
" let g:terminal_color_14 = "#5cc4d8"
" let g:terminal_color_15 = "#cfcfc1"
" hi SignColumn guibg='#252525'
" hi ColorColumn guifg=none guibg='#2d2d2d'
" hi Cursorline guifg=none guibg='#2d2d2d'
