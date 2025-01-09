local fennel = require("fennel")

table.insert(package.loaders or package.searchers, fennel.searcher)
package.path = package.path .. ";" .. hs.configdir .. "/?.lua"

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "r", function()
    hs.reload()
end)

fennel.dofile(hs.configdir .. "/config.fnl", { allowedGlobals = false })
