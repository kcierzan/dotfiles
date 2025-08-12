--[[
_____       __________ ______
___(_)_________(_)_  /____  /___  _______ _
__  /__  __ \_  /_  __/__  /_  / / /  __ `/
_  / _  / / /  / / /____  / / /_/ // /_/ /
/_/  /_/ /_//_/  \__/(_)_/  \__,_/ \__,_/
]]
--

local lazy = require("lazy-config")
require("globals").setup()
require("options").setup()
require("keys").setup()
require("autocommands").setup()
require("ghostty").setup()
require("neovide").setup()
require("vscode-config").setup()
lazy.setup()
lazy.load_plugins()
