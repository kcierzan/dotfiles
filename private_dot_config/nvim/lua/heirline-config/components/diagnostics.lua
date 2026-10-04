local M = {}

local utils = require("heirline.utils")

local function create_diagnostic_count(severity, severity_name, preceding_severities)
	return {
		init = function(self)
			self.count = #vim.diagnostic.get(0, { severity = severity })
		end,
		condition = function()
			return #vim.diagnostic.get(0, { severity = severity }) > 0
		end,
		provider = function(self)
			local prefix = ""
			for _, preceding_severity in ipairs(preceding_severities) do
				if #vim.diagnostic.get(0, { severity = preceding_severity }) > 0 then
					prefix = "  "
					break
				end
			end
			return prefix .. "● " .. self.count
		end,
		hl = { fg = utils.get_highlight("Diagnostic" .. severity_name).fg },
	}
end

function M.new()
	return {
		update = { "DiagnosticChanged", "BufEnter" },
		create_diagnostic_count(vim.diagnostic.severity.ERROR, "Error", {}),
		create_diagnostic_count(vim.diagnostic.severity.WARN, "Warn", {
			vim.diagnostic.severity.ERROR,
		}),
		create_diagnostic_count(vim.diagnostic.severity.INFO, "Info", {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
		}),
		create_diagnostic_count(vim.diagnostic.severity.HINT, "Hint", {
			vim.diagnostic.severity.ERROR,
			vim.diagnostic.severity.WARN,
			vim.diagnostic.severity.INFO,
		}),
	}
end

return M
