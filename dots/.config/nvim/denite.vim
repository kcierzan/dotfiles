"        __           _ __             _         
"   ____/ /__  ____  (_) /____  _   __(_)___ ___ 
"  / __  / _ \/ __ \/ / __/ _ \| | / / / __ `__ \
" / /_/ /  __/ / / / / /_/  __/| |/ / / / / / / /
" \__,_/\___/_/ /_/_/\__/\___(_)___/_/_/ /_/ /_/ 
                                              
autocmd FileType unite call s:uniteinit()
  function! s:uniteinit()
      set nonumber
      set norelativenumber
      nunmap <buffer> d
      nunmap <buffer> a
      nunmap <buffer> <c-n>
      nunmap <buffer> <c-k>
      nunmap <buffer> <c-p>

      nmap <silent> <Esc> <Plug>(unite_all_exit)
      nmap <silent> <c-n> <Plug>(unite_loop_cursor_down)
      nmap <silent> <c-p> <Plug>(unite_loop_cursor_up)

    endfunction

  call denite#custom#option('default', 'prompt', '☾')

  call denite#custom#source(
	\ 'file_rec', 'vars', {
	\   'command': [
  \      'ag', '--follow','--nogroup','--hidden', '-g', '', '--ignore', '.git', '--ignore', '*.png'
	\   ] })
  let s:menus = {}
	call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('grep', 'default_opts',
			\ ['--vimgrep', '--no-heading'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
  " call denite#custom#source('file_rec', 'sorters', ['sorter_sublime'])
  " call denite#custom#option('default', 'statusline', 0)
  call denite#custom#option('default', 'highlight-matched-char', '')
  call denite#custom#option('default', 'highlight-matched-range', '')
  hi deniteMatched guibg=None
  hi deniteMatchedChar guibg=None

  nnoremap <silent> <c-p> :Denite file_rec<CR>
  nnoremap <silent> <leader>h :Denite  help<CR>
  nnoremap <silent> <leader>c :Denite colorscheme<CR>
  nnoremap <silent> <leader>b :Denite buffer<CR>
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

  call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
    \ [ '.git/', '.ropeproject/', '__pycache__/',
    \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

  call denite#custom#var('menu', 'menus', s:menus)
  nnoremap <silent> <Leader>i :Denite -auto-resize menu:ionic <CR>

" Git from denite...ERMERGERD
  let s:menus.git = {
    \ 'description' : 'Fugitive interface',
    \}
  let s:menus.git.command_candidates = [
    \[' git status', 'Gstatus'],
    \[' git diff', 'Gvdiff'],
    \[' git commit', 'Gcommit'],
    \[' git stage/add', 'Gwrite'],
    \[' git checkout', 'Gread'],
    \[' git rm', 'Gremove'],
    \[' git cd', 'Gcd'],
    \[' git push', 'exe "Git! push " input("remote/branch: ")'],
    \[' git pull', 'exe "Git! pull " input("remote/branch: ")'],
    \[' git pull rebase', 'exe "Git! pull --rebase " input("branch: ")'],
    \[' git checkout branch', 'exe "Git! checkout " input("branch: ")'],
    \[' git fetch', 'Gfetch'],
    \[' git merge', 'Gmerge'],
    \[' git browse', 'Gbrowse'],
    \[' git head', 'Gedit HEAD^'],
    \[' git parent', 'edit %:h'],
    \[' git log commit buffers', 'Glog --'],
    \[' git log current file', 'Glog -- %'],
    \[' git log last n commits', 'exe "Glog -" input("num: ")'],
    \[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
    \[' git log until date', 'exe "Glog --until=" input("day: ")'],
    \[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
    \[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
    \[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
    \[' git mv', 'exe "Gmove " input("destination: ")'],
    \[' git grep',  'exe "Ggrep " input("string: ")'],
    \[' git prompt', 'exe "Git! " input("command: ")'],
    \] " Append ' --' after log to get commit info commit buffers
  
" Denite uses ripgrep
" call denite#custom#var('file_rec', 'command',
"       \ ['rg', '--files', '--glob', '!.git', ''])

