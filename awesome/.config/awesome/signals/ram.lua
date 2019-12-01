local awful = require("awful")

local update_interval = 1

awful.widget.watch("ram", update_interval, function(widget, stdout)
  awesome.emit_signal("signals::ram", stdout:gsub("%s+", ""))
end)
