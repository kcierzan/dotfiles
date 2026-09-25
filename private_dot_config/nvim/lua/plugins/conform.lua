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
					args = {
						"exec",
						"rubocop",
						"--autocorrect-all",
						"--stderr",
						"--force-exclusion",
						"--stdin",
						"$FILENAME",
					},
					cwd = require("conform.util").root_file({ "Gemfile" }),
				},
				sqlfluff = {
					command = "sqlfluff",
					args = { "format", "--dialect", "postgres", "-" },
					stdin = true,
					cwd = function()
						return vim.fn.getcwd()
					end,
				},
			},
			format_after_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				return {
					-- timeout_ms = 5000,
					lsp_format = "fallback",
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				ruby = { "rubocop" },
				eruby = { "erb-format" },
				zsh = { "shfmt" },
				bash = { "shfmt" },
				sql = { "sqlfluff" },
				python = { "ruff_fix", "ruff_format" },
				nix = { "nixfmt" },
			},
		})

		-- Auto-formatting is opt-in. The Snacks toggle updates the global state,
		-- while the buffer-local variable can still override it when needed.
		vim.g.disable_autoformat = true
		Snacks.toggle({
			name = "Auto Format",
			get = function()
				return not vim.g.disable_autoformat
			end,
			set = function(enabled)
				vim.g.disable_autoformat = not enabled
			end,
		}):map("<leader>uf")

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
