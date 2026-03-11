-- Keybindings are registered via require("keymaps").register("luasnip") rather
-- than lazy.nvim `keys` to avoid making <Tab> a lazy-load trigger (which would
-- intercept every Tab keypress before luasnip is loaded).

return {
  "L3MON4D3/LuaSnip",
  version = "2.*",
  build = "make install_jsregexp",
  -- dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load({
      -- exclude = { "ruby", "rails" },
      paths = { "./snippets" },
    })
    require("luasnip.loaders.from_lua").lazy_load({
      paths = { "./snippets" },
    })

    -- Register snippet navigation keymaps now that luasnip is loaded.
    -- Definitions live in lua/keymaps.lua M.luasnip.
    require("keymaps").register("luasnip")
  end,
}
