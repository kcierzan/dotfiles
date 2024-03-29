return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "jvgrootveld/telescope-zoxide",
      "benfowler/telescope-luasnip.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
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
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("zoxide")
      require("telescope").load_extension("luasnip")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}
