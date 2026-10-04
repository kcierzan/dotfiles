local M = {}

local mode_icons = {
	n = "",
	no = "",
	nov = "",
	noV = "",
	["no\22"] = "",
	niI = "",
	niR = "",
	niV = "",
	nt = "",
	v = "",
	vs = "",
	V = "",
	Vs = "",
	["\22"] = "󰩬",
	["\22s"] = "󰩬",
	s = "󰩬",
	S = "󰩬",
	["\19"] = "󰩬",
	i = "",
	ic = "",
	ix = "",
	R = "",
	Rc = "",
	Rx = "",
	Rv = "",
	Rvc = "",
	Rvx = "",
	c = "󰘳",
	cv = "",
	r = "",
	rm = "",
	["r?"] = "",
	["!"] = "",
	t = "",
}

local ModeBlock = {
	static = {
		mode_icons = mode_icons,
	},
	init = function(self)
		self.mode = vim.fn.mode(1)
	end,
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

local ModeIcon = {
	provider = function(self)
		return self.mode_icons[self.mode]
	end,
}

local Mode = require("heirline.utils").insert(ModeBlock, ModeIcon)

function M.new()
	return Mode
end

return M
