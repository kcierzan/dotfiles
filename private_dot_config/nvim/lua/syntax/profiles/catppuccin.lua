local common = require("syntax.profiles.common")
local M = {
	id = "catppuccin",
	name = "Catppuccin",
	description = "Green strings, peach literals, blue functions, mauve keywords and yellow types.",
}

function M.highlights(p)
	local groups = common.base(p)
	groups.Comment = { fg = p.base03, italic = true }
	common.paint(
		groups,
		"Constant Number Float Boolean @constant.builtin @function.builtin @attribute",
		{ fg = p.base09 }
	)
	groups.String = { fg = p.base0B }
	groups.Character = { fg = p.base0C }
	common.paint(groups, "Identifier @string.special.symbol", { fg = p.base0F })
	groups.Function = { fg = p.base0D }
	common.paint(groups, "Statement Keyword Repeat Exception Include Macro", { fg = p.base0E })
	groups.Conditional = { fg = p.base0E, italic = true }
	common.paint(groups, "Operator Label", { fg = p.base0C })
	common.paint(groups, "PreProc Special SpecialChar", { fg = p.base08 })
	common.paint(groups, "StorageClass Structure Type", { fg = p.base0A })
	groups.Delimiter = { fg = p.base04 }
	groups.Tag = { fg = p.base0D, bold = true }

	groups.Variable = { fg = p.base05 }
	groups["@variable.parameter"] = { fg = p.base0F }
	groups["@variable.builtin"] = { fg = p.base08 }
	groups["@variable.member"] = { fg = p.base05 }
	groups["@module"] = { fg = p.base0A, italic = true }
	common.paint(groups, "@string.documentation @markup.list @tag.delimiter", { fg = p.base0C })
	common.paint(groups, "@string.regexp @string.escape @function.macro", { fg = p.base08 })
	groups["@string.special.url"] = { fg = p.base0D, italic = true, underline = true }
	groups["@type.builtin"] = { fg = p.base0E, italic = true }
	groups["@constructor"] = { fg = p.base0A }
	groups["@punctuation.bracket"] = { fg = p.base04 }
	common.paint(groups, "@tag @tag.builtin", { fg = p.base0D })
	groups["@tag.attribute"] = { fg = p.base0A, italic = true }

	common.paint(groups, "@markup.heading @markup.math @markup.environment.name", { fg = p.base0D })
	common.paint(groups, "@markup.quote @markup.environment", { fg = p.base08 })
	common.paint(groups, "@markup.link @markup.link.label", { fg = p.base0D })
	groups["@markup.link.url"] = { fg = p.base0D, italic = true, underline = true }
	groups["@markup.raw"] = { fg = p.base0B }
	groups["@markup.list.checked"] = { fg = p.base0B }
	groups["@markup.list.unchecked"] = { fg = p.base04 }

	-- Language-specific roles retained by the pinned Catppuccin definitions.
	groups["@function.builtin.bash"] = { fg = p.base08, italic = true }
	groups["@variable.parameter.bash"] = { fg = p.base0B }
	common.paint(groups, "@property.css @property.scss @property.toml @property.json @property.yaml", { fg = p.base0D })
	common.paint(groups, "@property.id.css @property.class.css @label.yaml", { fg = p.base0A })
	groups["@type.css"] = { fg = p.base0D }
	groups["@type.tag.css"] = { fg = p.base0D }
	groups["@string.plain.css"] = { fg = p.base05 }
	groups["@string.special.url.html"] = { fg = p.base0B }
	groups["@markup.link.label.html"] = { fg = p.base05 }
	groups["@character.special.html"] = { fg = p.base08 }
	common.paint(groups, "@variable.member.nix @lsp.type.property.nix", { fg = p.base0D })
	groups["@keyword.import.c"] = { fg = p.base0A }
	groups["@keyword.import.cpp"] = { fg = p.base0A }
	groups["@attribute.c_sharp"] = { fg = p.base0A }

	return common.semantic(groups)
end

return M
