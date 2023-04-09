return {
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "v", "V" },
    config = function()
      require("Comment").setup()
    end
  },
  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs", "v", "V" },
    config = function()
      require("nvim-surround").setup()
    end
  },
  {
    "ggandor/leap.nvim",
    keys = { "s", "S" },
    config = function()
      require("leap").add_default_mappings()
    end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  {
    "tpope/vim-repeat",
    keys = { "." }
  }
}
