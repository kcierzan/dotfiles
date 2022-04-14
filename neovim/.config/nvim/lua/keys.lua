local wk = require('which-key')
wk.setup{}

wk.register({
  ["<leader>"] = {
    f = {
      name = "+find",
      f = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Files in cwd" },
      F = {
        '<cmd>' ..
        'Telescope find_files ' ..
        'find_command=' ..
        'fd,' ..
        '--type,' ..
        'f,' ..
        '--hidden,' ..
        '--strip-cwd-prefix,' ..
        '-E,*.pyc,' ..
        '-E,.git/,' ..
        '-E,node_modules,' ..
        '-E,**/spec/**/*,'..
        '-E,**/*migration*/**/*,' ..
        '-E,**/vendor/**/*,' ..
        '-E,**/migrate/**/*,' ..
        '-E,*.jpg,'..
        '-E,*.png,'..
        '-E,*.ttf' ..
        ' prompt_prefix=💫' ..
        '<cr>',
        "Find app files"
      },
      O = { "<cmd>lua require('telescope.builtin').vim_options()<cr>", "Vim options" },
      a = { "<cmd>lua require('telescope.builtin').autocommands()<cr>", "Autocommands" },
      b = { "<cmd>lua require('telescope.builtin').buffers()<cr>", "Open buffers" },
      c = { "<cmd>lua require('telescope.builtin').git_commits()<cr>", "Git commits" },
      g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Text in files" },
      t = { "<cmd>lua require('telescope.builtin').help_tags()<cr>", "Help tags" },
      h = { "<cmd>lua require('telescope.builtin').highlights()<cr>", "Highlights" },
      k = { "<cmd>lua require('telescope.builtin').keymaps()<cr>", "Keymaps" },
      l = { "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", "Lines in buffer" },
      m = { "<cmd>lua require('telescope.builtin').man_pages()<cr>", "Man pages" },
      o = { "<cmd>lua require('telescope.builtin').oldfiles()<cr>", "Recent files"},
      T = { "<cmd>lua require('telescope.builtin').filetypes()<cr>", "Filetypes"},
      p = { "<cmd>Telescope projects<cr>", "Projects"},
    },
    v = {
      name = "+vim",
      r = { "<cmd>so ~/.config/nvim/init.vim<cr>", "Reload config" },
      e = { "<cmd>edit ~/.config/nvim/init.vim<cr>", "Edit config" },
      s = { "<cmd>PackerUpdate<cr>", "Packer sync" },
      i = { "<cmd>PackerInstall<cr>", "Packer install" },
      c = { "<cmd>PackerClean<cr>", "Packer clean" },
      C = { "<cmd>PackerCompile<cr>", "Packer compile" },
    },
    b = {
      name = "+buffer",
      s = {'<cmd>w<cr>', "Write"},
      d = {'<cmd>Bdelete<cr>', "Delete buffer"},
      D = {'<cmd>Bdelete!<cr>', "Force delte buffer"},
      c = {'<cmd>windo diffthis<cr>', "Diff buffer"},
      C = {'<cmd>windo diffoff<cr>', "Diff off"},
      r = {'<cmd>edit!<cr>', "Reload buffer"},
    },
    w = {
      name = "+window",
      v = {'<cmd>vsp<cr>', "Split vertical" },
      s = {'<cmd>sp<cr>', "Split horizontal" },
      k = {'10<C-w>+', "Increase size"},
      j = {'10<C-w>-', "Decrease size"},
      r = {'<C-w>r', "Rotate windows"},
      o = {"<C-w>o", "Delete other windows"},
      e = {"<C-w>=", "Equalize windows"},
      V = {"<C-w>H", "To vertical splits"},
      S = {"<C-w>J", "To horizontal splits"},
    },
    i = {
      name = "+interface",
      ['%'] = { '<cmd>set invrelativenumber<cr>', 'Toggle relative line numbers'},
      ['#'] = { '<cmd>set invnumber<cr>', 'Toggle line numbers' },
      l = { '<cmd>IndentBlanklineToggle<cr>', 'Toggle indentation lines' },
      c = { '<cmd>nohlsearch<cr>', 'Clear search highlight' },
      h = { '<cmd>ColorizerAttachToBuffer<cr>', 'Colorize buffer' }
    },
    g = {
      s = { '<cmd>Git<cr>', 'git status' },
      b = { '<cmd>Git blame<cr>', 'git blame' },
      n = { '<cmd>lua require("gitsigns").next_hunk()<cr>', 'Next hunk' },
      p = { '<cmd>lua require("gitsigns").previous_hunk()<cr>', 'Previous hunk' },
      t = { '<cmd>diffget //2<cr>', 'Get diff from target buffer' },
      m = { '<cmd>diffget //3<cr>', 'Get diff from merge bugger' },
      d = { '<cmd>Gvdiff<cr>', 'git diff' },
      r = { '<cmd>Gvdiffsplit!', 'git 3-way diff' },
      c = { '<cmd>Git commit<cr>', 'git commit' }
    },
  }
})

Nmap("grl", "<cmd>diffget<cr>")
Nmap("grh", "<cmd>diffput<cr>")
Xmap("grl", "<cmd>diffget<cr>")
Xmap("grh", "<cmd>diffput<cr>")
Nmap("L", "<Nop>")
Nmap("H", "<Nop>")
Xmap("H", "<Nop>")
Xmap("L", "<Nop>")
Nmap("L", "g_")
Nmap("H", "^")
Xmap("L", "g_")
Xmap("H", "^")
Nmap("<Leader>q", "<cmd>q<cr>")
Nmap("<Leader>Q", "<cmd>q!<cr>")

Nmap("<C-l>", "<cmd>bnext<cr>")
Nmap("<C-h>", "<cmd>bprev<cr>")
