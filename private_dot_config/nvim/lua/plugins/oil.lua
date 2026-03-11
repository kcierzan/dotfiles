return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  cmd = { "Oil" },
  keys = require("keymaps").for_plugin("oil"),
  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
}
