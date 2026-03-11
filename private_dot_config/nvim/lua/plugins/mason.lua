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
      ensure_installed = {
        -- Formatters/linters
        "stylua",
        "erb-lint",
        "erb-formatter",
        "prettierd",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_enable = false,
      automatic_installation = true,
      ensure_installed = {
        "bash-language-server",
        "biome",
        "clangd",
        "copilot-language-server",
        "css-lsp",
        "elixir-ls",
        "emmet-language-server",
        "golangci-lint-langserver",
        "gopls",
        "harper-ls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "nil",
        "nushell",
        "rust-analyzer",
        "svelte-language-server",
        "tailwindcss-language-server",
        "typos-lsp",
        "vtsls",
      },
    },
  },
}
