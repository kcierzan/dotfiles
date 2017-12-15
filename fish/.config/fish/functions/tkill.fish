# Defined in /var/folders/6h/cfm0cx3923xbhznlqtqgjqwr000278/T//fish.sw9pdk/tkill.fish @ line 1
function tkill
	tmux ls | ggrep -v attached | gawk '{ print $1 }' | gsed 's/://' | cut -d ' ' -f1 | xargs -I {} tmux kill-session -t {}
end
