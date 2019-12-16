local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local pacman_log_date_pattern = "(%d%d%d%d)-(%d%d)-(%d%d)T(%d%d):(%d%d):(%d%d)(-%d%d%d%d)"

local days_since = function(time)
  -- eg. "2019-11-30T09:22:54-0500"
  local year, month, day, hour, min, sec, _ = time:match(pacman_log_date_pattern)
  local old = os.time(
    {
      year = year,
      month = month,
      day = day,
      hour = hour,
      min = min,
      sec = sec
    })

  -- the log should have the same offset as
  local days = math.floor((os.time() - old) / 60 / 60 / 24)

  if days > 10 then
    return helpers.colorize_text(helpers.bold_text(days), beautiful.xcolor1)
  elseif days > 5 then
    return helpers.colorize_text(helpers.bold_text(days), beautiful.xcolor3)
  else
    return days
  end
end

local last_update = wibox.widget {
  widget = wibox.widget.textbox
}

awesome.connect_signal("signals::last_pacman_update", function(last_update_time)
  last_update.markup = "It has been " .. days_since(last_update_time) .. " days since the last system update"
end)


return last_update
