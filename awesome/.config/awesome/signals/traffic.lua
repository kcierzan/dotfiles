-- Provides:
-- signals::traffic
--      down (string)
--      up (string)
--
local awful = require("awful")
local helpers = require("helpers")

local update_interval = 1

awful.widget.watch("traffic", update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")
                     local down = lines[1]
                     local up = lines[2]

                     awesome.emit_signal("signals::traffic", down, up)
end)
