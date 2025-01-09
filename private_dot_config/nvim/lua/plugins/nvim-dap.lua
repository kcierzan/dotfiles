local lib = require("lib")

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "suketa/nvim-dap-ruby" },
    keys = {
      { "<leader>db", lib.ex_cmd("lua require('dap').toggle_breakpoint()"), desc = "toggle breakpoint" },
      { "<leader>dc", lib.ex_cmd("lua require('dap').continue()"), desc = "continue" },
      { "<leader>do", lib.ex_cmd("lua require('dap').step_over()"), desc = "step over" },
      { "<leader>di", lib.ex_cmd("lua require('dap').step_into()"), desc = "step into" },
      { "<leader>du", lib.ex_cmd("lua require('dapui').toggle()"), desc = "toggle UI" },
      { "<leader>dr", lib.ex_cmd("lua require('dap').repl.toggle()"), desc = "toggle repl" },
      { "<leader>dt", lib.ex_cmd("lua require('neotest').run.run({ strategy = 'dap'})"), desc = "debug test" },
      {
        "<leader>df",
        lib.ex_cmd(
          "lua require('dapui').float_element('repl', { height = 40, width = 140, position = 'center', enter = true })"
        ),
        desc = "toggle floating repl",
      },
    },
    config = function()
      require("dap-ruby").setup()
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
    enabled = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = true,
  },
}
