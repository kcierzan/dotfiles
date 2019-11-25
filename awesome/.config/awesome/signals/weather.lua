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
                     local data = {
                       current_icon     = lines[1],
                       current_temp     = lines[2],
                       current_summary  = lines[3],
                       today_icon       = lines[4],
                       today_summary    = lines[5],
                       today_low        = lines[6],
                       today_high       = lines[7],
                       tomorrow_icon    = lines[8],
                       tomorrow_summary = lines[9],
                       tomorrow_low     = lines[10],
                       tomorrow_high    = lines[11],
                       day2_icon        = lines[12],
                       day2_summary     = lines[13],
                       day2_low         = lines[14],
                       day2_high        = lines[15],
                       day3_icon        = lines[16],
                       day3_summary     = lines[17],
                       day3_low         = lines[18],
                       day3_high        = lines[19],
                       day4_icon        = lines[20],
                       day4_summary     = lines[21],
                       day4_low         = lines[22],
                       day4_high        = lines[23],
                       day5_icon        = lines[24],
                       day5_summary     = lines[25],
                       day5_low         = lines[26],
                       day5_high        = lines[27],
                       day6_icon        = lines[28],
                       day6_summary     = lines[29],
                       day6_low         = lines[30],
                       day6_high        = lines[31],
                       day7_icon        = lines[32],
                       day7_summary     = lines[33],
                       day7_low         = lines[34],
                       day7_high        = lines[35]
                     }

                     if icon_code == "..." then
                       data.error = "ERROR"
                       awesome.emit_signal("signals::weather", data)
                     else
                       awesome.emit_signal("signals::weather", data)
                     end
end)
