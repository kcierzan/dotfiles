return {
  "zbirenbaum/copilot.lua",
  dependencies = { "copilotlsp-nvim/copilot-lsp" },
  enabled = true,
  event = "VeryLazy",
  cmd = "Copilot",
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    nes = {
      enabled = false,
    },
  },
}
