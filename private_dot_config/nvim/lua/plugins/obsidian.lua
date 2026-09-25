local workspaces_by_host = {
	["rem-betterment02253"] = {
		{
			name = "work-notes",
			path = "~/Documents/betterment",
		},
	},
	["home-pc"] = {
		{
			name = "home-pc-vault",
			path = "~/home-pc-vault",
		},
	},
}

return {
	"obsidian-nvim/obsidian.nvim",
	cmd = "Obsidian",
	ft = "markdown",
	opts = function()
		local hostname = vim.uv.os_gethostname():lower()

		return {
			legacy_commands = false,
			workspaces = workspaces_by_host[hostname] or {},
		}
	end,
}
