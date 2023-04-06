return {
  "nvim-lualine/lualine.nvim",
  event = "BufReadPre",
  config = function()
    local lualine = require("lualine")

    local function is_git_workspace()
      local filepath = vim.fn.expand("%:p:h")
      local git_dir = vim.fn.finddir(".git", filepath .. ";")

      return git_dir and #git_dir > 0 and #filepath > #git_dir
    end

    local function is_wide_window()
      return vim.fn.winwidth(0) > 85
    end

    local function buffer_not_empty()
      return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end

    local colors = {
      fg = "#DCD7BA",
      bg = "#1F1F28",
      blue = "#7E9CD8",
      green = "#98BB6C",
      violet = "#957FB8",
      red = "#E46876",
      magenta = "#D27E99",
      orange = "#FFA066",
      yellow = "#E6C384",
      cyan = "#7FB4CA"
    }

    local config = {
      options = {
        component_separators = "",
        section_separators = "",
        globalstatus = true,
        theme = {
          normal = {
            c = {
              fg = colors.fg,
              bg = colors.bg
            }
          },
          inactive = {
            c = {
              fg = colors.fg,
              bg = colors.bg
            }
          }
        }
      },
      sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {}
      }
    }

    local function left_insert(component)
      table.insert(config.sections.lualine_c, component)
    end

    local function right_insert(component)
      table.insert(config.sections.lualine_x, component)
    end

    local modes = {
      n = "NORMAL",
      no = "OPERATOR PENDING",
      v = "VISUAL",
      V = "VISUAL LINE",
      ["^V"] = "VISUAL BLOCK",
      s = "SELECT",
      S = "SELECT LINE",
      ["^S"] = "SELECT BLOCK",
      i = "INSERT",
      ic = "INSERT COMPLETION",
      ix = "INSERT COMPLETION",
      R = "REPLACE",
      Rv = "VIRTUAL REPLACE",
      c = "COMMAND",
      cv = "VIM EX",
      ce = "EX",
      r = "HIT ENTER",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      t = "TERMINAL"
    }

    local function edit_mode()
      local cube = ""
      local hex_empty = ""
      local hex_full = ""
      local mode = vim.fn.mode()
      local mode_string = ""

      if mode == "i" or mode == "ic" or mode == "ix" then
        mode_string = cube
      elseif mode == "n" or mode == "no" or mode == "!" or mode == "t" then
        mode_string = hex_empty
      else
        mode_string = hex_full
      end

      return mode_string .. "  " .. modes[mode]
    end

    local function get_buffer_lsp(clients, buf_ft)
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        local buffer_for_ft = vim.fn.index(filetypes, buf_ft) ~= -1

        if filetypes and buffer_for_ft then
          return client.name
        end
      end
      return "NONE"
    end

    local function lsp_name()
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      local clients_exist = function(clnts) return next(clnts) ~= nil and clnts end

      if clients_exist(clients) then
        return get_buffer_lsp(buf_ft)
      end
    end

    local function should_show_lsp_info()
      local clients = vim.lsp.get_active_clients()

      return is_wide_window() and next(clients) ~= nil
    end

    local function edit_mode_colors()
      local edit_colors = {
        n = colors.blue,
        i = colors.green,
        v = colors.violet,
        ["^V"] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        ["^S"] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red
      }

      return { fg = edit_colors[vim.fn.mode()], gui = "bold" }
    end

    local function progress_bar()
      local blocks = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
      local lines = vim.api.nvim_buf_line_count(0)
      local current_line = vim.api.nvim_win_get_cursor(0)[1]
      local block_index = math.floor((current_line / lines) * 7) + 1

      return string.rep(blocks[block_index], 2)
    end

    -- ================== Left Hand Sections ========================

    left_insert({
      function() return "▊" end,
      color = { fg = colors.blue },
      padding = { left = 0, right = 1 }
    })

    left_insert({
      edit_mode,
      color = edit_mode_colors,
      padding = { left = 0, right = 2 }
    })

    left_insert({
      "filetype",
      icon_only = true,
      colored = true,
      padding = { left = 0, right = 1 }
    })

    left_insert({
      "filename",
      cond = buffer_not_empty,
      path = 1,
      color = { fg = colors.fg },
      padding = { left = 0, right = 0 }
    })

    -- ================== Right Hand Sections ========================

    right_insert({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = {
        error = " ",
        warn = " ",
        info = " "
      },
      diagnostics_color = {
        color_error = { fg = colors.red },
        color_warn = { fg = colors.yellow },
        color_info = { fg = colors.cyan }
      }
    })

    right_insert({
      lsp_name,
      icon = "力",
      color = { fg = colors.cyan, gui = "bold" },
      cond = should_show_lsp_info,
    })

    right_insert({
      "branch",
      icon = "",
      color = { fg = colors.violet, gui = "bold" },
      cond = is_git_workspace
    })

    right_insert({
      "diff",
      symbols = {
        added = "  ",
        modified = "柳 ",
        removed = "  "
      },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red }
      },
      cond = is_wide_window
    })

    right_insert({
      "fileformat",
      icons_enabled = true,
      color = { fg = colors.blue, gui = "bold" },
      cond = is_wide_window
    })

    right_insert({
      progress_bar,
      color = { fg = colors.blue, bg = colors.bg },
      padding = { right = 0, left = 1 },
      cond = is_wide_window
    })

    right_insert({
      "progress",
      color = { fg = colors.blue, bg = colors.bg },
      padding = { right = 0, left = 1 },
      cond = is_wide_window,
    })

    right_insert({
      function() return "▊" end,
      color = { fg = colors.blue },
      padding = { left = 1 }
    })

    lualine.setup(config)
  end
}
