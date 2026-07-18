fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
debug.traceback = fennel.traceback
fennel.dofile("app.fnl")
