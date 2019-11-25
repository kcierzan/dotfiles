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

                     -- TODO: make this an object with everything for the forecast
                     local data = {
                       current_icon    = lines[1],
                       current_temp    = lines[2],
                       current_summary = lines[3],
                       icon_0      = lines[4],
                       summary_0   = lines[5],
                       temp_low_0  = lines[6],
                       temp_high_0 = lines[7],
                       icon_1      = lines[8],
                       summary_1   = lines[9],
                       temp_low_1  = lines[10],
                       temp_high_1 = lines[11],
                       icon_2      = lines[12],
                       summary_2   = lines[13],
                       temp_low_2  = lines[14],
                       temp_high_2 = lines[15],
                       icon_3      = lines[16],
                       summary_3   = lines[17],
                       temp_low_3  = lines[18],
                       temp_high_3 = lines[19],
                       icon_4      = lines[20],
                       summary_4   = lines[21],
                       temp_low_4  = lines[22],
                       temp_high_4 = lines[23],
                       icon_5      = lines[24],
                       summary_5   = lines[25],
                       temp_low_5  = lines[26],
                       temp_high_5 = lines[27],
                       icon_6      = lines[28],
                       summary_6   = lines[29],
                       temp_low_6  = lines[30],
                       temp_high_6 = lines[31],
                       icon_7      = lines[32],
                       summary_7   = lines[33],
                       temp_low_7  = lines[34],
                       temp_high_7 = lines[35]
                     }
                     local icon_code    = lines[1]
                     local temperature  = lines[2]
                     local summary      = lines[3]

                     if icon_code == "..." then
                       awesome.emit_signal("signals::weather", 999, "Weather unavailable", "")
                     else
                       awesome.emit_signal("signals::weather", temperature, summary, icon_code)
                     end
end)
