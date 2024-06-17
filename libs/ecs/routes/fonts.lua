local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local font_ttf = {
    pattern ="/(.+%.ttf)$", 
    func = function(matches, stream, headers, body)
        local ttf = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.file(ttf, "libs/ecs/www/"..matches[1])
    end,
}

local font_woff = {
    pattern = "/(.+%.woff2?)%??.*$", 
    func = function(matches, stream, headers, body)
        local woff = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.file(woff, "libs/ecs/www/"..matches[1])
    end,
}

route.routes = {
    font_ttf,
    font_woff,
}

return route