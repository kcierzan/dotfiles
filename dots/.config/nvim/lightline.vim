"     ___       __    __  ___                  _
"    / (_)___ _/ /_  / /_/ (_)___  ___  _   __(_)___ ___
"   / / / __ `/ __ \/ __/ / / __ \/ _ \| | / / / __ `__ \
"  / / / /_/ / / / / /_/ / / / / /  __/| |/ / / / / / / /
" /_/_/\__, /_/ /_/\__/_/_/_/ /_/\___(_)___/_/_/ /_/ /_/
"     /____/

let g:lightline = {
     \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'filename' ],
      \             [ 'neomake' ] ],
      \   'middle': [],
      \   'right': [ [ 'lineinfo', 'percent' ], [ 'filetype', 'fileencoding', 'fileformat'] ],
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightlineFugitive',
      \   'modified': 'LightlineModified',
      \   'readonly': 'LightlineReadonly',
      \   'fileformat': 'LightlineFileformat',
      \   'filename': 'LightlineFilename',
      \   'filetype': 'LightlineFiletype',
      \   'fileencoding': 'LightlineFileencoding',
      \   'mode': 'LightlineMode',
      \ },
      \ 'component_expand': {
      \   'neomake': 'LightlineNeomake',
      \ },
      \ 'component_type': {
      \   'neomake': 'error',
      \ },
      \ 'separator': { 'left': "\ue0bc", 'right': "\ue0be " },
      \ 'subseparator': { 'left': "\ue0bd", 'right': "\ue0bf" }
      \ }

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return "+"
  elseif &modifiable
    return ""
  else
    return ""
  endif
endfunction

function! LightlineFilename()
  return ('' != LightlineReadonly() ? LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'denite' ? denite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightlineModified() ? ' ' . LightlineModified() : '')
endfunction

function! LightlineFugitive()
  if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    let branch = fugitive#head()
    return branch !=# '' ? " \ue0a0 ".branch : ''
  endif
  return ''
endfunction

function! LightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return "\ue0a2"
  else
    return ""
  endif
endfunction

function! LightlineNeomake()
  return '%{neomake#statusline#LoclistStatus()}'
endfunction

augroup LightlineNeomake
  autocmd!
  autocmd BufWritePost *.py call lightline#update()
augroup END

