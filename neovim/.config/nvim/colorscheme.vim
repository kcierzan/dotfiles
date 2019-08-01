function! s:goyo_enter()
  silent !tmux set status off
  silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  set noshowcmd
  set noshowmode
  set nocursorline
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
hi Search guifg = '#46d9ff' guibg = '#505868' gui=underline

