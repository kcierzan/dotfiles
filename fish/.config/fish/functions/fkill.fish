function fkill --description "Kill the selected processes"
	set -l pid (ps -ef | sed 1d | fzf -m | awk '{print$2}')
	if test -n "$pid" && test "x$pid" != 'x'
		kill -9 $pid
	end
end
