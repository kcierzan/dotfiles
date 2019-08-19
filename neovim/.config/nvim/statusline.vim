" ====================================================================
" Make sure to:
" 1. source this file somewhere at the bottom of your config.
" 2. disable any statusline plugins, as they will override this.
" ====================================================================

" Do not show mode under the statusline since the statusline itself changes
" color depending on mode
set noshowmode

let NERDTreeStatusline="%8*%=%7*NERD%8*%="

set laststatus=2
let g:lightline = {}
let g:lightline.enable = {
  \  'statusline': 0
  \ }
" ~~~~ Statusline configuration ~~~~
" ':help statusline' is your friend!
function! RedrawModeColors(mode)
  " Normal mode
  if a:mode == 'n'
    hi MyStatuslineAccent guifg=#505868
    hi MyStatuslineAccentBody  guibg=#505868 guifg=#51afef
    hi MyStatuslineAccentLabel guifg=#98be65 guibg=#505868
    hi MyStatuslineFilename  guibg=#393f4a
    hi MyStatuslineSeparator guifg=#393f4a
    hi MyStatuslineModified guifg=#393f4a
    hi MyStatuslineFiletype guifg=#393f4a
    hi MyStatuslineFiletypeBody guibg=#393f4a guifg=#c678dd

    hi MyStatuslineLineCol guifg=#393f4a
    hi MyStatuslineLineColBody guibg=#393f4a
    hi MyStatuslineLangServer guibg=#393f4a
    hi MyStatuslineLineCwd guifg=#46d9ff guibg=#393f4a

  " Insert mode
  elseif a:mode == 'i'
    hi MyStatuslineAccentBody guifg=#98be65
  " Replace mode
  elseif a:mode == 'R'
    hi MyStatuslineAccentBody guifg=#ff6c6b
  " Visual mode
  elseif a:mode == 'v' || a:mode == 'V' || a:mode == '^V'
    hi MyStatuslineAccentBody guifg=#c678dd
  " Command mode
  elseif a:mode == 'c'
    hi MyStatuslineAccentBody guifg=#46d9ff
  " Terminal mode
  elseif a:mode == 't'
    hi MyStatuslineAccentBody ctermbg=8
  endif
  " Return empty string so as not to display anything in the statusline
  return ''
endfunction

function! SetModifiedSymbol(modified)
    if a:modified == 1
    hi MyStatuslineModifiedBody guibg=#393f4a guifg=#ff6c6b
    else
    hi MyStatuslineModifiedBody guibg=#393f4a guifg=#46d9ff
    endif
    return "\u25CF"
endfunction


function! SetFiletype(filetype) 
  if a:filetype == ''
      return '-'
  else
    return  WebDevIconsGetFileTypeSymbol() . ' ' . a:filetype
  endif
endfunction

function! ALECounts()
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.total - l:errors
  let l:status = ''

  if l:errors > 0
    let l:status = l:status . '  ' . l:errors
  endif
  if l:warnings > 0
    let l:status = l:status . '  ' . l:warnings
  endif

  if l:errors == 0 && l:warnings == 0
    let l:status = '  '
  endif

  return l:status

endfunction

function! Delta()
  return "%#MyStatuslineAccentBody#%#MyStatuslineAccentBody# "
endfunction

" Statusbar items
" ====================================================================

" This will not be displayed, but the function RedrawModeColors will be
" called every time the mode changes, thus updating the colors used for the
" components.
set statusline=%{RedrawModeColors(mode())}
" " Left side items
" " =======================
set statusline+=%#MyStatuslineAccent#
set statusline+=%#MyStatuslineAccentBody#
set statusline+=\ 
" " Filename
set statusline+=%#MyStatuslineFilename#\ %t
set statusline+=%#MyStatuslineSeparator#\ 

" " Modified status
set statusline+=%#MyStatuslineModified#
set statusline+=%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}
set statusline+=%#MyStatuslineModified#
" " Right side items
" " =======================
set statusline+=%=
set statusline+=%#MyStatuslineAccent#
set statusline+=%#MyStatuslineAccentLabel#LS\ 
set statusline+=%#MyStatuslineLangServer#%{ALECounts()}
set statusline+=%#MyStatuslineLineCol#\ 

" Current directory
function! LightlineCwd()
  return fnamemodify(getcwd(), ':t')
endfunction

set statusline+=%#MyStatuslineLineCol#
set statusline+=%#MyStatuslineLineColBody#%{LightlineCwd()}
set statusline+=%#MyStatuslineLineCol#
" " Padding
set statusline+=\ 
" " Filetype
set statusline+=%#MyStatuslineFiletype#
set statusline+=%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}
set statusline+=%#MyStatuslineFiletype#\ 
