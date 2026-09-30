local M = {}

function M.setup()
	vim.treesitter.query.add_predicate("syntax-profile?", function(_, _, _, predicate)
		return require("syntax").active() == predicate[2]
	end)
	vim.treesitter.query.add_predicate("syntax-variable?", function(match, _, source, predicate)
		local node = match[predicate[2]][1]
		if vim.treesitter.get_node_text(node, source):match("^_*[A-Z][A-Z%d_]*$") then
			return false
		end
		local parent = node:parent()
		local value = parent:field("value")[1]
		if parent:type() == "variable_list" then
			local assignment = parent:parent()
			local index = 1
			for i, name in ipairs(parent:field("name")) do
				if name:id() == node:id() then
					index = i
					break
				end
			end
			for child in assignment:iter_children() do
				if child:type() == "expression_list" then
					value = child:field("value")[index]
				end
			end
		end
		return not value
			or not vim.tbl_contains({ "arrow_function", "function_expression", "function_definition" }, value:type())
	end)
	vim.treesitter.query.add_directive("syntax-embedded-priority!", function(_, _, _, predicate, metadata)
		local id = require("syntax").active()
		local capture = predicate[2]
		metadata[capture] = metadata[capture] or {}
		metadata[capture].priority = id:match("^flatwhite%-") and vim.hl.priorities.semantic_tokens + 3
			or vim.hl.priorities.treesitter
	end)
end

return M
