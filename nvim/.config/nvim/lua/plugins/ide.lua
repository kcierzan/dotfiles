return {
  {
    "tpope/vim-projectionist",
    lazy = false,
  },
  {
    "akinsho/toggleterm.nvim",
    keys = { "<C-;>" },
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      open_mapping = "<C-;>",
      persist_mode = true,
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = { "olimorris/neotest-rspec", "jfpedroza/neotest-elixir" },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-rspec"), require("neotest-elixir") },
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
    config = function()
      local lib = require("lib")
      local red = lib.get_hl_group_colors("Error").fg
      local bg_dark = lib.get_hl_group_colors("Cursorline").bg
      local blue = lib.get_hl_group_colors("@function").fg
      local green = lib.get_hl_group_colors("@character").fg


      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = red, bg = bg_dark })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = blue, bg = bg_dark })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = green, bg = bg_dark })

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "󰝥", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "󰟃", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
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
