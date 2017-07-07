"     ___       __    __  ___                  _
"    / (_)___ _/ /_  / /_/ (_)___  ___  _   __(_)___ ___
"   / / / __ `/ __ \/ __/ / / __ \/ _ \| | / / / __ `__ \
"  / / / /_/ / / / / /_/ / / / / /  __/| |/ / / / / / / /
" /_/_/\__, /_/ /_/\__/_/_/_/ /_/\___(_)___/_/_/ /_/ /_/
"     /____/

scriptencoding utf-8

let g:lightline = {
      \ 'colorscheme': 'termina',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'gitgutter' ],
      \             [ 'ale' ], [ 'filename' ]  ],
      \   'middle': [],
      \   'right': [ [ 'percent', 'lineinfo' ], [ 'filetype' ] ],
      \ },
      \ 'tabline': {
        \   'left': [ [ 'buffers' ] ],
        \   'right': [],
      \ },
      \ 'mode_map': {
      \    'c': 'NORMAL'
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
      \   'gitgutter': 'LightLineGitGutter',
      \ },
      \ 'component_expand': {
        \ 'buffers': 'lightline#bufferline#buffers',
        \ 'ale': 'LightLineAleStatus',
      \ },
      \ 'component_type': {
      \   'ale': 'error',
      \   'buffers': 'tabsel'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }

function! LightlineModified()
  if &filetype == "help"
    return ""
  elseif &modified
    return ""
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

function! LightLineGitGutter()
    if ! exists('*GitGutterGetHunkSummary')
          \ || ! get(g:, 'gitgutter_enabled', 0)
          \ || winwidth('.') <= 90
      return ''
    endif
    let symbols = [
          \ g:gitgutter_sign_added,
          \ g:gitgutter_sign_modified,
          \ g:gitgutter_sign_removed
          \ ]
    let hunks = GitGutterGetHunkSummary()
    let ret = []
    for i in [0, 1, 2]
      if hunks[i] > 0
        call add(ret, symbols[i] . hunks[i])
      endif
    endfor
    return join(ret, ' ')
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
    return ""
  else
    return ""
  endif
endfunction

function! LightLineAleStatus()
  return '%{ale#statusline#Status()}'
endfunction

augroup UpdateAleLightLine
  autocmd!
  autocmd User ALELint call lightline#update()
augroup END
