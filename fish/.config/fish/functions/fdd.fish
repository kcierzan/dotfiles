function fdd
  if test -z $argv[1]
    set start $argv[1]
  else
    set start .
  end
  set dir (find $start -type d 2> /dev/null | fzf +m); and cd $dir
end
