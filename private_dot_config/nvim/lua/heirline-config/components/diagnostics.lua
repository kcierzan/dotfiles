local M = {}

local utils = require("heirline.utils")

local function create_diagnostic_count(severity, severity_name)
  return {
    init = function(self)
      self.count = #vim.diagnostic.get(0, { severity = severity })
    end,
    condition = function()
      return #vim.diagnostic.get(0, { severity = severity }) > 0
    end,
    provider = function(self)
      if self.count > 0 then
        return "●" .. " " .. self.count .. " "
      end
    end,
    hl = { fg = utils.get_highlight("Diagnostic" .. severity_name).fg },
  }
end

function M.new()
  return {
    update = { "DiagnosticChanged", "BufEnter" },
    create_diagnostic_count(vim.diagnostic.severity.ERROR, "Error"),
    create_diagnostic_count(vim.diagnostic.severity.WARN, "Warn"),
    create_diagnostic_count(vim.diagnostic.severity.INFO, "Info"),
    create_diagnostic_count(vim.diagnostic.severity.HINT, "Hint"),
  }
end

return M
