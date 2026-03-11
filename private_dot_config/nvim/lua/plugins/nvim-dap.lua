local lib = require("lib")

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "suketa/nvim-dap-ruby",
    },
    keys = require("keymaps").for_plugin("dap"),
    config = function()
      local dap = require("dap")

      -- Find the nearest parent directory containing a Gemfile from a given path
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

      -- Custom run_cmd that uses Gemfile directory as cwd
      local function run_ruby_cmd(cmd, args, for_current_line, for_current_file, error_on_failure)
        local current_file = vim.fn.expand("%:p")
        local file_dir = vim.fn.fnamemodify(current_file, ":h")
        local working_dir = find_gemfile_dir(file_dir) or vim.fn.getcwd()

        args = args or {}
        if for_current_line then
          table.insert(args, current_file .. ":" .. vim.fn.line("."))
        elseif for_current_file then
          table.insert(args, current_file)
        end

        local stdout = vim.loop.new_pipe(false)
        local opts = { args = args, cwd = working_dir, stdio = { nil, stdout } }

        local handle, pid_or_err = vim.loop.spawn(cmd, opts, function(code)
          if handle then
            handle:close()
          end
          if error_on_failure and code ~= 0 then
            local full_cmd = cmd .. " " .. table.concat(args, " ")
            vim.notify("Command `" .. full_cmd .. "` exited with code " .. code, vim.log.levels.ERROR)
          end
        end)

        if not handle then
          vim.notify("Error running command: " .. cmd .. " " .. tostring(pid_or_err), vim.log.levels.ERROR)
          return
        end

        stdout:read_start(function(err, chunk)
          assert(not err, err)
          if chunk then
            vim.schedule(function()
              require("dap.repl").append(chunk)
            end)
          end
        end)
      end

      -- Custom Ruby adapter that finds Gemfile directory from current file
      dap.adapters.ruby = function(callback, config)
        local waiting = config.waiting or 500
        local server = config.server or vim.env.RUBY_DEBUG_HOST or "127.0.0.1"
        local port = config.port
        port = port or config.random_port and math.random(49152, 65535)

        if not port then
          vim.ui.input({ prompt = "Select port to connect to: " }, function(input)
            port = input
          end)
        end

        if config.command then
          vim.env.RUBY_DEBUG_OPEN = true
          vim.env.RUBY_DEBUG_HOST = server
          vim.env.RUBY_DEBUG_PORT = port
          run_ruby_cmd(
            config.command,
            config.args,
            config.current_line,
            config.current_file,
            config.error_on_failure
          )
        end

        vim.defer_fn(function()
          callback({ type = "server", host = server, port = port })
        end, waiting)
      end

      -- Ruby DAP configurations with smart cwd
      local base_config = {
        type = "ruby",
        request = "attach",
        options = { source_filetype = "ruby" },
        error_on_failure = true,
        localfs = true,
      }
      local run_config = vim.tbl_extend("force", base_config, { waiting = 1000, random_port = true })

      dap.configurations.ruby = {
        vim.tbl_extend("force", run_config, { name = "debug current file", command = "rdbg", current_file = true }),
        vim.tbl_extend("force", run_config, { name = "run rails", command = "bundle", args = { "exec", "rails", "s" } }),
        vim.tbl_extend("force", run_config,
          { name = "run rspec current file", command = "bundle", args = { "exec", "rspec" }, current_file = true }),
        vim.tbl_extend("force", run_config,
          { name = "run rspec current_file:current_line", command = "bundle", args = { "exec", "rspec" }, current_line = true }),
        vim.tbl_extend("force", run_config, { name = "run rspec", command = "bundle", args = { "exec", "rspec" } }),
        vim.tbl_extend("force", run_config, { name = "bin/dev", command = "bin/dev" }),
        vim.tbl_extend("force", base_config, { name = "attach existing (port 38698)", port = 38698, waiting = 0 }),
        vim.tbl_extend("force", base_config, { name = "attach existing (pick port)", waiting = 0 }),
      }

      local red = lib.get_hl_group_colors("ErrorMsg").fg
      local yellow = lib.get_hl_group_colors("@comment.ruby").fg
      local bg_hl = lib.get_hl_group_colors("CursorLine").bg
      local blue = lib.get_hl_group_colors("@constant.ruby").fg

      vim.api.nvim_set_hl(0, "DapBreakpoint", { bg = bg_hl, fg = yellow })
      vim.api.nvim_set_hl(0, "DapLogPoint", { bg = bg_hl, fg = blue })
      vim.api.nvim_set_hl(0, "DapStopped", { bg = bg_hl, fg = red })

      vim.fn.sign_define(
        "DapBreakpoint",
        { text = "󰝥", texthl = "DapBreakpoint", linehl = "CursorLine", numhl = "CursorLine" }
      )
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "󰟃", texthl = "DapBreakpoint", linehl = "CursorLine", numhl = "CursorLine" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "", texthl = "DapBreakpoint", linehl = "CursorLine", numhl = "CursorLine" }
      )
      vim.fn.sign_define(
        "DapLogPoint",
        { text = "", texthl = "DapLogPoint", linehl = "CursorLine", numhl = "CursorLine" }
      )
      vim.fn.sign_define(
        "DapStopped",
        { text = "", texthl = "DapStopped", linehl = "CursorLine", numhl = "CursorLine" }
      )
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    enabled = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("dapui").setup({
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            -- TODO: set these
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.33 },
              { id = "breakpoints", size = 0.17 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            size = 0.33,
            position = "right",
          },
          {
            elements = {
              { id = "repl",    size = 0.45 },
              { id = "console", size = 0.55 },
            },
            size = 0.27,
            position = "bottom",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      })
    end,
  },
}
