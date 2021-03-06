" =============================================================================
" Filename: autoload/lightline/colorscheme/termina.vim
" Author: Kyle Cierzan
" License: MIT License
" Last Change: 2019/05/12 20:30:51.
" =============================================================================

" Common colors
let s:fg     = [ '#b9bfc9', 145 ]
let s:blue   = [ '#61afef', 75 ]
let s:green  = [ '#98c379', 76 ]
let s:purple = [ '#c678dd', 176 ]
let s:red1   = [ '#e06c75', 168 ]
let s:red2   = [ '#be5046', 168 ]
let s:yellow = [ '#e5c07b', 180 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

if lightline#colorscheme#background() ==# 'light'
  " Light variant
  let s:bg     = [ '#fafafa', 255 ]
  let s:gray1  = [ '#494b53', 238 ]
  let s:gray2  = [ '#f0f0f0', 255 ]
  let s:gray3  = [ '#d0d0d0', 250 ]
  let s:green  = [ '#98c379', 35 ]

  let s:p.normal.left     = [ [ s:gray1, s:gray3 ], [ s:green, s:bg, 'bold' ] ]
  let s:p.normal.middle   = [ [ s:gray1, s:gray2 ] ]
  let s:p.inactive.left   = [ [ s:bg,  s:gray3 ], [ s:bg, s:gray3 ] ]
  let s:p.inactive.middle = [ [ s:gray3, s:gray2 ] ]
  let s:p.inactive.right  = [ [ s:bg, s:gray3 ] ]
  let s:p.insert.left     = [ [ s:bg, s:blue, 'bold' ], [ s:gray1, s:gray3 ] ]
  let s:p.replace.left    = [ [ s:bg, s:red1, 'bold' ], [ s:gray1, s:gray3 ] ]
  let s:p.visual.left     = [ [ s:bg, s:purple, 'bold' ], [ s:gray1, s:gray3 ] ]
else
  " Dark variant
  let s:bg     = [ '#2c323d', 235 ]
  let s:gray1  = [ '#505868', 241 ]
  let s:gray2  = [ '#2c323d', 235 ]
  let s:gray3  = [ '#505868', 240 ]

  let s:p.normal.left     = [ [ s:green, s:bg, 'bold' ], [ s:fg, s:bg ] ]
  let s:p.normal.middle   = [ [ s:fg, s:gray2 ] ]
  let s:p.inactive.left   = [ [ s:gray1,  s:bg ], [ s:gray1, s:bg ] ]
  let s:p.inactive.middle = [ [ s:gray1, s:gray2 ] ]
  let s:p.inactive.right  = [ [ s:gray1, s:bg ] ]
  let s:p.insert.left     = [ [ s:blue, s:bg, 'bold' ], [ s:fg, s:bg ] ]
  let s:p.replace.left    = [ [ s:red1, s:bg, 'bold' ], [ s:fg, s:bg ] ]
  let s:p.visual.left     = [ [ s:purple, s:bg, 'bold' ], [ s:fg, s:bg ] ]
endif

" Common
let s:p.normal.right   = [ [ s:green, s:bg, 'bold' ], [ s:fg, s:bg ] ]
let s:p.normal.error   = [ [ s:red2,   s:bg ] ]
let s:p.normal.warning = [ [ s:yellow, s:bg ] ]
let s:p.insert.right   = [ [ s:blue, s:bg, 'bold' ], [ s:fg, s:bg ] ]
let s:p.replace.right  = [ [ s:red1, s:bg, 'bold' ], [ s:fg, s:bg ] ]
let s:p.visual.right   = [ [ s:purple, s:bg, 'bold' ], [ s:fg, s:bg ] ]

let g:lightline#colorscheme#termina#palette = lightline#colorscheme#flatten(s:p)
