local M = {}

local colors_path = vim.fn.stdpath("data") .. "/base16-colors.lua"

function M.apply()
	local ok, palette = pcall(dofile, colors_path)
	if not ok or type(palette) ~= "table" then
		vim.notify("Could not load Base16 colors from " .. colors_path, vim.log.levels.ERROR)
		return
	end
	for i = 0, 15 do
		local slot = string.format("base%02X", i)
		if type(palette[slot]) ~= "string" or not palette[slot]:match("^#%x%x%x%x%x%x$") then
			vim.notify("Invalid Base16 color: " .. slot, vim.log.levels.ERROR)
			return
		end
	end
	if palette.variant ~= "light" and palette.variant ~= "dark" then
		vim.notify("Invalid Base16 palette variant", vim.log.levels.ERROR)
		return
	end

	vim.opt.background = palette.variant
	if not package.loaded["mini.base16"] then
		return
	end

	local syntax = require("syntax")
	syntax.restore()
	require("mini.base16").setup({ palette = palette })
	local highlights = require("highlights")
	highlights.create_base16_hl_groups(palette)
	for group, attrs in pairs(highlights.get_overrides(palette)) do
		vim.api.nvim_set_hl(0, group, attrs)
	end

	syntax.apply(palette)

	if package.loaded.heirline then
		require("plugins.heirline").config()
		vim.cmd("redrawstatus")
	end
end

function M.setup()
	require("syntax").setup()
	M.apply()

	local watcher = vim.uv.new_fs_poll()
	watcher:start(colors_path, 300, function(err)
		if not err then
			vim.schedule(M.apply)
		end
	end)

	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			watcher:stop()
			watcher:close()
		end,
	})
end

return M
