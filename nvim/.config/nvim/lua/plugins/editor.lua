local lib = require("lib")

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
    keys = {
      "<C-;>",
      {
        "<leader>it",
        lib.ex_cmd("ToggleTerm direction=float"),
        desc = "toggle floating terminal",
      },
      {
        "<leader>Q",
        lib.ex_cmd("silent q!"),
        desc = "quit without saving",
      },
      {
        "<leader>:",
        lib.ex_cmd("ToggleTerm direction=horizontal"),
        desc = "toggle terminal drawer",
      },
      {
        "<leader>iT",
        lib.ex_cmd("ToggleTerm direction=horizontal"),
        desc = "toggle drawer terminal",
      },
      { "<leader>gl", lib.ex_cmd("TermExec direction=float cmd=lazygit"), desc = "open lazygit" },
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
    "nvim-neotest/neotest",
    enabled = true,
    keys = {

      { "<leader>tb", lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b')"), desc = "b4b suite" },
      {
        "<leader>tc",
        lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/clinic')"),
        desc = "clinic suite",
      },
      { "<leader>tf", lib.test_file_from_engine_root, desc = "file" },
      {
        "<leader>tm",
        lib.ex_cmd("lua require('neotest').run.run(vim.fn.getcwd() .. '/b4b_core')"),
        desc = "b4b_core suite",
      },
      { "<leader>to", lib.ex_cmd("lua require('neotest').output_panel.toggle()"), desc = "toggle output" },

      { "<leader>tt", lib.test_test_from_engine_root, desc = "test" },
      { "<leader>ts", lib.stop_test, desc = "stop test run" },
    },
    dependencies = {
      "olimorris/neotest-rspec",
      "jfpedroza/neotest-elixir",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("neotest").setup({
        adapters = { require("neotest-rspec"), require("neotest-elixir") },
        output = {
          open_on_run = false,
        },
        status = {
          signs = false,
          virtual_text = true,
        },
      })
    end,
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
    keys = {
      { "<leader>db", lib.ex_cmd("lua require('dap').toggle_breakpoint()"), desc = "toggle breakpoint" },
      { "<leader>dc", lib.ex_cmd("lua require('dap').continue()"), desc = "continue" },
      { "<leader>do", lib.ex_cmd("lua require('dap').step_over()"), desc = "step over" },
      { "<leader>di", lib.ex_cmd("lua require('dap').step_into()"), desc = "step into" },
      { "<leader>du", lib.ex_cmd("lua require('dapui').toggle()"), desc = "toggle UI" },
      { "<leader>dr", lib.ex_cmd("lua require('dap').repl.toggle()"), desc = "toggle repl" },
      {
        "<leader>df",
        lib.ex_cmd(
          "lua require('dapui').float_element('repl', { height = 40, width = 140, position = 'center', enter = true })"
        ),
        desc = "toggle floating repl",
      },
    },
    config = function()
      local lib = require("lib")
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
    enabled = false,
    dependencies = { "mfussenegger/nvim-dap" },
    config = true,
  },
  {
    "suketa/nvim-dap-ruby",
    enabled = false,
    dependencies = { "mfussenegger/nvim-dap" },
    ft = { "ruby", "eruby" },
    config = true,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    cmd = { "Neotree" },
    config = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        sort_case_insensitive = true,
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_by_name = { "node_modules" },
            never_show = { ".DS_STORE" },
          },
        },
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      {
        "<leader>if",
        lib.ex_cmd("NvimTreeToggle"),
        desc = "toggle tree",
      },
      {
        "<leader>oo",
        lib.ex_cmd("NvimTreeToggle"),
        desc = "open filetree",
      },
      {
        "<leader>ot",
        lib.ex_cmd("NvimTreeFindFile"),
        desc = "show file in tree",
      },
    },
    enabled = true,
    opts = {
      sync_root_with_cwd = true,
      renderer = {
        indent_markers = {
          enable = true,
        },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      filters = {
        custom = {
          "^.git$",
          "^.DS_STORE$",
        },
      },
    },
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
    event = "VeryLazy",
    commit = "0ef64599b8aa0187ee5f6d92cb39c951f348f041",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
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
    "ray-x/guihua.lua",
    build = "cd lua/fzy && make",
    enabled = false,
  },
  {
    "ray-x/navigator.lua",
    enabled = false,
    dependencies = { "ray-x/guihua.lua", "neovim/nvim-lspconfig" },
    event = "LspAttach",
    config = function()
      require("navigator").setup({
        width = 0.75,
        height = 0.3,
        preview_height = 0.35,
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        default_mapping = false,
        treesitter_analysis = false,
        treesitter_navigation = true,
        mason = true,
        icons = {
          diagnostic_head = "󰃤",
          diagnostic_err = "",
          diagnostic_warn = "",
          diagnostic_info = "",
          diagnostic_hint = "",
          diagnostic_virtual_text = "󱁤",
        },
        lsp = {
          display_diagnostic_qf = false,
          code_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
            format_on_save = true,
            -- display_diagnostic_qf = "trouble",
            format_options = {
              async = true,
            },
          },
          code_lens_action = {
            enable = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
          },
          hover = {
            enable = true,
            keymap = {
              gh = {
                default = function()
                  local w = vim.fn.expand("<cWORD>")
                  vim.lsp.buf.workspace_symbol(w)
                end,
              },
            },
          },
        },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = { "stylua", "erb-lint", "erb-formatter" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    -- event = "VeryLazy",
    lazy = false,
    opts = {
      ensure_installed = {
        "bashls",
        "elixirls",
        "emmet_ls",
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
        lib.ex_cmd("Trouble diagnostics toggle filter.buf=0"),
        desc = "show errors and warnings",
      },
    },
    opts = {
      auto_open = false,
      auto_preview = false,
    },
  },
  {
    "tpope/vim-endwise",
    event = "BufReadPre",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    cond = true,
    event = "BufReadPre",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "fish",
        "dockerfile",
        "eex",
        "erlang",
        "elixir",
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
      highlight = { enable = true },
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
      "L3MON4D3/LuaSnip",
    },
    event = "InsertEnter",
    config = function()
      vim.cmd("autocmd FileType guihua lua require('cmp').setup.buffer { enabled = false }")
      vim.cmd("autocmd FileType guihua_rust lua require('cmp').setup.buffer { enabled = false }")
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
        { "│", "CmpBorder" },
      }
      local autopairs = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", autopairs.on_confirm_done({ map_char = { tex = "" } }))

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

      local function neotree_buffer()
        local buftype = vim.api.nvim_buf_get_option(0, "buftype")
        local filetype = vim.api.nvim_buf_get_option(0, "filetype")
        return buftype == "nofile" and filetype == "neo-tree"
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
          return not telescope_buffer()
            and not popup_buffer()
            and not comment()
            and not neotree_buffer()
            and not nui_buffer()
        end,
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
          }),
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
        experimental = { ghost_text = true },
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
    "numToStr/Comment.nvim",
    keys = { "gc", "v", "V" },
    cond = true,
    config = true,
  },
  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs", "v", "V" },
    cond = true,
    config = true,
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
        mode = { "n", "o", "x" },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    cond = true,
    opts = {
      disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
    },
  },
  {
    "tpope/vim-repeat",
    cond = true,
    keys = { "." },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cond = true,
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            -- automatically jump forward to textobj
            lookahead = true,
            keymaps = {
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
            },
          },
        },
      })
    end,
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
}
