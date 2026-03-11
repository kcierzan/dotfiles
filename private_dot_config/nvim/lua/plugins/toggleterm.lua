-- <C-;> is kept as a bare string entry so lazy.nvim registers it as a
-- lazy-load trigger. The actual binding is created by toggleterm's
-- open_mapping opt after the plugin loads.
-- <leader>Q (quit without saving) was removed from here — it now lives in
-- keymaps.lua M.windows and is registered at startup by keys.lua.

return {
  "akinsho/toggleterm.nvim",
  enabled = true,
  version = "*",
  keys = vim.list_extend({ "<C-;>" }, require("keymaps").for_plugin("toggleterm")),
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    open_mapping = "<C-;>",
    persist_mode = true,
    size = 20,
    float_opts = {
      border = "curved",
    },
  },
}
