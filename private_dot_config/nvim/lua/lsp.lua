local M = {}

function M.setup()
  local enabled_lsp_servers = {
    "bashls",
    "biome",
    "clangd",
    "copilot",
    "cssls",
    "elixirls",
    "emmet_language_server",
    "golangci_lint_ls",
    "gopls",
    "html",
    -- "jsonls",
    "lua_ls",
    "nil_ls",
    "marksman",
    "nushell",
    "postgres_lsp",
    -- "basedpyright",
    "rust_analyzer",
    "svelte",
    "tailwindcss",
    "templ",
    "ty",
    "typos_lsp",
    "vtsls",
    "vscode-html-language-server",
    "vscode-css-language-server",
    "vscode-json-language-server",
    "zls",
  }

  vim.lsp.config("vscode-html-language-server", {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "templ", "eruby" },
  })

  vim.lsp.config("vscode-html-css-language-server", {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
  })

  vim.lsp.config("vscode-json-language-server", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
  })

  vim.lsp.config("rust_analyzer", {
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
      },
    },
  })
  vim.lsp.config("biome", {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "css" },
  })
  vim.lsp.config("elixirls", {
    cmd = { "elixir-ls" },
  })
  vim.lsp.config("emmet_language_server", {
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
  })
  vim.lsp.config("html", {
    filetypes = { "html", "templ" },
    capabilities = {
      documentFormattingProvider = false,
      documentRangeFormattingProvider = false,
    },
  })
  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        diagnostics = { globals = { "vim", "awesome", "hs", "Snacks" } },
        hint = {
          arrayIndex = "Disable",
        },
      },
    },
  })
  vim.lsp.config("nil_ls", {
    settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = true,
          },
        },
      },
    },
  })

  vim.lsp.config("zls", {
    filetypes = { "zig", "zon" },
    cmd = { "zls", "--config-path", "~/.config/zls/zls.json" },
    root_markers = { "build.zig" },
    settings = {
      zls = {
        enable_build_on_save = true,
      }
    }
  })
  -- Ruby LSPs with mise - started manually via autocommand
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ruby", "eruby" },
    callback = function(args)
      local bufnr = args.buf
      local fname = vim.api.nvim_buf_get_name(bufnr)

      local gemfile_root = vim.fs.root(fname, { "Gemfile" })

      -- Start ruby-lsp (global gem via mise)
      if gemfile_root then
        vim.lsp.start({
          name = "ruby_lsp",
          cmd = { "mise", "x", "-C", gemfile_root, "--", "ruby-lsp" },
          root_dir = gemfile_root,
          init_options = { formatter = "auto" },
        }, { bufnr = bufnr })
      end
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ruby" },
    callback = function(args)
      local bufnr = args.buf
      local fname = vim.api.nvim_buf_get_name(bufnr)
      local sorbet_root = vim.fs.root(fname, { "sorbet" })

      if sorbet_root then
        vim.lsp.start({
          name = "sorbet",
          cmd = { "mise", "x", "-C", sorbet_root, "--", "bundle", "exec", "srb", "typecheck", "--lsp" },
          root_dir = sorbet_root,

        }, { bufnr = bufnr })
      end
    end
  })


  vim.lsp.config("templ", {
    cmd = { "go", "tool", "templ", "lsp" },
  })
  vim.lsp.config("ty", {
    cmd = { "ty", "server" },
    filetypes = { "python" },
  })
  vim.lsp.config("vtsls", {
    capabilities = {
      documentFormattingProvider = false,
      documentRangeFormattingProvider = false,
    },
  })

  vim.lsp.config("copilot", {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "lua", "python", "go", "rust", "html", "css", "ruby", "eruby" },
  })

  -- enable the LSP servers
  vim.lsp.enable(enabled_lsp_servers)

  -- so nice, we enable it twice(???)
  vim.lsp.enable("copilot")

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
      end
    end,
  })

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
end

return M
