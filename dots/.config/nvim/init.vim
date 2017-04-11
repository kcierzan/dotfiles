"    _         _  __           _          
"   (_)____   (_)/ /_  _   __ (_)____ ___ 
"  / // __ \ / // __/ | | / // // __ `__ \
" / // / / // // /_ _ | |/ // // / / / / /
"/_//_/ /_//_/ \__/(_)|___//_//_/ /_/ /_/ 

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.local/share/nvim/plugged')

" Use . to repeat some stuff
Plug 'tpope/vim-repeat'

" Automatic deliminters
Plug 'Raimondi/delimitMate'

" Surround with brackets, quotes etc
Plug 'tpope/vim-surround'

" Comment for great success
Plug 'tpope/vim-commentary'

" Provide additional text objects
Plug 'wellle/targets.vim'

" Easymotion
Plug 'easymotion/vim-easymotion'

" MRU Source for Denite
Plug 'Shougo/neomru.vim'

" Unite all interfaces
Plug 'Shougo/denite.nvim'

" Vim Jedi for definition jumping and code navigation
Plug 'davidhalter/jedi-vim'

" FZF already installed via homebrew
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'

" Git gutter
Plug 'airblade/vim-gitgutter'

" Undo Tree
Plug 'mbbill/undotree'

" Fancy start screen
Plug 'mhinz/vim-startify'

" Delete and close buffers without closing windows
Plug 'moll/vim-bbye'

" Lightline for more speed
Plug 'itchyny/lightline.vim'

" Tmuxline
Plug 'edkolev/tmuxline.vim'

" Better looking tabs
Plug 'mkitt/tabline.vim'

" Git Wrapper
Plug 'tpope/vim-fugitive'

"Vim Tmux navigation harmony
Plug 'christoomey/vim-tmux-navigator'
"
" Interact with tmux from vim
Plug 'benmills/vimux'

" Run tests
Plug 'janko-m/vim-test'

" Lots of language packs
Plug 'sheerun/vim-polyglot'

" Deoplete completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Deoplete Jedi for great python success
Plug 'zchee/deoplete-jedi'

" Async linting courtesy of neomake
Plug 'neomake/neomake'

" Tab menu for completion
Plug 'ervandew/supertab'

" Load nerdtree on demand
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Automagically add ending statements
Plug 'tpope/endwise'

" ============ COLORSCHEMES =============
" Solarized
Plug 'altercation/vim-colors-solarized'

" Nord 
Plug 'arcticicestudio/nord-vim'
 
" Gruvbox 
Plug 'morhetz/gruvbox'

" Japanesque
Plug 'aereal/vim-colors-japanesque'

" Dracula
Plug 'crusoexia/vim-dracula'

" Ashes/Paraiso 
Plug 'chriskempson/base16-vim'

" Spacemacs Dark
Plug 'liuchengxu/space-vim-dark'

" One Light/Dark
Plug 'rakr/vim-one'

" Flatland
Plug 'vivkin/flatland.vim'

" OceanicNext
Plug 'mhartington/oceanic-next'

"Birds of Paradise
Plug 'ronny/birds-of-paradise.vim'

" Ayu Light/Dark
Plug 'ayu-theme/ayu-vim'

" Monokai Soda
Plug 'dunckr/vim-monokai-soda'

" Seashells
Plug 'vim-scripts/seashell'

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
