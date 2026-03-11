local M = {}

function M.new()
  local utils = require("heirline.utils")
  return {
    init = function(self)
      self.removed_count = vim.b.gitsigns_status_dict.removed
    end,
    hl = { fg = utils.get_highlight("b16_base08").fg }, -- red
    {
      provider = function(self)
        return self.removed_count and self.removed_count > 0 and "-" .. self.removed_count
      end
    }
  }
end

return M
