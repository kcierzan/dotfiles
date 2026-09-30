local M = {}

M.profiles = {
	require("syntax.profiles.current"),
	require("syntax.profiles.zenbones"),
	require("syntax.profiles.flatwhite-simple"),
	require("syntax.profiles.flatwhite-full"),
	require("syntax.profiles.noctis"),
	require("syntax.profiles.oxocarbon"),
	(require("syntax.profiles.mariana")),
	require("syntax.profiles.catppuccin"),
	require("syntax.profiles.moe"),
}

local state_path = vim.fn.stdpath("state") .. "/syntax-profile.json"
local active, confirmed = "current", "current"
local loaded = false
local previous = {}

function M.get(id)
	for _, profile in ipairs(M.profiles) do
		if profile.id == id then
			return profile
		end
	end
end

function M.load()
	if loaded then
		return
	end
	loaded = true
	if vim.uv.fs_stat(state_path) then
		local ok, id = pcall(function()
			return vim.json.decode(table.concat(vim.fn.readfile(state_path), "\n"))
		end)
		if ok and type(id) == "string" and M.get(id) then
			active, confirmed = id, id
		else
			vim.notify("Invalid syntax profile state; using Current", vim.log.levels.WARN)
		end
	end
end

function M.active()
	M.load()
	return active
end

function M.confirmed()
	M.load()
	return confirmed
end

-- mini.base16 doesn't reset every capture a profile may own.
function M.restore()
	for group, attrs in pairs(previous) do
		vim.api.nvim_set_hl(0, group, attrs)
	end
	previous = {}
end

function M.apply(palette)
	for group, attrs in pairs(M.get(M.active()).highlights(palette)) do
		local before = vim.api.nvim_get_hl(0, { name = group, link = true })
		-- An undefined capture inherits its parent. Restoring it as an empty
		-- group would shadow that inheritance after the first profile switch.
		local parent = group:match("^(@.*)%.[^.]+$")
		previous[group] = next(before) == nil and parent and { link = parent } or before
		vim.api.nvim_set_hl(0, group, attrs)
	end
end

function M.preview(id)
	M.load()
	if not M.get(id) then
		vim.notify("Unknown syntax profile: " .. tostring(id), vim.log.levels.ERROR)
		return false
	end
	if active ~= id then
		active = id
		require("theme").apply()
		-- Query predicates depend on the active profile. Restart only existing
		-- highlighters to discard their cached matches without enabling new ones.
		local buffers = vim.tbl_keys(vim.treesitter.highlighter.active)
		for _, buf in ipairs(buffers) do
			local lang = vim.treesitter.highlighter.active[buf].tree:lang()
			vim.treesitter.stop(buf)
			vim.treesitter.start(buf, lang)
		end
		vim.cmd("redraw")
	end
	return true
end

function M.select(id)
	if not M.preview(id) then
		return false
	end
	local temp = state_path .. "." .. vim.fn.getpid() .. ".tmp"
	local ok, err = pcall(function()
		vim.fn.mkdir(vim.fn.fnamemodify(state_path, ":h"), "p")
		if vim.fn.writefile({ vim.json.encode(id) }, temp) ~= 0 then
			error("Could not write " .. temp)
		end
		local renamed, rename_err = vim.uv.fs_rename(temp, state_path)
		if not renamed then
			error(rename_err)
		end
	end)
	if not ok then
		vim.uv.fs_unlink(temp)
		M.preview(confirmed)
		vim.notify("Could not save syntax profile: " .. tostring(err), vim.log.levels.ERROR)
		return false
	end
	confirmed = id
	return true
end

function M.setup()
	M.load()
	require("syntax.queries").setup()
	vim.api.nvim_create_user_command("SyntaxPicker", function()
		require("pickers").switch_syntax()
	end, {})
	vim.api.nvim_create_user_command("SyntaxProfile", function(args)
		M.select(args.args)
	end, {
		nargs = 1,
		complete = function(prefix)
			local ids = {}
			for _, profile in ipairs(M.profiles) do
				if vim.startswith(profile.id, prefix) then
					ids[#ids + 1] = profile.id
				end
			end
			return ids
		end,
	})
end

return M
