return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  config = true,
  keys = require("keymaps").for_plugin("sidekick"),
}
