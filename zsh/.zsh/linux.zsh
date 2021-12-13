alias pst="xclip -o -sel"
alias cpy="xclip -selection clipboard"
alias ppst="xclip -o -selection clipboard"

alias p="sudo pacman"
alias sys="sudo systemctl"
alias dc="sudo docker-compose"
alias dockstop="sudo docker ps -a -q | sudo xargs docker stop 2>&1"
alias dockrm="sudo docker ps -a -q | sudo xargs docker rm 2>&1"
alias usys="systemctl --user"
alias upgrade="yay -Syu"

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /opt/asdf-vm/asdf.sh
