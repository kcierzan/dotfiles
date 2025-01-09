local M = {}

local home_directory = vim.loop.os_homedir()

local function is_rails_app(path)
  return vim.fn.filereadable(path .. "/config/application.rb") == 1
end

local function is_rails_engine(path)
  local lib_dir = path .. "/lib"
  if vim.fn.isdirectory(lib_dir) == 0 then
    return false
  end

  local engine_files = vim.fn.glob(lib_dir .. "/*.rb", 0, 1)
  for _, file in ipairs(engine_files) do
    local filename = vim.fn.fnamemodify(file, ":t:r")
    if vim.fn.isdirectory(path .. "/lib/" .. filename) == 1 then
      return true
    end
  end
end

local function find_rails_root(path)
  local current_path = path
  while current_path ~= home_directory do
    if is_rails_app(current_path) then
      return current_path
    end
    current_path = vim.fn.fnamemodify(current_path, ":h")
  end
  return nil
end

function M.top_level_rails_dir(path)
  local current_path = path
  while current_path ~= home_directory do
    if is_rails_app(current_path) or is_rails_engine(current_path) then
      return current_path
    end
    current_path = vim.fn.fnamemodify(current_path, ":h")
  end
  print("Rails directory not found!")
  return nil
end

local function find_sibling_rails_apps(engine_root)
  local parent_dir = vim.fn.fnamemodify(engine_root, ":h")
  local siblings = vim.fn.glob(parent_dir .. "/*", 0, 1)
  local rails_apps = {}

  for _, sibling in ipairs(siblings) do
    if vim.fn.isdirectory(sibling) == 1 and find_rails_root(sibling) and not is_rails_engine(sibling) then
      table.insert(rails_apps, sibling)
    end
  end

  return rails_apps
end

local function rails_engine_or_app_root(path)
  local root = find_rails_root(path)

  if root then
    if not is_rails_engine(root) then
      -- This is a Rails application
      return root
    else
      -- This is a Rails engine, prompt user to select a Rails app
      local sibling_apps = find_sibling_rails_apps(root)

      if #sibling_apps > 0 then
        local selected = vim.ui.select(sibling_apps, {
          prompt = "Select a Rails application:",
          format_item = function(item)
            return vim.fn.fnamemodify(item, ":t")
          end,
        }, function(choice)
          if choice then
            return choice
          end
        end)

        if selected then
          return selected
        end
      end

      -- If no selection was made or no sibling apps found, return the engine root
      return root
    end
  end

  return nil
end

function M.current_path_and_line_number()
  local current_file_path = vim.api.nvim_buf_get_name(0)
  local current_line_number = vim.api.nvim_win_get_cursor(0)[1]

  return current_file_path, current_line_number
end

function M.generate_test_command(path, line_number)
  local test_cmd = string.format("bundle exec rspec %s", path)
  if line_number ~= nil then
    test_cmd = string.format("%s:%d", test_cmd, line_number)
  end

  return test_cmd
end

return M
