vim.cmd([[

  filetype off
  filetype plugin indent on
  colorscheme thematic

  call plug#begin()
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'windwp/nvim-autopairs'
    Plug 'numToStr/Comment.nvim'
    Plug 'akinsho/bufferline.nvim'
    Plug 'moll/vim-bbye'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'ahmedkhalf/project.nvim'
    Plug 'lewis6991/impatient.nvim'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'goolord/alpha-nvim'
    Plug 'folke/which-key.nvim'
    Plug 'lunarvim/colorschemes'
    Plug 'ms-jpq/coq_nvim', {'branch': 'coq' }
    Plug 'ms-jpq/coq.artifacts', { 'branch': 'artifacts' }
    Plug 'ms-jpq/coq.thirdparty',  { 'branch': '3p' }
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', {'do': 'make'}
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'lewis6991/gitsigns.nvim'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'catppuccin/nvim', {'as': 'catppuccin'}
    Plug 'phaazon/hop.nvim', { 'branch': 'v1' }
    Plug 'machakann/vim-sandwich'
    Plug 'folke/trouble.nvim'
    Plug 'folke/zen-mode.nvim'
  call plug#end()
]])

require('gitsigns').setup()
require('zen-mode').setup()
require('lualine').setup{}
require('alpha').setup(require('alpha.themes.dashboard').config)
require('Comment').setup()
require('telescope').setup {
  extensions = {
    fzf = {
     fuzz = true,
     override_generic_sorter = true,
     override_file_sorter = true,
     case_mode = 'smart_case' 
    }
  }
}

local tree_sitter = require('nvim-treesitter.configs')

tree_sitter.setup {
  ensure_installed = "maintained",
  sync_install = false,
}

require('telescope').load_extension('fzf')
vim.g.coq_settings = { auto_start = 'shut-up' }
local coq = require('coq')
local lsp = require('lspconfig')

lsp.pyright.setup(coq.lsp_ensure_capabilities())

require('coq_3p') {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "copilot", short_name = "COP", accept_key = "<c-f>" }
}

require("indent_blankline").setup{}
