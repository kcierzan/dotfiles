return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = true,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      buftype_exclude = { "terminal" },
      filetype_exclude = { "alpha" },
      use_treesitter = true,
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
    event = { "BufReadPost" },
    config = true,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    dependencies = { "folke/tokyonight.nvim" },
    config = function()
      local tn = require("tokyonight.colors").setup()
      require("notify").setup({
        timeout = 800,
        background_colour = tn.bg,
        fps = 60,
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = { "BufReadPre" },
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
    "akinsho/bufferline.nvim",
    version = "*",
    event = { "VimEnter" },
    config = function()
      require("bufferline").setup({
        options = {
          show_close_icon = false,
          show_buffer_close_icons = false,
          indicator = { style = "none" },
          -- separator_style = { "", "" },
          separator_style = "slant",
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true,
            },
          },
        },
      })
    end,
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
            "I was an expert C++ user and really loved C++. For some value of 'love', that involves no satisfaction at all."
          },
          ["Paul Graham"] = {
            "Object-oriented programming offers a sustainable way to write spaghetti code.",
            "Object-oriented programming lets you accrete programs as a series of patches.",
            "The recipe for great work is very exacting taste, plus the ability to gratify it."
          }
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
}
