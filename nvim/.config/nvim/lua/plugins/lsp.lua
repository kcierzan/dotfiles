return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
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
        "clangd",
        "bashls",
        "emmet_ls",
        "elixirls",
        "jsonls",
        "lua_ls",
        "pyright",
        "ruby_lsp",
        "rust_analyzer",
        -- "solargraph",
        "svelte",
        "tailwindcss",
        "tsserver",
      }

      for _, server in ipairs(servers) do
        local opts = { capabilities = capabilities }

        if server == "ruby_lsp" then
          opts.cmd = { "ruby-lsp" }
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
        elseif server == "elixirls" then
          opts.cmd = { vim.fn.expand("$HOME/.local/share/nvim/mason/packages/elixir-ls/language_server.sh") }
        elseif server == "emmet_ls" then
          opts.filetypes = {
            "astro",
            "css",
            "eruby",
            "heex",
            "html",
            "htmldjango",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "svelte",
            "typescriptreact",
            "vue",
          }
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
    build = "cd lua/fzy && make",
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
        treesitter_analysis = false,
        treesitter_navigation = true,
        mason = true,
        icons = {
          diagnostic_head = "󰃤",
          diagnostic_err = "",
          diagnostic_warn = "",
          diagnostic_info = "",
          diagnostic_hint = "",
          diagnostic_virtual_text = "󱁤",
        },
        lsp = {
          display_diagnostic_qf = false,
          code_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
            format_on_save = true,
            -- display_diagnostic_qf = "trouble",
            format_options = {
              async = true,
            },
          },
          code_lens_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
          },
          hover = {
            enable = true,
            keymap = {
              gh = {
                default = function()
                  local w = vim.fn.expand("<cWORD>")
                  vim.lsp.buf.workspace_symbol(w)
                end,
              },
            },
          },
        },
      })
    end,
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
    -- event = "VeryLazy",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "elixirls",
          "emmet_ls",
          "jsonls",
          "lua_ls",
          "pyright",
          "rust_analyzer",
          "tailwindcss",
          "svelte",
          "tsserver",
        },
      })
    end,
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    event = { "VeryLazy" },
    version = "*",
    config = true,
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "LspAttach",
    config = function()
      local trouble = require("trouble")
      trouble.setup({
        auto_open = false,
        auto_preview = false,
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = "LspAttach",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.stylua,
          -- null_ls.builtins.diagnostics.ruff,
          null_ls.builtins.diagnostics.rubocop.with({
            command = "bundle",
            args = {"exec", "rubocop", "-f", "json", "--force-exclusion", "--stdin", "$FILENAME"}
          }),
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.prettier,
        },
      })
    end,
  },
}
