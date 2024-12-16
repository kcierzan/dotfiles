return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading is handled by the plugin
  dependencies = {
    "rafamadriz/friendly-snippets",
    "mikavilpas/blink-ripgrep.nvim",
    "L3MON4D3/LuaSnip",
  },
  version = "v0.*",
  opts = {
    completion = {
      menu = {
        draw = {
          -- styled to look mostly like nvim-cmp
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", gap = 1 } },
        },
      },
      list = {
        selection = "auto_insert",
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
      ["<C-k>"] = { "show", "show_docmentation", "hide_documentation" },
    },
    snippets = {
      expand = function(snippet)
        require("luasnip").lsp_expand(snippet)
      end,
      active = function(filter)
        if filter and filter.direction then
          return require("luasnip").jumpable(filter.direction)
        end
        return require("luasnip").in_snippet()
      end,
      jump = function(direction)
        require("luasnip").jump(direction)
      end,
    },
    sources = {
      completion = {
        enabled_providers = {
          "codecompanion",
          "lsp",
          "path",
          "luasnip",
          "snippets",
          "buffer",
          "ripgrep",
        },
      },
      providers = {
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          opts = {
            prefix_min_length = 3,
            context_size = 5,
            max_filesize = "1M",
          },
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
