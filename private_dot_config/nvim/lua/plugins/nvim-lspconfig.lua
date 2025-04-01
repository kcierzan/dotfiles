return {
  "neovim/nvim-lspconfig",
  ft = {
    "bash",
    "css",
    "elixir",
    "eruby",
    "go",
    "heex",
    "html",
    "json",
    "lua",
    "markdown",
    "nu",
    "python",
    "ruby",
    "rust",
    "sh",
    "templ",
    "typescript",
    "zsh",
  },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    -- force loading these first
    require("mason")
    require("mason-lspconfig")

    local lspconfig = require("lspconfig")
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
    })

    local servers = {
      "clangd",
      "cssls",
      "bashls",
      "emmet_language_server",
      "elixirls",
      "gopls",
      "golangci_lint_ls",
      "html",
      "jsonls",
      "lua_ls",
      "nushell",
      "pyright",
      "ruby_lsp",
      "rust_analyzer",
      "svelte",
      "templ",
      "typos_lsp",
      "tailwindcss",
      "sorbet",
      "vtsls",
    }

    for _, server in ipairs(servers) do
      local opts = { capabilities = capabilities }

      if server == "ruby_lsp" then
        opts.cmd = { "ruby-lsp" }
        opts.root_dir = require("lspconfig").util.root_pattern("Gemfile")
      elseif server == "templ" then
        -- this is the command if templ is installed via `go get -tool`
        opts.cmd = { "go", "tool", "templ", "lsp" }
      elseif server == "html" then
        opts.filetypes = { "html", "templ" }
        opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
      elseif server == "emmet_language_server" then
        opts.filetypes = {
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
        }
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
      elseif server == "lua_ls" then
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "awesome", "hs", "Snacks" },
            },
          },
        }
      end

      lspconfig[server].setup(opts)
    end
  end,
}
