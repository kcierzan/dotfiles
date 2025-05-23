return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading is handled by the plugin
  dependencies = {
    "rafamadriz/friendly-snippets",
    "mikavilpas/blink-ripgrep.nvim",
    { "L3MON4D3/LuaSnip", version = "v2.*" },
  },
  version = "*",
  opts = {
    fuzzy = {
      implementation = "prefer_rust",
    },
    completion = {
      menu = {
        draw = {
          -- styled to look mostly like nvim-cmp
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
        },
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or ctx.mode ~= "noice" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
      },
      list = {
        selection = { preselect = false, auto_insert = true },
      },
    },
    keymap = {
      ["<Tab>"] = {
        "select_next",
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        "select_prev",
        "snippet_backward",
        "fallback",
      },
      ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-g>"] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-Space>"] = { "show" },
      ["<C-A-Space>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
    },
    snippets = { preset = "luasnip" },
    cmdline = {
      keymap = { preset = "inherit" },
      completion = { menu = { auto_show = true } },
    },
    sources = {
      default = {
        "codecompanion",
        "lsp",
        "path",
        "snippets",
        "buffer",
        "ripgrep",
      },
      providers = {
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          async = true,
          max_items = 3,
          opts = {
            prefix_min_length = 3,
            context_size = 5,
            max_filesize = "300K",
          },
          enabled = true,
        },
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
          enabled = true,
        },
      },
    },
  },
}
