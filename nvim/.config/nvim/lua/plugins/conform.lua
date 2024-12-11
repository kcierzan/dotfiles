return {
  "stevearc/conform.nvim",
  enabled = true,
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      default_format_opts = {
        async = true,
      },
      formatters = {
        rubocop = {
          command = "bundle",
          args = { "exec", "rubocop", "--autocorrect-all", "--stderr", "--force-exclusion", "--stdin", "$FILENAME" },
          cwd = require("conform.util").root_file({ "Gemfile" }),
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
    })
    vim.api.nvim_create_user_command("FormatDisable", function(args)
      if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = "Disable autoformat-on-save",
      bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = "Re-enable autoformat-on-save",
    })
  end,
}
