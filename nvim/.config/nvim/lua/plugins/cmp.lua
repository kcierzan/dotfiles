return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "windwp/nvim-autopairs",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/cmp-treesitter",
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip"
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local lspkind = require("lspkind")
      local luasnip = require("luasnip")
      local compare = cmp.config.compare
      local border = {
        { "╭", "CmpBorder" },
        { "─", "CmpBorder" },
        { "╮", "CmpBorder" },
        { "│", "CmpBorder" },
        { "╯", "CmpBorder" },
        { "─", "CmpBorder" },
        { "╰", "CmpBorder" },
        { "│", "CmpBorder" }
      }
      local autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", autopairs.on_confirm_done({ map_char = { tex = ""}}))

      local function has_words_before()
        local line,col = unpack(vim.api.nvim_win_get_cursor(0))
        local before = vim.api.nvim_buf_get_lines(0, line - 1, line, true)
        local lines_before = before[1]:sub(col, col):match("%s")

        return col ~= 0 and lines_before == nil
      end

      local function tab_func(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local function s_tab_func(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      local function ctrl_n(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end

      local function ctrl_p(fallback)
        if luasnip.expand_or_jumpable() then
          luasnip.jump(-1)
        else
          fallback()
        end
      end

      local mapping = {
        ["<Tab>"] = cmp.mapping(tab_func, {"i", "s", "c"}),
        ["<S-Tab>"] = cmp.mapping(s_tab_func, {"i", "s", "c"}),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-n>"] = cmp.mapping(ctrl_n, {"i", "s", "c"}),
        ["<C-p>"] = cmp.mapping(ctrl_p, {"i", "s", "c"})
      }

      local function telescope_buffer()
        return vim.bo.ft == "TelescopePrompt"
      end

      local function popup_buffer()
        return string.find(vim.api.nvim_buf_get_name(0), "s_popup:/")
      end

      local function comment()
        local context = require("cmp.config.context")
        return context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
      end

      local sources = {
        {
          name = "buffer",
          priority = 700
        },
        {
          name = "treesitter",
          priority = 750
        },
        {
          name = "path",
          priority = 500
        },
        {
          name = "rg",
          priority = 600
        },
        {
          name = "calc",
          priority = 900
        },
        {
          name = "nvim_lsp",
          priority = 900
        },
        {
          name = "luasnip",
          priority = 800
        },
        {
          name = "nvim_lsp_signature_help",
          priority = 1000
        }
      }

      cmp.setup({
        window = {
          completion = {
            border = border,
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Pmenu,Search:None"
          },
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = mapping,
        sources = sources,
        enabled = function() return not telescope_buffer() and not popup_buffer() and not comment() end,
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth= 50,
            ellipsis_char= "...",
          })
        },
        sorting = {
          priority_weight = 1.0,
          comparators = {
            compare.locality,
            compare.recently_used,
            compare.score,
            compare.offset,
            compare.order
          }
        },
        experimental = { ghost_text = true }
      })

      cmp.setup.cmdline(":", {
        sources = {
          {
            name = "cmdline",
            group_index = 1
          },
          {
            name = "cmdline_history",
            group_index = 2
          }
        },
        mapping = mapping
      })

      cmp.setup.cmdline("/", {
        sources = {
          {
            name = "cmdline_history",
          },
          {
            name = "buffer"
          }
        },
        mapping = mapping
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
}
