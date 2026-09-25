return {
	"zbirenbaum/copilot.lua",
	dependencies = { "copilotlsp-nvim/copilot-lsp" },
	enabled = true,
	event = "VeryLazy",
	cmd = "Copilot",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = false,
			keymap = {
				accept = false,
				accept_word = false,
				accept_line = false,
				next = false,
				prev = false,
				dismiss = false,
				toggle_auto_trigger = false,
			},
		},
		panel = { enabled = false },
		nes = {
			enabled = false,
		},
	},
}
