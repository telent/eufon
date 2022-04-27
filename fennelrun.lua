local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
-- print(fennel.view(arg))
fennel.dofile(arg[0], { correlate = true })
