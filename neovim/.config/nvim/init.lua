--[[
 __         __ __          __
|__|.-----.|__|  |_       |  |.--.--.---.-.
|  ||     ||  |   _|  __  |  ||  |  |  _  |
|__||__|__||__|____| |__| |__||_____|___._|

--]]
local hotpot_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/hotpot.nvim'

local function file_exits(filepath)
  return vim.fn.empty(vim.fn.glob(filepath)) == 0
end

-- bootstrap hotpot
if not file_exits(hotpot_path) then
  print("Could not find hotpot.nvim, cloning new copy to", hotpot_path)
  vim.fn.system({'git', 'clone', 'https://github.com/rktjmp/hotpot.nvim', hotpot_path})
  vim.cmd("helptags " .. hotpot_path .. "/doc")
end

-- pcall(require, "impatient")

require("hotpot").setup({
  provide_required_fennel = true,
  macros = {
    env = '_COMPILER',
    compilerEnv = _G,
    allowGlobals = false
  }
})

require("init")
