local common = require("syntax.profiles.common")
local M = {
	id = "mariana",
	name = "Mariana",
	description = "Cyan definitions, blue calls, orange parameters and italic built-ins.",
}

function M.highlights(p)
	local groups = common.base(p)
	common.paint(groups, "String Character", { fg = p.base0B })
	common.paint(groups, "Number Float Type @variable.parameter", { fg = p.base09 })
	common.paint(groups, "Boolean @constant.builtin @variable.builtin", { fg = p.base08, italic = true })
	common.paint(groups, "Constant Keyword Conditional Repeat Exception Include @tag.attribute", { fg = p.base0E })
	common.paint(groups, "@variable.member StorageClass Tag", { fg = p.base08 })
	groups["@keyword.modifier"] = { fg = p.base08 }
	groups["@keyword.storage"] = { fg = p.base08 }
	common.paint(groups, "@keyword.type @keyword.function", { fg = p.base0E, italic = true })
	groups.Operator = { fg = p.base09 }
	common.paint(groups, "Function SpecialChar", { fg = p.base0C })
	common.paint(groups, "@function.call @function.method.call", { fg = p.base0D })
	common.paint(groups, "@function.builtin @function.macro @type.builtin", { fg = p.base0D, italic = true })
	groups["@punctuation.bracket"] = { fg = p.base07 }
	groups.Delimiter = { fg = p.base04 }
	groups["@constant.macro"] = { fg = p.base0E, italic = true }
	common.paint(groups, "@string.escape @string.special.symbol", { fg = p.base0E })
	return common.semantic(groups)
end

return M
