return {
  {
    "tpope/vim-projectionist",
    lazy = false,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-\\>" },
    cmd = { "ToggleTerm" },
    config = function()
      require("toggleterm").setup({ open_mapping = "<C-\\>" })
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    enabled = false,
    event = { "BufReadPost" },
    config = function()
      require("project_nvim").setup({ manual_mode = false })
      require("telescope").load_extension("projects")
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "olimorris/neotest-rspec" },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-rspec") },
        status = {
          signs = false,
          virtual_text = true,
        },
      })
    end,
  },
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    cmd = { "Git", "GBrowse", "GDelete", "GMove", "Gread", "Gwrite", "Gvdiffsplit", "Gdiffsplit", "Gedit" },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
      )
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
    end,
  },
  {
    "suketa/nvim-dap-ruby",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "ruby", "eruby" },
    config = function()
      require("dap-ruby").setup()
    end,
  },
}
