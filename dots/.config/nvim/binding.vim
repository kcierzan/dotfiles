"    __    _           ___                   _         
"   / /_  (_)___  ____/ (_)___  ____ __   __(_)___ ___ 
"  / __ \/ / __ \/ __  / / __ \/ __ `/ | / / / __ `__ \
" / /_/ / / / / / /_/ / / / / / /_/ /| |/ / / / / / / /
"/_____/_/_/ /_/\__,_/_/_/ /_/\__, (_)___/_/_/ /_/ /_/ 
"                            /____/                    
"
" Set leader key
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>
" Define leader guide dictionary
let g:lmap = {}

" -----Finding-------------------
" Clean search highlight
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
" Keep search results in the center of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

"------Jumping-------------------
nmap <leader><leader> <Nop>
let g:lmap[' '] = ['', 'Exit']
let g:lmap.j = { 'name' : 'Jumping' }
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
nmap <leader>js <Plug>(easymotion-overwin-f2)
let g:lmap.j.s = ['easymotion-overwin-f2', 'Jump to 2 characters']
" Go to character
map  <Leader>jf <Plug>(easymotion-bd-f)
nmap <Leader>jf <Plug>(easymotion-overwin-f)
let g:lmap.j.f = ['easymotion-overwin-f', 'Jump to character']
" Move to line
map <Leader>jl <Plug>(easymotion-bd-jk)
let g:lmap.j.l = ['easymotion-bd-jk', 'Jump to line']
nmap <Leader>jl <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>jw <Plug>(easymotion-bd-w)
nmap <Leader>jw <Plug>(easymotion-overwin-w)
let g:lmap.j.w = ['easymotion-overwin-w', 'Jump to word']
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
nnoremap L $
nnoremap H ^
xnoremap L $
xnoremap H ^

" ----- Jedi -----------
let g:lmap.p = { 'name' : 'Python' }
" Go to definition
let g:jedi#goto_command = "<leader>pd"
let g:lmap.p.d = ['jedi#goto_command', 'Go to definition']
" Go to assignments
let g:jedi#goto_assignments_command = "<leader>pa"
let g:lmap.p.a = ['jedi#goto_assignments_command', 'Go to assignments']
" Go to usages
let g:jedi#goto_usages = "<leader>pu"
let g:lmap.p.u = ['jedi#goto_usages', 'Go to usages']
  " Rename element
let g:jedi#rename_command = "<leader>pr"
let g:lmap.p.r = ['jedi#rename_command', 'Rename']
" Show documentation
let g:jedi#documentation_command = "<leader>ps" 
let g:lmap.p.s = ['jedi#documentation_command', 'Show documentation']

"------Buffers and Windows-------
let g:lmap.w = { 'name' : 'Windows' }
" Close window
nnoremap <Leader>wq :q<CR>
let g:lmap.w.q = [':q', 'Close window']
" Force close window
nnoremap <Leader>wQ :q!<CR>
let g:lmap.w.Q = [':q!', 'Force close window']
" Close buffer
nnoremap <Leader>wd :Bdelete<CR>
let g:lmap.w.d = [':Bdelete', 'Close buffer']
" Intelligently close deoplete popup
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
" <CR>: close deoplete popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction
" create splits
nnoremap <leader>wv :vsp<CR>
let g:lmap.w.v = [':vsp', 'Open split vertical']
nnoremap <leader>wh :sp<CR>
let g:lmap.w.h = [':sp', 'Open split horizontal']
nnoremap <leader>wi :IndentLinesToggle<CR>
let g:lmap.w.i = [':IndentLinesToggle', 'Toggle indent lines']
"buftabline
nmap <C-L> <Nop>
nmap <C-H> <Nop>
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

"--------Project-----------------
let g:lmap.n = { 'name' : 'Neovim' }
" Source dotfile
nnoremap <Leader>nr :so ~/.config/nvim/init.vim<CR>
let g:lmap.n.r = ['so ~/.config/nvim/init.vim', 'Source dotfile']
" show file browser
nnoremap <Leader>nt :NERDTreeToggle<CR>
let g:lmap.n.t = ['NERDTreeToggle', 'Toggle NerdTree']
" cd to current file directory
nnoremap <Leader>nd :lcd %:p:h<CR>
let g:lmap.n.d = ['lcd %:p:h', 'Cd to current directory']
" Open nerdtree at current working directory
nnoremap <Leader>nT :NERDTreeCWD<CR>
let g:lmap.n.T = ['NERDTreeCWD', 'Open tree at current location']
" show start buffer
nnoremap <Leader>ns :Startify<CR>
let g:lmap.n.s = ['Startify', 'Open start menu']
" Show undotree
nnoremap <Leader>nu :UndotreeToggle<CR>
let g:lmap.n.u = ['UndotreeToggle', 'Toggle undotree']

"-------Editing-------------------
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" Select all text
noremap vA ggVG

"-------Code Generation-----------

"-------Run/Debug-----------------
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
let g:lmap.t.v = ['TestVisit', 'Go to last run test']

"-------Version Control-----------
let g:lmap.g = { 'name' : 'Git' }
nnoremap <silent> <leader>gs :Gstatus<CR>
let g:lmap.g.s = ['Gstatus', 'Git status']
nnoremap <silent> <leader>gh :GitGutterStageHunk<CR>
let g:lmap.g.h = ['GitGutterStageHunk', 'Stage hunk']
nnoremap <silent> <leader>gu :GitGutterUndoHunk<CR>
let g:lmap.g.u = ['GitGutterUndoHunk', 'Undo hunk']
nnoremap <silent> <leader>gp :GitGutterPreviewHunk<CR>
let g:lmap.g.p = ['GitGutterPreviewHunk', 'Preview hunk']

"--------Denite-----------
let g:lmap.d = { 'name' : 'Denite' }
nnoremap <silent> <leader>df :Denite file_rec<CR>
let g:lmap.d.f = ['Denite file_rec', 'Search filenames recursively']
nnoremap <silent> <leader>dh :Denite  help<CR>
let g:lmap.d.h = ['Denite help', 'Search help docs']
nnoremap <silent> <leader>db :Denite buffer<CR>
let g:lmap.d.b = ['Denite buffer', 'Switch to open buffer']
nnoremap <silent> <leader>dl :Denite line<CR>
let g:lmap.d.l = ['Denite line', 'Search buffer and jump to line']
nnoremap <silent> <leader>dr :Denite file_mru<CR>
let g:lmap.d.r = ['Denite file_mru', 'Open recent']
nnoremap <silent> <leader>dg :Denite grep<CR>
let g:lmap.d.g = ['Denite grep', 'Grep files recursively']
nnoremap <silent> <leader>dt :Denite filetype<CR>
let g:lmap.d.t = ['Denite filetype', 'Switch filetype']
nnoremap <silent> <Leader>dv :Denite menu:git <CR>
let g:lmap.d.v = ['Denite git', 'Git menu']

" Set up leader guide
call leaderGuide#register_prefix_descriptions("<Space>", "g:lmap")
nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
