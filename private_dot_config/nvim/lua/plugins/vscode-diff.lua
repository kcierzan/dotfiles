return {
	"esmuellert/vscode-diff.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	cmd = "CodeDiff",
	opts = {
		highlights = {
			-- mini.base16 gives DiffAdd and DiffDelete the same background and
			-- distinguishes them by foreground. CodeDiff only uses their background.
			line_insert = "#34402f",
			line_delete = "#482e31",
		},
	},
}
