local lib = require("lib")

return {
  "mrjones2014/legendary.nvim",
  dependencies = { "stevearc/dressing.nvim" },
  cmd = { "Legendary" },
  keys = {
    {
      "<leader>?",
      lib.ex_cmd("Legendary"),
      desc = "search commands",
    },
  },
  enabled = true,
  -- lazy = false,
  -- priority = 10000,
  config = function()
    require("legendary").setup({
      extensions = {
        lazy_nvim = true,
        codecompanion = true,
      },
    })
  end,
}
