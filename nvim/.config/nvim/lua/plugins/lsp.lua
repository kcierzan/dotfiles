return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
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
        "solargraph",
        "ruby_ls",
        "rust_analyzer",
        "lua_ls",
        "emmet_ls"
      }

      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        if server == "ruby_ls" then
          opts.cmd = { "bundle", "exec", "ruby-lsp" }
          opts.root_dir = require("lspconfig").util.root_pattern("Gemfile")
        elseif server == "solargraph" then
          opts.cmd = { "bundle", "exec", "solargraph", "stdio" }
          opts.filetypes = { "ruby" }
          opts.flags = { debounce_text_changes = 150 }
          opts.settings = {
            solargraph = {
              autoformat = true,
              completion = true,
              diagnostic = true,
              references = true,
              rename = true,
              symbols = true
            }
          }
          opts.root_dir = require("lspconfig").util.root_pattern("Gemfile")
        elseif server == "lua_ls" then
          opts.settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "awesome", "hs" }
              }
            }
          }
        end

        lspconfig[server].setup(opts)
      end
    end
  },
  {
    "glepnir/lspsaga.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    branch = "main",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup()
    end
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "BufReadPost",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "tsserver",
          "jsonls",
          "rust_analyzer",
          "ruby_ls",
          "solargraph",
          "lua_ls",
          "emmet_ls"
        }
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LspAttach",
    config = function()
      require("trouble").setup()
    end
  }
}
