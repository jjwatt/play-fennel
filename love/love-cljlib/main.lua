-- main.lua
local fennel = require("fennel")

-- Use the paths set up by deps.fnl
table.insert(package.loaders or package.searchers, fennel.searcher)

-- Boot into your Fennel code
require("src.main")
