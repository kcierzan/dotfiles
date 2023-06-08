return {
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "v", "V" },
    config = true,
  },
  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs", "v", "V" },
    config = true,
  },
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
    },
  },
  {
    "tpope/vim-repeat",
    keys = { "." },
  },
  {
    "chrisbra/csv.vim",
    ft = { "csv" },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "BufReadPost",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            -- automatically jump forward to textobj
            lookahead = true,
            keymaps = {
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
        },
      })
    end,
  },
}
