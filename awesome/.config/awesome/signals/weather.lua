-- Provides:
-- signals::weather
--      temperature (integer)
--      summary (string)
--      icon_code (string)
local awful = require("awful")
local helpers = require("helpers")

-- update every 10 minutes
local update_interval = 600

-- call the `weather` shell script periodically
awful.widget.watch("weather", update_interval, function(widget, stdout)
                     local lines = helpers.split(stdout, ":")

                     local icon_code    = lines[1]
                     local temperature  = lines[2]
                     local summary      = lines[3]

                     if icon_code == "..." then
                       awesome.emit_signal("signals::weather", 999, "Weather unavailable", "")
                     else
                       awesome.emit_signal("signals::weather", temperature, summary, icon_code)
                     end
end)
