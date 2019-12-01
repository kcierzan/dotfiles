local awful = require("awful")
local helpers = require("helpers")

local update_interval = 5

awful.widget.watch("hdd", update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")
                     local root = lines[1]
                     local media = lines[2]

                     awesome.emit_signal("signals::hdd", root, media)
end)
