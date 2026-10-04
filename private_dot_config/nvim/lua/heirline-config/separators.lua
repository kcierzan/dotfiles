local M = {}

M.styles = {
	"none",
	"block",
	"rounded",
	"arrow",
	"slant",
	"slant_down",
	"gradient",
}

local current = "rounded"
local layout = "chips"
local state_file = vim.fn.stdpath("state") .. "/heirline-separators.json"

local function valid_style(style)
	return vim.tbl_contains(M.styles, style)
end

local function load_state()
	if vim.fn.filereadable(state_file) == 0 then
		return
	end

	local ok, state = pcall(vim.json.decode, table.concat(vim.fn.readfile(state_file), "\n"))
	if not ok or type(state) ~= "table" then
		return
	end

	if valid_style(state.style) then
		current = state.style
	end
	if state.layout == "chips" or state.layout == "airline" then
		layout = state.layout
	end
end

load_state()

function M.get()
	return current
end

function M.select(style)
	if not valid_style(style) then
		error("unknown heirline separator: " .. style)
	end

	current = style
	vim.cmd.redrawstatus()
end

function M.get_layout()
	return layout
end

function M.select_layout(value)
	if value ~= "chips" and value ~= "airline" then
		error("unknown heirline separator layout: " .. value)
	end

	layout = value
	vim.cmd.redrawstatus()
end

function M.toggle_layout()
	M.select_layout(layout == "chips" and "airline" or "chips")
end

function M.save()
	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	vim.fn.writefile({ vim.json.encode({ style = current, layout = layout }) }, state_file)
end

return M
