return {
  {
    "tpope/vim-projectionist",
    lazy = false,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-\\>" },
    cmd = { "ToggleTerm" },
    opts = { open_mapping = "<C-\\>" },
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
    dependencies = { "folke/tokyonight.nvim" },
    config = function()
      local tn_colors = require("tokyonight.colors").setup()

      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = tn_colors.red, bg = tn_colors.bg })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = tn_colors.blue, bg = tn_colors.bg })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = tn_colors.green, bg = tn_colors.bg })

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
    config = true,
  },
  {
    "suketa/nvim-dap-ruby",
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "ruby", "eruby" },
    config = true,
  },
}
