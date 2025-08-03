---@class Spec
---@field private current_file_path string The current file path
---@field private current_line_number number The current line number
---@field private rails_root? string The rails root of the current file
local Spec = {}

---@class SpecOptions
---@field at_point boolean Whether to run the spec at the current line (true) or the whole file (false)

---@type string
local HOME_DIRECTORY = vim.loop.os_homedir()

---@type string
local RAILS_ROOT_MARKER = "Gemfile"

---@return Spec
function Spec.new()
  local instance = setmetatable({}, Spec)
  Spec.__index = Spec
  instance.current_file_path = vim.api.nvim_buf_get_name(0)
  instance.current_line_number = vim.api.nvim_win_get_cursor(0)[1]
  instance.rails_root = instance:_get_current_rails_root()
  return instance
end

---@param opts SpecOptions
---@return nil
function Spec:run(opts)
  opts = opts or {}
  opts.at_point = opts.at_point or false
  local term_name = string.format("RSpec - [%s]", vim.fn.fnamemodify(self.rails_root, ":t"))
  local command = string.format("cd %s", self.rails_root)

  if opts.at_point then
    command = string.format("%s; %s", command, self:_generate_line_test_command())
  else
    command = string.format("%s; %s", command, self:_generate_file_test_command())
  end

  local toggle_term_cmd =
    string.format('TermExec direction=float name="%s" cmd="%s" dir="%s"', term_name, command, self.rails_root)

  vim.cmd(toggle_term_cmd)
end

---@private
---@return string?
function Spec:_get_current_rails_root()
  local current_dir = vim.fn.fnamemodify(self.current_file_path, ":p:h")
  local home_dir = vim.fn.fnamemodify(HOME_DIRECTORY, ":p")

  while current_dir ~= home_dir do
    local gemfile_path = current_dir .. "/" .. RAILS_ROOT_MARKER
    if vim.fn.filereadable(gemfile_path) == 1 then
      return current_dir
    end

    local parent_dir = vim.fn.fnamemodify(current_dir, ":h")

    -- break when we can't go higher
    if parent_dir == current_dir then
      break
    end

    current_dir = parent_dir
  end

  print("No rails root found for current file!")
  return nil
end

---@private
---@return string
function Spec:_generate_file_test_command()
  return string.format("bundle exec rspec %s", self.current_file_path)
end

---@private
---@return string
function Spec:_generate_line_test_command()
  return string.format("bundle exec rspec %s:%d", self.current_file_path, self.current_line_number)
end

---@type Spec
return Spec
