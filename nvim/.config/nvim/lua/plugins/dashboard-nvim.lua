local lib = require("lib")

-- TODO: replace this with folke/snacks
return {
  "nvimdev/dashboard-nvim",
  enabled = true,
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
}
