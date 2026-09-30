local common = require("syntax.profiles.common")
local M = {
	id = "moe",
	name = "Moe",
	description = "Magenta strings, green keywords, warm functions and orange variables.",
}

function M.highlights(p)
	local groups = common.base(p)
	local function_color = p.variant == "light" and p.base08 or p.base0A

	groups.Comment = { fg = p.base03, italic = true }
	groups["@comment.documentation"] = { fg = p.base08, italic = true }
	common.paint(groups, "Constant Number Float Boolean", { fg = p.base0D })
	common.paint(groups, "String Character", { fg = p.base0E })
	common.paint(groups, "Function Tag", { fg = function_color })
	common.paint(groups, "Statement Keyword Conditional Repeat Exception", { fg = p.base0B })
	common.paint(groups, "PreProc Include Define Macro", { fg = p.base0F })
	common.paint(groups, "StorageClass Structure Type Typedef", { fg = p.base0C })
	common.paint(groups, "Variable Identifier @variable.parameter @variable.member", { fg = p.base09 })
	common.paint(groups, "@function.builtin @variable.builtin @type.builtin", { fg = p.base0F })
	common.paint(groups, "Special SpecialChar @string.documentation", { fg = p.base0A })
	groups.SpecialComment = { fg = p.base08, italic = true }
	groups["@string.regexp"] = { fg = p.base0E }
	groups["@string.escape"] = { fg = p.base0A }
	groups["@string.special.symbol"] = { fg = p.base0F }
	groups["@attribute"] = { fg = p.base0F }
	groups.Delimiter = { fg = p.base04 }
	groups.Operator = { fg = p.base05 }

	return common.semantic(groups)
end

return M
