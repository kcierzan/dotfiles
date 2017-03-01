"    __    _           ___                   _         
"   / /_  (_)___  ____/ (_)___  ____ __   __(_)___ ___ 
"  / __ \/ / __ \/ __  / / __ \/ __ `/ | / / / __ `__ \
" / /_/ / / / / / /_/ / / / / / /_/ /| |/ / / / / / / /
"/_.___/_/_/ /_/\__,_/_/_/ /_/\__, (_)___/_/_/ /_/ /_/ 
"                            /____/                    
" Set up keybindings for neovim

" Set leader key
let mapleader = "\<Space>"

" Space + w saves a buffer
nnoremap <Leader>W :w<CR>

" Close window
nnoremap <Leader>q :q<CR>

" Force close window
nnoremap <Leader>Q :q!<CR>

" Close buffer
nnoremap <Leader>d :bd<CR>

" Clean search highlight
nnoremap <Leader>sc :noh<CR>

" Source dotfile
nnoremap <Leader>fer :so ~/.config/nvim/init.vim<CR>

" Edit Dotfile
nnoremap <Leader>fed :tabedit ~/.config/nvim/init.vim<CR>

" start changing directories
nnoremap <Leader>cd :cd<space>

" Easymotion bindings
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)

" s{char}{char} to move to {char}{char}
nmap s <Plug>(easymotion-overwin-f2)

" Move to line
map <Leader>L <Plug>(easymotion-bd-jk)
nmap <Leader>L <Plug>(easymotion-overwin-line)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)
nmap <Leader>w <Plug>(easymotion-overwin-w)

" Search files in current dir
nnoremap <Leader><tab> :FZF<CR>

" Intelligently close deoplete popup
inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
  return deoplete#close_popup() . "\<CR>"
endfunction

