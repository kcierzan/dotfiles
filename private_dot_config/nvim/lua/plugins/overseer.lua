return {
	"stevearc/overseer.nvim",
	cmd = {
		"OverseerOpen",
		"OverseerClose",
		"OverseerToggle",
		"OverseerRun",
		"OverseerShell",
		"OverseerTaskAction",
	},
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
