local lib = require("lib")

local function load_catppuccin_mocha()
  return require("catppuccin.palettes").get_palette("mocha")
end

local function load_kanso_ink()
  return require("kanso.colors").setup({ theme = "ink" }).palette
end

local function load_scheme_colors()
  local loaders = { load_catppuccin_mocha, load_kanso_ink }
  for _, loader in ipairs(loaders) do
    local success, colors = pcall(loader)
    if success then
      return colors
    end
  end
  error("Colorscheme is not heirline compatible!")
end

local colors = {
  -- Bg Shades
  zen0 = "#090E13",
  zen1 = "#1C1E25",
  zen2 = "#24262D",
  zen3 = "#393B42",

  -- Popup and Floats
  zenBlue1 = "#223249",
  zenBlue2 = "#2D4F67",

  -- Diff and Git
  winterGreen = "#2B3328",
  winterYellow = "#49443C",
  winterRed = "#43242B",
  winterBlue = "#252535",
  autumnGreen = "#76946A",
  autumnRed = "#C34043",
  autumnYellow = "#DCA561",

  -- Diag
  samuraiRed = "#E82424",
  roninYellow = "#FF9E3B",
  zenAqua1 = "#6A9589",
  inkBlue = "#658594",

  -- Fg and Comments
  oldWhite = "#C5C9C7",
  fujiWhite = "#f2f1ef",
  fujiGray = "#727169",

  oniViolet = "#957FB8",
  oniViolet2 = "#b8b4d0",
  crystalBlue = "#7E9CD8",
  springViolet1 = "#938AA9",
  springViolet2 = "#9CABCA",
  springBlue = "#7FB4CA",
  lightBlue = "#A3D4D5",
  zenAqua2 = "#7AA89F",

  springGreen = "#98BB6C",
  boatYellow1 = "#938056",
  boatYellow2 = "#C0A36E",
  carpYellow = "#E6C384",

  sakuraPink = "#D27E99",
  zenRed = "#E46876",
  peachRed = "#FF5D62",
  surimiOrange = "#FFA066",
  katanaGray = "#717C7C",

  inkBlack0 = "#14171d",
  inkBlack1 = "#1f1f26",
  inkBlack2 = "#24262D",
  inkBlack3 = "#393B42",

  inkWhite = "#C5C9C7",
  inkGreen = "#87a987",
  inkGreen2 = "#8a9a7b",
  inkPink = "#a292a3",
  inkOrange = "#b6927b",
  inkOrange2 = "#b98d7b",
  inkGray = "#A4A7A4",
  inkGray1 = "#9E9B93",
  inkGray2 = "#75797f",
  inkGray3 = "#5C6066",
  inkBlue2 = "#8ba4b0",
  inkViolet = "#8992a7",
  inkRed = "#c4746e",
  inkAqua = "#8ea4a2",
  inkAsh = "#5C6066",
  inkTeal = "#949fb5",
  inkYellow = "#c4b28a", --"#a99c8b",
  -- "#8a9aa3",

  pearlInk0 = "#24262D",
  pearlInk1 = "#545464",
  pearlInk2 = "#43436c",
  pearlGray = "#e2e1df",
  pearlGray2 = "#5C6068",
  pearlGray3 = "#6D6D69",
  pearlGray4 = "#9F9F99",

  pearlWhite0 = "#f2f1ef",
  pearlWhite1 = "#e2e1df",
  pearlWhite2 = "#dddddb",
  pearlViolet1 = "#a09cac",
  pearlViolet2 = "#766b90",
  pearlViolet3 = "#c9cbd1",
  pearlViolet4 = "#624c83",
  pearlBlue1 = "#c7d7e0",
  pearlBlue2 = "#b5cbd2",
  pearlBlue3 = "#9fb5c9",
  pearlBlue4 = "#4d699b",
  pearlBlue5 = "#5d57a3",
  pearlGreen = "#6f894e",
  pearlGreen2 = "#6e915f",
  pearlGreen3 = "#b7d0ae",
  pearlPink = "#b35b79",
  pearlOrange = "#cc6d00",
  pearlOrange2 = "#e98a00",
  pearlYellow = "#77713f",
  pearlYellow2 = "#836f4a",
  pearlYellow3 = "#de9800",
  pearlYellow4 = "#f9d791",
  pearlRed = "#c84053",
  pearlRed2 = "#d7474b",
  pearlRed3 = "#e82424",
  pearlRed4 = "#d9a594",
  pearlAqua = "#597b75",
  pearlAqua2 = "#5e857a",
  pearlTeal1 = "#4e8ca2",
  pearlTeal2 = "#6693bf",
  pearlTeal3 = "#5a7785",
  pearlCyan = "#d7e3d8",
}

return {
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  dependencies = {
    "echanovski/mini.icons",
    "lewis6991/gitsigns.nvim",
    -- "catppuccin/nvim",
    "webhooked/kanso",
  },
  config = function()
    local separator = "none"
    local colorscheme = vim.g.colors_name
    local scheme_colors = load_scheme_colors()

    local palettes = {
      -- works with catppuccin xcode
      catppuccin = {
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
      },
      kanso = {
        segment_bg = scheme_colors.inkBlack2,
        insert_mode_fg = scheme_colors.inkGreen2,
        normal_mode_fg = scheme_colors.inkBlue2,
        file_path_fg = scheme_colors.fujiGray,
        file_name_fg = scheme_colors.oldWhite,
        modified_light_fg = scheme_colors.roninYellow,
        lsp_fg = scheme_colors.inkViolet,
        cwd_fg = scheme_colors.inkPink,
        branch_fg = scheme_colors.inkTeal,
        override_sp = scheme_colors.fujiGray,
      },
    }

    -- TODO: come up with a better case statement here
    local palette = palettes.catppuccin
    if colorscheme == "kanso" then
      palette = palettes.kanso
    end

    local utils = require("heirline.utils")

    local function set_statusline_bg()
      local statusline_bg = utils.get_highlight("StatusLine").bg
      for _, pal in pairs(palettes) do
        pal.statusline_bg = statusline_bg
      end
    end

    set_statusline_bg()

    local conditions = require("heirline.conditions")

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
      update = { "LspAttach", "LspDetach" },
      provider = function()
        local lsp_icons = {
          typos_lsp = "󰓆 ",
          lua_ls = " ",
          ruby_lsp = " ",
          sorbet = " ",
          gopls = " ",
          golangci_lint_ls = " ",
          postgres_lsp = " ",
          emmet_language_server = " ",
          templ = "{} ",
          html = " ",
          nushell = " ",
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
