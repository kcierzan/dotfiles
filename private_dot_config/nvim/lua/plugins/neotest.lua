-- Find the nearest parent directory containing a Gemfile
local function find_gemfile_dir(start_path)
  local path = start_path
  while path and path ~= "" and path ~= "/" do
    if vim.fn.filereadable(path .. "/Gemfile") == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end

-- Wrap neotest-rspec adapter to fix DAP strategy cwd
local function wrap_rspec_adapter(adapter)
  local original_build_spec = adapter.build_spec

  adapter.build_spec = function(args)
    local spec = original_build_spec(args)
    if not spec then
      return nil
    end

    -- Fix DAP strategy config if present
    if spec.strategy and type(spec.strategy) == "table" then
      local position = args.tree:data()
      local spec_file = position.path

      -- Find the Gemfile directory from the spec file location
      local gemfile_dir = find_gemfile_dir(vim.fn.fnamemodify(spec_file, ":h"))

      if gemfile_dir then
        -- Fix cwd - use the Gemfile directory instead of ${workspaceFolder}
        spec.strategy.cwd = gemfile_dir

        -- Fix current_line - neotest-rspec already includes line number in args,
        -- so we disable nvim-dap-ruby from adding it again
        spec.strategy.current_line = false
        spec.strategy.current_file = false
      end
    end

    return spec
  end

  return adapter
end

return {
  "nvim-neotest/neotest",
  ft = { "ruby" },
  keys = require("keymaps").for_plugin("neotest"),
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
  },
  config = function()
    local rspec_adapter = require("neotest-rspec")({
      rspec_cmd = function()
        return vim.tbl_flatten({
          "bundle",
          "exec",
          "rspec",
        })
      end,
      transform_spec_path = function(path)
        return path
      end,
      results_path = function()
        return vim.fn.tempname()
      end,
    })

    require("neotest").setup({
      adapters = {
        wrap_rspec_adapter(rspec_adapter),
      },
      status = {
        virtual_text = true,
        signs = true,
      },
      output = {
        open_on_run = false,
      },
      quickfix = {
        enabled = true,
        open = false,
      },
    })
  end,
}
