return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading is handled by the plugin
  dependencies = {
    "rafamadriz/friendly-snippets",
    "mikavilpas/blink-ripgrep.nvim",
    -- FIXME: this shouldn't depend on a colorscheme
    "webhooked/kanso.nvim",
    "fang2hou/blink-copilot",
    { "L3MON4D3/LuaSnip", version = "v2.*" },
  },
  version = "*",
  opts = {
    fuzzy = {
      implementation = "prefer_rust",
    },
    completion = {
      menu = {
        -- border = "rounded",
        draw = {
          padding = { 0, 1 },
          components = {
            kind_icon = {
              text = function(ctx)
                return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
              end,
            },
          },
        },
        auto_show = function(ctx)
          return ctx.mode ~= "cmdline" or ctx.mode ~= "noice" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
        end,
      },
      list = {
        max_items = 100,
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
      keymap = { preset = "cmdline" },
    },
    sources = {
      default = {
        "codecompanion",
        "copilot",
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
            prefix_min_length = 5,
            context_size = 5,
            max_filesize = "300K",
            ignore_paths = {
              "~/",
            },
            future_features = {
              backend = {
                -- gitgrep may be faster for large repositories
                use = "ripgrep",
              },
            },
          },
          enabled = true,
        },
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
          enabled = true,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
          opts = {
            max_completions = 3,
          },
        },
      },
    },
  },
}
