-- lua/plugins/which-key.lua
-- Group labels only. All actual bindings live in lua/keymaps.lua and are
-- registered either by keys.lua (startup) or by individual plugin specs.
-- which-key reads registered keymaps automatically via its lazy autocmd.

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      local wk = require("which-key")

      wk.add({
        { "<leader>a",  group = "AI" },
        { "<leader>c",  group = "Code / LSP" },
        { "<leader>cd", group = "Debug" },
        { "<leader>g",  group = "Git" },
        { "<leader>t",  group = "Test" },
        { "<leader>u",  group = "Toggle" },
        { "<leader>v",  group = "Neovim" },
        { "<leader>w",  group = "Window" },
      })

      wk.setup({
        preset = "helix",
        win = {
          border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        },
      })
    end,
  },
}
