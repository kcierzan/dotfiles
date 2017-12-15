function fkill
  set pid (ps -ef | sed 1d | fzf -m | awk '{print $2}')
  set op $argv[1]
  if test -z $pid
    if test -z $op
      kill -$op $pid 2> /dev/null
    else
      kill -9 $pid 2> /dev/null
    end
  end
end
