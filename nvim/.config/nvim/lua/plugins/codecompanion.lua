local lib = require("lib")

return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionToggle", "CodeCompanionActions", "CodeCompanionAdd" },
  keys = {
    { "<leader>ac", lib.ex_cmd("CodeCompanionChat"), desc = "open chat" },
    { "<leader>at", lib.ex_cmd("CodeCompanionChat Toggle"), desc = "toggle chat" },
    { "<leader>aa", lib.ex_cmd("CodeCompanionActions"), desc = "actions" },
    { "<leader>av", lib.ex_cmd("CodeCompanionChat Add"), desc = "add selection to chat", mode = "v" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "hrsh7th/nvim-cmp",
    {
      "stevearc/dressing.nvim",
      opts = {},
    },
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = "cmd:op read op://personal/Anthropic\\ API\\ Key/credential --no-newline",
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "anthropic",
      },
      inline = {
        adapter = "anthropic",
      },
      agent = {
        adapter = "anthropic",
      },
    },
  },
}
