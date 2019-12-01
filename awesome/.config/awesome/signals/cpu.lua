local awful = require("awful")

local update_interval = 1

awful.widget.watch("cpu", update_interval, function(widget, stdout)
  awesome.emit_signal("signals::cpu", stdout:gsub("%s+", ""))
end)
