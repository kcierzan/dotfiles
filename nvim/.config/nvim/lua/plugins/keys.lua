return {
  {
    "stevearc/dressing.nvim",
    opts = {},
  },
  {
    -- TODO: This doesn't appear to recognize the new style of which-key keybindings
    "mrjones2014/legendary.nvim",
    dependencies = { "stevearc/dressing.nvim" },
    enabled = false,
    lazy = false,
    priority = 10000,
    config = function()
      local keybinds = require("keybinds")
      -- require("legendary.util.which_key").bind_whichkey(keybinds.normal_mode_mappings, {}, false)
      require("legendary").setup({
        extensions = {
          which_key = {
            mappings = keybinds.normal_mode_mappings,
            -- auto_register = true,
            do_binding = true,
          },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local wk = require("which-key")
      local keybinds = require("keybinds")
      wk.add(keybinds.normal_mode_mappings)
      wk.add(keybinds.visual_mode_mappings)
      wk.setup({
        win = {
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        },
      })
    end,
  },
}
