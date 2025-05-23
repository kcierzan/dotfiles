local lib = require("lib")

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local wk = require("which-key")
      local normal_mode_mappings = {
        { "<leader>a", group = "+ai" },
        { "<leader>b", group = "+buffer" },
        { "<leader>d", group = "+debug" },
        { "<leader>f", group = "+find" },
        { "<leader>g", group = "+git" },
        { "<leader>i", group = "+interface" },
        { "<leader>l", group = "+lsp" },
        { "<leader>o", group = "+filetree" },
        { "<leader>t", group = "+test" },
        { "<leader>v", group = "+vim" },
        { "<leader>w", group = "+window" },
        {
          "<leader>q",
          lib.ex_cmd("silent wq"),
          desc = "save and quit",
        },
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
        {
          "<leader>ve",
          lib.ex_cmd("edit ~/.config/nvim/init.lua"),
          desc = "edit init.lua",
        },
        { "<leader>vp", lib.ex_cmd("Lazy"), desc = "plugins" },
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
        {
          "<leader>ii",
          lib.ex_cmd("Inspect"),
          desc = "show highlight under cursor",
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
        {
          "<leader>iL",
          lib.ex_cmd("set cursorline"),
          desc = "toggle cursorline",
        },
        {
          "<leader>vR",
          lib.ex_cmd("Lazy reload armonk"),
          desc = "reload armonk colorscheme",
        },
      }
      wk.add(normal_mode_mappings)
      wk.setup({
        preset = "helix",
        win = {
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        },
      })
    end,
  },
}
