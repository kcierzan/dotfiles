-- lua/keys.lua
-- Thin consumer of lua/keymaps.lua.
-- Registers core groups at startup (before lazy.nvim loads plugins).

local M = {}

function M.setup()
  vim.g.mapleader      = " "
  vim.g.maplocalleader = "+"

  local km = require("keymaps")

  -- Groups that have no plugin dependency and must be available immediately.
  local core_groups = { km.core, km.lsp, km.windows }

  for _, group in ipairs(core_groups) do
    for _, mapping in ipairs(group) do
      local key    = mapping[1]
      local action = mapping[2]
      local modes  = mapping.mode or { "n" }
      local opts   = {
        noremap = true,
        silent  = true,
        desc    = mapping.desc,
      }
      if mapping.expr then opts.expr = mapping.expr end
      vim.keymap.set(modes, key, action, opts)
    end
  end
end

return M
