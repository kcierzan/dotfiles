local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end


return require('packer').startup(function()
  use { 'wbthomason/packer.nvim' }

  -- Interface
  use 'Yggdroot/indentLine'
  use 'mhinz/vim-signify'
  use { 'junegunn/goyo.vim', opt = true, cmd = { 'Goyo' } }
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'
  use 'haya14busa/vim-keeppad'
  use 'blueyed/vim-diminactive'
  use 'norcalli/nvim-colorizer.lua'
  use 'terryma/vim-multiple-cursors'
  use { 'liuchengxu/vim-which-key', opt = true, cmd = { 'WhichKey' } }
  use 'psliwka/vim-smoothie'
  use 'romgrk/barbar.nvim'
  use { 'glepnir/galaxyline.nvim', branch = 'main', config = function() require('statusline') end}
  -- Colorschemes --
  use 'sainnhe/edge'
  use 'sainnhe/gruvbox-material'
  use 'sainnhe/sonokai'
  use 'dracula/vim'
  use 'lifepillar/vim-solarized8'
  -- Navigation --
  use 'easymotion/vim-easymotion'
  use 'airblade/vim-rooter'
  use 'andymass/vim-matchup'
  -- Editing --
  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use { 'terryma/vim-expand-region', opt = true }
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'wellle/targets.vim'
  use { 'junegunn/vim-easy-align', opt = true, cmd = { 'EasyAlign'} }
  use 'michaeljsmith/vim-indent-object'
  use { 'AndrewRadev/sideways.vim', opt = true, cmd = {'SidewaysLeft', 'SidewaysRight'} }
  use 'mattn/emmet-vim'
  use { 'dsznajder/vscode-es7-javascript-react-snippets', run = 'yarn install --frozen-lockfile && yarn compile' }
  use { 'brooth/far.vim', opt = true, cmd = { 'Far' } }
  use 'editorconfig/editorconfig'
  -- Git
  use 'tpope/vim-fugitive'
  use 'junegunn/gv.vim'
  use 'tpope/vim-rhubarb'
  use 'shumphrey/fugitive-gitlab.vim'
  -- tmux --
  use 'christoomey/vim-tmux-navigator'
  use 'benmills/vimux'
  use 'tmux-plugins/vim-tmux-focus-events'
  -- Syntax --
  use { 'sheerun/vim-polyglot', setup = function() vim.api.nvim_set_var('polyglot_disabled', {'python'}) end }
  use { 'plasticboy/vim-markdown', event = 'FileType markdown' }
  use 'pangloss/vim-javascript'
  use 'lervag/vimtex'
  use { 'styled-components/vim-styled-components', branch = 'main' }
  -- Applications --
  use 'glepnir/dashboard-nvim'
  use 'tpope/vim-eunuch'
  use { 'mbbill/undotree', opt = true, cmd = {'UndotreeToggle'} }
  use 'metakirby5/codi.vim'
  -- Testing --
  use { 'janko-m/vim-test' , cmd = {'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'} }
  -- IDE --
  use { 'neoclide/coc.nvim', branch = 'release' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-fzf-writer.nvim' },
      { 'nvim-telescope/telescope-fzy-native.nvim' },
    }
  }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'Shougo/neomru.vim'
  use { 'kyazdani42/nvim-tree.lua', opt = true, cmd = { 'NvimTreeToggle' } }
end)
