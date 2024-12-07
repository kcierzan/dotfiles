return {
  "rebelot/heirline.nvim",
  lazy = false,
  dependencies = { "rebelot/kanagawa.nvim" },
  config = function()
    local utils = require("heirline.utils")
    local conditions = require("heirline.conditions")
    local colors = require("kanagawa.colors").setup()

    local Space = { provider = " " }
    local Align = { provider = "%=" }
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
          i = "green",
          v = "cyan",
          V = "cyan",
          ["\22"] = "cyan",
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
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.icon, self.icon_color =
          require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. " ")
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        local filename = vim.fn.fnamemodify(self.filename, ":.")
        if filename == "" then
          return "[No Name]"
        end

        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = utils.get_highlight("Directory").fg },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = "[+]",
        hl = { fg = "green" },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = "",
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
          return { fg = "cyan", bold = true, force = true }
        end
      end,
    }

    local FileType = {
      provider = function()
        return string.upper(vim.bo.filetype)
      end,
      hl = { fg = utils.get_highlight("Type").fg, bold = true },
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
      Space,
      FileIcon,
      utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
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
      condition = conditions.lsp_attached,
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, server.name)
        end
        return " [" .. table.concat(names, " ") .. "]"
      end,
      hl = { fg = "green", bold = true },
    }

    local WorkDir = {
      provider = function()
        local icon = (vim.fn.haslocaldir(0) == 1 and "[local]" or "") .. " " .. " "
        local cwd = vim.fn.getcwd(0)
        cwd = vim.fn.fnamemodify(cwd, ":~")
        if not conditions.width_percent_below(#cwd, 0.25) then
          cwd = vim.fn.pathshorten(cwd)
        end
        return icon .. cwd
      end,
      hl = { fg = "waveRed", bold = true },
    }

    require("heirline").setup({
      statusline = {
        Space,
        ViMode,
        Space,
        FileNameBlock,
        Space,
        MacroRec,
        Align,
        LSPActive,
        Space,
        WorkDir,
        Space,
      },
      opts = {
        colors = colors.palette,
      },
    })
  end,
}
