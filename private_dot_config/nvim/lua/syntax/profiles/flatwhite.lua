local common = require("syntax.profiles.common")
local M = {}

-- Doom Flatwhite carries the original theme's neutral colors and secondary
-- accents in Base16 slots. Use the original primary text/background pairs for
-- this palette; other palettes keep the portable Base16 interpolation.
local doom_flatwhite = {
	palette = {
		base00 = "#f7f3ee",
		base05 = "#605a52",
		base09 = "#957f5f",
		base0B = "#81895d",
		base0C = "#5f8c7d",
		base0D = "#7382a0",
		base0E = "#9c739c",
	},
	families = {
		orange = { fg = "#5b5143", bg = "#f7e0c3" },
		green = { fg = "#525643", bg = "#e2e9c1" },
		teal = { fg = "#465953", bg = "#d2ebe3" },
		blue = { fg = "#4c5361", bg = "#dde4f2" },
		purple = { fg = "#614c61", bg = "#f1ddf1" },
	},
}

local function is_doom_flatwhite(palette)
	for slot, color in pairs(doom_flatwhite.palette) do
		if palette[slot]:lower() ~= color then
			return false
		end
	end
	return true
end

local function blend(base, accent, amount)
	local channels = {}
	for i = 1, 3 do
		local offset = i * 2
		local a = tonumber(base:sub(offset, offset + 1), 16)
		local b = tonumber(accent:sub(offset, offset + 1), 16)
		channels[i] = math.floor(a * (1 - amount) + b * amount + 0.5)
	end
	return string.format("#%02x%02x%02x", unpack(channels))
end

function M.highlights(p, simple)
	local groups = common.base(p)
	local function family(slot, amount)
		return { fg = blend(p.base05, p[slot], 0.15), bg = blend(p.base00, p[slot], amount) }
	end
	local exact = is_doom_flatwhite(p) and doom_flatwhite.families or {}
	local orange = exact.orange or family("base09", 0.18)
	local green = exact.green or family("base0B", 0.19)
	local teal = exact.teal or family("base0C", 0.15)
	local blue = exact.blue or family("base0D", 0.20)
	local purple = exact.purple or family("base0E", 0.15)
	common.paint(groups, "String Character @string.regexp", green)
	common.paint(groups, "Number Float Boolean @constant.builtin @variable.builtin", teal)
	common.paint(groups, "Constant SpecialChar @string.special.symbol", blue)
	common.paint(groups, "Conditional Repeat Exception Include @keyword.return @keyword.function Tag", purple)
	common.paint(groups, "@function.builtin.ruby @keyword.modifier.ruby", orange)
	groups["@string.escape"] = { fg = green.fg }
	groups["@tag.attribute"] = { fg = p.base04, italic = true }
	groups["@tag.delimiter"] = { fg = p.base04 }
	groups.Comment = { fg = p.base03, italic = true }
	groups["@syntax.embedded"] = simple and orange or {}
	groups["@syntax.embedded.boundary"] = orange
	groups["@syntax.embedded.reset"] = { fg = p.base05, bg = p.base00 }
	return common.semantic(groups)
end

return M
