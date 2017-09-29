"        __           _ __             _         
"   ____/ /__  ____  (_) /____  _   __(_)___ ___ 
"  / __  / _ \/ __ \/ / __/ _ \| | / / / __ `__ \
" / /_/ /  __/ / / / / /_/  __/| |/ / / / / / / /
" \____/\___/_/ /_/_/\__/\___(_)___/_/_/ /_/ /_/ 
                                              
call denite#custom#option('default', 'prompt', 'µ')
call denite#custom#option('default', 'winheight', '15')

call denite#custom#var('file_rec', 'command', 
    \ ['rg', '--files','--hidden', '-g', '!.git', '-g', '!.pyc'])
call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
    \ [ '-L', '--hidden', '--vimgrep', '--no-heading', '-g', '!.pyc', '-g', '!.git'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
call denite#custom#option('file_rec', '')
call denite#custom#source('outline', 'sorters', ['sorter_sublime'])
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])
call denite#custom#alias('source', 'file_rec/git', 'file_rec')

hi! deniteMatched ctermfg=none ctermbg=none
hi! deniteMatchedChar ctermfg=3 ctermbg=none
hi! deniteMatchedRange ctermfg=none ctermbg=none
hi! deniteSource_grepFile ctermfg=4 ctermbg=none
hi! deniteSource_grepLineNR ctermfg=5 ctermbg=none
hi! deniteGrepPatterns ctermfg=2 ctermbg=none
hi! deniteSource_lineNumber ctermfg=5

call denite#custom#map(
      \ 'insert',
      \ '<C-n>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-p>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-s>',
      \ '<denite:do_action:vsplitswitch>',
      \ 'noremap'
      \)

call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
  \ [ '.git/', '.ropeproject/', '__pycache__/',
  \   'env/', 'images/', '*.min.*', 'img/', 'fonts/'])
