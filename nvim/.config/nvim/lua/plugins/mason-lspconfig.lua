return {
  "williamboman/mason-lspconfig.nvim",
  lazy = true,
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "bashls",
        "tsserver",
        "jsonls",
        "rust_analyzer",
        "ruby_ls",
        "lua_ls",
        -- "emmet_ls"
      }
    })
  end
}
