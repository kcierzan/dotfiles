return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
      })

      local servers = {
        "bashls",
        "emmet_ls",
        "jsonls",
        "lua_ls",
        "pyright",
        "ruby_ls",
        "rust_analyzer",
        "solargraph",
        "tsserver",
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
              symbols = true,
            },
          }
          opts.root_dir = require("lspconfig").util.root_pattern("Gemfile")
        elseif server == "lua_ls" then
          opts.settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "awesome", "hs" },
              },
            },
          }
        end

        lspconfig[server].setup(opts)
      end
    end,
  },
  {
    "glepnir/lspsaga.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    enabled = false,
    branch = "main",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        outline = {
          auto_preview = false,
        },
        symbols_in_winbar = {
          in_custom = true,
        },
      })
    end,
  },
  {
    "ray-x/guihua.lua",
    build = "cd lua/fzy && make"
  },
  {
    "ray-x/navigator.lua",
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
    event = "LspAttach",
    config = function()
      require("navigator").setup({
        width = 0.75,
        height = 0.3,
        preview_height = 0.35,
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        default_mapping = false,
        treesitter_analysis = true,
        treesitter_navigation = true,
        mason = true,
        lsp = {
          code_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
            format_on_save = true,
            format_options = {
              async = true
            },
            hover = {
              enable = true,
              keymap = {
                gh = {
                  default = function()
                    local w = vim.fn.expand("<cWORD>")
                    vim.lsp.buf.workspace_symbol(w)
                  end
                }
              }
            },
          }
        }
      })
    end
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    event = "BufReadPost",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "emmet_ls",
          "jsonls",
          "lua_ls",
          "pyright",
          "ruby_ls",
          "rust_analyzer",
          "solargraph",
          "tsserver",
        },
      })
    end,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LspAttach",
    config = function()
      require("trouble").setup()
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "LspAttach",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.diagnostics.ruff,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
        },
      })
    end,
  },
}
