local M = {}

local function run(args)
	local result = vim.system(args, { text = true }):wait()
	if result.code ~= 0 then
		vim.notify(result.stderr or "theme-switch failed", vim.log.levels.ERROR)
		return nil
	end
	return result.stdout
end

function M.switch_theme()
	local output = run({ "theme-switch", "--list" })
	if not output then
		return
	end

	local items = {}
	for line in output:gmatch("[^\n]+") do
		local id, name, variant, marker = line:match("^([^\t]+)\t([^\t]+)\t([^\t]+)\t?(.*)$")
		if id then
			items[#items + 1] = {
				text = name .. " (" .. variant .. ")",
				id = id,
				is_current = marker == "*",
			}
		end
	end

	return Snacks.picker.pick({
		items = items,
		title = "Themes",
		layout = { preset = "vscode" },
		format = function(item)
			return { { (item.is_current and "● " or "  ") .. item.text, item.is_current and "Special" or nil } }
		end,
		confirm = function(picker, item)
			picker:close()
			if not item then
				return
			end
			vim.system({ "theme-switch", "--set", item.id }, { text = true }, function(result)
				vim.schedule(function()
					if result.code ~= 0 then
						vim.notify(result.stderr or "theme-switch failed", vim.log.levels.ERROR)
					elseif result.stdout and vim.trim(result.stdout) ~= "" then
						vim.notify(vim.trim(result.stdout), vim.log.levels.INFO)
					end
				end)
			end)
		end,
	})
end

return M
