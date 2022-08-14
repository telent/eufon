local fennel = require("fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
fennel.path = os.getenv("EUFON_PATH")  .. "/?.fnl;" ..
   os.getenv("EUFON_PATH")  .. "/?/init.fnl;"

require(arg[0])
