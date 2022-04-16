local wk = require('which-key')
wk.setup{}

wk.register({
  ["<leader>"] = {
    ["<cr>"] = { "org smart return" },
    f = {
      name = "+find",
      f = {
        "<cmd>lua require('telescope.builtin').find_files()<cr>",
        "files in current directory"
      },
      F = {
        "<cmd>" ..
        "Telescope find_files " ..
        "find_command=" ..
        "fd," ..
        "--type," ..
        "f," ..
        "--hidden," ..
        "--strip-cwd-prefix," ..
        "-E,*.pyc," ..
        "-E,.git/," ..
        "-E,node_modules," ..
        "-E,**/spec/**/*,"..
        "-E,**/*migration*/**/*," ..
        "-E,**/vendor/**/*," ..
        "-E,**/migrate/**/*," ..
        "-E,*.jpg,"..
        "-E,*.png,"..
        "-E,*.ttf" ..
        " prompt_prefix=💫" ..
        "<cr>",
        "Find application files"
      },
      O = {
        "<cmd>lua require('telescope.builtin').vim_options()<cr>",
        "vim options"
      },
      a = {
        "<cmd>lua require('telescope.builtin').autocommands()<cr>",
        "autocommands"
      },
      b = {
        "<cmd>lua require('telescope.builtin').buffers()<cr>",
        "open buffers"
      },
      c = {
        "<cmd>lua require('telescope.builtin').git_commits()<cr>",
        "git commits"
      },
      g = {
        "<cmd>lua require('telescope.builtin').live_grep()<cr>",
        "text in files"
      },
      t = {
        "<cmd>lua require('telescope.builtin').help_tags()<cr>",
        "help tags"
      },
      h = {
        "<cmd>lua require('telescope.builtin').highlights()<cr>",
        "highlights"
      },
      k = {
        "<cmd>lua require('telescope.builtin').keymaps()<cr>",
        "keymaps"
      },
      l = {
        "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
        "lines in buffer"
      },
      m = {
        "<cmd>lua require('telescope.builtin').man_pages()<cr>",
        "man pages"
      },
      o = {
        "<cmd>lua require('telescope.builtin').oldfiles()<cr>",
        "recent files"
      },
      T = {
        "<cmd>lua require('telescope.builtin').filetypes()<cr>",
        "filetypes"
      },
      p = {
        "<cmd>Telescope projects<cr>",
        "projects"
      },
    },
    v = {
      name = "+vim",
      r = { "<cmd>so ~/.config/nvim/init.lua<cr>", "reload config" },
      e = { "<cmd>edit ~/.config/nvim/init.lua<cr>", "edit config" },
      s = { "<cmd>PackerUpdate<cr>", "packer sync" },
      i = { "<cmd>PackerInstall<cr>", "packer install" },
      c = { "<cmd>PackerClean<cr>", "packer clean" },
      C = { "<cmd>PackerCompile<cr>", "packer compile" },
    },
    b = {
      name = "+buffer",
      s = { "<cmd>w<cr>", "write" },
      d = { "<cmd>Bdelete<cr>", "delete buffer" },
      D = { "<cmd>Bdelete!<cr>", "force delete buffer" },
      c = { "<cmd>windo diffthis<cr>", "diff buffer" },
      C = { "<cmd>windo diffoff<cr>", "diff off" },
      r = { "<cmd>edit!<cr>", "reload buffer" },
      w = { [[<cmd>%s/\s\+$//e<cr>]], "trim trailing whitespace" }
    },
    w = {
      name = "+window",
      v = { "<cmd>vsp<cr>", "split vertically" },
      s = { "<cmd>sp<cr>", "split horizontally" },
      k = { "10<C-w>+", "increase size" },
      j = { "10<C-w>-", "decrease size" },
      r = { "<C-w>r", "rotate windows" },
      o = { "<C-w>o", "delete other windows" },
      e = { "<C-w>=", "equalize windows" },
      V = { "<C-w>H", "to vertical split" },
      S = { "<C-w>J", "to horizontal split" },
    },
    i = {
      name = "+interface",
      ["%"] = {
        "<cmd>set invrelativenumber<cr>",
        "toggle relative line numbers"
      },
      ["#"] = { "<cmd>set invnumber<cr>", "toggle line numbers" },
      l = { "<cmd>IndentBlanklineToggle<cr>", "toggle indentation lines" },
      c = { "<cmd>nohlsearch<cr>", "clear search highlight" },
      h = { "<cmd>ColorizerAttachToBuffer<cr>", "colorize buffer" },
      t = { "<cmd>NvimTreeToggle<cr>", "toggle tree" }
    },
    g = {
      name = "+git",
      s = { "<cmd>Git<cr>", "git status" },
      b = { "<cmd>Git blame<cr>", "git blame" },
      n = { "<cmd>lua require('gitsigns').next_hunk()<cr>", "next hunk" },
      p = { "<cmd>lua require('gitsigns').previous_hunk()<cr>", "previous hunk" },
      t = { "<cmd>diffget //2<cr>", "get diff from target buffer" },
      m = { "<cmd>diffget //3<cr>", "get diff from merge bugger" },
      d = { "<cmd>Gvdiff<cr>", "git diff" },
      r = { "<cmd>Gvdiffsplit!", "git 3-way diff" },
      c = { "<cmd>Git commit<cr>", "git commit" }
    },
    o = {
      name = "+org",
      a = { "agenda" },
      c = { "capture" },
      r = { "refile" },
      o = { "open at point" },
      K = { "move subtree up" },
      J = { "move subtree down" },
      e = { "export" },
      k = { "capture kill" },
      t = { "set tags" },
      A = { "archive tag" },
      ["'"] = { "edit special" },
      ["$"] = { "archive subtree" },
      [","] = { "priority" },
      ["*"] = { "toggle heading" },
      i = {
        name = "+insert",
        h = { "insert heading at same level" },
        T = { "insert todo header" },
        t = { "insert todo header at same level" },
        ["."] = { "time stamp" },
        s = { "schedule" },
        ["!"] = { "time stamp inactive" },
        d = { "deadline" },
      },
      x = {
        name = "+clock",
        i = { "clock in" },
        o = { "clock out" },
        q = { "cancel clock" },
        j = { "go to clock" },
        e = { "set effort" },
      }
    }
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
