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
    enabled = false,
    keys = { "s", "S" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
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
    event = "VeryLazy",
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
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "eruby",
      "glimmer",
      "handlebars",
      "hbs",
      "heex",
      "html",
      "javascript",
      "javascriptreact",
      "jsx",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "tsx",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
    },
    opts = {
      filetypes = {
        "astro",
        "eruby",
        "glimmer",
        "handlebars",
        "hbs",
        "heex",
        "html",
        "javascript",
        "javascriptreact",
        "jsx",
        "markdown",
        "php",
        "rescript",
        "svelte",
        "tsx",
        "typescript",
        "typescriptreact",
        "vue",
        "xml",
      },
    },
  },
}
