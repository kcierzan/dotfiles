---@class ExcludesPickerWrapper
---@field public with_dynamic_excludes fun(options: Options): function
local M = {}

---@alias PickerFunc fun(opts: table): nil
---@alias TargetArgs { exclude: string[], win: table, search: string, pattern: string }
---@alias SharedState { selected_patterns: string[] }
---@alias PickerItem { text: string, pattern: string, is_selected: boolean, preview: { text: string }}

---@class Options
---@field public picker_func function The original picker function to wrap
---@field public picker_args? table Arguments to pass directly to the wrapped picker
---@field public use_pattern? boolean Whether to use picker `pattern` to resume search (defaults to false and uses `search`)

local CLEAR_EXCLUDES_KEY = "<C-a>"
local TRIGGER_EXCLUDES_KEY = "<C-y>"

---@type string[]
local AVAILABLE_PATTERNS = {
  "**/spec/*",
  "**/app/*",
  "**/b4b/*",
  "**/clinic/*",
  "**/factories/*",
  "**/b4b_core/*",
  "**/db/*",
  "**/config/*",
  "*.yml",
  "**/doc/*",
  "**/migrate/*",
  "*.rbi",
}

---@type string[]
local DEFAULT_PATTERNS = {
  "**/migrate/*",
  "**/doc/*",
  "*.rbi",
}

---@type SharedState
local shared_state = {
  selected_patterns = {},
}

---@return nil
local function set_default_patterns()
  shared_state.selected_patterns = DEFAULT_PATTERNS
end

set_default_patterns()

---@class Context
---@field public picker_func PickerFunc
---@field public target_args TargetArgs
---@field public use_pattern boolean
local Context = {}

---@param options Options
---@return Context
function Context.new(options)
  ---@type Context
  local instance = setmetatable({}, Context)
  Context.__index = Context
  instance.picker_func = vim.deepcopy(options.picker_func)
  instance.target_args = vim.deepcopy(options.picker_args or {})
  instance.use_pattern = options.use_pattern or false
  return instance
end

---@package
---@return nil
function Context:build_args_from_state()
  self:_reset_excludes()
  self:_insert_selected_excludes()
end

---@private
---@return nil
function Context:_reset_excludes()
  self.target_args.exclude = vim.tbl_filter(function(item)
    return not vim.tbl_contains(AVAILABLE_PATTERNS, item)
  end, self.target_args.exclude or {})
end

---@private
---@return nil
function Context:_insert_selected_excludes()
  if #shared_state.selected_patterns == 0 then
    return
  end

  for _, pattern in ipairs(shared_state.selected_patterns) do
    if not vim.tbl_contains(self.target_args.exclude, pattern) then
      table.insert(self.target_args.exclude, pattern)
    end
  end
end

---@class PickerFactory
---@field context Context
local PickerFactory = {}

---@param context Context
---@return PickerFactory
function PickerFactory.new(context)
  local instance = setmetatable({}, PickerFactory)
  PickerFactory.__index = PickerFactory
  instance.context = context
  return instance
end

---@package
---@param pattern string
---@return number?
function PickerFactory.find_pattern_index(pattern)
  for i, p in ipairs(shared_state.selected_patterns) do
    if p == pattern then
      return i
    end
  end
end

---@package
---@param pattern string
function PickerFactory.toggle_pattern(pattern)
  local index = PickerFactory.find_pattern_index(pattern)
  if index then
    table.remove(shared_state.selected_patterns, index)
  else
    table.insert(shared_state.selected_patterns, pattern)
  end
end

---@package
---@return nil
function PickerFactory:setup_exclude_keybinds()
  self.context.target_args.win = self.context.target_args.win or {}
  self.context.target_args.win.input = self.context.target_args.win.input or {}
  self.context.target_args.win.input.keys = self.context.target_args.win.input.keys or {}

  self.context.target_args.win.input.keys = vim.tbl_extend("force", self.context.target_args.win.input.keys, {
    [TRIGGER_EXCLUDES_KEY] = self:_create_toggle_ignore_bindings(),
  })
end

---@package
---@return nil
function PickerFactory:run_picker()
  self.context:build_args_from_state()

  if self.context.use_pattern then
    self.context.target_args.pattern = self.context.target_args.search
    self.context.target_args.search = nil
  end

  self.context.picker_func(self.context.target_args)
end

---@private
---@return nil
function PickerFactory:_show_exclude_glob_picker()
  local function select_patterns(picker, item)
    -- NOTE: state is shared via the module thus the static method
    PickerFactory.toggle_pattern(item.pattern)
    picker:close()
    vim.schedule(function()
      -- confirming glob pattern changes re-launches the picker for feedback
      self:_show_exclude_glob_picker()
    end)
  end

  local function reset_default_patterns(picker)
    set_default_patterns()
    picker:close()
    vim.schedule(function()
      self:_show_exclude_glob_picker()
    end)
  end

  require("snacks").picker.pick({
    items = self:_generate_pattern_items(),
    title = "Toggle ignore patterns (" .. #shared_state.selected_patterns .. " selected)",
    format = "text",
    focus = "list",
    preview = "preview",
    on_show = function()
      vim.cmd.stopinsert()
    end,
    confirm = select_patterns,
    win = {
      input = {
        keys = {
          ["<CR>"] = {
            select_patterns,
            mode = { "i", "n" },
          },
        },
      },
      list = {
        keys = {
          ["<Space>"] = "confirm",
          [CLEAR_EXCLUDES_KEY] = {
            reset_default_patterns,
            desc = "set default patterns",
            mode = { "i", "n" },
          },
          ["<CR>"] = self:_create_rerun_binding(),
        },
      },
    },
  })
end

---@private
---@return string
function PickerFactory:_get_current_search_input()
  local filter = require("snacks").picker.get({ tab = true })[1].finder.filter
  if self.context.use_pattern then
    return filter.pattern
  else
    return filter.search
  end
end

---@private
---@return nil
function PickerFactory:_cache_current_picker_search()
  local current_pattern = self:_get_current_search_input()

  if current_pattern and current_pattern ~= "" then
    self.context.target_args.search = current_pattern
  elseif not self.context.target_args.search then
    self.context.target_args.search = ""
  end
end

---@private
---@return PickerItem[]
function PickerFactory:_generate_pattern_items()
  ---@type PickerItem[]
  local items = {}

  for _, pattern in ipairs(AVAILABLE_PATTERNS) do
    local is_selected = vim.tbl_contains(shared_state.selected_patterns, pattern)
    table.insert(items, {
      text = (is_selected and "✓ " or "  ") .. pattern,
      pattern = pattern,
      selected = is_selected,
      preview = {
        text = pattern,
      },
    })
  end

  return items
end

---@private
---@return table
function PickerFactory:_create_rerun_binding()
  return {
    function()
      vim.schedule(function()
        self:run_picker()
      end)
    end,
    desc = "Rerun picker with excludes",
    mode = { "i", "n" },
  }
end

---@private
---@return table
function PickerFactory:_create_toggle_ignore_bindings()
  return {
    function()
      self:_cache_current_picker_search()
      self:_show_exclude_glob_picker()
    end,
    mode = { "i", "n" },
  }
end

---@param options Options
---@return fun(): nil
function M.with_dynamic_excludes(options)
  return function()
    local context = Context.new(options)
    local picker_factory = PickerFactory.new(context)
    picker_factory:setup_exclude_keybinds()
    picker_factory:run_picker()
  end
end

---@type ExcludesPickerWrapper
return M
