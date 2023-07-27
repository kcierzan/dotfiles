return {
  {
    "tpope/vim-projectionist",
    lazy = false,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-\\>" },
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      open_mapping = "<C-\\>",
      persist_mode = true,
    },
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
        output = {
          open_on_run = false
        },
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
    cmd = {
      "Git",
      "GBrowse",
      "GDelete",
      "GMove",
      "Gread",
      "Gwrite",
      "Gvdiffsplit",
      "Gdiffsplit",
      "Gedit",
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "folke/tokyonight.nvim" },
    config = function()
      local tn_colors = require("tokyonight.colors").setup()

      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = tn_colors.red, bg = tn_colors.bg_dark })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = tn_colors.blue, bg = tn_colors.bg_dark })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = tn_colors.green, bg = tn_colors.bg_dark })

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
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = { "Neotree" },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        sort_case_insensitive = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_by_name = { "node_modules" },
            never_show = { ".DS_STORE" },
          },
        },
      })
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    config = true,
  },
}
