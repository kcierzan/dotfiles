function __fzf_preview
  if file --mime "$argv" | grep -q binary
    echo "$argv"
  else
    if command --quiet --search preview
      preview "$argv" 2> /dev/null | head -250
    else if command --quiet --search cat
      cat "$argv" | head -250
    else
      head -250 "$argv"
    end
  end
end
