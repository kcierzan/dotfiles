"    __    _           ___                   _         
"   / /_  (_)___  ____/ (_)___  ____ __   __(_)___ ___ 
"  / __ \/ / __ \/ __  / / __ \/ __ `/ | / / / __ `__ \
" / /_/ / / / / / /_/ / / / / / /_/ /| |/ / / / / / / /
"/_____/_/_/ /_/\__,_/_/_/ /_/\__, (_)___/_/_/ /_/ /_/ 
"                            /____/                    

" Keep search results in the center of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Clear search highlight
nnoremap <C-_> :nohlsearch<CR>
" Select all text
noremap vA ggVG
" Align stuff
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
" Move stuff left and right
nmap gsh :SidewaysLeft<CR>
nmap gsl :SidewaysRight<CR>
" Jump to characters
nmap s <Plug>(easymotion-overwin-f2)
" Jump to tag in new window
nnoremap gD g<C-]>
" Jump to tag
nnoremap gd g<C-]>
" jump to next error message
nnoremap ge :ALENextWrap<CR>
" jumpt to next line
nmap gl <Plug>(easymotion-bd-jk)
nmap gl <Plug>(easymotion-overwin-line)

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
" Intelligently close deoplete popup
" inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
" <CR>: close deoplete popup and save indent.
inoremap <expr><CR> <SID>my_cr_function()
function! s:my_cr_function() abort
  return pumvisible() ? deoplete#close_popup() : "\<CR>"
endfunction

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
nnoremap <leader>ww <C-w>w
let g:lmap.w.w = ['<C-w>w', 'Switch split']
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

"-------- Neovim -----------------
let g:lmap.n = { 'name' : 'Neovim' }
nnoremap <Leader>nr :so ~/.config/nvim/init.vim<CR>
let g:lmap.n.r = ['so ~/.config/nvim/init.vim', 'Source dotfiles']
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

"--------Denite-----------
let g:lmap.f = { 'name' : 'Find' }
nnoremap <silent> <leader>ff :Denite `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
let g:lmap.f.f = ['Denite file_rec', 'Find files']
nnoremap <silent> <leader>fh :Denite help<CR>
let g:lmap.f.h = ['Denite help', 'Find help']
nnoremap <silent> <leader>fb :Denite buffer<CR>
let g:lmap.f.b = ['Denite buffer', 'Find buffers']
nnoremap <silent> <leader>fl :Denite line<CR>
let g:lmap.f.l = ['Denite line', 'Find lines']
nnoremap <silent> <leader>fr :Denite file_mru<CR>
let g:lmap.f.r = ['Denite file_mru', 'Find recent']
nnoremap <silent> <leader>fg :Denite grep<CR>
let g:lmap.f.g = ['Denite grep', 'Grep']
nnoremap <silent> <leader>ft :Denite filetype<CR>
let g:lmap.f.t = ['Denite filetype', 'Find filetypes']
nnoremap <silent> <Leader>fd :Denite directory_mru<CR>
let g:lmap.f.d = ['Denite file', 'Find recent dirs']
nnoremap <silent> <Leader>fc :Denite colorscheme<CR>
let g:lmap.f.c = ['Denite coloscheme', 'Find colorschemes']
nnoremap <silent> <Leader>fo :Denite outline<CR>
let g:lmap.f.o = ['Denite outline', 'Find ctags']
nnoremap <silent> <Leader>fe :Denite command<CR>
let g:lmap.f.e = ['Denite command', 'Find commands']

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

" ------ Solarized --------
" call togglebg#map("<leader>\")
