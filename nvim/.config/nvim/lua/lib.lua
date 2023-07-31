local M = {}

function M.nmap(key, command)
  vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
end

function M.xmap(key, command)
  vim.api.nvim_set_keymap("x", key, command, { noremap = true, silent = true })
end

function M.tmap(key, command)
  vim.api.nvim_set_keymap("t", key, command, { noremap = true, silent = true })
end

function M.ex_cmd(command)
  return "<cmd>" .. command .. "<cr>"
end

function M.telescope_builtin(method)
  return M.ex_cmd("lua require('telescope.builtin')." .. method .. "()")
end

local function parent_git_dir()
  local dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  return vim.fn.empty(vim.fn.glob(dir)) == 0, dir
end

local function create_rails_fd_command(directory)
  local excludes = { ".git/", "node_modules", "**/*migration*/**/*", "**/vendor/**/*", "**/migrate/**/*" }
  if directory ~= "spec" then
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
    table.concat(excludes, ","),
  }
end

function M.fast_find_file()
  local tscope = require("telescope.builtin")
  local exists, _ = parent_git_dir()
  if exists then
    tscope.git_files({ show_untracked_files = true })
  else
    tscope.find_files()
  end
end

local function run_test_from_engine(test_func)
  return function()
    local engine_root_files = { "Gemfile", "spec" }
    local path = vim.api.nvim_buf_get_name(0)
    if path == "" then
      return
    end

    path = vim.fs.dirname(path)
    local cwd = vim.fn.getcwd()
    local root_file = vim.fs.find(engine_root_files, { path = path, upward = true })[1]
    if root_file == nil then
      return
    end

    local root = vim.fs.dirname(root_file)
    vim.fn.chdir(root)
    test_func()
    vim.fn.chdir(cwd)
  end
end

M.test_file_from_engine_root = run_test_from_engine(function()
  require("neotest").run.run(vim.fn.expand("%"))
end)

M.test_test_from_engine_root = run_test_from_engine(function()
  require("neotest").run.run()
end)

M.stop_test = run_test_from_engine(function()
  require("neotest").run.stop()
end)

local function parent_git_dir_or_cwd()
  local in_git_dir, git_dir = parent_git_dir()
  return in_git_dir and git_dir or vim.fn.getcwd()
end

function M.live_grep_rails_app_files()
  require("telescope.builtin").live_grep({
    cwd = parent_git_dir_or_cwd(),
    glob_pattern = {
      "!**/spec/**/*",
      "!**/*migration*/**/*",
      "!**/vendor/**/*",
      "!**/migrate/**/*",
      "!**/doc/**/*",
      "!node_modules",
    },
  })
end

function M.find_rails_app_file()
  local tscope = require("telescope.builtin")
  tscope.find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = {
      "fd",
      "--type",
      "f",
      "--hidden",
      "--strip-cwd-prefix",
      "-E",
      "{.git/,node_modules,**/spec/**/*,**/*migration*/**/*,**/vendor/**/*,**/migrate/**/*}",
    },
    prompt_prefix = "💎 ",
  })
end

function M.find_rails_model()
  require("telescope.builtin").find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = create_rails_fd_command("models"),
    prompt_prefix = "🗿",
  })
end

function M.find_rails_controller()
  require("telescope.builtin").find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = create_rails_fd_command("controllers"),
    prompt_prefix = "🎛️",
  })
end

function M.find_rails_view()
  require("telescope.builtin").find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = create_rails_fd_command("views"),
    prompt_prefix = "👁️",
  })
end

function M.find_specs()
  require("telescope.builtin").find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = create_rails_fd_command("spec"),
    prompt_prefix = "🧪",
  })
end

function M.super_fuzzy_grep()
  require("telescope.builtin").grep_string({
    cwd = parent_git_dir_or_cwd(),
    search = "",
  })
end

function M.grep_word_under_cursor()
  require("telescope.builtin").grep_string({
    cwd = parent_git_dir_or_cwd(),
  })
end

function M.open_in_rubymine()
  vim.fn.system({ "rubymine", vim.fn.expand("%:p") })
end

function M.live_grep_from_git_root()
  local tscope = require("telescope.builtin")
  tscope.live_grep({ cwd = parent_git_dir_or_cwd() })
end

function M.lsp_document_symbols()
  require("telescope.builtin").lsp_document_symbols({
    symbol_width = 60,
  })
end

function M.keys(in_table)
  local keys = {}
  for k, _ in pairs(in_table) do
    table.insert(keys, k)
  end
  return keys
end

function M.random_table_key(in_table)
  local keys = M.keys(in_table)
  math.randomseed(os.time())
  return keys[math.random(#keys)]
end

function M.random_table_value(in_table)
  local random_key = M.random_table_key(in_table)
  return in_table[random_key]
end

function M.get_hl_group_colors(group)
  local colors = vim.fn.synIDtrans(vim.fn.hlID(group))
  local fg = vim.fn.synIDattr(colors, "fg#")
  local bg = vim.fn.synIDattr(colors, "bg#")
  return { fg = fg, bg = bg }
end

return M
