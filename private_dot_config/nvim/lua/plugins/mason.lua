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
      automatic_enable = false,
      automatic_installation = false,
      ensure_installed = {
        "bash-language-server",
        "css-lsp",
        "elixir-ls",
        "emmet-language-server",
        "golangci-lint-langserver",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "rust-analyzer",
        "svelte-language-server",
        "tailwindcss-language-server",
        "typos-lsp",
        "vtsls",
      },
    },
  },
}
