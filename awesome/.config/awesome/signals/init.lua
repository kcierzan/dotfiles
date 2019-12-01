signals = {}
signals.weather = require("signals.weather")
signals.wifi = require("signals.wifi")
signals.traffic = require("signals.traffic")
signals.last_pacman_update = require("signals.last_pacman_update")
signals.number_pacman_updates = require("signals.number_pacman_updates")
signals.cpu = require("signals.cpu")
signals.ram = require("signals.ram")
signals.hdd = require("signals.hdd")
return signals
