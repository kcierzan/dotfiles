-- Modern LSP configuration using nvim-lspconfig
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "saghen/blink.cmp",
  },
  ft = {
    "bash",
    "css",
    "elixir",
    "eruby",
    "go",
    "heex",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "markdown",
    "nu",
    "python",
    "ruby",
    "rust",
    "sh",
    "sql",
    "templ",
    "typescript",
    "typescriptreact",
    "zsh",
  },
  config = function()
    -- Setup Mason first
    require("mason").setup()

    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Modern diagnostic configuration
    vim.diagnostic.config({
      virtual_text = false,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "●",
          [vim.diagnostic.severity.WARN] = "●",
          [vim.diagnostic.severity.INFO] = "●",
          [vim.diagnostic.severity.HINT] = "●",
        },
      },
      underline = true,
      float = {
        border = "rounded",
        source = true,
      },
      severity_sort = true,
    })

    -- Ensure sign column is always shown
    vim.opt.signcolumn = "yes"

    -- Global LSP on_attach
    local on_attach = function(client, bufnr)
      -- Enable inlay hints if supported
      if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    -- Configure servers with lspconfig defaults + custom options
    local servers = {
      bashls = {},
      biome = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "css" },
      },
      clangd = {},
      cssls = {},
      elixirls = {
        cmd = { vim.fn.expand("$HOME/.local/share/nvim/mason/packages/elixir-ls/language_server.sh") },
      },
      emmet_language_server = {
        filetypes = {
          "css",
          "eruby",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "sass",
          "scss",
          "typescriptreact",
          "pug",
          "templ",
        },
      },
      golangci_lint_ls = {},
      gopls = {},
      html = {
        filetypes = { "html", "templ" },
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if vim.bo[bufnr].filetype == "templ" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end,
      },
      jsonls = {},
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim", "awesome", "hs", "Snacks" } },
          },
        },
      },
      nushell = {},
      postgres_lsp = {},
      basedpyright = {},
      ruby_lsp = {
        cmd = { "ruby-lsp" },
        root_dir = lspconfig.util.root_pattern("Gemfile"),
      },
      rust_analyzer = {},
      sorbet = {},
      svelte = {},
      tailwindcss = {},
      templ = {
        cmd = { "go", "tool", "templ", "lsp" },
      },
      typos_lsp = {},
      vtsls = {
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      },
    }

    -- Configure servers with lspconfig (autostart enabled)
    for server, config in pairs(servers) do
      local final_config = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = config.on_attach or on_attach,
      }, config)

      lspconfig[server].setup(final_config)
    end
  end,
}
