local awful = require("awful")

-- update every 15 minutes
local update_interval = 900

-- call the `weather` shell script periodically
awful.widget.watch("weather", update_interval, function(widget, stdout)
                     local lines = {}
                     -- split colon-delimited stdout into array
                     for line in stdout:gmatch("[^:]+") do
                       table.insert(lines, line)
                     end

                     local icon_code    = lines[1]
                     local temperature  = lines[2]
                     local summary      = lines[3]

                     if icon_code == "..." then
                       awesome.emit_signal("signals::weather", 999, "Weather unavailable", "")
                     else
                       awesome.emit_signal("signals::weather", temperature, summary, icon_code)
                     end
end)
