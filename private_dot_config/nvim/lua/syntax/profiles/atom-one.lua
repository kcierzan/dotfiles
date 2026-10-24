local common = require("syntax.profiles.common")
local M = {
	id = "atom-one",
	name = "Atom One",
	description = "Green strings, orange constants, blue functions, purple keywords and red variables.",
}

function M.highlights(p)
	local groups = common.base(p)
	groups.Comment = { fg = p.base03, italic = true }
	common.paint(groups, "String Character", { fg = p.base0B })
	common.paint(groups, "Constant Number Float Boolean", { fg = p.base09 })
	common.paint(
		groups,
		"Statement Keyword Conditional Repeat Exception StorageClass PreProc Include Define",
		{ fg = p.base0E }
	)
	common.paint(groups, "Function", { fg = p.base0D })
	common.paint(groups, "Type Structure Typedef", { fg = p.base0A })
	common.paint(groups, "Variable Identifier", { fg = p.base08 })
	common.paint(groups, "Special SpecialChar", { fg = p.base0C })
	groups.Operator = { fg = p.base05 }
	groups.Delimiter = { fg = p.base05 }
	groups.Tag = { fg = p.base08 }

	groups["@variable.parameter"] = { fg = p.base05 }
	groups["@variable.member"] = { fg = p.base08 }
	groups["@variable.builtin"] = { fg = p.base08 }
	groups["@string.regexp"] = { fg = p.base0C }
	common.paint(groups, "@string.escape @string.special.symbol", { fg = p.base0C })
	common.paint(groups, "@function.builtin @function.macro", { fg = p.base0C })
	groups["@type.builtin"] = { fg = p.base0E }
	groups["@constructor"] = { fg = p.base0A }
	groups["@module"] = { fg = p.base0A }
	groups["@attribute"] = { fg = p.base09 }
	groups["@tag.attribute"] = { fg = p.base09 }

	groups["@markup.bold"] = { fg = p.base09, bold = true }
	groups["@markup.italic"] = { fg = p.base0E, italic = true }
	groups["@markup.heading"] = { fg = p.base08 }
	groups["@markup.link"] = { fg = p.base0C, underline = true }
	groups["@markup.link.url"] = { fg = p.base0C, underline = true }
	groups["@markup.raw"] = { fg = p.base0B }
	groups["@markup.quote"] = { fg = p.base09 }

	return common.semantic(groups)
end

return M
