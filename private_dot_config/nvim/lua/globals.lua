local M = {}

function M.setup()
  _G.dd = function(...)
    Snacks.debug.inspect(...)
  end

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.highlight.priorities.semantic_tokens = 95
end

return M
