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

local function parent_git_dir()
  local dir = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
  return vim.fn.empty(vim.fn.glob(dir)) == 0, dir
end

function M.search_visual_selection()
  -- yank the visual selection to the z register
  vim.cmd([[normal! "zy]])

  -- get the contents of the z register
  local picker = require("snacks").picker

  picker.grep_word({
    search = function()
      -- return the contents of the z register
      return vim.fn.getreg("z")
    end,
    glob = "!**/spec/**/*",
  })
end

local function parent_git_dir_or_cwd()
  local in_git_dir, git_dir = parent_git_dir()
  return in_git_dir and git_dir or vim.fn.getcwd()
end

function M.open_in_rubymine()
  vim.fn.system({ "rubymine", vim.fn.expand("%:p") })
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
