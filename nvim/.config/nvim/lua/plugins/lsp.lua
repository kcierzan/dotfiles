return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "glepnir/lspsaga.nvim",
      "hrsh7th/cmp-nvim-lsp"
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

      for _, server in ipairs(servers) do
        lspconfig[server].setup({ capabilities = capabilities })
      end
    end
  },
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup()
    end
  },
  {
    "williamboman/mason.nvim",
    build = "MasonUpdate",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "UIEnter",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "tsserver",
          "jsonls",
          "rust_analyzer",
          "ruby_ls",
          "lua_ls",
          "emmet_ls"
        }
      })
    end
  }
}
