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
  colorscheme onedark
  nnoremap <silent> <leader> :<c-u>LeaderGuide '<Space>'<CR>
  vnoremap <silent> <leader> :<c-u>LeaderGuideVisual '<Space>'<CR>
  ALEEnable
endfunction

augroup GoyoToggle
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

set background=dark
colorscheme onedark

hi Normal ctermfg=none ctermbg=none guibg=none guifg=none
hi  ColorColumn ctermfg=none ctermbg=0
hi ALEErrorSign                   ctermfg=1 guifg='#e06c75'
hi ALEWarningSign                 ctermfg=3 guifg='#e5c07b'
hi ALEError                       ctermbg=0
hi ALEWarning                     ctermbg=0
hi VertSplit guifg = '#272c33'
hi Comment cterm=italic
hi CocHighlightText guibg = '#404754'
