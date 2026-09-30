local M = {
	id = "current",
	name = "Current",
	description = "Existing Base16 syntax, including Ruby, Lua, Zig, Nix and LSP overrides.",
}

function M.highlights(colors)
	local groups = {
		-- Syntax
		SpecialChar = { fg = colors.base04 }, -- ruby symbols link to this
		Delimiter = { fg = colors.base04 },
		Variable = { fg = colors.base05 },
		["@module"] = { fg = colors.base0C },

		-- ruby
		["@string.special.symbol.ruby"] = { fg = colors.base0C },
		["@function.call.ruby"] = { fg = colors.base0D },
		["@variable.ruby"] = { link = "Variable" },
		["@function.ruby"] = { fg = colors.base0D },
		["@keyword.type.ruby"] = { fg = colors.base0E, bold = true },
		["@variable.parameter.ruby"] = { link = "Variable" },
		["@keyword.ruby"] = { fg = colors.base0E, bold = true },
		["@function.builtin.ruby"] = { link = "@function.ruby" },
		["@keyword.function.ruby"] = { fg = colors.base0E, bold = true },
		["@type.ruby"] = { fg = colors.base0A, bold = true },
		["@constant.ruby"] = { fg = colors.base09 },
		["@constant.builtin.ruby"] = { link = "@constant.ruby" },
		["@keyword.exception.ruby"] = { fg = colors.base08, bold = true },
		["@comment.documentation.ruby"] = { link = "@comment.ruby" },
		["@comment.ruby"] = { fg = colors.base03, italic = true },
		["@keyword.conditional.ruby"] = { fg = colors.base0F, bold = true },
		["@operator.ruby"] = { link = "Operator" },

		-- lua
		["@keyword.lua"] = { fg = colors.base0E, bold = true },

		-- zig
		["@punctuation.delimiter.zig"] = { fg = colors.base05 },
		["@punctuation.bracket.zig"] = { fg = colors.base04 },
		["@comment.zig"] = { fg = colors.base03 },

		-- Types: yellow; constants: orange; functions: blue; variables: neutral;
		-- modules and special symbols: cyan. Match the Tree-sitter palette.
		["@lsp.type.class"] = { link = "@type" },
		["@lsp.type.decorator"] = { fg = colors.base0C },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.enumMember"] = { link = "@constant" },
		["@lsp.type.event"] = { fg = colors.base0C },
		["@lsp.type.function"] = { link = "@function" },
		["@lsp.type.interface"] = { link = "@type" },
		["@lsp.type.macro"] = { fg = colors.base0C },
		["@lsp.type.method"] = { link = "@function.method" },
		["@lsp.type.namespace"] = { link = "@module" },
		["@lsp.type.parameter"] = { link = "@variable.parameter" },
		["@lsp.type.property"] = { link = "@variable.member" },
		["@lsp.type.struct"] = { link = "@type" },
		["@lsp.type.type"] = { link = "@type" },
		["@lsp.type.typeParameter"] = { link = "@type" },
		["@lsp.type.variable"] = { link = "@variable" },

		-- Preserve Ruby's language-specific Tree-sitter colors.
		["@lsp.type.class.ruby"] = { link = "@type.ruby" },
		["@lsp.type.type.ruby"] = { link = "@type.ruby" },

		-- Tree-sitter already handles syntax categories; LSP adds symbol meaning.
		["@lsp.type.comment"] = {},
		["@lsp.type.keyword"] = {},
		["@lsp.type.modifier"] = {},
		["@lsp.type.number"] = {},
		["@lsp.type.operator"] = {},
		["@lsp.type.regexp"] = {},
		["@lsp.type.string"] = {},

		["@lsp.mod.deprecated"] = { fg = colors.base08, strikethrough = true },
		["@lsp.mod.readonly"] = { italic = true },

		-- nix
		["@string.special.path.nix"] = { fg = colors.base0D },
	}
	groups["@function.method.call.ruby"] = { link = "@function.call.ruby" }
	groups["@keyword.storage.lua"] = { link = "@keyword.lua" }
	return require("syntax.profiles.common").parents(groups)
end

return M
