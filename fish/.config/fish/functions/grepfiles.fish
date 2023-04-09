function grepfiles --description 'Fuzzy file grepper'
  set preview_cmd 'if test "(file --mime {} | string match -r \'binary\')" != binary; preview {} 2> /dev/null | head -2000; else; echo {} is a binary file; end'
  set excludes '"!{.git,node_modules,*.pyc,env,*.dmp}"'
  set get_files rg -n --hidden -g $excludes . 2>/dev/null
  set filter_files fzf +m --exit-0 --preview-window=up:80% --delimiter ':' --nth 3.. --preview (string join '' "'" $preview_cmd "'")

  switch "$EDITOR"
    case nvim 'neovide --frame buttonless'
      set format_for_editor 'gawk -F: \'{print "+"$2" "$1}\''
    case code
      set format_for_editor 'gawk -F : \'{print "-g "$1":"$2 }\''
    case subl
      set format_for_editor 'gawk -F : \'{print $1":"$2 }\''
  end

  set linefile (eval "$get_files | $filter_files | $format_for_editor")

	if test -n "$linefile"
		eval $EDITOR (string split -- ' ' $linefile)
	end
end
