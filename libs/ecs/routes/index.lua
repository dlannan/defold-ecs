local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local index_root = {
    pattern = "/index.html[.+]?$", 
    func = function(matches, stream, headers, body)
        local index = utils.loaddata("libs/ecs/www/index.html")		
        return route.http_server.html(index)
    end,
}

route.routes = {
    index_root,
}

return route 