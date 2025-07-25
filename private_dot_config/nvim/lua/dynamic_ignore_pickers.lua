local M = {}

---@class IgnoreState
---@field available_patterns string[]
---@field default_patterns string[]
---@field selected_patterns string[]

---@class PickerItem
---@field text string
---@field pattern string
---@field selected boolean
---@field preview {text: string}

---@class PickerContext
---@field fn function
---@field opts {use_pattern?: boolean}
---@field current_args {search?: string, pattern?: string, exclude?: string[], win?: table}

---@class Picker
---@field close function
---@field win number

---@type IgnoreState
local ignore_state = {
  available_patterns = {
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
  },
  default_patterns = {
    "**/migrate/*",
    "**/doc/*",
    "*.rbi",
  },
  -- NOTE: the selected patterns are shared across each of the functions created via `with_dynamic_ignore_patterns`.
  -- This makes the excludes persistent between different types of search.
  selected_patterns = {},
}

-- forward declarations to make lua lsp happy
---@type fun(context: PickerContext): nil
local show_exclude_glob_picker
---@type fun(args: table, context: PickerContext): table
local setup_exclude_keybinds

---@return nil
local function set_default_patterns()
  ignore_state.selected_patterns = ignore_state.default_patterns
end

set_default_patterns()

---@param pattern string
---@return integer?
local function find_pattern_index(pattern)
  for i, p in ipairs(ignore_state.selected_patterns) do
    if p == pattern then
      return i
    end
  end
end

---@param pattern string
---@return nil
local function toggle_pattern(pattern)
  local index = find_pattern_index(pattern)

  if index then
    table.remove(ignore_state.selected_patterns, index)
  else
    table.insert(ignore_state.selected_patterns, pattern)
  end
end

---@param args table
---@return table
local function reset_excludes(args)
  args.exclude = vim.tbl_filter(function(item)
    return not vim.tbl_contains(ignore_state.available_patterns, item)
  end, args.exclude or {})

  return args
end

---@param args table
---@return table
local function insert_select_excludes(args)
  if #ignore_state.selected_patterns == 0 then
    return {}
  end

  for _, pattern in ipairs(ignore_state.selected_patterns) do
    if not vim.tbl_contains(args.exclude, pattern) then
      table.insert(args.exclude, pattern)
    end
  end

  return args
end

---@param current_args table
---@return table
local function build_exclude_args(current_args)
  local args = reset_excludes(current_args)
  return insert_select_excludes(args)
end

---@param context PickerContext
---@return nil
local function rerun_original_picker(context)
  local args = build_exclude_args(context.current_args)

  if context.opts.use_pattern then
    args.pattern = context.current_args.search
    args.search = nil
  else
    args.search = context.current_args.search
  end

  args = setup_exclude_keybinds(args, context)

  context.fn(args)
end

---@param picker Picker
---@param item PickerItem
---@param context PickerContext
---@return nil
local function handle_pattern_selection(picker, item, context)
  toggle_pattern(item.pattern)
  -- close picker and reopen to show updated selections
  picker:close()
  vim.schedule(function()
    show_exclude_glob_picker(context)
  end)
end

---@param picker Picker
---@param context PickerContext
---@return nil
local function handle_clear_patterns(picker, context)
  set_default_patterns()
  picker:close()
  vim.schedule(function()
    show_exclude_glob_picker(context)
  end)
end

---@return PickerItem[]
local function create_pattern_items()
  local items = {}

  for _, pattern in ipairs(ignore_state.available_patterns) do
    local is_selected = vim.tbl_contains(ignore_state.selected_patterns, pattern)
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

---@param context PickerContext
---@return {[1]: function, desc: string, mode: string[]}
local function create_rerun_binding(context)
  return {
    function()
      vim.schedule(function()
        rerun_original_picker(context)
      end)
    end,
    desc = "Rerun grep with excludes",
    mode = { "i", "n" },
  }
end

---@param context PickerContext
---@return nil
show_exclude_glob_picker = function(context)
  ---@param picker Picker
  ---@param item PickerItem
  local function handle_selection(picker, item)
    handle_pattern_selection(picker, item, context)
  end

  ---@param picker Picker
  local function handle_clear(picker)
    handle_clear_patterns(picker, context)
  end

  require("snacks").picker.pick({
    items = create_pattern_items(),
    title = "Toggle ignore patterns (" .. #ignore_state.selected_patterns .. " selected)",
    format = "text",
    focus = "list",
    preview = "preview",
    on_show = function()
      vim.cmd.stopinsert()
    end,
    confirm = handle_selection,
    win = {
      input = {
        keys = {
          ["<CR>"] = {
            handle_selection,
            mode = { "i", "n" },
          },
        },
      },
      list = {
        keys = {
          ["<Space>"] = "confirm",
          ["<C-a>"] = {
            handle_clear,
            desc = "set default patterns",
            mode = { "i", "n" },
          },
          ["<CR>"] = create_rerun_binding(context),
        },
      },
    },
  })
end

---@param picker Picker
---@param context PickerContext
---@return string
local function get_current_search_input(picker, context)
  local filter = require("snacks").picker.get({ tab = true })[1].finder.filter
  if context.opts.use_pattern then
    return filter.pattern
  else
    return filter.search
  end
end

---@param picker Picker
---@param fallback_search? string
---@param context PickerContext
---@return nil
local function save_current_picker_search(picker, fallback_search, context)
  local current_pattern = get_current_search_input(picker, context)

  if current_pattern and current_pattern ~= "" then
    context.current_args.search = current_pattern
  elseif not context.current_args.search then
    context.current_args.search = fallback_search or ""
  end
end

---@param args table
---@param context PickerContext
---@return {[1]: function, mode: string[]}
local function create_toggle_ignore_binding(args, context)
  return {
    function(picker)
      save_current_picker_search(picker, args.search, context)
      show_exclude_glob_picker(context)
    end,
    mode = { "i", "n" },
  }
end

---@param args table
---@param context PickerContext
---@return table
setup_exclude_keybinds = function(args, context)
  args.win = args.win or {}
  args.win.input = args.win.input or {}
  args.win.input.keys = args.win.input.keys or {}

  -- TODO: add keybinds for win.list focus
  args.win.input.keys = vim.tbl_extend("force", args.win.input.keys, {
    ["<C-y>"] = create_toggle_ignore_binding(args, context),
  })

  return args
end

---@param fn function A snacks picker function that accepts an `exclude` argument
---@param opts? table Options used for configuring correct behavior of the exclude picker
---@param picker_opts? table Static options always passed to `fn`
---@return function A new picker that adds a keybinding for dynamically managing excludes to the picker
function M.with_dynamic_ignore_patterns(fn, opts, picker_opts)
  opts = opts or {}
  -- NOTE: file-finder pickers use the `pattern` field to filter results in the picker itself. This is different
  -- from grep-like pickers which pass the value of the `search` field to rg/git-grep to populate the
  -- initial list which is subsequently filtered. We want need to specify which value we want to use for
  -- re-running the initial search with newly selected exclude patterns via the `use_pattern` option.
  opts.use_pattern = opts.use_pattern or false

  return function()
    local context = {
      fn = fn,
      opts = opts,
      current_args = vim.deepcopy(picker_opts or {}),
    }

    local args = build_exclude_args(context.current_args)
    if args.search then
      context.current_args.search = args.search
    end

    args = setup_exclude_keybinds(args, context)
    fn(args)
  end
end

return M
