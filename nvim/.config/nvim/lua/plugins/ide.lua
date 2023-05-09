return {
  {
    "tpope/vim-projectionist",
    lazy = false
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-\\>" },
    config = function()
      require("toggleterm").setup({ open_mapping = "<C-\\>" })
    end
  },
  {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Telescope" },
    config = function()
      require("project_nvim").setup({ manual_mode = false })
      require("telescope").load_extension("projects")
    end
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "olimorris/neotest-rspec" },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-rspec") },
        status = {
          signs = false,
          virtual_text = true
        }
      })
    end
  },
  {
    "f-person/git-blame.nvim",
    cmd = { "GitBlameToggle" },
  }
}
