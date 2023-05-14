local function ex_cmd(command)
  return "<cmd>" .. command .. "<cr>"
end

local function telescope_builtin(method)
  return ex_cmd("lua require('telescope.builtin')." .. method .. "()")
end

local function parent_git_dir()
  local dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  return vim.fn.empty(vim.fn.glob(dir)) == 0, dir
end

local function create_rails_fd_command(directory)
  local excludes = { ".git/", "node_modules", "**/*migration*/**/*", "**/vendor/**/*", "**/migrate/**/*" }
  if directory ~= 'spec' then
    table.insert(excludes, "**/spec/**/*")
  end
  return {
    "fd",
    "--type",
    "f",
    "--hidden",
    "--strip-cwd-prefix",
    "--full-path",
    "--glob",
    "**/" .. directory .. "/**/*.{erb,rb}",
    "-E",
    table.concat(excludes, ",")
  }
end

local function fast_find_file()
  local tscope = require("telescope.builtin")
  local exists, _ = parent_git_dir()
  if exists then
    tscope.git_files({ show_untracked_files = true })
  else
    tscope.find_files()
  end
end

local function live_grep_rails_app_files()
  require("telescope.builtin").live_grep({
    glob_pattern = {
      "!**/spec/**/*",
      "!**/*migration*/**/*",
      "!**/vendor/**/*",
      "!**/migrate/**/*",
      "!**/doc/**/*",
      "!node_modules"
    }
  })
end

local function find_rails_app_file()
  local tscope = require("telescope.builtin")
  tscope.find_files(
    {
      find_command = {
        "fd",
        "--type",
        "f",
        "--hidden",
        "--strip-cwd-prefix",
        "-E",
        "{.git/,node_modules,**/spec/**/*,**/*migration*/**/*,**/vendor/**/*,**/migrate/**/*}"
      },
      prompt_prefix = "💎 "
    }
  )
end

local function find_rails_model()
  require("telescope.builtin").find_files(
    {
      find_command = create_rails_fd_command("models"),
      prompt_prefix = "🗿"
    }
  )
end

local function find_rails_controller()
  require("telescope.builtin").find_files(
    {
      find_command = create_rails_fd_command("controllers"),
      prompt_prefix = "🎛️"
    }
  )
end

local function find_rails_view()
  require("telescope.builtin").find_files(
    {
      find_command = create_rails_fd_command("views"),
      prompt_prefix = "👁️"
    }
  )
end

local function find_specs()
  require("telescope.builtin").find_files(
    {
      find_command = create_rails_fd_command("spec"),
      prompt_prefix = "🧪"
    }
  )
end

local function open_in_rubymine()
  vim.fn.system({ "rubymine", vim.fn.expand("%:p") })
end

local function live_grep_from_git_root()
  local tscope = require("telescope.builtin")
  local exists, dir = parent_git_dir()
  if exists then
    tscope.live_grep({ cwd = dir })
  else
    tscope.live_grep()
  end
end

return {
  ex_cmd = ex_cmd,
  open_in_rubymine = open_in_rubymine,
  find_specs = find_specs,
  live_grep_from_git_root = live_grep_from_git_root,
  find_rails_app_file = find_rails_app_file,
  fast_find_file = fast_find_file,
  find_rails_model = find_rails_model,
  find_rails_controller = find_rails_controller,
  find_rails_view = find_rails_view,
  telescope_builtin = telescope_builtin,
  live_grep_rails_app_files = live_grep_rails_app_files,
}
