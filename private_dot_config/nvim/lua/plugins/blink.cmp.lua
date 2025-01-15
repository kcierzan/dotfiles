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
        selection = { preselect = true, auto_insert = false },
      },
    },
    keymap = {
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.select_and_accept()
          else
            return cmp.select_next()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-c>"] = {
        "cancel",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.select_prev()
          end
        end,
        "snippet_backward",
        "fallback",
      },
      ["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-space>"] = {
        function(cmp)
          cmp.show({ providers = { "ripgrep" } })
        end,
      },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = {
        "codecompanion",
        "lsp",
        "path",
        "snippets",
        "buffer",
      },
      cmdline = {},
      providers = {
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
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
