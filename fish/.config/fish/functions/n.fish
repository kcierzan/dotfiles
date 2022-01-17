function n --wraps nnn --description 'NNN file browser'
	if test -n "$NNNLVL" && test "$NNNLVL" -ge 1
		return
	end

	if test -n "$XDG_CONFIG_HOME"
		set config_dir $XDG_CONFIG_HOME
	else
		set config_dir $HOME/.config
	end

	set -gx NNN_TMPFILE "$config_dir/nnn/.lastd"

	nnn -edH $argv[1]

	if test -f $NNN_TMPFILE
		source $NNN_TMPFILE
		rm -f $NNN_TMPFILE > /dev/null
	end	
end