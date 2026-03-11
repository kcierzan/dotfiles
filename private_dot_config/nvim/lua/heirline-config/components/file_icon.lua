local M = {}

local utils = require("heirline.utils")

function M.new()
  return {
    init = function(self)
      self.filename = vim.api.nvim_buf_get_name(0)
      self.icon, self.icon_color = require("mini.icons").get("file", self.filename)
    end,
    provider = function(self)
      return self.icon and (self.icon .. " ")
    end,
    hl = function(self)
      return { fg = utils.get_highlight(self.icon_color).fg }
    end
  }
end

return M
