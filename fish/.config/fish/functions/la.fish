function la --wraps=ls --wraps='lsd -lah' --description 'alias la lsd -lah'
  lsd -lah $argv; 
end
