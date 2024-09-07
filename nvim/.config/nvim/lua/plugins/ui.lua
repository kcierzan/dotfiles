return {
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {
      exclude = {
        filetypes = { "alpha" },
        buftypes = { "terminal" },
      },
      enabled = false,
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "famiu/bufdelete.nvim",
    cmd = { "Bdelete" },
  },
  {
    "folke/todo-comments.nvim",
    event = { "VeryLazy" },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "VeryLazy",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    enabled = true,
    config = function()
      local lib = require("lib")
      require("notify").setup({
        timeout = 800,
        background_colour = lib.get_hl_group_colors("CursorLine").bg,
        fps = 60,
      })
    end,
  },
  {
    "folke/noice.nvim",
    commit = "d9328ef",
    enabled = true,
    event = { "VeryLazy" },
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
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
          view = "notify",
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
      },
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = { "VimEnter" },
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
    config = function()
      local lib = require("lib")
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
          header = {
            "",
            "⠀⠀⢀⣤⣤⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⢸⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠘⠉⠉⠙⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀ ",
            "⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀",
            "⠀⠀⠀⠀⣴⣿⣿⣿⠟⣿⣿⣿⣷⠀⠀⠀⠀",
            "⠀⠀⠀⣰⣿⣿⣿⡏⠀⠸⣿⣿⣿⣇⠀⠀⠀",
            "⠀⠀⢠⣿⣿⣿⡟⠀⠀⠀⢻⣿⣿⣿⡆⠀⠀",
            "⠀⢠⣿⣿⣿⡿⠀⠀⠀⠀⠀⢿⣿⣿⣷⣤⡄",
            "⢀⣾⣿⣿⣿⠁⠀⠀⠀⠀⠀⠈⠿⣿⣿⣿⡇",
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
    event = "BufReadPre",
    config = function()
      local lualine = require("lualine")
      local lib = require("lib")

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

        return mode_string .. "  " .. modes[mode]
      end

      local function get_buffer_lsp(clients, buf_ft)
        for _, client in ipairs(clients) do
          local filetypes = client.config.filetypes
          local buffer_for_ft = vim.fn.index(filetypes, buf_ft) ~= -1

          if filetypes and buffer_for_ft then
            return client.name
          end
        end
        return "NONE"
      end

      local function lsp_name()
        local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
        local clients = vim.lsp.get_active_clients()
        local clients_exist = function(clnts)
          return next(clnts) ~= nil and clnts
        end

        if clients_exist(clients) then
          return get_buffer_lsp(buf_ft)
        end
      end

      local function should_show_lsp_info()
        local clients = vim.lsp.get_active_clients()

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
        padding = { left = 0, right = 2 },
      })

      left_insert({
        "filetype",
        icon_only = true,
        colored = true,
        padding = { left = 0, right = 1 },
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
}
