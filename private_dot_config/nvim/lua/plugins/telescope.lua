local lib = require("lib")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "jvgrootveld/telescope-zoxide",
      "benfowler/telescope-luasnip.nvim",
      "nvim-telescope/telescope-frecency.nvim",
    },
    event = { "VeryLazy" },
    enabled = false,
    keys = {
      {
        "<leader>fG",
        lib.super_fuzzy_grep,
        desc = "super fuzzy grep",
      },
      -- { "<leader>fb", lib.telescope_builtin("buffers"), desc = "buffers" },
      -- { "<leader>fc", lib.telescope_builtin("git_commits"), desc = "commits" },
      -- {
      --   "<leader>fd",
      --   lib.telescope_builtin("lsp_definitions"),
      --   desc = "definitions",
      -- },
      -- {
      --   "<leader>ff",
      --   lib.fast_find_file,
      --   desc = "files in repo",
      -- },
      -- {
      --   "<leader>fg",
      --   lib.live_grep_from_git_root,
      --   desc = "text in git files",
      -- },
      -- { "<leader>fh", lib.ex_cmd("Telescope frecency"), desc = "frecent files" },
      -- {
      --   "<leader>fi",
      --   lib.telescope_builtin("lsp_implementations"),
      --   desc = "implementations",
      -- },
      -- {
      --   "<leader>fq",
      --   lib.telescope_builtin("quickfix"),
      --   desc = "quickfix",
      -- },
      -- {
      --   "<leader>fj",
      --   lib.ex_cmd(":lua require('telescope').extensions.zoxide.list()"),
      --   desc = "recent dirs",
      -- },
      -- {
      --   "<leader>fl",
      --   lib.telescope_builtin("current_buffer_fuzzy_find"),
      --   desc = "line in buffer",
      -- },
      -- {
      --   "<leader>fo",
      --   lib.telescope_builtin("lsp_workspace_symbols"),
      --   desc = "workspace symbols",
      -- },
      -- {
      --   "<leader>fs",
      --   lib.lsp_document_symbols,
      --   desc = "buffer symbols",
      -- },
      -- {
      --   "<leader>fu",
      --   lib.telescope_builtin("lsp_references"),
      --   desc = "usages",
      -- },
      -- {
      --   "<leader>fw",
      --   lib.grep_word_under_cursor,
      --   desc = "word under cursor",
      -- },
      { "<leader>fr", group = "+rails" },
      { "<leader>frf", lib.find_rails_app_file, desc = "app files" },
      -- { "<leader>frm", lib.find_rails_model, desc = "models" },
      {
        "<leader>frc",
        lib.find_rails_controller,
        desc = "controllers",
      },
      { "<leader>frv", lib.find_rails_view, desc = "views" },
      { "<leader>frs", lib.find_specs, desc = "specs" },
      { "<leader>frF", lib.find_factories, desc = "factories" },
      {
        "<leader>frg",
        lib.live_grep_rails_app_files,
        desc = "find in app files",
      },
      -- { "<leader>vT", lib.telescope_builtin("filetypes"), desc = "filetypes" },
      -- { "<leader>vh", lib.telescope_builtin("help_tags"), desc = "help tags" },
      -- { "<leader>vk", lib.telescope_builtin("keymaps"), desc = "keymaps" },
      -- { "<leader>vm", lib.telescope_builtin("man_pages"), desc = "man pages" },
      -- {
      --   "<leader>vo",
      --   lib.telescope_builtin("vim_options"),
      --   desc = "vim options",
      -- },
      -- {
      --   "<leader>vs",
      --   lib.ex_cmd("Telescope themes"),
      --   desc = "colorschemes",
      -- },
      -- {
      --   "<leader>ff",
      --   lib.search_visual_selection,
      --   desc = "search visual selection",
      --   mode = "v",
      -- },
      {
        "<leader>va",
        lib.telescope_builtin("autocommands"),
        desc = "autocommands",
      },
      -- {
      --   "<leader>vc",
      --   lib.telescope_builtin("highlights"),
      --   desc = "highlights",
      -- },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          prompt_prefix = "❯ ",
          selection_caret = "❯ ",
          preview = {
            treesitter = false,
          },
          file_ignore_patterns = {
            "%.rbi",
            "%.png",
            "%.ttf",
            "%.pdf",
          },
          vimgrep_arguments = {
            "rg",
            "--no-heading",
            "--color=never",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--trim",
            "--glob",
            "!.git/",
            "--glob",
            "!*.lock",
          },
          layout_strategy = "vertical",
          layout_config = {
            vertical = {
              width = { padding = 0 },
              height = { padding = 0 },
              preview_height = 0.65,
            },
          },
          pickers = {
            find_files = {
              find_command = {
                "fd",
                "--type",
                "f",
                "--hidden",
                "--strip-cwd-prefix",
              },
              lsp_references = { fname_width = 60 },
              lsp_workspace_symbols = { fname_width = 60 },
              lsp_document_symbols = { fname_width = 60 },
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("zoxide")
      telescope.load_extension("luasnip")
      telescope.load_extension("frecency")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
