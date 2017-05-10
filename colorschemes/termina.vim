" -----------------------------------------------------------------------------
" File: termina.vim
" Description: Robust terminal based colorscheme
" Author: Kyle Cierzan <kcierzan@gmail.com>
" Source: https://github.com/kcierzan/termina
" Last Modified: 09 May 2017
" -----------------------------------------------------------------------------

set background=dark
let g:colors_name="termina"
syntax reset

" Palette
" let s:pal = {}

" Palette"{{{
" let s:pal.bg          = 0
" let s:pal.fg          = 15

" let s:pal.dark0_hard  =  234
" let s:pal.dark0       =  235
" let s:pal.dark0_soft  =  236
" let s:pal.dark1       =  237
" let s:pal.dark2       =  239
" let s:pal.dark3       =  241
" let s:pal.dark4       =  243
" let s:pal.dark4_256   =  243

" let s:pal.gray_245    =  245
" let s:pal.gray_244    =  244

" let s:pal.light0_hard =  230
" let s:pal.light0      =  229
" let s:pal.light0_soft =  228
" let s:pal.light1      =  223
" let s:pal.light2      =  250
" let s:pal.light3      =  248
" let s:pal.light4      =  246
" let s:pal.light4_256  =  246

" let s:pal.bright_red     = 9
" let s:pal.bright_green   = 10
" let s:pal.bright_yellow  = 11
" let s:pal.bright_blue    = 12
" let s:pal.bright_purple  = 13
" let s:pal.bright_aqua    = 14
" let s:pal.bright_orange  = 208

" let s:pal.neutral_red    = 1
" let s:pal.neutral_green  = 2
" let s:pal.neutral_yellow = 3
" let s:pal.neutral_blue   = 4
" let s:pal.neutral_purple = 5
" let s:pal.neutral_aqua   = 6
" let s:pal.neutral_orange = 166"}}}

hi CursorLine ctermfg=none ctermbg=235 cterm=none
hi! link CursorColumn CursorLine

hi  TabLineFill  ctermfg=243  ctermbg=0    cterm=none
hi  TabLine      ctermfg=243  ctermbg=0    cterm=none
hi  TabLineSel   ctermfg=0    ctermbg=243  cterm=inverse,bold
" hi  MatchParen   ctermfg=none ctermbg=241  cterm=bold
hi  ColorColumn  ctermfg=none ctermbg=0    cterm=none
hi  Conceal      ctermfg=4    ctermbg=none cterm=none
hi  CursorLineNr ctermfg=11   ctermbg=237  cterm=none
hi  Visual       ctermfg=none ctermbg=241  cterm=inverse
hi  VisualNOS    ctermfg=none ctermbg=241  cterm=inverse
hi  Search       ctermfg=11   ctermbg=235  cterm=inverse
hi  IncSearch    ctermfg=166  ctermbg=235  cterm=inverse
hi  Underlined   ctermfg=4    ctermbg=none cterm=underline
hi  StatusLine   ctermfg=243  ctermbg=235  cterm=inverse
hi  StatusLineNC ctermfg=239  ctermbg=246  cterm=inverse
hi  VertSplit    ctermfg=246  ctermbg=239  cterm=none
hi  WildMenu     ctermfg=4    ctermbg=239  cterm=bold
hi  ErrorMsg     ctermfg=235  ctermbg=1    cterm=bold
hi  NonText      ctermfg=239  ctermbg=none cterm=none
hi  SpecialKey   ctermfg=239  ctermbg=none cterm=none
hi  Directory    ctermfg=2    ctermbg=none cterm=bold
hi  Title        ctermfg=2    ctermbg=none cterm=bold
hi  MoreMsg      ctermfg=3    ctermbg=none cterm=bold
hi  ModeMsg      ctermfg=3    ctermbg=none cterm=bold
hi  Question     ctermfg=166  ctermbg=none cterm=bold
hi  WarningMsg   ctermfg=166  ctermbg=none cterm=bold
hi  LineNr       ctermfg=243  ctermbg=none cterm=none
hi  SignColumn   ctermfg=none ctermbg=237  cterm=none
hi  Folded       ctermfg=244  ctermbg=237  cterm=none
hi  FoldColumn   ctermfg=244  ctermbg=237  cterm=none
hi  Cursor       ctermfg=235  ctermbg=166  cterm=inverse
hi  vCursor      ctermfg=none ctermbg=none cterm=inverse
hi  iCursor      ctermfg=none ctermbg=none cterm=inverse
hi  lCursor      ctermfg=none ctermbg=none cterm=inverse


hi Special      ctermfg=237  ctermbg=none cterm=bold
hi Comment      ctermfg=244  ctermbg=none cterm=none
hi Todo         ctermfg=15   ctermbg=0    cterm=none
hi Error        ctermfg=1    ctermbg=0    cterm=bold,inverse
hi Statement    ctermfg=1    ctermbg=none cterm=bold
hi Conditional  ctermfg=1    ctermbg=none cterm=none
hi Repeat       ctermfg=1    ctermbg=none cterm=none
hi Label        ctermfg=1    ctermbg=none cterm=none
hi Exception    ctermfg=1    ctermbg=none cterm=none
hi Keyword      ctermfg=1    ctermbg=none cterm=none
hi Normal       ctermfg=none ctermbg=none cterm=none
hi Operator     ctermfg=none ctermbg=none cterm=none
hi Identifier   ctermfg=4    ctermbg=none cterm=none
hi Function     ctermfg=2    ctermbg=none cterm=bold
hi PreProc      ctermfg=6    ctermbg=none cterm=none
hi Include      ctermfg=6    ctermbg=none cterm=none
hi Define       ctermfg=6    ctermbg=none cterm=none
hi Macro        ctermfg=6    ctermbg=none cterm=none
hi PreCondit    ctermfg=6    ctermbg=none cterm=none
hi Constant     ctermfg=5    ctermbg=none cterm=none
hi Character    ctermfg=5    ctermbg=none cterm=none
hi Boolean      ctermfg=5    ctermbg=none cterm=none
hi Number       ctermfg=5    ctermbg=none cterm=none
hi Float        ctermfg=5    ctermbg=none cterm=none
hi String       ctermfg=2    ctermbg=none cterm=none
hi Type         ctermfg=3    ctermbg=none cterm=none
hi StorageClass ctermfg=166  ctermbg=none cterm=none
hi Structure    ctermfg=6    ctermbg=none cterm=none
hi Typedef      ctermfg=3    ctermbg=none cterm=none

hi Pmenu      ctermfg=223  ctermbg=239 cterm=none
hi PmenuSel   ctermfg=239  ctermbg=4   cterm=bold
hi PmenuSbar  ctermfg=none ctermbg=239 cterm=none
hi PmenuThumb ctermfg=none ctermbg=243 cterm=none


hi DiffDelete      ctermfg=1   ctermbg=235  cterm=inverse
hi DiffAdd         ctermfg=2   ctermbg=235  cterm=inverse
hi DiffChange      ctermfg=6   ctermbg=235  cterm=inverse
hi DiffText        ctermfg=3   ctermbg=235  cterm=inverse
hi EasyMotion      ctermfg=11  ctermbg=235  cterm=inverse
hi EasyMotionShade ctermfg=244 ctermbg=none cterm=none

if !exists('g:indentLine_color_term')
  let g:indentLine_color_term = 239
endif

hi GitGutterAdd          ctermfg=2   ctermbg=237  cterm=none
hi GitGutterChange       ctermfg=6   ctermbg=237  cterm=none
hi GitGutterDelete       ctermfg=1   ctermbg=237  cterm=none
hi GitGutterChangeDelete ctermfg=6   ctermbg=237  cterm=none

hi StartifyBracket       ctermfg=248 ctermbg=none cterm=none
hi StartifyFile          ctermfg=229 ctermbg=none cterm=none
hi StartifyNumber        ctermfg=4   ctermbg=none cterm=none
hi StartifyPath          ctermfg=244 ctermbg=none cterm=none
hi StartifySlash         ctermfg=244 ctermbg=none cterm=none
hi StartifySection       ctermfg=3   ctermbg=none cterm=none
hi StartifySpecial       ctermfg=239 ctermbg=none cterm=none
hi StartifyHeader        ctermfg=1   ctermbg=none cterm=none
hi StartifyFooter        ctermfg=239 ctermbg=none cterm=none

hi BufTabLineCurrent     ctermfg=235 ctermbg=246  cterm=none
hi BufTabLineActive      ctermfg=246 ctermbg=239  cterm=none
hi BufTabLineHidden      ctermfg=243 ctermbg=237  cterm=none
hi BufTabLineFill        ctermfg=235 ctermbg=none  cterm=none

hi pythonBuiltin         ctermfg=166 ctermbg=none cterm=none
hi pythonBuiltinObj      ctermfg=166 ctermbg=none cterm=none
hi pythonBuiltinFunc     ctermfg=166 ctermbg=none cterm=none
hi pythonFunction        ctermfg=6   ctermbg=none cterm=none
hi pythonDecorator       ctermfg=1   ctermbg=none cterm=none
hi pythonInclude         ctermfg=4   ctermbg=none cterm=none
hi pythonImport          ctermfg=4   ctermbg=none cterm=none
hi pythonRun             ctermfg=4   ctermbg=none cterm=none
hi pythonCoding          ctermfg=4   ctermbg=none cterm=none
hi pythonOperator        ctermfg=1   ctermbg=none cterm=none
hi pythonExceptions      ctermfg=5   ctermbg=none cterm=none
hi pythonBoolean         ctermfg=5   ctermbg=none cterm=none
hi pythonDot             ctermfg=248 ctermbg=none cterm=none


hi vimCommentTitle ctermfg=243 ctermbg=none cterm=bold
hi vimNotation     ctermfg=166 ctermbg=none cterm=none
hi vimBracket      ctermfg=166 ctermbg=none cterm=none
hi vimMapModKey    ctermfg=166 ctermbg=none cterm=none
hi vimFuncSID      ctermfg=248 ctermbg=none cterm=none
hi vimSetSep       ctermfg=248 ctermbg=none cterm=none
hi vimSep          ctermfg=248 ctermbg=none cterm=none
hi vimContinue     ctermfg=248 ctermbg=none cterm=none
