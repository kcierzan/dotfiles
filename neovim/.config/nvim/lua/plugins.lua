local fn = vim.fn

local nmap = function(key, cmd)
  vim.api.nvim_set_keymap('n', key, cmd, { noremap = true, silent = true })
end

-- TODO: move this to whichkey
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

nmap('<Leader>vr', "<cmd>so ~/.config/nvim/init.vim<cr>")
nmap('<Leader>ve', "<cmd>edit ~/.config/nvim/init.vim<cr>")
nmap('<Leader>vu', "<cmd>PackerUpdate<cr>")
nmap('<Leader>vi', "<cmd>PackerInstall<cr>")
nmap('<Leader>vc', "<cmd>PackerClean<cr>")
nmap('<Leader>vC', "<cmd>PackerCompile<cr>")

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

nmap('<Leader>gs', "<cmd>Git<cr>")
nmap('<Leader>gb', "<cmd>Git blame<cr>")
nmap('<Leader>gn', "<Plug>(signify-next-hunk)")
nmap('<Leader>gN', "<Plug>(signify-prev-hunk)")
nmap('<Leader>gd', "<cmd>Gvdiff<cr>")
nmap('<Leader>gl', "<cmd>GV<cr>")
nmap('<Leader>go', "<cmd>Gbrowse<cr>")
nmap('<Leader>gc', "<cmd>Gcommit<cr>")
nmap('<Leader>gr', "<cmd>Gvdiffsplit!<cr>")
nmap('<Leader>gt', "<cmd>diffget //2<cr>")
nmap('<Leader>gm', "<cmd>diffget //3<cr>")

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
