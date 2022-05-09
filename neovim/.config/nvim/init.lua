--[[
 __         __ __          __
|__|.-----.|__|  |_       |  |.--.--.---.-.
|  ||     ||  |   _|  __  |  ||  |  |  _  |
|__||__|__||__|____| |__| |__||_____|___._|

--]]
local hotpot_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/hotpot.nvim'

-- bootstrap hotpot
if vim.fn.empty(vim.fn.glob(hotpot_path)) > 0 then
  print("Could not find hotpot.nvim, cloning new copy to", hotpot_path)
  vim.fn.system({'git', 'clone', 'https://github.com/rktjmp/hotpot.nvim', hotpot_path})
  vim.cmd("helptags " .. hotpot_path .. "/doc")
end

require("hotpot")

require("init_fennel")
