return {
	condition = {
		filetype = "ruby",
	},
	generator = function(search)
		local gemfile = vim.fs.find("Gemfile", {
			path = search.dir,
			upward = true,
			type = "file",
		})[1]
		if not gemfile then
			vim.notify("No Gemfile found for RSpec", vim.log.levels.WARN, { title = "Tasks" })
			return "No Gemfile found for RSpec"
		end

		local root = vim.fs.dirname(gemfile)
		return {
			{
				name = "RSpec",
				desc = "Run RSpec from the nearest Gemfile",
				tags = { "TEST" },
				params = {
					target = {
						type = "string",
						optional = true,
						desc = "Optional file or file:line target",
					},
				},
				builder = function(params)
					local target = params.target or vim.api.nvim_buf_get_name(0)
					local args = { "exec", "rspec" }
					if target ~= "" then
						table.insert(args, target)
					end

					return {
						name = target ~= "" and "RSpec " .. vim.fn.fnamemodify(target, ":~:.") or "RSpec",
						cmd = "bundle",
						args = args,
						cwd = root,
					}
				end,
			},
		}
	end,
}
