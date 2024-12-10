local lib = require("lib")

return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = { "rebelot/kanagawa.nvim", "echanovski/mini.icons" },
  config = function()
    local separator = "round"
    local segment_bg = "sumiInk4"
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")
    local colors = require("kanagawa.colors").setup()

    local separators = {
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
          provider = left_sep,
          hl = { fg = segment_bg, bg = utils.get_highlight("StatusLine").bg },
        },
        padding,
        unpack(components),
        padding,
        {
          provider = right_sep,
          hl = { fg = segment_bg, bg = utils.get_highlight("StatusLine").bg },
        },
      }
    end

    local ViMode = {
      static = {
        mode_names = {
          n = "N",
          no = "N?",
          nov = "N?",
          noV = "N?",
          ["no\22"] = "N?",
          niI = "Ni",
          niR = "Nr",
          niV = "Nv",
          nt = "Nt",
          v = "V",
          vs = "Vs",
          V = "V_",
          Vs = "Vs",
          ["\22"] = "^V",
          ["\22s"] = "^V",
          s = "S",
          S = "S_",
          ["\19"] = "^S",
          i = "I",
          ic = "Ic",
          ix = "Ix",
          R = "R",
          Rc = "Rc",
          Rx = "Rx",
          Rv = "Rv",
          Rvc = "Rv",
          Rvx = "Rv",
          c = "C",
          cv = "Ex",
          r = "...",
          rm = "M",
          ["r?"] = "?",
          ["!"] = "!",
          t = "T",
        },
        mode_colors = {
          n = "crystalBlue",
          i = "springGreen",
          v = "springBlue",
          V = "springBlue",
          ["\22"] = "springBlue",
          c = "orange",
          s = "purple",
          S = "purple",
          ["\19"] = "purple",
          R = "orange",
          r = "orange",
          ["!"] = "red",
          t = "red",
        },
      },
      init = function(self)
        self.mode = vim.fn.mode(1)
      end,
      provider = function(self)
        return "%2( [" .. self.mode_names[self.mode] .. "]%)"
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
        local path = vim.fn.fnamemodify(self.filename, ":~:.:h")

        if not conditions.width_percent_below(#path, 0.25) then
          path = vim.fn.pathshorten(path)
        end
        return path .. "/"
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":t")
        if filename == "" then
          filename = "[No Name]"
        end
        return filename
      end,
      hl = { fg = utils.get_highlight("Boolean").fg, bold = true },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " 󰧞",
        hl = { fg = "roninYellow" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = " ",
        hl = { fg = "orange" },
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
          return { fg = "springBlue", bold = true, force = true }
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
      -- FileType,
      FileEncoding,
      FileFormat,
      { provider = "%<" } -- this means that the statusline is cut here when there's not enough space
    )

    local MacroRec = {
      condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
      end,
      provider = "󰑋 ",
      hl = { fg = "waveRed" },
      utils.surround({ "[", "]" }, nil, {
        provider = function()
          return vim.fn.reg_recording()
        end,
        hl = { fg = "springGreen" },
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
        return " " .. table.concat(names, " ")
      end,
      hl = { fg = "springGreen", bold = true },
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
      hl = { fg = "waveRed", bold = true },
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
      hl = { fg = "oniViolet", bold = true },
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

    ActiveStatusLine = {
      Mode,
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
      opts = {
        colors = colors.palette,
      },
    })
  end,
}
