local M = {}

function M.switch_syntax()
	local syntax = require("syntax")
	local original = syntax.active()
	local confirmed = false
	local items = {}
	for _, profile in ipairs(syntax.profiles) do
		items[#items + 1] = {
			id = profile.id,
			text = profile.name .. " — " .. profile.description,
			is_current = profile.id == syntax.confirmed(),
		}
	end

	return Snacks.picker.pick({
		items = items,
		title = "Syntax profiles",
		layout = { preset = "vscode" },
		format = function(item)
			return { { (item.is_current and "● " or "  ") .. item.text, item.is_current and "Special" or nil } }
		end,
		on_change = function(_, item)
			if item then
				syntax.preview(item.id)
			end
		end,
		confirm = function(picker, item)
			if item then
				-- Set before close: Snacks calls on_close synchronously.
				confirmed = true
				syntax.select(item.id)
			end
			picker:close()
		end,
		on_close = function()
			if not confirmed then
				syntax.preview(original)
			end
		end,
	})
end

return M
