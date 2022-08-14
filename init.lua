print(os.getenv("LUA_PATH"))
print(os.getenv("LUA_CPATH"))

local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
fennel.path = fennel.path .. ";" .. os.getenv("EUFON_PATH") .. "/?.fnl"
require("eufon")
