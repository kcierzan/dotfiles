local lib = require("lib")

return {
	{
		"nvim-mini/mini.comment",
		keys = { "gc", "v", "V" },
		cond = true,
		version = false,
		opts = {},
	},
	{
		"nvim-mini/mini.surround",
		version = false,
		cond = true,
		event = "VeryLazy",
		keys = {
			{
				"S",
				mode = { "x" },
				function()
					require("mini.surround").add("visual")
				end,
			},
		},
		opts = {
			custom_surroundings = {
				d = {
					input = { "%b{}" },
					output = {
						left = "do\n",
						right = "\nend",
					},
				},
			},
			mappings = {
				add = "ys",
				delete = "ds",
				find = "",
				find_left = "",
				highlight = "",
				replace = "cs",
				update_n_lines = "",
			},
		},
	},
	{
		"nvim-mini/mini.operators",
		keys = { "g=", "gx", "gm", "gr", "gs" },
		-- conflicts with new lsp bindings
		enabled = false,
		version = false,
		opts = {},
	},
	{
		"nvim-mini/mini.icons",
		lazy = false,
		version = false,
		config = function()
			require("mini.icons").setup({})
			require("mini.icons").mock_nvim_web_devicons()
		end,
	},
	{
		"nvim-mini/mini.ai",
		version = false,
		cond = true,
		keys = { "a", "i", "g" },
		opts = {},
	},
	{
		"nvim-mini/mini.pairs",
		enabled = false,
		version = false,
		cond = true,
		event = "InsertEnter",
		opts = {},
	},
	{
		"nvim-mini/mini.indentscope",
		enabled = false,
		version = false,
		event = "BufReadPre",
		opts = {
			symbol = "▎",
		},
	},
	{
		"nvim-mini/mini.diff",
		enabled = false,
		version = false,
		event = "VeryLazy",
		opts = {},
	},
	{
		"nvim-mini/mini.bufremove",
		enabled = false,
		keys = {
			{ "<leader>wd", lib.ex_cmd("bd"), desc = "delete" },
		},
		opts = {},
	},
	{
		"nvim-mini/mini.base16",
		version = "*",
		enabled = true,
		lazy = false,
		priority = 1000, -- Load before other plugins to ensure colorscheme is available
		config = function()
			require("mini.base16")
			require("theme").apply()
		end,
	},
}
