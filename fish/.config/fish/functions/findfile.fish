function findfile --description 'Fuzzy file finder'
	set out (
    fd . \
    --no-ignore \
    --hidden \
    --follow \
    --strip-cwd-prefix \
    --type f \
    --exclude ".git" \
    --exclude "*.pyc" \
    --exclude "node_modules" \
    2> /dev/null \
    | fzf \
    -m \
    --exit-0 \
    --expect=ctrl-o,ctrl-x \
    --preview-window=up:80% \
    --preview 'if test "(file --mime {} | string match -r 'binary')" != binary
          preview {} 2> /dev/null | head -2000
        else 
          echo {} is a binary file
        end'
  )

	set key $out[1]
	set file $out[2..]

  if test "$key" = 'ctrl-o' && test -n "$file"
    open "$file"
  else if test "$key" = 'ctrl-x' && test -n "$file"
    rm -i "$file"
  else if test -n "$file"
    $EDITOR $file
  end
end
