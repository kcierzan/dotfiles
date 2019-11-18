let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>

Shortcut show shortcut menu and run chosen shortcut
      \ noremap <silent> <Leader><Leader> :Shortcuts<Return>

Shortcut fallback to shortcut menu on partial entry
      \ noremap <silent> <Leader> :Shortcuts<Return>

nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" Select all text
noremap vA ggVG

" Align stuff
Shortcut align text
      \ nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)

" Move stuff left and right
Shortcut move text object left
      \ nmap gsh :SidewaysLeft<CR>
Shortcut move text object right
      \ nmap gsl :SidewaysRight<CR>

Shortcut jump to tag in new window
      \ nnoremap gT g<C-]>
" Jump to tag
Shortcut jump to tag
      \ nnoremap gt g<C-]>

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

nmap ]z :call GoToOpenFold("next")
nmap [z :call GoToOpenFold("prev")

" Jump to next error message
Shortcut jump to next error message
      \ nnoremap ge :ALENextWrap<CR>

" Show syntax highlight at point
Shortcut show syntax highlighting at point
      \ map gi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
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

Shortcut next buffer
      \ nnoremap <C-L> :bnext<CR>
Shortcut previous buffer
      \ nnoremap <C-H> :bprev<CR>

Shortcut quit
      \ nnoremap <silent> <Space>q :q<Return>
Shortcut quit without saving
      \ nnoremap <silent> <Space>Q :q!<Return>

" ------------ interface ----------------
Shortcut toggle relative line numbers
      \ nnoremap <silent> <Space>i% :set invrelativenumber<CR>
Shortcut toggle line numbers
      \ nnoremap <silent> <Space>i# :set invnumber<CR>
Shortcut toggle cursor line highlight
      \ nnoremap <silent> <Space>il :set invcursorline<CR>:hi CursorLineNr cterm=none<CR>
Shortcut toggle indent lines
      \ nnoremap <silent> <Space>ii :IndentLinesToggle<CR>
Shortcut toggle undo tree
      \ nnoremap <silent> <Space>iu :UndotreeToggle<CR>
Shortcut clear search highlighting
      \ nnoremap <silent> <Space>ic :nohlsearch<CR>
Shortcut toggle distraction-free mode
      \ nnoremap <silent> <Space>iz :Goyo<CR>
Shortcut toggle color highlighting
      \ nnoremap <silent> <Space>ih :ColorHighlight<CR>
Shortcut toggle file browser
      \ nnoremap <silent> <Space>it :NERDTreeToggle<CR>

" ------------ buffers ------------------
Shortcut save buffer
      \ nnoremap <silent> <Space>bs :w<CR>
Shortcut new buffer
      \ nnoremap <silent> <Space>bn :new<CR>
Shortcut close buffer
      \ nnoremap <silent> <Space>bd :bd<CR>
Shortcut close buffer without saving
      \ nnoremap <silent> <Space>bD :bd!<CR>
Shortcut diff this
      \ nnoremap <silent> <Space>bc :windo diffthis<CR>
Shortcut diff off
      \ nnoremap <silent> <Space>bC :windo diffoff<CR>
Shortcut reload buffer
      \ nnoremap <silent> <Space>br :edit!<CR>
Shortcut trim whitespace
      \ nnoremap <silent> <Space>bw :Trimws<CR>

" ------------- windows ------------------
Shortcut split window vertically
      \ nnoremap <silent> <Space>wv :vsp<CR>
Shortcut split window horizontally
      \ nnoremap <silent> <Space>ws :sp<CR>
Shortcut increase window height
      \ nnoremap <silent> <Space>wk 10<C-w>+
Shortcut decrease window height
      \ nnoremap <silent> <Space>wj 10<C-w>-
Shortcut increase window width
      \ nnoremap <silent> <Space>wl 10<C-w>>
Shortcut decrease window width
      \ nnoremap <silent> <Space>wh 10<C-w><
Shortcut rotate windows
      \ nnoremap <silent> <Space>wr <C-w>r
Shortcut kill other windows
      \ nnoremap <silent> <Space>wo <C-w>o
Shortcut equalize windows
      \ nnoremap <silent> <Space>we <C-w>=
Shortcut move window left
      \ nnoremap <silent> <Space>wV <C-w>H
Shortcut move window right
      \ nnoremap <silent> <Space>wS <C-w>J

" ------------- nvim --------------------------
Shortcut reload config file
      \ nnoremap <silent> <Space>vr :so ~/.config/nvim/init.vim<CR>
Shortcut edit config file
      \ nnoremap <silent> <Space>ve :edit ~/.config/nvim/init.vim<CR>
Shortcut open start page
      \ nnoremap <silent> <Space>vs :Startify<CR>
Shortcut update plugins
      \ nnoremap <silent> <Space>vu :PlugUpdate<CR>
Shortcut install plugins
      \ nnoremap <silent> <Space>vi :PlugInstall<CR>
Shortcut clean up plugins
      \ nnoremap <silent> <Space>vc :PlugClean<CR>

" ------------ code ---------------------------
Shortcut create ctags
      \ nnoremap <silent> <Space>cT :!ctags<CR>
Shortcut refresh ctags
      \ nnoremap <silent> <Space>cr :!rm tags && ctags<CR>
Shortcut code action at point
      \ nnoremap <silent> <Space>ca <Plug>(coc-codeaction)
Shortcut code action at selection
      \ vnoremap <silent> <Space>ca <Plug>(coc-codeaction-selected)
Shortcut fix current
      \ nnoremap <silent> <Space>cf <Plug>(coc-fix-current)
Shortcut format selected
      \ nnoremap <silent> <Space>cF <Plug>(coc-format-selected)
Shortcut format selected
      \ vnoremap <silent> <Space>cF <Plug>(coc-format-selected)
Shortcut restart coc
      \ nnoremap <silent> <Space>cc :CocRestart<CR>
Shortcut rename thing at point
      \ nnoremap <silent> <Space>cR <Plug>(coc-rename)

" ------------ testing -----------------------
Shortcut run nearest test
      \ nnoremap <silent> <Space>tn :TestNearest<CR>
Shortcut test file
      \ nnoremap <silent> <Space>tf :TestFile<CR>
Shortcut run test suite
      \ nnoremap <silent> <Space>ts :TestSuite<CR>
Shortcut run last test
      \ nnoremap <silent> <Space>tl :TestLast<CR>
Shortcut show last test
      \ nnoremap <silent> <Space>tv :TestVisit<CR>

" ------------- git ------------------------
Shortcut git status
      \ nnoremap <silent> <Space>gs :Gstatus<CR>
Shortcut git blame
      \ nnoremap <silent> <Space>gb :Gblame<CR>
Shortcut next git hunk
      \ nnoremap <silent> <Space>gn :GitGutterNextHunk<CR>
Shortcut previous git hunk
      \ nnoremap <silent> <Space>gN :GitGutterPrevHunk<CR>
Shortcut stage hunk
      \ nnoremap <silent> <Space>gh :GitGutterStageHunk<CR>
Shortcut next git hunk (all buffers)
      \ nnoremap <silent> <Space>g] :call <SID>NextHunkAllBuffers()<CR>
Shortcut previous git hunk (all buffers)
      \ nnoremap <silent> <Space>g[ :call <SID>PrevHunkAllBuffers()<CR>
Shortcut revert git hunk
      \ nnoremap <silent> <Space>gu :GitGutterUndoHunk<CR>
Shortcut preview hunk
      \ nnoremap <silent> <Space>gp :GitGutterPreviewHunk<CR>
Shortcut git diff
      \ nnoremap <silent> <Space>gd :Gvdiff<CR>
Shortcut git log
      \ nnoremap <silent> <Space>gl :GV<CR>
Shortcut open remote file in browser
      \ nnoremap <silent> <Space>go :Gbrowse<CR>
Shortcut open remote file in browser
      \ vnoremap <silent> <Space>go :Gbrowse<CR>
Shortcut git commit
      \ nnoremap <silent> <Space>gc :Gcommit<CR>

" ------------ FZF -------------------------
Shortcut find files under source control
      \ nnoremap <silent> <Space>ff :GFiles<CR>
Shortcut find all files
      \ nnoremap <silent> <Space>fa :Files<CR>
Shortcut search help files
      \ nnoremap <silent> <Space>fi :Helptags<CR>
Shortcut find open buffer
      \ nnoremap <silent> <Space>fb :Buffers<CR>
Shortcut find in current buffer
      \ nnoremap <silent> <Space>fl :BLines<CR>
Shortcut find in all buffers
      \ nnoremap <silent> <Space>fL :Lines<CR>
Shortcut find recent file
      \ nnoremap <silent> <Space>fh :HHistory<CR>
Shortcut search in files
      \ nnoremap <silent> <Space>fg :Rg<CR>
Shortcut set filetype
      \ nnoremap <silent> <Space>ft :Filetypes<CR>
Shortcut set colorscheme
      \ nnoremap <silent> <Space>fc :Colors<CR>
Shortcut search project tags
      \ nnoremap <silent> <Space>fO :Tags<CR>
Shortcut search buffer tags
      \ nnoremap <silent> <Space>fo :BTags<CR>
Shortcut execute command
      \ nnoremap <silent> <Space>fe :Commands<CR>
Shortcut git grep
      \ nnoremap <silent> <Space>fp :GGrep<CR>
Shortcut change project
      \ nnoremap <silent> <Space>fj :Cd<CR>

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
