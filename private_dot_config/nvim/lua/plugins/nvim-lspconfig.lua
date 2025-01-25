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
      "bashls",
      "emmet_ls",
      "elixirls",
      "gopls",
      "golangci_lint_ls",
      "jsonls",
      "lua_ls",
      "nushell",
      "pyright",
      "ruby_lsp",
      "rust_analyzer",
      "svelte",
      "tailwindcss",
      "sorbet",
      "vtsls",
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
              globals = { "vim", "awesome", "hs", "Snacks" },
            },
          },
        }
      end

      lspconfig[server].setup(opts)
    end
  end,
}
