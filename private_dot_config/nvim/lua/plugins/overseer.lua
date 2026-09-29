return {
	"stevearc/overseer.nvim",
	lazy = false,
	keys = require("keymaps").for_plugin("overseer"),
	opts = {
		dap = true,
		output = {
			use_terminal = true,
		},
		task_list = {
			direction = "bottom",
		},
	},
}
