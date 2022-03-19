function findfile --description 'Fuzzy file finder'
	set out (
    fd . \
    --no-ignore \
    --hidden \
    --follow \
    --type f \
    --exclude ".git" \
    --exclude "*.pyc" \
    2> /dev/null \
    | fzf +m --exit-0 --expect=ctrl-o,ctrl-x \
    --preview-window=up:80% \
    --preview 'if test "(file --mime {} | string match -r 'binary')" != binary
          preview {} 2> /dev/null | head -2000
        else 
          echo {} is a binary file
        end'
  )

	set key (echo "$out" | cut -d' ' -f 1)
	set file (echo "$out" | cut -d' ' -f 2)

	if test -e "$file"
		if test "$key" = 'ctrl-o'
			open "$file"
		else if test "$key" = 'ctrl-x'
			rm -i "$file"
		else
			$EDITOR "$file"
		end
	end
end
