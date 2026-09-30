local M = {}

function M.paint(groups, names, attrs)
	for name in names:gmatch("%S+") do
		groups[name] = vim.deepcopy(attrs)
	end
end

function M.parents(groups)
	groups["@variable.declaration"] = groups["@variable.declaration"] or { link = "@variable" }
	groups["@keyword.storage"] = groups["@keyword.storage"] or { link = "@keyword" }
	groups["@syntax.embedded"] = groups["@syntax.embedded"] or { link = "@none" }
	groups["@syntax.embedded.reset"] = groups["@syntax.embedded.reset"] or { link = "@none" }
	groups["@syntax.embedded.boundary"] = groups["@syntax.embedded.boundary"] or { link = "@punctuation.special" }
	return groups
end

function M.base(p)
	local groups = {}
	M.paint(
		groups,
		"Boolean Character Conditional Constant Define Delimiter Exception Float Function Identifier Include Keyword Label Macro Number Operator PreCondit PreProc Repeat Special SpecialChar SpecialComment Statement StorageClass String Structure Tag Type Typedef Variable",
		{ fg = p.base05 }
	)
	groups.Comment = { fg = p.base03 }
	local links = {
		["@comment"] = "Comment",
		["@constant"] = "Constant",
		["@constant.builtin"] = "Constant",
		["@constant.macro"] = "Macro",
		["@string"] = "String",
		["@string.regexp"] = "String",
		["@string.escape"] = "SpecialChar",
		["@string.special.symbol"] = "SpecialChar",
		["@character"] = "Character",
		["@boolean"] = "Boolean",
		["@number"] = "Number",
		["@number.float"] = "Float",
		["@function"] = "Function",
		["@function.call"] = "@function",
		["@function.method"] = "@function",
		["@function.method.call"] = "@function.call",
		["@function.builtin"] = "@function.call",
		["@function.macro"] = "Macro",
		["@constructor"] = "Type",
		["@variable"] = "Variable",
		["@variable.parameter"] = "@variable",
		["@variable.member"] = "@variable",
		["@variable.builtin"] = "@variable",
		["@property"] = "@variable.member",
		["@module"] = "Type",
		["@type"] = "Type",
		["@type.builtin"] = "@type",
		["@type.definition"] = "@type",
		["@attribute"] = "Special",
		["@label"] = "Label",
		["@operator"] = "Operator",
		["@keyword"] = "Keyword",
		["@keyword.return"] = "@keyword",
		["@keyword.function"] = "@keyword",
		["@keyword.type"] = "@keyword",
		["@keyword.modifier"] = "@keyword",
		["@keyword.operator"] = "@operator",
		["@keyword.conditional"] = "Conditional",
		["@keyword.repeat"] = "Repeat",
		["@keyword.exception"] = "Exception",
		["@keyword.import"] = "Include",
		["@keyword.directive"] = "PreProc",
		["@keyword.coroutine"] = "@keyword",
		["@punctuation.delimiter"] = "Delimiter",
		["@punctuation.bracket"] = "Delimiter",
		["@punctuation.special"] = "SpecialChar",
		["@tag"] = "Tag",
		["@tag.builtin"] = "@tag",
		["@tag.attribute"] = "@attribute",
		["@tag.delimiter"] = "Delimiter",
	}
	for group, target in pairs(links) do
		groups[group] = { link = target }
	end
	return M.parents(groups)
end

-- Generic symbol tokens would erase call/declaration and grammar distinctions.
-- Retain semantic meaning through specific type/modifier combinations instead.
function M.semantic(groups)
	M.paint(
		groups,
		"@lsp.type.function @lsp.type.method @lsp.type.variable @lsp.type.parameter @lsp.type.property @lsp.type.comment @lsp.type.keyword @lsp.type.modifier @lsp.type.number @lsp.type.boolean @lsp.type.operator @lsp.type.regexp @lsp.type.string",
		{}
	)
	local links = {
		class = "@type",
		enum = "@type",
		enumMember = "@constant",
		interface = "@type",
		struct = "@type",
		type = "@type",
		typeParameter = "@type",
		typeAlias = "@type.definition",
		namespace = "@module",
		decorator = "@attribute",
		macro = "@function.macro",
		event = "@attribute",
		selfParameter = "@variable.builtin",
		selfKeyword = "@variable.builtin",
		builtinConstant = "@constant.builtin",
		builtinType = "@type.builtin",
		magicFunction = "@function.builtin",
	}
	for kind, target in pairs(links) do
		groups["@lsp.type." .. kind] = { link = target }
	end
	for _, modifier in ipairs({ "declaration", "definition" }) do
		for kind, target in pairs({
			["function"] = "@function",
			method = "@function.method",
			variable = "@variable.declaration",
			parameter = "@variable.parameter",
			property = "@variable.member",
		}) do
			groups["@lsp.typemod." .. kind .. "." .. modifier] = { link = target }
		end
	end
	for _, kind in ipairs({ "variable", "property", "parameter" }) do
		groups["@lsp.typemod." .. kind .. ".readonly"] = { link = "@constant" }
	end
	for _, modifier in ipairs({ "defaultLibrary", "builtin" }) do
		for kind, target in pairs({
			["function"] = "@function.builtin",
			method = "@function.builtin",
			variable = "@variable.builtin",
			class = "@type.builtin",
			type = "@type.builtin",
			enum = "@type.builtin",
			enumMember = "@constant.builtin",
		}) do
			groups["@lsp.typemod." .. kind .. "." .. modifier] = { link = target }
		end
	end
	groups["@lsp.mod.readonly"] = {}
	groups["@lsp.mod.deprecated"] = { strikethrough = true }
	return groups
end

return M
