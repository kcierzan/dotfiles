local M = {}

function M.pick()
	local items = {}
	local terminals = {}

	for _, terminal in ipairs(Snacks.terminal.list()) do
    local data = vim.b[terminal.buf].snacks_terminal
    local title = vim.b[terminal.buf].snacks_terminal_name or vim.b[terminal.buf].term_title
    local command = data.cmd
    local cwd = type(data.cwd) == "string" and data.cwd or vim.fn.getcwd(0)

		if type(command) == "table" then
			command = table.concat(command, " ")
		end

		items[#items + 1] = {
      text = string.format("%d  %s  %s", data.id, title or command or vim.o.shell, cwd),
			buf = terminal.buf,
			id = data.id,
		}
		terminals[terminal.buf] = terminal
	end

	if #items == 0 then
		Snacks.notify.info("No terminals are open")
		return
	end

	table.sort(items, function(a, b)
		return a.id < b.id
	end)

	Snacks.picker.pick({
		title = "Terminals",
		items = items,
		format = "text",
		confirm = function(picker, item)
			picker:close()
			vim.schedule(function()
				terminals[item.buf]:show():focus()
			end)
		end,
	})
end

return M
