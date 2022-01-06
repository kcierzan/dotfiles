function tns --wraps='tmux new-session -s' --description 'alias tns tmux new-session -s'
  tmux new-session -s $argv; 
end
