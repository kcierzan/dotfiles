local M = {}

function M.switch_separator()
	local separators = require("heirline-config.separators")
	local glyphs = require("heirline-config.utils").separators
	local original = separators.get()
	local original_layout = separators.get_layout()
	local confirmed = false
	local items = {}

	for _, style in ipairs(separators.styles) do
		items[#items + 1] = {
			id = style,
			text = string.format("%s  %s statusline %s", style, glyphs[style .. "_left"], glyphs[style .. "_right"]),
			is_current = style == original,
		}
	end

	return Snacks.picker.pick({
		items = items,
		title = "Statusline separators (<C-t>: chips/airline)",
		layout = { preset = "vscode" },
		win = {
			input = {
				keys = {
					["<C-t>"] = { separators.toggle_layout, mode = { "i", "n" }, desc = "toggle chips/airline" },
				},
			},
			list = {
				keys = {
					["<C-t>"] = { separators.toggle_layout, mode = "n", desc = "toggle chips/airline" },
				},
			},
		},
		format = function(item)
			return { { (item.is_current and "● " or "  ") .. item.text, item.is_current and "Special" or nil } }
		end,
		on_change = function(_, item)
			if item then
				separators.select(item.id)
			end
		end,
		confirm = function(picker, item)
			if item then
				confirmed = true
				separators.select(item.id)
				separators.save()
			end
			picker:close()
		end,
		on_close = function()
			if not confirmed then
				separators.select(original)
				separators.select_layout(original_layout)
			end
		end,
	})
end

return M
