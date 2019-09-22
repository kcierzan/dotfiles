-- Provides:
-- signals::wifi
--      network (string)
--      signal_strength (integer)
--
local awful = require("awful")
local helpers = require("helpers")

-- update every 15 minutes
local update_interval = 30

awful.widget.watch("wifi", update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")
                     local network_name = lines[1]
                     local strength = lines[2]

                     awesome.emit_signal("signals::wifi", network_name, strength)
end)
