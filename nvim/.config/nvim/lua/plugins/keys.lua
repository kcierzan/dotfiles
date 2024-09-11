local lib = require("lib")

return {
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    -- TODO: This doesn't appear to recognize the new style of which-key keybindings
    "mrjones2014/legendary.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    keys = {
      {
        "<leader>?",
        lib.ex_cmd("Legendary"),
        desc = "search commands",
      },
    },
    enabled = true,
    lazy = false,
    priority = 10000,
    config = function()
      require("legendary").setup({
        extensions = {
          lazy_nvim = true,
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local wk = require("which-key")
      local normal_mode_mappings = {
        {
          "<leader>q",
          lib.ex_cmd("silent wq"),
          desc = "save and quit",
        },
        -- LSP
        { "<leader>l", group = "+lsp" },
        {
          "<leader>lF",
          vim.lsp.buf.format,
          desc = "format buffer",
        },
        { "<leader>lI", lib.ex_cmd("LspInfo"), desc = "info" },
        { "<leader>lL", lib.ex_cmd("LspLog"), desc = "log" },
        {
          "<leader>la",
          lib.ex_cmd("lua vim.lsp.buf.code_action()"),
          desc = "code action",
        },
        {
          "<leader>lo",
          lib.ex_cmd("LspSymbols"),
          desc = "toggle outline",
        },
        { "<leader>lq", lib.ex_cmd("LspRestart"), desc = "restart" },
        { "<leader>lr", lib.ex_cmd("lua vim.lsp.buf.rename()"), desc = "rename" },
        { "<leader>ls", lib.ex_cmd("LspStart"), desc = "start" },
        -- Find
        { "<leader>f", group = "+find" },
        -- Find -> Rails
        -- Vim
        { "<leader>v", group = "+vim" },
        {
          "<leader>ve",
          lib.ex_cmd("edit ~/.config/nvim/init.lua"),
          desc = "edit init.lua",
        },
        { "<leader>vp", lib.ex_cmd("Lazy"), desc = "plugins" },
        { "<leader>vt", lib.ex_cmd("Mason"), desc = "tools" },
        -- Buffer
        { "<leader>b", desc = "+buffer" },
        { "<leader>bC", lib.ex_cmd("window diffoff"), desc = "diff off" },
        { "<leader>bc", lib.ex_cmd("window diffthis"), desc = "diff on" },
        {
          "<leader>bf",
          lib.ex_cmd('silent exec "!bundle exec rubocop -A %:p"'),
          desc = "run rubocop on buffer",
        },
        { "<leader>br", lib.ex_cmd("edit!"), desc = "reload" },
        { "<leader>bs", lib.ex_cmd("silent! w"), desc = "write" },
        {
          "<leader>bw",
          lib.ex_cmd("%s/\\s\\+$//e"),
          desc = "trim trailing whitespace",
        },
        { "<leader>by", lib.ex_cmd('let @+ = expand("%:p")'), desc = "yank name" },
        -- Window
        { "<leader>w", group = "+window" },
        {
          "<leader>wS",
          "<C-w>J",
          desc = "to horizontal split",
        },
        {
          "<leader>wV",
          "<C-w>H",
          desc = "to vertical split",
        },
        {
          "<leader>we",
          "<C-w>=",
          desc = "equalize windows",
        },
        {
          "<leader>wj",
          "10<C-w>-",
          desc = "decrease size",
        },
        {
          "<leader>wk",
          "10<C-w>+",
          desc = "increase size",
        },
        {
          "<leader>wo",
          "<C-w>o",
          desc = "delete other windows",
        },
        {
          "<leader>wr",
          "<C-w>r",
          desc = "rotate windows",
        },
        {
          "<leader>ws",
          lib.ex_cmd("sp"),
          desc = "split horizontal",
        },
        {
          "<leader>wv",
          lib.ex_cmd("vsp"),
          desc = "split vertical",
        },
        {
          "<leader>wq",
          "<C-w>q",
          desc = "close split",
        },
        -- Interface
        { "<leader>i", group = "+interface" },
        {
          "<leader>iF",
          lib.ex_cmd("NvimTreeFindFile"),
          desc = "show current file in tree",
        },
        {
          "<leader>iH",
          lib.ex_cmd("TSHighlightCapturesUnderCursor"),
          desc = "show highlights under cursor",
        },
        {
          "<leader>i#",
          lib.ex_cmd("set invnumber"),
          desc = "toggle line numbers",
        },
        {
          "<leader>i%",
          lib.ex_cmd("set invrelativenumber"),
          desc = "toggle relative line numbers",
        },
        {
          "<leader>ic",
          lib.ex_cmd("nohlsearch"),
          desc = "clear search highlight",
        },
        {
          "<leader>iL",
          lib.ex_cmd("set cursorline"),
          desc = "toggle cursorline",
        },
        -- Filetree
        { "<leader>o", group = "+filetree" },
        {
          "<leader>iL",
          lib.ex_cmd("set cursorline"),
          desc = "toggle cursorline",
        },
        -- Test
        { "<leader>t", group = "+test" },
        -- Git
        { "<leader>g", group = "+git" },
        -- Debug
        { "<leader>d", group = "+debug" },
      }
      wk.add(normal_mode_mappings)
      wk.setup({
        win = {
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        },
      })
    end,
  },
}
