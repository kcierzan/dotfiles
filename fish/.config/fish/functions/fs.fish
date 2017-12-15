function fs
  if du -b /dev/null > /dev/null 2>&1
    set arg -sbh
  else
    set arg -sh
  end
  if test -n $argv
    du $arg -- $argv
  else
    du $arg .[^.]* *
  end
end
