function grepfiles --description 'Fuzzy file grepper'
	if test "$EDITOR" = 'nvim'
		set linefile (rg -n --hidden \
	    -g "!.pyc" \
	    -g "!.git/*" \
	    -g "!node-modules/*" \
	    -g "!env/*" \
	    -g "!TAGS" \
	    -g "!*.dmp" \
	    . \
	    2> /dev/null \
	    | fzf +m --exit-0 --preview-window=up:80% --delimiter ':' --nth 3.. --preview 'preview.sh {}' \
	    | gawk -F : '{print "+"$2" "$1 }')
	else if test "$EDITOR" = 'code'
	      set linefile (rg -n --hidden \
	        -g "!.pyc" \
	        -g "!.git/*" \
	        -g "!node-modules/*" \
	        -g "!env/*" \
	        -g "!TAGS" \
	        -g "!*.dmp" \
	        . \
	        2> /dev/null \
	        | fzf +m --exit-0 --preview-window=up:80% --delimiter ':' --nth 3.. --preview 'preview.sh {}' \
	        | gawk -F : '{print "-g "$1":"$2 }')
	else if test "$EDITOR" = 'subl'
	      set linefile (rg -n --hidden \
	        -g "!.pyc" \
	        -g "!.git/*" \
	        -g "!node-modules/*" \
	        -g "!env/*" \
	        -g "!TAGS" \
	        -g "!*.dmp" \
	        . \
	        2> /dev/null \
	        | fzf +m --exit-0 --preview-window=up:80% --delimiter ':' --nth 3.. --preview 'preview.sh {}' \
	        | gawk -F : '{print $1":"$2 }')
	end

	if test -n "$linefile"
		$EDITOR $linefile
	end
end