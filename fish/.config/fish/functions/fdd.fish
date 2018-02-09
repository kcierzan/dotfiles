function fdd
  set dir (gfind . -type d 2> /dev/null | fzf +m); and cd "$dir"
end
