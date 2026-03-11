local M = {}

function M.new(palette)
  return {
    init = function(self)
      self.status_dict = vim.b.gitsigns_status_dict
      self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    hl = { fg = palette.branch_fg },
    {
      provider = function(self)
        return "󰘬 " .. self.status_dict.head
      end,
    },
  }
end

return M
