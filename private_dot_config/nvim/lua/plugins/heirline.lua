local lib = require("lib")

return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = {
    "echanovski/mini.icons",
    "lewis6991/gitsigns.nvim",
    "neovim/rose-pine",
  },
  config = function()
    local separator = "gradient"
    local palette = require("catppuccin.palettes").get_palette("mocha")

    local utils = require("heirline.utils")
    local segment_bg = palette.surface0
    local conditions = require("heirline.conditions")

    local separators = {
      none_left = " ",
      none_right = " ",
      pixels_left = " ",
      pixels_right = "",
      slant_up_left = "",
      slant_up_right = "",
      slant_down_left = "",
      slant_down_right = "",
      round_left = "",
      round_right = "",
      trapezoid_left = "",
      trapezoid_right = "",
      gradient_left = "░▒▓",
      gradient_right = "▓▒░",
    }
    local Space = { provider = " " }
    local Align = { provider = "%=" }

    local function segment(...)
      -- each usage of ... is a copy of the arguments so we
      -- capture them in a table here
      local components = { ... }
      local left_sep = separators[separator .. "_left"]
      local right_sep = separators[separator .. "_right"]
      local padding = {
        Space,
        hl = { bg = segment_bg, force = true },
        condition = function()
          return separator == "slant_up" or separator == "slant_down"
        end,
      }

      local function override_bg_highlight(component)
        local hl = component.hl
        local hl_type = type(hl)

        if hl_type == "function" then
          local original_hl = hl
          component.hl = function(self)
            return lib.merge(original_hl(self), { bg = segment_bg, force = true })
          end
        else
          component.hl = lib.merge(hl_type == "table" and hl or {}, { bg = segment_bg, force = true })
        end
      end

      for _, component in ipairs(components) do
        override_bg_highlight(component)
      end

      return {
        Space,
        {
          {
            provider = left_sep,
            hl = { fg = segment_bg, bg = utils.get_highlight("StatusLine").bg },
            -- hl = { bg = segment_bg },
          },
          padding,
          unpack(components),
          padding,
          {
            provider = right_sep,
            -- hl = { bg = segment_bg },
            hl = { fg = segment_bg, bg = utils.get_highlight("StatusLine").bg },
          },
          hl = { underline = false, sp = palette.surface2, force = true },
        },
      }
    end

    local ViMode = {
      static = {
        mode_names = {
          n = "NORMAL",
          no = "NORMAL (OPERATOR PENDING)",
          nov = "NORMAL (OPERATOR PENDING)",
          noV = "NORMAL (OPERATOR PENDING)",
          ["no\22"] = "NORMAL (OPERATOR PENDING)",
          niI = "NORMAL (INSERT)",
          niR = "NORMAL (REPLACE)",
          niV = "NORMAL (VIRTUAL)",
          nt = "NORMAL (TERMINAL)",
          v = "VISUAL",
          vs = "VISUAL (SELECT)",
          V = "VISUAL LINE",
          Vs = "VISUAL LINE (SELECT)",
          ["\22"] = "VISUAL BLOCK",
          ["\22s"] = "VISUAL BLOCK (SELECT)",
          s = "SELECT",
          S = "SELECT LINE",
          ["\19"] = "SELECT BLOCK",
          i = "INSERT",
          ic = "INSERT (COMPLETION)",
          ix = "INSERT (CTRL-X)",
          R = "REPLACE",
          Rc = "REPLACE (COMPLETION)",
          Rx = "REPLACE (CTRL-X)",
          Rv = "REPLACE VIRTUAL",
          Rvc = "REPLACE VIRTUAL (COMPLETION)",
          Rvx = "REPLACE VIRTUAL (CTRL-X)",
          c = "COMMAND",
          cv = "EX",
          r = "PROMPT",
          rm = "MORE",
          ["r?"] = "CONFIRM",
          ["!"] = "SHELL",
          t = "TERMINAL",
        },
        mode_colors = {
          n = palette.green,
          i = palette.yellow,
          v = utils.get_highlight("Function").fg,
          V = utils.get_highlight("Function").fg,
          ["\22"] = utils.get_highlight("SpecialKey").fg,
          c = utils.get_highlight("Boolean").fg,
          s = utils.get_highlight("String").fg,
          S = utils.get_highlight("String").fg,
          ["\19"] = utils.get_highlight("Function").fg,
          R = utils.get_highlight("String").fg,
          r = utils.get_highlight("String").fg,
          ["!"] = utils.get_highlight("DiagnosticError").fg,
          t = utils.get_highlight("DiagnosticError").fg,
        },
      },
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      provider = function(self)
        return "%2(" .. self.mode_names[self.mode] .. "%)"
      end,
      hl = function(self)
        local mode = self.mode:sub(1, 1) -- only the first character
        return { fg = self.mode_colors[mode], bold = true }
      end,
      update = {
        "ModeChanged",
        pattern = "*:*",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        self.filetype = vim.api.nvim_buf_get_option(0, "filetype")
      end,
    }

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        self.icon, self.icon_color = require("mini.icons").get("file", filename)
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = utils.get_highlight(self.icon_color).fg }
      end,
    }

    local FilePath = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":t")

        if not filename then
          return ""
        end

        local path = vim.fn.fnamemodify(self.filename, ":~:.:h")

        if not conditions.width_percent_below(#path, 0.25) then
          path = vim.fn.pathshorten(path)
        end
        return path .. "/"
      end,
      hl = { fg = palette.overlay1 },
    }

    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":t")

        if self.filetype == "oil" then
          return ""
        end

        if filename == "" then
          filename = "[No Name]"
        end
        return filename
      end,
      hl = { fg = palette.text, bold = true },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " 󰧞",
        hl = { fg = palette.yellow },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "󰌾",
        hl = { fg = utils.get_highlight("Comment").fg },
      },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    local FileNameModifer = {
      hl = function()
        if vim.bo.modified then
          -- use `force` because we need to override the child's hl foreground
          return { fg = utils.get_highlight("Boolean").fg, bold = true, force = true }
        end
      end,
    }

    local FileEncoding = {
      provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
        return enc ~= "utf-8" and enc:upper()
      end,
    }

    local FileFormat = {
      provider = function()
        local fmt = vim.bo.fileformat
        return fmt ~= "unix" and fmt:upper()
      end,
    }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      utils.insert(FileNameModifer, { FilePath, FileName }), -- a new table where FileName is a child of FileNameModifier
      FileFlags,
      FileEncoding,
      FileFormat,
      { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    local MacroRec = {
      condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
      end,
      provider = "󰑋 ",
      hl = { fg = utils.get_highlight("DiagnosticError").fg },
      utils.surround({ "[", "]" }, nil, {
        provider = function()
          return vim.fn.reg_recording()
        end,
        hl = { fg = utils.get_highlight("Delimiter").fg },
      }),
      update = {
        "RecordingEnter",
        "RecordingLeave",
      },
    }

    local LSPActive = {
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return " " .. table.concat(names, " ")
      end,
      hl = { fg = palette.yellow },
    }

    local WorkDir = {
      provider = function()
        local cwd = vim.fn.getcwd(0)
        local icon = require("mini.icons").get("directory", cwd)
        icon = (vim.fn.haslocaldir(0) == 1 and "[local] " or "") .. icon .. " "
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        return icon .. cwd
      end,
      hl = { fg = palette.mauve },
    }

    WorkDir = segment(WorkDir)

    local VisualWords = {
      provider = function()
        local wc = vim.api.nvim_eval("wordcount()")
        if wc["visual_words"] then
          return wc["visual_words"] .. " words"
        else
          return wc["words"] .. " words"
        end
      end,
      update = { "CursorMoved" },
      hl = { fg = utils.get_highlight("Function").fg },
    }

    local Mode = segment(ViMode)
    local File = segment(FileNameBlock)

    VisualWords = {
      segment(VisualWords),
      condition = function()
        local mode = vim.fn.mode()
        return mode == "v" or mode == "V"
      end,
    }

    LSPActive = {
      segment(LSPActive),
      condition = conditions.lsp_attached,
    }

    local function is_regular_buffer()
      return not conditions.buffer_matches({ buftype = { "terminal", "TelescopePrompt", "quickfix", "help" } })
    end

    local Git = {
      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = palette.cyan },
      {
        provider = function(self)
          return "󰘬 " .. self.status_dict.head
        end,
      },
    }

    Git = {
      segment(Git),
      condition = conditions.is_git_repo,
    }

    ActiveStatusLine = {
      Mode,
      Git,
      { File, VisualWords, MacroRec, Align, LSPActive, WorkDir, condition = is_regular_buffer },
      Space,
      condition = conditions.is_active,
    }

    InactiveStatusLine = {
      File,
    }

    require("heirline").setup({
      statusline = {
        ActiveStatusLine,
        InactiveStatusLine,
        fallthrough = false,
      },
    })
  end,
}
