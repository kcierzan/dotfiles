local M = {}

function M.new()
  local utils = require("heirline.utils")
  return {
    init = function(self)
      self.modified_count = vim.b.gitsigns_status_dict.changed
    end,
    hl = { fg = utils.get_highlight("b16_base0A").fg }, -- yellow
    {
      provider = function(self)
        return self.modified_count and self.modified_count > 0 and "~" .. self.modified_count
      end
    }
  }
end

return M
