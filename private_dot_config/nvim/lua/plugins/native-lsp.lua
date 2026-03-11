-- LSP configuration — Mason ensures servers are installed,
-- lsp.lua (vim.lsp.config/enable) handles the actual configuration.
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
  },
  lazy = false,
}
