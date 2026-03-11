return {
  "mrjones2014/legendary.nvim",
  cmd = { "Legendary" },
  keys = require("keymaps").for_plugin("legendary"),
  enabled = true,
  config = function()
    require("legendary").setup({
      extensions = {
        lazy_nvim = true,
      },
    })
  end,
}
