local common = require("syntax.profiles.common")
local M = {
	id = "oxocarbon",
	name = "Oxocarbon",
	description = "Bold pink functions, cyan methods, blue keywords and purple constants.",
}

function M.highlights(p)
	local groups = common.base(p)
	common.paint(groups, "String Character @constant", { fg = p.base0E })
	common.paint(
		groups,
		"Boolean Type Keyword Conditional Repeat Include StorageClass PreProc Statement Define Structure Typedef @constructor @number Tag",
		{ fg = p.base0D }
	)
	common.paint(groups, "Number Float", { fg = p.base0D })
	groups.Comment = { fg = p.base03, italic = true }
	groups.Function = { fg = p.base0C }
	groups["@function"] = { fg = p.base08, bold = true }
	groups["@function.builtin"] = { fg = p.base08 }
	groups.Operator = { fg = p.base0D }
	common.paint(
		groups,
		"@function.method @function.method.call @function.macro @constant.builtin @constant.macro @module @string.regexp",
		{ fg = p.base0C }
	)
	common.paint(groups, "@keyword.function @keyword.operator Delimiter", { fg = p.base0C })
	common.paint(groups, "@string.escape @label Exception @attribute @tag.attribute @tag.delimiter", { fg = p.base0D })
	groups["@string.special.symbol"] = { fg = p.base0D, bold = true }
	-- Upstream's old @field is the modern @variable.member; its distinct
	-- @property role remains for parsers that still emit that capture.
	groups["@property"] = { fg = p.base08 }
	common.semantic(groups)
	groups["@lsp.typemod.method.declaration"] = { link = "@function" }
	groups["@lsp.typemod.method.definition"] = { link = "@function" }
	groups["@lsp.typemod.property.declaration"] = { link = "@property" }
	groups["@lsp.typemod.property.definition"] = { link = "@property" }
	groups["@lsp.type.escapeSequence"] = { link = "@string.escape" }
	groups["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" }
	groups["@lsp.mod.typeHint"] = { link = "Type" }
	return groups
end

return M
