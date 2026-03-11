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

local mode_icons = {
  n = "",
  no = "",
  nov = "",
  noV = "",
  ["no\22"] = "",
  niI = "",
  niR = "",
  niV = "",
  nt = "",
  v = "",
  vs = "",
  V = "",
  Vs = "",
  ["\22"] = "󰩬",
  ["\22s"] = "󰩬",
  s = "󰩬",
  S = "󰩬",
  ["\19"] = "󰩬",
  i = "",
  ic = "",
  ix = "",
  R = "",
  Rc = "",
  Rx = "",
  Rv = "",
  Rvc = "",
  Rvx = "",
  c = "󰘳",
  cv = "",
  r = "",
  rm = "",
  ["r?"] = "",
  ["!"] = "",
  t = "",
}

-- Load Stylix colors from Nix-generated file

local function get_mode_colors()
  return {
    n = utils.get_highlight("b16_base0D").fg, -- Blue (normal)
    i = utils.get_highlight("b16_base0B").fg, -- Green (insert)
    v = utils.get_highlight("b16_base0E").fg, -- Purple (visual - selection)
    V = utils.get_highlight("b16_base0E").fg,
    ["\22"] = utils.get_highlight("b16_base0E").fg,
    c = utils.get_highlight("b16_base0A").fg, -- Yellow (command)
    s = utils.get_highlight("b16_base0C").fg, -- Cyan (select)
    S = utils.get_highlight("b16_base0C").fg,
    ["\19"] = utils.get_highlight("b16_base0C").fg,
    R = utils.get_highlight("b16_base08").fg, -- Red (replace - destructive)
    r = utils.get_highlight("b16_base09").fg, -- Orange (prompt)
    ["!"] = utils.get_highlight("b16_base08").fg,
    t = utils.get_highlight("b16_base0C").fg, -- Cyan (terminal)
  }
end

local ModeBlock = {
  static = {
    mode_icons = mode_icons,
  },
  init = function(self)
    self.mode = vim.fn.mode(1)
    self.mode_colors = get_mode_colors()
  end,
  update = {
    "ModeChanged",
    pattern = "*:*",
    callback = vim.schedule_wrap(function()
      vim.cmd("redrawstatus")
    end),
  },
}

local ModeIcon = {
  provider = function(self)
    -- return "%2(" .. self.mode_icons[self.mode] .. "%)" -- with padding
    return " " .. self.mode_icons[self.mode] .. " "
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { bg = self.mode_colors[mode], fg = utils.get_highlight("b16_base01").fg }
  end,
}

local ModeRightSeparator = {
  provider = function()
    return ""
  end,
  hl = function(self)
    local mode = self.mode:sub(1, 1)
    return { bg = utils.get_highlight("b16_base01").fg, fg = self.mode_colors[mode] }
  end
}

local Mode = utils.insert(ModeBlock, ModeIcon, ModeRightSeparator)

function M.new()
  return Mode
end

return M
