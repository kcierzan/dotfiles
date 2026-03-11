local M = {}

function M.new()
  local utils = require("heirline.utils")
  return {
    init = function(self)
      self.added_count = vim.b.gitsigns_status_dict.added
    end,
    hl = { fg = utils.get_highlight("b16_base0B").fg }, -- green
    {
      provider = function(self)
        return self.added_count and self.added_count > 0 and "+" .. self.added_count
      end
    }
  }
end

return M
