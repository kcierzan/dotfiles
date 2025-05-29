local lib = require("lib")

local function explain()
  require("codecompanion").prompt("explain")
end

vim.cmd.cab("cc", "CodeCompanion")

return {
  "olimorris/codecompanion.nvim",
  cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionToggle", "CodeCompanionActions", "CodeCompanionAdd" },
  keys = {
    { "<leader>ac", lib.ex_cmd("CodeCompanionChat"), desc = "open chat" },
    { "<leader>at", lib.ex_cmd("CodeCompanionChat Toggle"), desc = "toggle chat" },
    { "<leader>aa", lib.ex_cmd("CodeCompanionActions"), desc = "actions" },
    { "<leader>av", lib.ex_cmd("CodeCompanionChat Add"), desc = "add selection to chat", mode = "v" },
    { "<leader>ae", explain, desc = "explain this", mode = "v" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/snacks.nvim",
  },
  opts = {
    adapters = {
      anthropic = function()
        return require("codecompanion.adapters").extend("anthropic", {
          env = {
            api_key = "ANTHROPIC_API_KEY",
          },
        })
      end,
    },
    strategies = {
      chat = {
        adapter = "anthropic",
        keymaps = {
          completion = {
            modes = {
              -- codecompanion does not yet play nicely with blink.cmp
              -- so completion must be triggered manually
              i = "<Tab>",
            },
          },
        },
        slash_commands = {
          ["file"] = {
            opts = {
              provider = "snacks",
            },
          },
          ["buffer"] = {
            opts = {
              provider = "snacks",
            },
          },
        },
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
