local lib = require("lib")

local function load_catppuccin_mocha()
  return require("catppuccin.palettes").get_palette("mocha")
end

local function create_kanso_palette_loader(shade)
  return function()
    return require("kanso.colors").setup({ theme = shade }).palette
  end
end

local palettes = {
  ["catppuccin-mocha"] = load_catppuccin_mocha,
  ["kanso-ink"] = create_kanso_palette_loader("ink"),
  ["kanso-mist"] = create_kanso_palette_loader("mist"),
  ["kanso-pearl"] = create_kanso_palette_loader("pearl"),
  ["kanso-zen"] = create_kanso_palette_loader("zen"),
}

return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = {
    "echanovski/mini.icons",
    "lewis6991/gitsigns.nvim",
    -- TODO: make this load conditionally?
    -- "catppuccin/nvim",
    "webhooked/kanso.nvim",
  },
  config = function()
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")
    local separator = "none"
    local scheme_colors = palettes[vim.g.ghostty_theme_name]()

    local colors = {
      ["catppuccin-mocha"] = {
        -- FIXME: use utils.get_highlight or this will break when color names change internally
        segment_bg = scheme_colors.surface0,
        normal_mode_fg = scheme_colors.green,
        insert_mode_fg = scheme_colors.yellow,
        file_path_fg = scheme_colors.overlay1,
        file_name_fg = scheme_colors.text,
        modified_light_fg = scheme_colors.yellow,
        lsp_fg = scheme_colors.yellow,
        cwd_fg = scheme_colors.mauve,
        branch_fg = scheme_colors.cyan,
        override_sp = scheme_colors.surface2,
        statusline_bg = utils.get_highlight("Statusline").bg,
      },
      ["kanso-ink"] = {
        segment_bg = utils.get_highlight("Cursorline").bg,
        insert_mode_fg = utils.get_highlight("String").fg,
        normal_mode_fg = utils.get_highlight("Function").fg,
        file_path_fg = utils.get_highlight("Operator").fg,
        file_name_fg = utils.get_highlight("Normal").fg,
        modified_light_fg = utils.get_highlight("Special").fg,
        lsp_fg = utils.get_highlight("Special").fg,
        cwd_fg = utils.get_highlight("Number").fg,
        branch_fg = utils.get_highlight("Type").fg,
        override_sp = utils.get_highlight("Operator").fg,
        statusline_bg = utils.get_highlight("Statusline").bg,
      },
    }

    colors["kanso-mist"] = vim.deepcopy(colors["kanso-ink"])
    colors["kanso-zen"] = vim.deepcopy(colors["kanso-ink"])
    colors["kanso-pearl"] = vim.deepcopy(colors["kanso-ink"])
    colors["kanso-pearl"].file_name_fg = utils.get_highlight("Operator").fg
    colors["kanso-pearl"].file_path_fg = utils.get_highlight("Normal").fg
    colors["kanso-pearl"].segment_bg = utils.get_highlight("Pmenu").bg
    colors["catppuccin-xcode"] = colors["catppuccin-mocha"]

    local palette = colors[vim.g.ghostty_theme_name]

    local separators = {
      none_left = "█",
      none_right = "█",
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
        hl = { bg = palette.segment_bg, force = true },
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
            return lib.merge(original_hl(self), { bg = palette.segment_bg, force = true })
          end
        else
          component.hl = lib.merge(hl_type == "table" and hl or {}, { bg = palette.segment_bg, force = true })
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
            hl = { fg = palette.segment_bg, bg = palette.statusline_bg },
            -- hl = { bg = segment_bg },
          },
          padding,
          unpack(components),
          padding,
          {
            provider = right_sep,
            -- hl = { bg = segment_bg },
            hl = { fg = palette.segment_bg, bg = palette.statusline_bg },
          },
          hl = { underline = false, sp = scheme_colors.override_sp, force = true },
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
          n = palette.normal_mode_fg,
          i = palette.insert_mode_fg,
          v = utils.get_highlight("Function").fg,
          V = utils.get_highlight("Function").fg,
          ["\22"] = utils.get_highlight("SpecialKey").fg,
          c = utils.get_highlight("Boolean").fg,
          S = utils.get_highlight("String").fg,
          s = utils.get_highlight("String").fg,
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

        local full_path = vim.fn.fnamemodify(self.filename, ":~:.:h")

        if full_path == "." then
          return "./"
        end

        local parent_dir = vim.fn.fnamemodify(full_path, ":t")

        return parent_dir .. "/"
      end,
      hl = { fg = palette.file_path_fg },
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
      hl = { fg = palette.file_name_fg, bold = true },
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = " 󰧞",
        hl = { fg = palette.modified_light_fg },
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

    local FileNameModifier = {
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
      utils.insert(FileNameModifier, { FilePath, FileName }), -- a new table where FileName is a child of FileNameModifier
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
      update = { "LspAttach", "LspDetach", "BufEnter", "WinEnter" },
      provider = function()
        local lsp_icons = {
          bashls = " ",
          copilot = " ",
          emmet_language_server = " ",
          golangci_lint_ls = " ",
          gopls = " ",
          html = " ",
          lua_ls = " ",
          nushell = " ",
          postgres_lsp = " ",
          ruby_lsp = " ",
          sorbet = " ",
          templ = "{} ",
          typos_lsp = "󰓆 ",
        }
        local names = {}
        for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
          table.insert(names, lsp_icons[server.name] or server.name)
        end
        return table.concat(names, ":: ")
      end,
      hl = { fg = palette.modified_light_fg },
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
      hl = { fg = palette.cwd_fg },
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

      hl = { fg = palette.branch_fg },
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
