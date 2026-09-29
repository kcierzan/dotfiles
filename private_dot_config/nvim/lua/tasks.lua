local M = {}

local function notify(message)
	vim.notify(message, vim.log.levels.WARN, { title = "Tasks" })
end

local function current_file()
	local path = vim.api.nvim_buf_get_name(0)
	if path == "" then
		notify("The current buffer is not a file")
		return nil
	end
	return vim.fs.normalize(path)
end

local function gemfile_root(path)
	local gemfile = vim.fs.find("Gemfile", {
		path = vim.fs.dirname(path),
		upward = true,
		type = "file",
	})[1]
	return gemfile and vim.fs.dirname(gemfile) or nil
end

local function rspec_context(at_line)
	local path = current_file()
	if not path then
		return nil
	end

	local root = gemfile_root(path)
	if not root then
		notify("No Gemfile found for the current file")
		return nil
	end

	local target = path
	if at_line then
		target = string.format("%s:%d", path, vim.api.nvim_win_get_cursor(0)[1])
	end
	return { root = root, target = target }
end

local function latest_task(filter)
	local latest
	for _, task in ipairs(require("overseer").list_tasks({ filter = filter })) do
		local activity = task.time_end or task.time_start or 0
		local latest_activity = latest and (latest.time_end or latest.time_start or 0) or -1
		if not latest or activity > latest_activity or (activity == latest_activity and task.id > latest.id) then
			latest = task
		end
	end
	return latest
end

local function require_task(task, message)
	if not task then
		notify(message)
		return false
	end
	return true
end

function M.run_rspec(at_line)
	local context = rspec_context(at_line)
	if not context then
		return
	end

	require("overseer").run_task({
		name = "RSpec",
		params = { target = context.target },
		cwd = context.root,
		search_params = { dir = context.root, filetype = "ruby" },
	})
end

function M.restart_last()
	local task = latest_task(function(candidate)
		return candidate:is_complete()
	end)
	if require_task(task, "No completed task to restart") then
		task:restart()
	end
end

function M.stop_last()
	local task = latest_task(function(candidate)
		return candidate:is_running()
	end)
	if require_task(task, "No running task to stop") then
		task:stop()
	end
end

function M.open_last_output()
	local task = latest_task(function(candidate)
		return candidate.time_start ~= nil
	end)
	if require_task(task, "No task output to open") then
		task:open_output("float")
	end
end

function M.debug_rspec(at_line)
	if not rspec_context(at_line) then
		return
	end

	local name = at_line and "run rspec current_file:current_line" or "run rspec current file"
	for _, config in ipairs(require("dap").configurations.ruby or {}) do
		if config.name == name then
			require("dap").run(config)
			return
		end
	end

	notify(string.format("DAP configuration %q was not found", name))
end

return M
