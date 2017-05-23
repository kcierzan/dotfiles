"   _  ____   __ ____ ___  __ __ ________
"  / // __ \ / // __/ | | / // // __ `__ \
" / // / / // // /_ _ | |/ // // / / / / /
"/_//_/ /_//_/ \__/(_)|___//_//_/ /_/ /_/ 

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.local/share/nvim/plugged')

Plug 'tpope/vim-repeat'                    " Use . to repeat some stuff
Plug 'Raimondi/delimitMate'                " Automatic deliminters
Plug 'tpope/vim-surround'                  " Surround with brackets, quotes etc
Plug 'tpope/vim-commentary'                " Comment for great success
Plug 'wellle/targets.vim'                  " Provide additional text objects
Plug 'easymotion/vim-easymotion'           " Easymotion
Plug 'Shougo/neomru.vim'                   " MRU Source for Denite
Plug 'Shougo/denite.nvim'                  " Unite all interfaces
Plug 'davidhalter/jedi-vim',               { 'for': 'python' } " Vim Jedi for definition jumping and code navigation
Plug 'airblade/vim-gitgutter'              " Git gutter
Plug 'mbbill/undotree'                     " Undo Tree
Plug 'mhinz/vim-startify'                  " The cow says...
Plug 'moll/vim-bbye'                       " Delete and close buffers without closing windows
Plug 'itchyny/lightline.vim'               " Lightline for more speed
Plug 'mkitt/tabline.vim'                   " Better looking tabs
Plug 'tpope/vim-fugitive'                  " Git Wrapper
Plug 'christoomey/vim-tmux-navigator'      " Vim Tmux navigation harmony
Plug 'benmills/vimux'                      " Interact with tmux from vim
Plug 'janko-m/vim-test'                    " Run tests
Plug 'sheerun/vim-polyglot'                " Lots of language packs
Plug 'Shougo/deoplete.nvim',               { 'do': ':UpdateRemotePlugins' } " Deoplete completion
Plug 'zchee/deoplete-jedi',                { 'for': 'python' } " Deoplete Jedi for great python success
Plug 'neomake/neomake'                     " Async linting
Plug 'ervandew/supertab'                   " Tab menu for completion
Plug 'scrooloose/nerdtree',                { 'on': ['NERDTreeToggle', 'NERDTreeCWD'] } " Load nerdtree on demand
Plug 'tpope/vim-endwise'                   " Automagically add ending statements
Plug 'Yggdroot/indentLine'                 " indent lines
Plug 'ap/vim-buftabline'                   " tabline is now useful
Plug 'junegunn/vim-easy-align'             " align stuff
Plug 'kien/rainbow_parentheses.vim'        " Rainbow Parens
Plug 'michaeljsmith/vim-indent-object'     " indentation objects
Plug 'rhysd/clever-f.vim'                  " F and T are repeatable
Plug 'tpope/vim-abolish'                   " correct common misspellings
Plug 'AndrewRadev/sideways.vim'            " Move stuff sideways
Plug '~/git/dotfiles/colorschemes/termina' " Best. Colorscheme. Ever.
Plug 'hecal3/vim-leader-guide'             " Spacemacs style leader guide

call plug#end()
" Source nvim modules
if filereadable(expand("~/.config/nvim/config.vim"))
  source ~/.config/nvim/config.vim
endif

if filereadable(expand("~/.config/nvim/binding.vim"))
  source ~/.config/nvim/binding.vim
endif

if filereadable(expand("~/.config/nvim/lightline.vim"))
  source ~/.config/nvim/lightline.vim
endif

if filereadable(expand("~/.config/nvim/denite.vim"))
  source ~/.config/nvim/denite.vim
endif
