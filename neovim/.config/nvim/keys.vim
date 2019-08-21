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

" Set leader key
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>

nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>

" ------------ interface ----------------
nnoremap <silent> <leader>i% :set invrelativenumber<CR>
nnoremap <silent> <leader>i# :set invnumber<CR>
nnoremap <silent> <leader>il :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
nnoremap <silent> <leader>ii :IndentLinesToggle<CR>
nnoremap <silent> <leader>iu :UndotreeToggle<CR>
nnoremap <silent> <leader>ic :nohlsearch<CR>
nnoremap <silent> <leader>iz :Goyo<CR>
nnoremap <silent> <leader>ih :ColorHighlight<CR>
nnoremap <silent> <leader>iL :Limelight!<CR>
nnoremap <silent> <leader>it :NERDTreeToggle<CR>

" ------------ buffers ------------------
nnoremap <silent> <leader>bs :w<CR>
nnoremap <silent> <leader>bn :new<CR>
nnoremap <silent> <Leader>bd :bd<CR>
nnoremap <silent> <Leader>bD :bd!<CR>
nnoremap <silent> <leader>bc :windo diffthis<CR>
nnoremap <silent> <leader>bC :windo diffoff<CR>
nnoremap <silent> <leader>br :edit!<CR>
nnoremap <silent> <leader>bw :Nows<CR>

" ------------- windows ------------------
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

" ------------- nvim --------------------------
nnoremap <silent> <Leader>vr :so ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>ve :edit ~/.config/nvim/init.vim<CR>
nnoremap <silent> <Leader>vs :Startify<CR>
nnoremap <silent> <Leader>vu :PlugUpdate<CR>
nnoremap <silent> <Leader>vi :PlugInstall<CR>
nnoremap <silent> <Leader>vc :PlugClean<CR>

" ------------ code ---------------------------
nnoremap <silent> <leader>cT :!ctags<CR>
nnoremap <silent> <leader>cr :!rm tags && ctags<CR>
nnoremap <silent> <leader>ca <Plug>(coc-codeaction)
vnoremap <silent> <leader>ca <Plug>(coc-codeaction-selected)
nnoremap <silent> <leader>cf <Plug>(coc-fix-current)
nnoremap <silent> <leader>cF <Plug>(coc-format-selected)
vnoremap <silent> <leader>cF <Plug>(coc-format-selected)
nnoremap <silent> <leader>cc :CocRestart<CR>
nnoremap <silent> <leader>cR <Plug>(coc-rename)

" ------------ testing -----------------------
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>

" ------------- git ------------------------
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

" ------------ FZF -------------------------
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

" ----------- VimWiki ---------------------
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

