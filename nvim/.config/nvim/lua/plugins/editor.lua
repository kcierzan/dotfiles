local lib = require("lib")
local rails = require("rails")

return {
  {
    "tpope/vim-projectionist",
    keys = {
      { "<leader>tg", lib.ex_cmd("A"), desc = "show test file" },
    },
    lazy = false,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      "<C-;>",
      {
        "<leader>it",
        lib.ex_cmd("ToggleTerm direction=float name='zsh'"),
        desc = "toggle floating terminal",
      },
      {
        "<leader>Q",
        lib.ex_cmd("silent q!"),
        desc = "quit without saving",
      },
      {
        "<leader>:",
        lib.ex_cmd("ToggleTerm direction=horizontal name='zsh'"),
        desc = "toggle terminal drawer",
      },
      {
        "<leader>iT",
        lib.ex_cmd("ToggleTerm direction=horizontal"),
        desc = "toggle drawer terminal",
      },
      { "<leader>gl", lib.ex_cmd("TermExec direction=float cmd=lazygit"), desc = "open lazygit" },
      { "<leader>tt", rails.run_rspec_thing_at_point_in_toggleterm, desc = "run rspec test" },
      { "<leader>tf", rails.run_rspec_file_in_toggleterm, desc = "run rspec file" },
    },
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      open_mapping = "<C-;>",
      persist_mode = true,
      size = 20,
      float_opts = {
        border = "curved",
      },
    },
  },
  {
    "tpope/vim-fugitive",
    dependencies = { "tpope/vim-rhubarb" },
    keys = {
      { "<leader>go", lib.ex_cmd("'<,'>GBrowse"), desc = "open in github", mode = "v" },
      {
        "<leader>gd",
        lib.ex_cmd("Gvdiffsplit"),
        desc = "diff staged & working tree",
      },
      { "<leader>gc", lib.ex_cmd("Gvdiffsplit!"), desc = "3 way merge" },
      { "<leader>go", lib.ex_cmd("GBrowse"), desc = "open in github" },
      { "<leader>gs", lib.ex_cmd("Git"), desc = "status" },
    },
    cmd = {
      "Git",
      "GBrowse",
      "GDelete",
      "GMove",
      "Gread",
      "Gwrite",
      "Gvdiffsplit",
      "Gdiffsplit",
      "Gedit",
    },
  },
  {
    "stevearc/conform.nvim",
    enabled = true,
    event = "LspAttach",
    opts = {
      default_format_opts = {
        async = true,
      },
      formatters = {
        rubocop = {
          args = { "--auto-correct-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
        },
      },
      format_after_save = {
        -- timeout_ms = 5000,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        ruby = { "rubocop" },
        eruby = { "erb-format" },
        python = { "isort", "black" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "suketa/nvim-dap-ruby" },
    keys = {
      { "<leader>db", lib.ex_cmd("lua require('dap').toggle_breakpoint()"), desc = "toggle breakpoint" },
      { "<leader>dc", lib.ex_cmd("lua require('dap').continue()"), desc = "continue" },
      { "<leader>do", lib.ex_cmd("lua require('dap').step_over()"), desc = "step over" },
      { "<leader>di", lib.ex_cmd("lua require('dap').step_into()"), desc = "step into" },
      { "<leader>du", lib.ex_cmd("lua require('dapui').toggle()"), desc = "toggle UI" },
      { "<leader>dr", lib.ex_cmd("lua require('dap').repl.toggle()"), desc = "toggle repl" },
      { "<leader>dt", lib.ex_cmd("lua require('neotest').run.run({ strategy = 'dap'})"), desc = "debug test" },
      {
        "<leader>df",
        lib.ex_cmd(
          "lua require('dapui').float_element('repl', { height = 40, width = 140, position = 'center', enter = true })"
        ),
        desc = "toggle floating repl",
      },
    },
    config = function()
      require("dap-ruby").setup()
      local red = lib.get_hl_group_colors("Error").fg
      local bg_dark = lib.get_hl_group_colors("Cursorline").bg
      local blue = lib.get_hl_group_colors("@function").fg
      local green = lib.get_hl_group_colors("@character").fg

      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = red, bg = bg_dark })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = blue, bg = bg_dark })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = green, bg = bg_dark })

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "󰝥", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "󰟃", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
      )
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    enabled = true,
    dependencies = { "mfussenegger/nvim-dap" },
    config = true,
  },
  {
    "nvim-pack/nvim-spectre",
    keys = {
      { "<leader>fR", lib.ex_cmd("Spectre"), desc = "replace" },
    },
    cmd = { "Spectre" },
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    -- event = { "VeryLazy" },
    -- commit = "0ef64599b8aa0187ee5f6d92cb39c951f348f041",
    ft = {
      "ruby",
      "eruby",
      "markdown",
      "bash",
      "sh",
      "zsh",
      "typescript",
      "go",
      "json",
      "python",
      "rust",
      "css",
      "heex",
      "html",
      "elixir",
      "lua",
    },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- force loading these first
      require("mason")
      require("mason-lspconfig")

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
        "gopls",
        "golangci_lint_ls",
        "jsonls",
        "lua_ls",
        "pyright",
        "ruby_lsp",
        "rust_analyzer",
        "svelte",
        "tailwindcss",
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
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    keys = {
      { "<leader>vt", lib.ex_cmd("Mason"), desc = "tools" },
    },
    opts = {
      ensure_installed = { "stylua", "erb-lint", "erb-formatter" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- dependencies = { "williamboman/mason.nvim" },
    -- lazy = false,
    opts = {
      ensure_installed = {
        "bashls",
        "elixirls",
        "emmet_ls",
        "gopls",
        "golangci_lint_ls",
        "jsonls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "tailwindcss",
        "svelte",
        "vtsls",
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader>le",
        lib.ex_cmd("Trouble diagnostics toggle filter.buf=0 focus=true"),
        desc = "show errors and warnings",
      },
    },
    opts = {
      auto_open = false,
      auto_preview = false,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cond = true,
    lazy = false,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "clojure",
        "cmake",
        "cpp",
        "css",
        "fish",
        "dockerfile",
        "eex",
        "erlang",
        "elixir",
        "fennel",
        "go",
        "haskell",
        "heex",
        "html",
        "hyprlang",
        "java",
        "javascript",
        "julia",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "ruby",
        "rust",
        "scss",
        "surface",
        "svelte",
        "typescript",
        "vim",
        "yaml",
      },
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true, disable = "ruby" },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    version = "2.*",
    build = "make install_jsregexp",
  },
  {
    "benfowler/telescope-luasnip.nvim",
    cmd = { "Telescope", "Telescope luasnip" },
  },
  {
    "onsails/lspkind.nvim",
    event = "VeryLazy",
    config = function()
      require("lspkind").init({
        symbol_map = {
          Array = "[]",
          Boolean = "",
          Calendar = "",
          Class = "󰠱",
          Codeium = "",
          Color = "󰏘",
          Constant = "󰏿",
          Constructor = "",
          Copilot = "",
          Enum = "",
          EnumMember = "",
          Event = "",
          Field = "󰜢",
          File = "󰈚",
          Folder = "󰉋",
          Function = "󰆧",
          Interface = "",
          Keyword = "󰌋",
          KeywordOperator = "󰌋",
          KeywordConditional = "",
          Method = "󰆧",
          Module = "",
          Namespace = "󰌗",
          Null = "󰟢",
          Number = "",
          Object = "󰅩",
          Operator = "󰆕",
          Package = "",
          Property = "󰜢",
          Reference = "󰈇",
          Snippet = "",
          Spell = "",
          String = "󰉿",
          StringSpecialSymbol = "󰙴",
          Struct = "󰙅",
          Supermaven = "",
          TabNine = "",
          Table = "",
          Tag = "",
          Text = "󰉿",
          TypeParameter = "󰊄",
          Unit = "󰑭",
          Value = "󰎠",
          Variable = "󰀫",
          VariableMember = "󰀫",
          Watch = "󰥔",
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "onsails/lspkind.nvim",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "saadparwaiz1/cmp_luasnip",
      "lukas-reineke/cmp-rg",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/cmp-treesitter",
      "rafamadriz/friendly-snippets",
      "L3MON4D3/LuaSnip",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
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
        { "│", "CmpBorder" },
      }

      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
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
        ["<Tab>"] = cmp.mapping(tab_func, { "i", "s", "c" }),
        ["<S-Tab>"] = cmp.mapping(s_tab_func, { "i", "s", "c" }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-n>"] = cmp.mapping(ctrl_n, { "i", "s", "c" }),
        ["<C-p>"] = cmp.mapping(ctrl_p, { "i", "s", "c" }),
      }

      local function telescope_buffer()
        return vim.bo.ft == "TelescopePrompt"
      end

      local function popup_buffer()
        return string.find(vim.api.nvim_buf_get_name(0), "s_popup:/")
      end

      local function nui_buffer()
        return string.find(vim.api.nvim_buf_get_name(0), "nui:/")
      end

      local function comment()
        local context = require("cmp.config.context")
        return context.in_treesitter_capture("comment") or context.in_syntax_group("Comment")
      end

      local sources = {
        {
          name = "buffer",
          priority = 700,
        },
        {
          name = "treesitter",
          priority = 750,
        },
        {
          name = "path",
          priority = 500,
        },
        {
          name = "rg",
          priority = 600,
        },
        {
          name = "calc",
          priority = 900,
        },
        {
          name = "nvim_lsp",
          priority = 800,
        },
        {
          name = "luasnip",
          priority = 900,
        },
        {
          name = "nvim_lsp_signature_help",
          priority = 1000,
        },
      }

      cmp.setup({
        window = {
          completion = {
            border = border,
            winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Pmenu,Search:None",
            scrollbar = false,
            col_offset = -4,
            side_padding = 0,
          },
          documentation = cmp.config.window.bordered(),
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = mapping,
        sources = sources,
        enabled = function()
          return not telescope_buffer() and not popup_buffer() and not comment() and not nui_buffer()
        end,
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[1] or "") .. " "
            kind.menu = "    (" .. (strings[2] or "") .. ")"

            return kind
          end,
        },
        sorting = {
          priority_weight = 1.0,
          comparators = {
            compare.locality,
            compare.recently_used,
            compare.score,
            compare.offset,
            compare.order,
          },
        },
        experimental = { ghost_text = false },
      })

      cmp.setup.cmdline(":", {
        sources = {
          {
            name = "cmdline",
            group_index = 1,
          },
          {
            name = "cmdline_history",
            group_index = 2,
          },
        },
        mapping = mapping,
      })

      cmp.setup.cmdline("/", {
        sources = {
          {
            name = "cmdline_history",
          },
          {
            name = "buffer",
          },
        },
        mapping = mapping,
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "echasnovski/mini.comment",
    keys = { "gc", "v", "V" },
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    version = false,
    event = "InsertEnter",
    keys = {
      {
        "S",
        mode = { "x" },
        function()
          require("mini.surround").add("visual")
        end,
      },
    },
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
      },
    },
  },
  {
    "echasnovski/mini.operators",
    keys = { "g=", "gx", "gm", "gr", "gs" },
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    version = false,
    keys = { "a", "i", "g" },
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "BufReadPre",
    opts = {
      symbol = "▎",
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    cond = true,
    keys = {
      {
        "s",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  {
    "RRethy/nvim-treesitter-endwise",
    event = "BufReadPre",
  },
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "eruby",
      "glimmer",
      "handlebars",
      "hbs",
      "heex",
      "html",
      "javascript",
      "javascriptreact",
      "jsx",
      "markdown",
      "php",
      "rescript",
      "svelte",
      "tsx",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
    },
    opts = {
      filetypes = {
        "astro",
        "eruby",
        "glimmer",
        "handlebars",
        "hbs",
        "heex",
        "html",
        "javascript",
        "javascriptreact",
        "jsx",
        "markdown",
        "php",
        "rescript",
        "svelte",
        "tsx",
        "typescript",
        "typescriptreact",
        "vue",
        "xml",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = { "BufReadPre" },
    opts = {},
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionToggle", "CodeCompanionActions", "CodeCompanionAdd" },
    keys = {
      { "<leader>ac", lib.ex_cmd("CodeCompanionChat"), desc = "open chat" },
      { "<leader>at", lib.ex_cmd("CodeCompanionToggle"), desc = "toggle chat" },
      { "<leader>aa", lib.ex_cmd("CodeCompanionActions"), desc = "actions" },
      { "<leader>av", lib.ex_cmd("CodeCompanionAdd"), desc = "add selection to chat", mode = "v" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      {
        "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
        opts = {},
      },
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    },
    opts = {
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = "cmd:op read op://personal/Anthropic\\ API\\ Key/credential --no-newline",
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
    },
  },
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    keys = {
      { "<leader>if", lib.ex_cmd("Oil"), desc = "open parent dir" },
    },
    opts = {},
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
  },
  {
    "lewis6991/gitsigns.nvim",
    keys = {

      { "<leader>gP", lib.ex_cmd("Gitsigns preview_hunk"), desc = "preview hunk" },
      { "<leader>gr", lib.ex_cmd("Gitsigns reset_hunk"), desc = "reset hunk" },
      { "<leader>gB", lib.ex_cmd("Gitsigns stage_buffer"), desc = "stage buffer" },
      { "<leader>gR", lib.ex_cmd("Gitsigns reset_buffer"), desc = "reset bufffer" },
      { "<leader>gb", lib.ex_cmd("Gitsigns toggle_current_line_blame"), desc = "toggle blame" },
      { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"), desc = "stage hunk", mode = "v" },
      { "<leader>gr", lib.ex_cmd("'<,'>Gitsigns reset_hunk"), desc = "reset hunk", mode = "v" },
      { "<leader>gh", lib.ex_cmd("Gitsigns stage_hunk"), desc = "stage hunk" },
      { "<leader>gp", lib.ex_cmd("Gitsigns nav_hunk next"), desc = "next hunk" },
      { "<leader>gn", lib.ex_cmd("Gitsigns nav_hunk prev"), desc = "prev hunk" },
    },
    event = "VeryLazy",
    config = true,
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "famiu/bufdelete.nvim",
    keys = {
      { "<leader>bd", lib.ex_cmd("Bdelete"), desc = "delete" },
    },
    cmd = { "Bdelete" },
  },
  {
    "folke/todo-comments.nvim",
    event = { "VeryLazy" },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    -- event = "VeryLazy",
    keys = {
      {
        "<leader>ih",
        lib.ex_cmd("ColorizerAttachToBuffer"),
        desc = "colorize buffer",
      },
    },
    opts = {},
    -- opts = {
    --   "css",
    --   "javascript",
    -- },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 800,
      fps = 60,
      -- background_colour = lib.get_hl_group_colors("CursorLine").bg,
    },
  },
  {
    "folke/noice.nvim",
    -- there is a bug in later versions that causes cursor jumping
    -- TODO: fix this after folke comes back from vacation
    -- commit = "d9328ef",
    enabled = true,
    event = { "VeryLazy" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      messages = {
        enabled = true,
        view = "mini",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
        view_search = "virtualtext",
      },
      lsp = {
        hover = {
          enabled = false,
        },
      },
      routes = {
        {
          filter = {
            warning = true,
            find = "Failed to attach",
          },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            event = "msg_showmode",
          },
        },
        {
          filter = {
            error = true,
            find = "Pattern",
          },
          opts = { skip = true },
        },
        {
          filter = {
            warning = true,
            find = "search hit",
          },
          opts = { skip = true },
        },
        {
          filter = {
            find = "go up one level",
          },
          opts = { skip = true },
        },
        {
          filter = {
            find = "quit with exit code",
            warning = true,
          },
          opts = { skip = true },
        },
        {
          view = "mini",
          filter = {
            find = "Directory changed to",
          },
        },
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = { "VimEnter" },
    cond = function()
      return vim.fn.argc() == 0
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local telescope = require("telescope.builtin")
      local generate_nerd_quote = function()
        local quotes = {
          ["Rich Hickey"] = {
            "Programming is not about typing, it's about thinking.",
            "This is the 'Information non-problem': Information is simple. This is a problem we create for ourselves.",
            "Leave data alone.",
            "Polymorphism à la carte completely changes the way you work.",
            "Every new thing you have to do, you write a new class. Where's the reuse in that?",
            "'It requires object-relational mapping, and that's like, a problem with SQL'. No! It's a problem with objects.",
            "You cannot correctly represent change without immutability. It's a profound idea.",
            "State. You're doing it wrong.",
            "Mutable objects are the new Spaghetti code.",
            "...recognize the difference between abstracting in order to simplify, and abstracting in order to hide.",
            "By the time you're writing a service, there's nothing premature about abstraction.",
            "I was an expert C++ user and really loved C++. For some value of 'love', that involves no satisfaction at all.",
          },
          ["Paul Graham"] = {
            "Object-oriented programming offers a sustainable way to write spaghetti code.",
            "Object-oriented programming lets you accrete programs as a series of patches.",
            "The recipe for great work is very exacting taste, plus the ability to gratify it.",
          },
        }

        local random_author = lib.random_table_key(quotes)
        local random_quote = lib.random_table_value(quotes[random_author])

        return random_author, random_quote
      end

      local author, quote = generate_nerd_quote()
      require("dashboard").setup({
        config = {
          shortcut = {
            { desc = "Find files", key = "f", group = "@function", action = lib.fast_find_file },
            { desc = "Grep", key = "g", group = "@character", action = lib.live_grep_from_git_root },
            { desc = "Plugins", key = "p", group = "@string.documentation", action = "Lazy" },
            { desc = "Help", key = "h", group = "@boolean", action = telescope.help_tags },
            { desc = "Quit", key = "q", group = "@variable.builtin", action = "q!" },
          },
          -- header = {
          --   "",
          --   "⠀⠀⢀⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
          --   "⠀⠀⢸⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀",
          --   "⠀⠀⠘⠉⠉⠙⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀ ",
          --   "⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀",
          --   "⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀",
          --   "⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀",
          --   "⠀⠀⠀⠀⣴⣿⣿⣿⠟⣿⣿⣿⣷⠀⠀⠀⠀",
          --   "⠀⠀⠀⣰⣿⣿⣿⡏⠀⠸⣿⣿⣿⣇⠀⠀⠀",
          --   "⠀⠀⢠⣿⣿⣿⡟⠀⠀⠀⢻⣿⣿⣿⡆⠀⠀",
          --   "⠀⢠⣿⣿⣿⡿⠀⠀⠀⠀⠀⢿⣿⣿⣷⣤⡄",
          --   "⢀⣾⣿⣿⣿⠁⠀⠀⠀⠀⠀⠈⠿⣿⣿⣿⡇",
          --   "",
          -- },
          header = {
            "",
            "           ____             ",
            "         /\\   \\           ",
            "        /  \\   \\          ",
            "       /    \\   \\         ",
            "      /      \\   \\        ",
            "     /   /\\   \\   \\      ",
            "    /   /  \\   \\   \\     ",
            "   /   /    \\   \\   \\    ",
            "  /   /    / \\   \\   \\   ",
            " /   /    /   \\   \\   \\  ",
            " /   /    /---------'   \\  ",
            "/   /    /_______________\\ ",
            "\\  /                     / ",
            " \\/_____________________/  ",
            "",
            "",
          },
          footer = {
            "",
            "",
            quote,
            "                              - " .. author,
          },
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      local lualine = require("lualine")

      local function is_git_workspace()
        local filepath = vim.fn.expand("%:p:h")
        local git_dir = vim.fn.finddir(".git", filepath .. ";")

        return git_dir and #git_dir > 0 and #filepath > #git_dir
      end

      local function is_wide_window()
        return vim.fn.winwidth(0) > 85
      end

      local function buffer_not_empty()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end

      local colors = {
        fg = lib.get_hl_group_colors("Normal").fg,
        bg = lib.get_hl_group_colors("CursorLine").bg,
        blue = lib.get_hl_group_colors("@function").fg,
        green = lib.get_hl_group_colors("@character").fg,
        violet = lib.get_hl_group_colors("@keyword").fg,
        red = lib.get_hl_group_colors("Error").fg,
        magenta = lib.get_hl_group_colors("@conditional").fg,
        orange = lib.get_hl_group_colors("@constant").fg,
        yellow = lib.get_hl_group_colors("@parameter").fg,
        cyan = lib.get_hl_group_colors("@define").fg,
      }

      local config = {
        options = {
          component_separators = "",
          section_separators = "",
          globalstatus = true,
          theme = {
            normal = {
              c = {
                fg = colors.fg,
                bg = colors.bg,
              },
            },
            inactive = {
              c = {
                fg = colors.fg,
                bg = colors.bg,
              },
            },
          },
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_y = {},
          lualine_z = {},
          lualine_c = {},
          lualine_x = {},
        },
      }

      local function left_insert(component)
        table.insert(config.sections.lualine_c, component)
      end

      local function right_insert(component)
        table.insert(config.sections.lualine_x, component)
      end

      local modes = {
        n = "NORMAL",
        no = "OPERATOR PENDING",
        v = "VISUAL",
        V = "VISUAL LINE",
        ["^V"] = "VISUAL BLOCK",
        s = "SELECT",
        S = "SELECT LINE",
        ["^S"] = "SELECT BLOCK",
        i = "INSERT",
        ic = "INSERT COMPLETION",
        ix = "INSERT COMPLETION",
        R = "REPLACE",
        Rv = "VIRTUAL REPLACE",
        c = "COMMAND",
        cv = "VIM EX",
        ce = "EX",
        r = "HIT ENTER",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        t = "TERMINAL",
      }

      local function edit_mode()
        local cube = "󰆧"
        local hex_empty = "󰋙"
        local hex_full = "󰋘"
        local mode = vim.fn.mode()
        local mode_string = ""

        if mode == "i" or mode == "ic" or mode == "ix" then
          mode_string = cube
        elseif mode == "n" or mode == "no" or mode == "!" or mode == "t" then
          mode_string = hex_empty
        else
          mode_string = hex_full
        end

        return mode_string .. " " .. modes[mode]
      end

      local function get_buffer_lsp(clients, buf_ft)
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
            return client.name
          end
        end
      end

      local function lsp_name()
        local buf_ft = vim.bo.filetype
        local clients = vim.lsp.get_active_clients({ bufnr = 0 })

        if next(clients) then
          return get_buffer_lsp(clients, buf_ft) or "NONE"
        end
      end

      local function location()
        return "[" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. "]"
      end

      local function should_show_lsp_info()
        local buf_number = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = buf_number })

        return is_wide_window() and next(clients) ~= nil
      end

      local function edit_mode_colors()
        local edit_colors = {
          n = colors.blue,
          i = colors.green,
          v = colors.violet,
          ["^V"] = colors.violet,
          V = colors.blue,
          c = colors.magenta,
          no = colors.red,
          s = colors.orange,
          S = colors.orange,
          ["^S"] = colors.orange,
          ic = colors.yellow,
          R = colors.violet,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ["r?"] = colors.cyan,
          ["!"] = colors.red,
          t = colors.red,
        }

        return { fg = edit_colors[vim.fn.mode()], gui = "bold" }
      end

      local function progress_bar()
        local blocks = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
        local lines = vim.api.nvim_buf_line_count(0)
        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local block_index = math.floor((current_line / lines) * 7) + 1

        return string.rep(blocks[block_index], 2)
      end

      -- ================== Left Hand Sections ========================

      left_insert({
        function()
          return "▊"
        end,
        color = { fg = colors.blue },
        padding = { left = 0, right = 1 },
      })

      left_insert({
        edit_mode,
        color = edit_mode_colors,
        padding = { left = 0, right = 1 },
      })

      left_insert({
        "filetype",
        icon_only = true,
        colored = true,
        padding = { left = 0, right = 0 },
      })

      left_insert({
        location,
        color = { fg = colors.orange, gui = "bold" },
        padding = { right = 1 },
      })

      left_insert({
        "filename",
        cond = buffer_not_empty,
        path = 1,
        color = { fg = colors.fg },
        padding = { left = 0, right = 0 },
      })

      -- ================== Right Hand Sections ========================

      right_insert({
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
        },
        diagnostics_color = {
          color_error = { fg = colors.red },
          color_warn = { fg = colors.yellow },
          color_info = { fg = colors.cyan },
        },
      })

      right_insert({
        lsp_name,
        icon = "󰒋",
        color = { fg = colors.cyan, gui = "bold" },
        cond = should_show_lsp_info,
      })

      right_insert({
        "branch",
        icon = "",
        color = { fg = colors.violet, gui = "bold" },
        cond = is_git_workspace,
      })

      right_insert({
        "diff",
        symbols = {
          added = "  ",
          modified = "󰝤 ",
          removed = "  ",
        },
        diff_color = {
          added = { fg = colors.green },
          modified = { fg = colors.orange },
          removed = { fg = colors.red },
        },
        cond = is_wide_window,
      })

      right_insert({
        "fileformat",
        icons_enabled = true,
        color = { fg = colors.blue, gui = "bold" },
        cond = is_wide_window,
      })

      right_insert({
        progress_bar,
        color = { fg = colors.blue, bg = colors.bg },
        padding = { right = 0, left = 1 },
        cond = is_wide_window,
      })

      right_insert({
        "progress",
        color = { fg = colors.blue, bg = colors.bg },
        padding = { right = 0, left = 1 },
        cond = is_wide_window,
      })

      right_insert({
        function()
          return "▊"
        end,
        color = { fg = colors.blue },
        padding = { left = 1 },
      })

      lualine.setup(config)
    end,
  },
  {
    "karb94/neoscroll.nvim",
    keys = { "<C-d>", "<C-u>", "<C-y>", "<C-e>" },
    opts = {},
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      {
        "<leader>gD",
        lib.ex_cmd("DiffviewOpen"),
        desc = "open index diff",
      },
      {
        "<leader>gH",
        lib.ex_cmd("DiffviewFileHistory %"),
        desc = "open file history",
      },
    },
    opts = {},
  },
  {
    "julienvincent/nvim-paredit",
    opts = {},
  },
  {
    "Olical/conjure",
    ft = { "clojure", "fennel", "janet" },
    dependencies = { "PaterJason/cmp-conjure" },
  },
  {
    "PaterJason/cmp-conjure",
    ft = { "clojure", "janet", "fennel" },
    config = function()
      local cmp = require("cmp")
      local config = cmp.get_config()
      table.insert(config.sources, { name = "conjure", priority = 850 })
      return cmp.setup(config)
    end,
  },
}
