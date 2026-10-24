local common = require("syntax.profiles.common")
local M = {
	id = "sublime-monokai",
	name = "Sublime Monokai",
	description = "Yellow strings, purple constants, green definitions and pink keywords.",
}

function M.highlights(p)
	local groups = common.base(p)
	groups.Comment = { fg = p.base03 }
	common.paint(groups, "String Character", { fg = p.base0A })
	common.paint(groups, "Constant Number Float Boolean", { fg = p.base0E })
	common.paint(
		groups,
		"Statement Keyword Conditional Repeat Exception StorageClass PreProc Include Define",
		{ fg = p.base08 }
	)
	common.paint(groups, "Function Type Structure Typedef", { fg = p.base0B })
	common.paint(groups, "Special SpecialChar", { fg = p.base0E })
	groups.Operator = { fg = p.base08 }
	groups.Delimiter = { fg = p.base05 }
	groups.Tag = { fg = p.base08 }

	common.paint(groups, "@function.call @function.method.call @function.builtin @function.macro", { fg = p.base0C })
	common.paint(groups, "@variable.parameter @variable.builtin", { fg = p.base09, italic = true })
	groups["@variable.member"] = { fg = p.base05 }
	groups["@constant.macro"] = { fg = p.base0E }
	common.paint(groups, "@string.escape @string.special.symbol", { fg = p.base0E })
	groups["@type.builtin"] = { fg = p.base0C, italic = true }
	groups["@keyword.type"] = { fg = p.base0C, italic = true }
	groups["@keyword.storage"] = { fg = p.base08 }
	groups["@constructor"] = { fg = p.base0B }
	groups["@module"] = { fg = p.base0B }
	groups["@attribute"] = { fg = p.base0B }
	groups["@tag.attribute"] = { fg = p.base0B }

	groups["@markup.heading"] = { fg = p.base05, bold = true }
	groups["@markup.heading.1"] = { fg = p.base08, bold = true }
	groups["@markup.link"] = { fg = p.base0C, underline = true }
	groups["@markup.link.url"] = { fg = p.base0C, underline = true }
	groups["@markup.raw"] = { fg = p.base05 }
	groups["@markup.list"] = { fg = p.base0E }
	groups["@markup.quote"] = { fg = p.base03 }

	return common.semantic(groups)
end

return M
