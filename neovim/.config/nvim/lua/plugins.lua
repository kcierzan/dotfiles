vim.cmd([[
  filetype off
  filetype plugin indent on

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
    Plug 'phaazon/hop.nvim'
    Plug 'machakann/vim-sandwich'
    Plug 'folke/trouble.nvim'
    Plug 'folke/zen-mode.nvim'
    Plug 'norcalli/nvim-colorizer.lua'
  call plug#end()
]])

require('impatient')
require('gitsigns').setup{}
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

local bufline_bg = '#212226'
local bufline_faded = '#393f4a'
local bufline_fg = '#2c2e34'

require("indent_blankline").setup{}
require("project_nvim").setup{}
require("nvim-autopairs").setup{}
require("hop").setup{}
require("colorizer").setup()
require("bufferline").setup{
  options = {
    separator_style = "slant"
  },
  highlights = {
    separator_selected = {
      guifg = bufline_bg,
      guibg = bufline_fg
    },
    background = {
      guibg = bufline_faded,
    },
    close_button = {
      guibg = bufline_faded
    },
    separator = {
      guibg = bufline_faded,
      guifg = bufline_bg
    },
    separator_visible = {
      guibg = bufline_faded,
      guifg = bufline_bg
    },
    fill = {
      guibg = bufline_bg,
    },
  }
  
}

vim.cmd("colorscheme thematic")
