"    __    _           ___                   _         
"   / /_  (_)___  ____/ (_)___  ____ __   __(_)___ ___ 
"  / __ \/ / __ \/ __  / / __ \/ __ `/ | / / / __ `__ \
" / /_/ / / / / / /_/ / / / / / /_/ /| |/ / / / / / / /
"/_____/_/_/ /_/\__,_/_/_/ /_/\__, (_)___/_/_/ /_/ /_/ 
"                            /____/                    

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

" -----Finding-------------------
let g:lmap.s = { 'name' : 'Search' }

nnoremap <silent> <leader>sc :nohlsearch<CR><Esc>
let g:lmap.s.c = ['nohlsearch', 'Clear search highlight']
nnoremap <silent> <leader>sf /
let g:lmap.s.f = ['/', 'Search forward']
nnoremap <silent> <leader>sb ?
let g:lmap.s.b = ['?', 'Search backward']
nnoremap <silent> <leader>sw *
let g:lmap.s.w = ['*', 'Search under cursor']
   
" Keep search results in the center of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

"------Jumping-------------------
let g:lmap.j = { 'name' : 'Jump' }
" jump to 2 characters
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
nmap  <Leader>jw <C-w>g<C-]>
let g:lmap.j.w = ['stjump', 'Jump to tag in new window']
nnoremap <leader>jt g<C-]>
let g:lmap.j.t = ['tjump', 'Jump to tag']
nnoremap <leader>jb <C-t>
let g:lmap.j.b = ['jump backj', 'Jump back from tag']

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

"------ Windows -------
let g:lmap.w = { 'name' : 'Windows' }
" Intelligently close deoplete popup
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
" <CR>: close deoplete popup and save indent.
inoremap <expr><silent> <CR> <SID>my_cr_function()
function! s:my_cr_function() abort
  return pumvisible() ? deoplete#close_popup() : "\<CR>"
endfunction

nnoremap <leader>wv :vsp<CR>
let g:lmap.w.v = [':vsp', 'Open split vertical']
nnoremap <leader>ws :sp<CR>
let g:lmap.w.s = [':sp', 'Open split horizontal']
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

"buftabline navigation
nmap <C-L> <Nop>
nmap <C-H> <Nop>
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

"---------Buffers ---------------
let g:lmap.b = { 'name' : 'Buffers' }
nnoremap <leader>bi :IndentLinesToggle<CR>
let g:lmap.b.i = [':IndentLinesToggle', 'Toggle indent lines']
nnoremap <Leader>bd :Bdelete<CR>
let g:lmap.b.d = [':Bdelete', 'Close buffer']
nnoremap <Leader>bD :Bdelete!<CR>
let g:lmap.b.D = [':Bdelete', 'Force close buffer']
nnoremap <leader>bn :new<CR>
let g:lmap.b.n = ['new', 'New buffer']
nnoremap <leader>b% :set invrelativenumber<CR>
let g:lmap.b['%'] = ['set invrelativenumber', 'Toggle relative line numbers']
nnoremap <leader>b# :set invnumber<CR>
let g:lmap.b['#'] = ['set invnumber', 'Toggle line numbers']
nnoremap <leader>bl :Limelight<CR>
let g:lmap.b.l = ['Limelight', 'Limelight On']
nnoremap <leader>bL :Limelight!<CR>
let g:lmap.b.L = ['Limelight!', 'Limelight Off']
nnoremap <leader>bg :Goyo<CR>
let g:lmap.b.g = ['Goyo', 'Distraction-free mode']
nnoremap <leader>bu :UndotreeToggle<CR>
let g:lmap.b.u = ['UndoTree', 'Toggle UndoTree']
nnoremap <leader>bs :w<CR>
let g:lmap.b.s = ['w', 'Save buffer']
nnoremap <leader>be :ALENextWrap<CR>
let g:lmap.b.e = ['ALENextWrap', 'Next linter message']
nnoremap <leader>br :edit!<CR>
let g:lmap.b.r = ['edit!', 'Revert changes']
nnoremap <leader>bh :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
let g:lmap.b.h = ['invcursorline', 'Toggle cursorline']
nnoremap <leader>bE :ALEToggle<CR>
let g:lmap.b.E = ['ALEToggle', 'Toggle linter']

"-------- Neovim -----------------
let g:lmap.n = { 'name' : 'Neovim' }
nnoremap <Leader>nr :so ~/.config/nvim/init.vim<CR>
let g:lmap.n.r = ['so ~/.config/nvim/init.vim', 'Source dotfile']
nnoremap <Leader>ns :Startify<CR>
let g:lmap.n.s = ['Startify', 'Open start menu']
nnoremap <Leader>nu :PlugUpdate<CR>
let g:lmap.n.u = ['Plug Update', 'Update plugins]']
nnoremap <Leader>ni :PlugInstall<CR>
let g:lmap.n.i = ['Plug Install', 'Install plugins']
nnoremap <Leader>nc :PlugClean<CR>
let g:lmap.n.c = ['Plug Clean', 'Remove unmanaged plugins']

"-------Editing-------------------
let g:lmap.e = { 'name' : 'Edit' }
xmap <leader>ea <Plug>(EasyAlign)
nnoremap <leader>ea <Plug>(EasyAlign)
let g:lmap.e.a = ['EasyAlign', 'Align']
nnoremap <leader>eh :SidewaysLeft<CR>
let g:lmap.e.h = ['SidewaysLeft', 'Move left']
nnoremap <leader>el :SidewaysRight<CR>
let g:lmap.e.l = ['SidewaysRight', 'Move right']

" Select all text
noremap vA ggVG
nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

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
let g:lmap.f = { 'name' : 'Denite' }
nnoremap <silent> <leader>ff :Denite `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
let g:lmap.f.f = ['Denite file_rec', 'Search filenames recursively']
nnoremap <silent> <leader>fh :Denite help<CR>
let g:lmap.f.h = ['Denite help', 'Search help docs']
nnoremap <silent> <leader>fb :Denite buffer<CR>
let g:lmap.f.b = ['Denite buffer', 'Switch to open buffer']
nnoremap <silent> <leader>fl :Denite line<CR>
let g:lmap.f.l = ['Denite line', 'Search buffer and jump to line']
nnoremap <silent> <leader>fr :Denite file_mru<CR>
let g:lmap.f.r = ['Denite file_mru', 'Open recent']
nnoremap <silent> <leader>fg :Denite grep<CR>
let g:lmap.f.g = ['Denite grep', 'Grep files recursively']
nnoremap <silent> <leader>ft :Denite filetype<CR>
let g:lmap.f.t = ['Denite filetype', 'Switch filetype']
nnoremap <silent> <Leader>fi :Denite menu:git <CR>
let g:lmap.f.i = ['Denite git', 'Git menu']
nnoremap <silent> <Leader>fd :Denite directory_mru<CR>
let g:lmap.f.d = ['Denite file', 'CD to frecent directory']
nnoremap <silent> <Leader>fc :Denite colorscheme<CR>
let g:lmap.f.c = ['Denite coloscheme', 'Search colorschemes']
nnoremap <silent> <Leader>fo :Denite outline<CR>
let g:lmap.f.o = ['Denite outline', 'Search ctags']
nnoremap <silent> <Leader>fe :Denite command<CR>
let g:lmap.f.e = ['Denite command', 'Search neovim commands']

" ------ Dir ------------
let g:lmap.d = { 'name' : 'Dir' }
nnoremap <Leader>df :call NERDTreeToggleAndFind()<CR>
let g:lmap.d.f = ['call NERDTreeToggleAndFind()', 'Show file in tree']
nnoremap <Leader>dc :NERDTreeCWD<CR>
let g:lmap.d.c = ['NERDTreeCWD', 'Open tree at current location']
nnoremap <Leader>dt :NERDTreeToggle<CR>
let g:lmap.d.t = ['NERDTreeToggle', 'Toggle NerdTree']
"cd to current file directory and move up one level
nnoremap <Leader>dd :lcd %:p:h<CR>:cd ..<CR>
let g:lmap.d.d = ['lcd %:p:h', 'CD to current directory']
nnoremap <Leader>du :cd ..<CR> 
let g:lmap.d.u = ['cd ..', 'CD to parent directory']
nnoremap <Leader>dg :cd ~/git<CR> 
let g:lmap.d.g = ['cd ~/git', 'CD to git directory']
nnoremap <leader>dp :pwd<CR>
let g:lmap.d.p = ['pwd', 'Print working directory']
nnoremap <leader>da :set invautochdir<CR>
let g:lmap.d.a = ['set invautochdir', 'Toggle autochange dir']

function! NERDTreeToggleAndFind()
  if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
    execute ':NERDTreeClose'
  else
    execute ':NERDTreeFind'
  endif
endfunction

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
