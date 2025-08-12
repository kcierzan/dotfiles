local M = {}

local utils = require("heirline.utils")

local mode_names = {
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
}

local function get_mode_colors(palette)
  return {
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
  }
end

function M.create_vi_mode(palette)
  return {
    static = {
      mode_names = mode_names,
      mode_colors = get_mode_colors(palette),
    },
    init = function(self)
      self.mode = vim.fn.mode(1)
    end,
    provider = function(self)
      return "%2(" .. self.mode_names[self.mode] .. "%)"
    end,
    hl = function(self)
      local mode = self.mode:sub(1, 1)
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
end

function M.create_file_name_block(palette)
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
      provider = " ●",
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

  local FileNameModifier = {
    hl = function()
      if vim.bo.modified then
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

  return utils.insert(
    FileNameBlock,
    FileIcon,
    utils.insert(FileNameModifier, { FilePath, FileName }),
    FileFlags,
    FileEncoding,
    FileFormat,
    { provider = "%<" }
  )
end

function M.create_macro_rec()
  return {
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
end

function M.create_lsp_active(palette)
  return {
    update = { "LspAttach", "LspDetach", "BufEnter", "WinEnter" },
    provider = function()
      local lsp_icons = {
        basedpyright = " ",
        bashls = " ",
        biome = "󰂦 ",
        copilot = " ",
        cssls = " ",
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
        vtsls = " ",
      }
      local names = {}
      for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        table.insert(names, lsp_icons[server.name] or server.name)
      end
      return table.concat(names, ":: ")
    end,
    hl = { fg = palette.modified_light_fg },
  }
end

function M.create_work_dir(palette)
  return {
    provider = function()
      local cwd = vim.fn.getcwd(0)
      local icon = require("mini.icons").get("directory", cwd)
      icon = (vim.fn.haslocaldir(0) == 1 and "[local] " or "") .. icon .. " "
      cwd = vim.fn.fnamemodify(cwd, ":~")
      local conditions = require("heirline.conditions")
      if not conditions.width_percent_below(#cwd, 0.25) then
        cwd = vim.fn.pathshorten(cwd)
      end
      return icon .. cwd
    end,
    hl = { fg = palette.cwd_fg },
  }
end

function M.create_visual_words()
  return {
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
end

local function create_diagnostic_count(severity, severity_name)
  return {
    init = function(self)
      self.count = #vim.diagnostic.get(0, { severity = severity })
    end,
    condition = function()
      return #vim.diagnostic.get(0, { severity = severity }) > 0
    end,
    provider = function(self)
      if self.count > 0 then
        return "●" .. " " .. self.count .. " "
      end
    end,
    hl = { fg = utils.get_highlight("Diagnostic" .. severity_name).fg },
  }
end

function M.create_diagnostic_counts()
  return {
    update = { "DiagnosticChanged", "BufEnter" },
    create_diagnostic_count(vim.diagnostic.severity.ERROR, "Error"),
    create_diagnostic_count(vim.diagnostic.severity.WARN, "Warn"),
    create_diagnostic_count(vim.diagnostic.severity.INFO, "Info"),
    create_diagnostic_count(vim.diagnostic.severity.HINT, "Hint"),
  }
end

function M.create_codecompanion_status()
  -- Set up autocmds to track CodeCompanion status
  local group = vim.api.nvim_create_augroup("CodeCompanionHeirlineStatus", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestStreaming" },
    group = group,
    callback = function()
      vim.g.codecompanion_request_active = true
      vim.cmd("redrawstatus")
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "CodeCompanionRequestFinished", "CodeCompanionInlineFinished" },
    group = group,
    callback = function()
      vim.g.codecompanion_request_active = false
      vim.cmd("redrawstatus")
    end,
  })

  return {
    init = function(self)
      self.is_active = vim.g.codecompanion_request_active or false
    end,
    provider = function(self)
      return self.is_active and " 󰔟 Processing..." or ""
    end,
    hl = { fg = utils.get_highlight("DiagnosticInfo").fg },
    update = {
      "User",
      pattern = {
        "CodeCompanionRequestStarted",
        "CodeCompanionRequestFinished",
        "CodeCompanionRequestStreaming",
        "CodeCompanionInlineFinished",
      },
    },
  }
end

function M.create_git(palette)
  return {
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
end

return M
