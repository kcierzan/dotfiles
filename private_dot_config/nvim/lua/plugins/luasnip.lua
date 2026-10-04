-- Keybindings are registered via require("keymaps").register("luasnip") rather
-- than lazy.nvim `keys` to avoid making <Tab> a lazy-load trigger (which would
-- intercept every Tab keypress before luasnip is loaded).

return {
	"L3MON4D3/LuaSnip",
	version = "2.*",
	build = "make install_jsregexp",
	config = function()
		-- Discover VS Code snippets on the runtime path, including
		-- friendly-snippets. A paths option here would disable that discovery.
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_lua").lazy_load({
			paths = { vim.fn.stdpath("config") .. "/snippets" },
		})

		-- Register snippet navigation keymaps now that luasnip is loaded.
		-- Definitions live in lua/keymaps.lua M.luasnip.
		require("keymaps").register("luasnip")
	end,
}
