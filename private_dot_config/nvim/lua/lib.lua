local M = {}

local live_grep_excludes = {
  "!**/.rubocop_todo.yml",
  "!**/*.ignore",
  "!**/doc/*",
  "!**/*.rbi",
}

function M.nmap(key, command)
  vim.api.nvim_set_keymap("n", key, command, { noremap = true, silent = true })
end

function M.xmap(key, command)
  vim.api.nvim_set_keymap("x", key, command, { noremap = true, silent = true })
end

function M.tmap(key, command)
  vim.api.nvim_set_keymap("t", key, command, { noremap = true, silent = true })
end

function M.omap(key, command)
  vim.api.nvim_set_keymap("o", key, command, { noremap = true, silent = true })
end

function M.imap(key, command)
  vim.api.nvim_set_keymap("i", key, command, { noremap = true, silent = true })
end

function M.cmap(key, command)
  vim.api.nvim_set_keymap("c", key, command, { noremap = true, silent = true })
end

function M.ex_cmd(command)
  return string.format("<cmd>%s<cr>", command)
end

function M.telescope_builtin(method)
  local telescope_command = string.format("Telescope %s", method)
  return M.ex_cmd(telescope_command)
end

local function parent_git_dir()
  local dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  return vim.fn.empty(vim.fn.glob(dir)) == 0, dir
end

local function create_rails_fd_command(directory)
  local top_level = "app/"
  local excludes = { ".git/", "node_modules", "**/*migration*/**/*", "**/vendor/**/*", "**/migrate/**/*" }

  if directory == "spec" then
    top_level = ""
  end

  if directory == "factories" then
    top_level = "spec/"
  end

  return {
    "fd",
    "--type",
    "f",
    "--hidden",
    "--strip-cwd-prefix",
    "--full-path",
    "--glob",
    "**/" .. top_level .. directory .. "/**/*.{erb,rb}",
    "-E",
    table.concat(excludes, ","),
  }
end

function M.fast_find_file()
  local tscope = require("telescope.builtin")
  local exists, _ = parent_git_dir()
  if exists then
    tscope.git_files({ show_untracked = true })
  else
    tscope.find_files()
  end
end

function M.search_visual_selection()
  -- yank the visual selection to the z register
  vim.cmd([[normal! "zy]])

  -- get the contents fo the z register
  local selection = vim.fn.getreg("z")

  local telescope = require("telescope.builtin")
  telescope.live_grep({
    default_text = selection,
    silent = true,
    glob_pattern = "!**/spec/**/*",
  })
end

local function parent_git_dir_or_cwd()
  local in_git_dir, git_dir = parent_git_dir()
  return in_git_dir and git_dir or vim.fn.getcwd()
end

function M.live_grep_rails_app_files()
  require("telescope.builtin").live_grep({
    cwd = parent_git_dir_or_cwd(),
    glob_pattern = {
      "!.git",
      "!.Gemfile.lock",
      "!**/spec/**/*",
      "!**/*migration*/**/*",
      "!**/*.ignore",
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
  local command = create_rails_fd_command("models")
  require("telescope.builtin").find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = command,
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

function M.find_factories()
  require("telescope.builtin").find_files({
    cwd = parent_git_dir_or_cwd(),
    find_command = create_rails_fd_command("factories"),
    prompt_prefix = "🏭",
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
  tscope.live_grep({ cwd = parent_git_dir_or_cwd(), glob_pattern = live_grep_excludes })
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

function M.paste_in_gui_terminal()
  local keys = vim.api.nvim_replace_termcodes('<C-\\><C-N>"+pi', true, false, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

function M.merge(t1, t2)
  local result = {}
  t1 = t1 or {}
  t2 = t2 or {}

  -- Copy array part first to maintain sequence
  local maxIndex = math.max(#t1, #t2)
  for i = 1, maxIndex do
    if t1[i] ~= nil then
      result[i] = t1[i]
    end
    if t2[i] ~= nil then
      result[i] = t2[i]
    end
  end

  -- Copy hash part
  for k, v in pairs(t1) do
    if type(k) ~= "number" or k > maxIndex then
      result[k] = v
    end
  end
  for k, v in pairs(t2) do
    if type(k) ~= "number" or k > maxIndex then
      result[k] = v
    end
  end

  return result
end

return M
