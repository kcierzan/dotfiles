local function ai_active()
	return vim.b.copilot_completion_active == true
end

local function set_ai_active(active)
	vim.b.copilot_completion_active = active or nil
end

local function copilot_suggestion()
	return require("copilot.suggestion")
end

local function enter_ai(cmp, direction)
	set_ai_active(true)
	cmp.cancel()

	if direction == -1 then
		copilot_suggestion().prev()
	else
		copilot_suggestion().next()
	end

	return true
end

local function leave_ai(cmp, show_normal_completions)
	if not ai_active() then
		return false
	end

	set_ai_active(false)
	copilot_suggestion().dismiss()

	if show_normal_completions then
		cmp.show()
	end

	return true
end

local function toggle_ai(cmp)
	if ai_active() then
		return leave_ai(cmp, true)
	end

	return enter_ai(cmp, 1)
end

local function accept_ai()
	if not ai_active() then
		return false
	end

	local suggestion = copilot_suggestion()
	if suggestion.is_visible() then
		set_ai_active(false)
		suggestion.accept()
	else
		-- Keep Tab from falling through to snippets, NES, or indentation while
		-- an on-demand Copilot request is still pending.
		suggestion.next()
	end

	return true
end

local function show_normal(cmp, opts)
	if ai_active() then
		set_ai_active(false)
		copilot_suggestion().dismiss()
	end

	return cmp.show(opts)
end

return {
	"saghen/blink.cmp",
	lazy = true,
	dependencies = {
		"rafamadriz/friendly-snippets",
		"mikavilpas/blink-ripgrep.nvim",
		"folke/sidekick.nvim",
		{ "L3MON4D3/LuaSnip", version = "v2.*" },
	},
	event = "VeryLazy",
	version = "*",
	init = function()
		local group = vim.api.nvim_create_augroup("copilot_completion_lane", { clear = true })
		vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave" }, {
			group = group,
			callback = function(args)
				vim.b[args.buf].copilot_completion_active = nil
			end,
			desc = "reset the on-demand Copilot completion lane",
		})
	end,
	opts = {
		fuzzy = {
			implementation = "prefer_rust",
		},
		completion = {
			menu = {
				-- border = "rounded",
				draw = {
					padding = { 0, 1 },
					components = {
						kind_icon = {
							text = function(ctx)
								return " " .. ctx.kind_icon .. ctx.icon_gap .. " "
							end,
						},
					},
				},
				auto_show = function(ctx)
					if ai_active() then
						return false
					end

					return ctx.mode ~= "cmdline"
						or ctx.mode ~= "noice"
						or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
				end,
			},
			list = {
				max_items = 100,
				selection = { preselect = false, auto_insert = true },
			},
		},
		keymap = {
			["<M-Tab>"] = {
				function(cmp)
					return toggle_ai(cmp)
				end,
			},
			["<Tab>"] = {
				accept_ai,
				"select_next",
				-- "snippet_forward", --disabling this for now to let luasnippet handling jumping (pmenu must be closed!)
				function()
					return require("sidekick").nes_jump_or_apply()
				end,
				"fallback",
			},
			["<S-Tab>"] = {
				"select_prev",
				-- "snippet_backward", -- disabling this for now to let luasnippet handling jumping (pmenu must be closed!)
				"fallback",
			},
			["<M-]>"] = {
				function(cmp)
					if not ai_active() then
						return false
					end

					copilot_suggestion().next()
					return true
				end,
				"fallback",
			},
			["<M-[>"] = {
				function(cmp)
					if not ai_active() then
						return false
					end

					copilot_suggestion().prev()
					return true
				end,
				"fallback",
			},
			["<C-k>"] = {
				function(cmp)
					leave_ai(cmp, false)
					return false
				end,
				"show",
				"show_documentation",
				"hide_documentation",
			},
			["<C-g>"] = {
				function(cmp)
					return leave_ai(cmp, false)
				end,
				"cancel",
				"fallback",
			},
			["<CR>"] = { "accept", "fallback" },
			["<C-Space>"] = {
				function(cmp)
					return show_normal(cmp)
				end,
			},
			["<C-A-Space>"] = {
				function(cmp)
					return show_normal(cmp, { providers = { "snippets" } })
				end,
			},
		},
		snippets = { preset = "luasnip" },
		cmdline = {
			keymap = { preset = "cmdline" },
		},
		sources = {
			default = {
				-- "codecompanion",
				"lsp",
				"path",
				"snippets",
				"buffer",
				"ripgrep",
			},
			providers = {
				lsp = { async = true, fallbacks = { "ripgrep" } },
				snippets = { async = true, score_offset = 50 },
				ripgrep = {
					module = "blink-ripgrep",
					name = "Ripgrep",
					async = true,
					max_items = 3,
					opts = {
						prefix_min_length = 5,
						backend = {
							-- gitgrep may be faster for large repositories
							use = "ripgrep",
							context_size = 5,
							ripgrep = {
								max_filesize = "300K",
								ignore_paths = {
									"~/",
								},
							},
						},
					},
					enabled = true,
					score_offset = -50,
				},
				-- codecompanion = {
				--   name = "CodeCompanion",
				--   module = "codecompanion.providers.completion.blink",
				--   enabled = false,
				-- },
			},
		},
	},
}
