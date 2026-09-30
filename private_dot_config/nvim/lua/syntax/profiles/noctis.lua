local common = require("syntax.profiles.common")
local M = {
	id = "noctis",
	name = "Noctis",
	description = "Orange declarations, cyan calls, blue methods and warm variables.",
}

function M.highlights(p)
	local groups = common.base(p)
	common.paint(groups, "String Character", { fg = p.base0B })
	common.paint(groups, "Number Float Boolean @constant.builtin", { fg = p.base0E })
	common.paint(
		groups,
		"Keyword Conditional Repeat Exception Include Operator PreProc StorageClass",
		{ fg = p.base08, bold = true }
	)
	common.paint(groups, "Function @variable.declaration @variable.builtin Tag", { fg = p.base09 })
	common.paint(groups, "@function.call @function.builtin @module", { fg = p.base0C })
	groups["@function.method.call"] = { fg = p.base0D }
	groups["@variable.member"] = { fg = p.base0F }
	groups.Type = { fg = p.base0F, italic = true }
	common.paint(groups, "Constant SpecialChar @attribute", { fg = p.base0A })
	groups.Variable = { fg = p.base0F }
	groups["@variable.parameter"] = { fg = p.base0F, bold = true }
	groups.Delimiter = { fg = p.base05, bold = true }
	groups["@string.escape"] = { fg = p.base05 }
	return common.semantic(groups)
end

return M
