"    __    _           ___                   _         
"   / /_  (_)___  ____/ (_)___  ____ __   __(_)___ ___ 
"  / __ \/ / __ \/ __  / / __ \/ __ `/ | / / / __ `__ \
" / /_/ / / / / / /_/ / / / / / /_/ /| |/ / / / / / / /
"/_.___/_/_/ /_/\__,_/_/_/ /_/\__, (_)___/_/_/ /_/ /_/ 
"                            /____/                    
" Set up keybindings for neovim

" Set leader key
let mapleader = "\<Space>"
tnoremap <Esc> <C-\><C-n>

" -----Finding-------------------
" Clean search highlight
nnoremap <Leader>sc :noh<CR>

"------Jumping-------------------
" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)
" Go to character
map  <Leader>gf <Plug>(easymotion-bd-f)
nmap <Leader>gf <Plug>(easymotion-overwin-f)
" Move to line
map <Leader>gl <Plug>(easymotion-bd-jk)
nmap <Leader>gl <Plug>(easymotion-overwin-line)
" Move to word
map  <Leader>gw <Plug>(easymotion-bd-w)
nmap <Leader>gw <Plug>(easymotion-overwin-w)
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
  
" -----Code Navigation-----------
" Go to definition
let g:jedi#goto_command = "<leader>gd"
" Go to assignments
let g:jedi#goto_assignments_command = "<leader>ga"
" Go to usages
let g:jedi#goto_usages = "<leader>gu"

"------Buffers and Windows-------
" Close window
nnoremap <Leader>q :q<CR>
" Force close window
nnoremap <Leader>Q :q!<CR>
" Close buffer
nnoremap <Leader>d :Bdelete<CR>
" Save current buffer
nnoremap <Leader>W :w<CR>
" Intelligently close deoplete popup
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
" <CR>: close deoplete popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction
" create splits
nnoremap <leader>sv :vsp<CR>
nnoremap <leader>sh :sp<CR>
nnoremap <leader>si :IndentLinesToggle<CR>

"buftabline
nmap <C-L> <Nop>
nmap <C-H> <Nop>
nnoremap <C-L> :bnext<CR>
nnoremap <C-H> :bprev<CR>

"--------Project-----------------
" Source dotfile
nnoremap <Leader><c-r> :so ~/.config/nvim/init.vim<CR>
" show file browser
nnoremap <Leader>st :NERDTreeToggle<CR>

" cd to current file directory
nnoremap <Leader>cd :lcd %:p:h<CR>
" Open nerdtree at current working directory
nnoremap <Leader>ST :NERDTreeCWD<CR>
" show start buffer
nnoremap <Leader>ss :Startify<CR>
"-------Refactoring---------------
  " Rename element
let g:jedi#rename_command = "<leader>jr"
  
"-------Inspection----------------
" Show documentation
let g:jedi#documentation_command = "<leader>jd" 
" Show undotree
nnoremap <Leader>su :UndotreeToggle<CR>
  
"-------Editing-------------------
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

nmap ga <Plug>(EasyAlign)
xmap ga <Plug>(EasyAlign)
"-------Code Generation-----------

"-------Run/Debug-----------------
" run tests
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tv :TestVisit<CR>

"-------Version Control-----------

"--------Denite-----------
nnoremap <silent> <leader>f :Denite file_rec<CR>
nnoremap <silent> <leader>h :Denite  help<CR>
nnoremap <silent> <leader>b :Denite buffer<CR>
nnoremap <silent> <leader>l :Denite line<CR>
nnoremap <silent> <leader>r :Denite file_mru<CR>
nnoremap <silent> <leader>vg :Denite grep<CR>

