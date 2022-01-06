function tkillall --description 'Kill all unattached tmux sessions'
	tmux ls | grep -v attached | awk '{ print $1 }' | sed 's/://' | cut -d ' ' -f1 | xargs -I {} tmux kill-session -t {}
end