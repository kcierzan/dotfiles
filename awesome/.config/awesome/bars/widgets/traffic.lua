local wibox = require("wibox")

local down = wibox.widget {
  valign = "center",
  widget = wibox.widget.textbox
}

local up = wibox.widget {
  valign = "center",
  widget = wibox.widget.textbox
}

local traffic = wibox.widget {
  up,
  down,
  layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("signals::traffic", function(download, upload)
                         down.text = "Down: " .. download
                         up.text = "Up: " .. upload
end)

return traffic
