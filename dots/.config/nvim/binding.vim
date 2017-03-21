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
  " Search files in current dir
  nnoremap <Leader><tab> :FZF<CR>

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
 
" -----Code Navigation-----------
  " Go to definition
  let g:jedi#goto_command = "<leader>ngd"
  " Go to assignments
  let g:jedi#goto_assignments_command = "<leader>nga"
  " Go to usages
  let g:jedi#goto_usages = "<leader>ngu"

"------Buffers and Windows-------
  " Close window
  nnoremap <Leader>q :q<CR>
  " Force close window
  nnoremap <Leader>Q :q!<CR>
  " Close buffer
  nnoremap <Leader>d :bd<CR>
  " Save current buffer
  nnoremap <Leader>W :w<CR>
  " Intelligently close deoplete popup
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
  " <CR>: close deoplete popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
  endfunction

"--------Project-----------------
  " Source dotfile
  nnoremap <Leader>psd :so ~/.config/nvim/init.vim<CR>
  " Edit Dotfile
  nnoremap <Leader>ped :tabedit ~/.config/nvim/init.vim<CR>
  " start changing directories
  nnoremap <Leader>pcd :cd<space>
  " show file browser
  nnoremap <Leader>pst :NERDTreeToggle<CR>

"-------Refactoring---------------
  " Rename element
  let g:jedi#rename_command = "<leader>rre"
  
"-------Inspection----------------
  " Show documentation
  let g:jedi#documentation_command = "<leader>isd" 
  " Show undotree
  nnoremap <Leader>isu :UndotreeToggle<CR>
  
"-------Editing-------------------

"-------Code Generation-----------

"-------Run/Debug-----------------
  " run tests
  nmap <silent> <leader>trn :TestNearest<CR>
  nmap <silent> <leader>trf :TestFile<CR>
  nmap <silent> <leader>trs :TestSuite<CR>
  nmap <silent> <leader>trl :TestLast<CR>
  nmap <silent> <leader>trv :TestVisit<CR>

"-------Version Control-----------

