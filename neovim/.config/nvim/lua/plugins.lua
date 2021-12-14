local fn = vim.fn
local nmap = function(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

nmap('<Leader>i%', '<cmd>set invrelativenumber<cr>')
nmap('<Leader>i#', '<cmd>set invnumber<cr>')
nmap('<Leader>il', '<cmd>IndentBlanklineToggle<cr>')
nmap('<Leader>ic', '<cmd>nohlsearch<cr>')
nmap('<Leader>ih', '<cmd>ColorizerAttachToBuffer<cr>')

nmap('<Leader>be', '<cmd>SudoEdit<cr>')
nmap('<Leader>bs', '<cmd>w<cr>')
nmap('<Leader>bd', '<cmd>BufferClose<cr>')
nmap('<Leader>bD', '<cmd>BufferClose!<cr>')
nmap('<Leader>bc', '<cmd>windo diffthis<cr>')
nmap('<Leader>bC', '<cmd>windo diffoff<cr>')
nmap('<Leader>br', '<cmd>edit!<cr>')

nmap('<Leader>wv', '<cmd>vsp<cr>')
nmap('<Leader>ws', '<cmd>sp<cr>')
nmap('<Leader>wk', '10<C-w>+')
nmap('<Leader>wj', '10<C-w>-')
nmap('<Leader>wr', '<C-w>r')
nmap('<Leader>wo', "<C-w>o")
nmap('<Leader>we', "<C-w>=")
nmap('<Leader>wV', "<C-w>H")
nmap('<Leader>wS', "<C-w>J")

nmap('<Leader>nr', "<cmd>so ~/.config/nvim/init.vim<cr>")
nmap('<Leader>ne', "<cmd>edit ~/.config/nvim/init.vim<cr>")
nmap('<Leader>nu', "<cmd>PackerUpdate<cr>")
nmap('<Leader>ni', "<cmd>PackerInstall<cr>")
nmap('<Leader>nc', "<cmd>PackerClean<cr>")
nmap('<Leader>nC', "<cmd>PackerCompile<cr>")

nmap('<Leader>fO', "<cmd>lua require('telescope.builtin').vim_options()<cr>")

nmap('<Leader>fO', "<cmd>lua require('telescope.builtin').vim_options()<cr>")
nmap('<Leader>fa', "<cmd>lua require('telescope.builtin').autocommands()<cr>")
nmap('<Leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>")
nmap('<Leader>fc', "<cmd>lua require('telescope.builtin').git_commits()<cr>")
nmap('<Leader>ff', "<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--iglob', '!.git', '--hidden' } })<cr>")
nmap('<Leader>fg', "<cmd>lua require('telescope.builtin').live_grep()<cr>")
nmap('<Leader>fi', "<cmd>lua require('telescope.builtin').help_tags()<cr>")
nmap('<Leader>fh', "<cmd>lua require('telescope.builtin').highlights()<cr>")
nmap('<Leader>fk', "<cmd>lua require('telescope.builtin').keymaps()<cr>")
nmap('<Leader>fl', "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>")
nmap('<Leader>fm', "<cmd>lua require('telescope.builtin').man_pages()<cr>")
nmap('<Leader>fo', "<cmd>lua require('telescope.builtin').oldfiles()<cr>")
nmap('<Leader>ft', "<cmd>lua require('telescope.builtin').filetypes()<cr>")


local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  execute 'packadd packer.nvim'
end


return require('packer').startup(function()
  use { 'wbthomason/packer.nvim' }

  -- Interface
  use { 'lukas-reineke/indent-blankline.nvim', config = function() 
    vim.g.indent_blankline_enabled = false    
  end }
  use 'mhinz/vim-signify'
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'
  use 'haya14busa/vim-keeppad'
  use 'blueyed/vim-diminactive'
  use {'norcalli/nvim-colorizer.lua', config = function()
    require('colorizer').setup()
  end}

  -- use 'terryma/vim-multiple-cursors'
  -- use { 'folke/which-key.nvim', config = function()
  --   local wk = require("which-key")
  --     wk.setup()
  --     wk.register({
  --         i = {
  --           name = "Interface",
  --           ["%"] = {"<cmd>set invrelativenumber<cr>", "Toggle relative line numbers"},
  --           ["#"] = {"<cmd>set invnumber<cr>", "Toggle line numbers"},
  --           l = {"<cmd>set invcursorline<cr>", "Disable cursorline"},
  --           i = {"<cmd>IndentBlanklineToggle<cr>", "Toggle indentation lines"},
  --           u = {"<cmd>UndotreeToggle<cr>", "Toggle undotree"},
  --           c = {"<cmd>nohlsearch<cr>", "Toggle search highlight"},
  --           h = {"<cmd>ColorizerAttachToBuffer<cr>", "Highlight colors"},
  --           t = {"<cmd>NvimTreeToggle<cr>", "Toggle file browser"},
  --         },
  --         b = {
  --           name = "Buffers",
  --           e = {"<cmd>SudoEdit<cr>", "Edit with sudo"},
  --           s = {"<cmd>w<cr>", "Write buffer"},
  --           n = {"<cmd>vsplit", "New buffer and file"},
  --           d = {"<cmd>BufferClose<cr>", "Close buffer"},
  --           D = {"<cmd>BufferClose!<cr>", "Close buffer without saving"},
  --           c = {"<cmd>windo diffthis<cr>", "Diff buffers"},
  --           C = {"<cmd>windo diffoff<cr>", "Diff off"},
  --           r = {"<cmd>edit!<cr>", "Force reload buffer"}
  --         },
  --         w = {
  --           name = "Windows",
  --           v = {"<cmd>vsp<cr>", "Split window vertically"},
  --           s = {"<cmd>sp<cr>", "Split window horizontally"},
  --           k = {"10<C-w>+", "Decrease window height"},
  --           j = {"10<C-w>-", "Increase window height"},
  --           l = {"10<C-w>>", "Increase right window width"},
  --           h = {"10<C-w><", "Increase left window width"},
  --           r = {"<C-w>r", "Rotate windows"},
  --           o = {"<C-w>o", "Kill other windows"},
  --           e = {"<C-w>=", "Equalize windows"},
  --           V = {"<C-w>H", "To vertical split"},
  --           S = {"<C-w>J", "To horizontal split"}
  --         },
  --         v = {
  --           name = "Neovim",
  --           r = {"<cmd>so ~/.config/nvim/init.vim<cr>", "Reload init.vim"},
  --           e = {"<cmd>edit ~/.config/nvim/init.vim<cr>", "Edit init.vim"},
  --           s = {"<cmd>Dashboard<cr>", "Go to start page"},
  --           u = {"<cmd>PackerUpdate<cr>", "Update plugins"},
  --           i = {"<cmd>PackerInstall<cr>", "Install plugins"},
  --           c = {"<cmd>PackerClean<cr>", "Clean plugins"},
  --           C = {"<cmd>PackerCompile<cr>", "Compile plugins"}
  --         },
  --         c = {
  --           name = "CoC",
  --           a = {"<Plug>(coc-codeaction)", "Code action"},
  --           f = {"<Plug>(coc-fix-current)", "Fix current"},
  --           F = {"<Plug>(coc-format-selected)", "Format selected"},
  --           c = {"<cmd>CocRestart<cr>", "Restart CoC"},
  --           e = {"<cmd>CocConfig<cr>", "Edit CoC config"},
  --           r = {"<Plug>(coc-rename)", "Rename"},
  --           R = {"<Plug>(coc-references-used)", "Jump to references"}
  --         },
  --         F = {
  --           name = "Functions",
  --           t = {"<cmd>Trimws<cr>", "Trim whitespace"},
  --           c = {"<cmd>!rm tags && ctags<cr>", "Create ctags"}
  --         },
  --         ["<leader>"] = {
  --           name = "Find",
  --           O = {"<cmd>lua require('telescope.builtin').vim_options()<cr>", "Options"},
  --           a = {"<cmd>lua require('telescope.builtin').autocommands()<cr>", "Autocommands"},
  --           b = {"<cmd>lua require('telescope.builtin').buffers()<cr>", "Buffers"},
  --           c = {"<cmd>lua require('telescope.builtin').git_commits()<cr>", "Find git commits"},
  --           f = {"<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--iglob', '!.git', '--hidden' } })<cr>", "Files"},
  --           g = {"<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep"},
  --           i = {"<cmd>lua require('telescope.builtin').help_tags()<cr>", "Nvim help tags"},
  --           h = {"<cmd>lua require('telescope.builtin').highlights()<cr>", "Highlights"},
  --           k = {"<cmd>lua require('telescope.builtin').keymaps()<cr>", "Keymaps"},
  --           l = {"<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "Line in current buffer"},
  --           m = {"<cmd>lua require('telescope.builtin').man_pages()<cr>", "Man pages"},
  --           o = {"<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Old files"},
  --           t = {"<cmd>lua require('telescope.builtin').filetypes()<cr>", "Filetypes"},
  --         },
  --         t = {
  --           name = "Testing",
  --           n = {"<cmd>TestNearest<cr>", "Test nearest"},
  --           f = {"<cmd>TestFile<cr>", "Test file"},
  --           s = {"<cmd>TestSuite<cr>", "Test suite"},
  --           l = {"<cmd>TestLast<cr>", "Test last"},
  --           v = {"<cmd>TestVisit<cr>", "Test visit"},
  --         },
  --         g = {
  --           name = "Git",
  --           s = {"<cmd>Gstatus<cr>", "Git status"},
  --           b = {"<cmd>Git blame<cr>", "Git blame"},
  --           n = {"<Plug>(signify-next-hunk)", "Next hunk"},
  --           N = {"<Plug>(signify-prev-hunk)", "Previous hunk"},
  --           d = {"<cmd>Gvdiff<cr>", "Git diff"},
  --           l = {"<cmd>GV<cr>", "Git log"},
  --           o = {"<cmd>Gbrowse<cr>", "Open in browser"},
  --           c = {"<cmd>Gcommit<cr>", "Git commit"},
  --           r = {"<cmd>Gvdiffsplit!<cr>", "Three-way merge"},
  --           t = {"<cmd>diffget //2<cr>", "Keep changes from target buffer"},
  --           m = {"<cmd>diffget //3<cr>", "Keep changes from merge buffer"},
  --         },
  --       }, { prefix = "<leader>", noremap = true, silent = true}
  --     )
  -- end}
  -- use 'psliwka/vim-smoothie'
  use 'romgrk/barbar.nvim'
  use { 'glepnir/galaxyline.nvim', branch = 'main', config = function() require('statusline') end }
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
  use 'mattn/emmet-vim'
  use { 'dsznajder/vscode-es7-javascript-react-snippets', run = 'yarn install --frozen-lockfile && yarn compile' }
  -- use { 'brooth/far.vim', opt = true, cmd = { 'Far' } }
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
  use { 'plasticboy/vim-markdown', event = 'FileType markdown' }
  use 'pangloss/vim-javascript'
  use 'lervag/vimtex'
  use { 'styled-components/vim-styled-components', branch = 'main' }
  -- Applications --
  -- use 'glepnir/dashboard-nvim'
  use 'tpope/vim-eunuch'
  -- use { 'mbbill/undotree', opt = true, cmd = {'UndotreeToggle'} }
  -- use 'metakirby5/codi.vim'
  -- Testing --
  -- use { 'janko-m/vim-test' , cmd = {'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'} }
  -- IDE --
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use { 'nvim-lua/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}},
  config = function ()
    require('telescope').load_extension('fzf')
  end}
  -- TODO: replace with neovim completion
  -- use { 'neoclide/coc.nvim', branch = 'release' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
    require 'nvim-treesitter.configs'.setup {
      ensure_installed = {"python", "javascript", "typescript", "go", "java", "yaml", "json", "lua"},
      highlight = {
        enable = true
      },
      indent = {
        enable = false
      }
    }
    end
  }
  use 'Shougo/neomru.vim'
  -- use { 'kyazdani42/nvim-tree.lua', config = function() require 'nvim-tree'.setup {} end  }
  use 'wellle/tmux-complete.vim'
  use 'fatih/vim-go'
  use { 'famiu/nvim-reload', config = function()
    local reload = require('nvim-reload')
    local plugin_dirs = vim.fn.stdpath('data') .. 'site/pack/*/start/*'
    reload.vim_reload_dirs = {
      vim.fn.stdpath('config'),
      plugin_dirs
    }
    reload.lua_reload_dirs = {
      vim.fn.stdpath('config'),
      plugin_dirs
    }
    reload.modules_reload_external = {'packer'}
  end}
  use 'nvim-lua/plenary.nvim'
end)
