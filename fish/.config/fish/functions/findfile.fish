function findfile --description 'Fuzzy file finder'
	set -l out (fd . --no-ignore --hidden --follow --type f \
	--exclude ".git" \
	--exclude "*.pyc" \
	2> /dev/null \
	| fzf +m --exit-0 --expect=ctrl-o,ctrl-x \
	--preview-window=up:80% \
    --preview '[[ $(file --mime {}) =~ binary ]] &&
        echo {} is a binary file ||
        preview {} 2> /dev/null | head -2000')

	set -l key (echo "$out" | head -1)
	set -l file (echo "$out" | head -2 | tail -1 | cut -c 2-)

	if test -e "$file"
		if "$key" = 'ctrl-o'
			open "$file"
		else if "$key" = 'ctrl-x'
			rm -i "$file"
		else
			$EDITOR "$file"
		end
	end
end