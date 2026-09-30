local common = require("syntax.profiles.common")
local M = {
	id = "zenbones",
	name = "Zenbones",
	description = "Neutral syntax that uses contrast, bold and italics instead of accent colors.",
}

function M.highlights(p)
	local groups = common.base(p)
	local dim = { fg = p.base03 }
	local quiet = { fg = p.base04 }
	local text = { fg = p.base05 }

	groups.Comment = { fg = p.base03, italic = true }
	groups.SpecialComment = dim

	groups.Constant = { fg = p.base04, italic = true }
	groups.String = { fg = p.base04, italic = true }
	groups.Character = { fg = p.base04, italic = true }
	common.paint(groups, "Number Float", quiet)
	groups.Boolean = { fg = p.base05, italic = true }

	common.paint(groups, "Identifier Variable", quiet)
	groups.Function = text
	common.paint(
		groups,
		"Statement Conditional Repeat Label Operator Keyword Exception PreProc Include Define Macro PreCondit",
		{ fg = p.base05, bold = true }
	)
	common.paint(groups, "StorageClass Structure Type Typedef", quiet)
	common.paint(groups, "Special SpecialChar Tag", { fg = p.base04, bold = true })
	groups.Delimiter = dim
	groups.Todo = { fg = p.base05, bold = true, underline = true }

	groups["@variable.builtin"] = { link = "Constant" }
	groups["@constant"] = { fg = p.base04, bold = true }
	groups["@constant.builtin"] = { link = "Constant" }
	groups["@constant.macro"] = { link = "Constant" }
	groups["@module"] = { link = "Constant" }
	groups["@label"] = { link = "Statement" }
	groups["@string.regexp"] = { link = "Constant" }
	common.paint(groups, "@string.escape @string.special @character.special", { fg = p.base04, bold = true })
	groups["@string.special.symbol"] = { link = "Identifier" }
	groups["@property"] = { link = "Identifier" }
	groups["@function.builtin"] = { link = "Special" }
	groups["@function.macro"] = { link = "PreProc" }
	groups["@constructor"] = { link = "Special" }
	groups["@attribute"] = { link = "PreProc" }
	groups["@keyword.storage"] = { link = "Type" }
	groups["@keyword.debug"] = { link = "Special" }
	groups["@tag"] = { link = "Special" }
	groups["@tag.builtin"] = { link = "@tag" }
	groups["@tag.attribute"] = { link = "@property" }
	groups["@tag.delimiter"] = { link = "Delimiter" }
	groups["@comment.todo"] = { link = "Todo" }

	groups["@markup.strong"] = { bold = true }
	groups["@markup.italic"] = { italic = true }
	groups["@markup.strikethrough"] = { strikethrough = true }
	groups["@markup.underline"] = { underline = true }
	groups["@markup.heading"] = { fg = p.base05, bold = true }
	groups["@markup.quote"] = quiet
	groups["@markup.math"] = { link = "Special" }
	groups["@markup.environment"] = { link = "PreProc" }
	groups["@markup.link"] = { link = "Constant" }
	groups["@markup.link.label"] = { link = "Special" }
	groups["@markup.link.url"] = { link = "Constant" }
	groups["@markup.raw"] = { link = "Constant" }
	groups["@markup.raw.block"] = { link = "@markup.raw" }
	groups["@markup.list"] = { link = "Special" }
	groups["@markup.list.checked"] = { link = "@markup.list" }
	groups["@markup.list.unchecked"] = { link = "@markup.list" }

	return common.semantic(groups)
end

return M
