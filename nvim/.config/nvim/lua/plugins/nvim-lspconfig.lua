return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true
    })

    local servers = {
      "bashls",
      "tsserver",
      "jsonls",
      "rust_analyzer",
      "lua_ls",
      "ruby_ls",
      "emmet_ls"
    }

    -- for _, server in ipairs(servers) do
    --   lspconfig.server.setup()
    -- end
  end
}
