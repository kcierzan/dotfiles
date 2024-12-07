local lib = require("lib")

return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    keys = {
      { "<leader>vt", lib.ex_cmd("Mason"), desc = "tools" },
    },
    opts = {
      ensure_installed = { "stylua", "erb-lint", "erb-formatter" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "elixirls",
        "emmet_ls",
        "gopls",
        "golangci_lint_ls",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "tailwindcss",
        "svelte",
        "vtsls",
      },
    },
  },
}
