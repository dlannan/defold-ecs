local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local images_png = {
    pattern = "/(.*%.png)$", 
    func = function(matches, stream, headers, body)
        local png = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.file(png, "libs/ecs/www/"..matches[1])
    end,
}

local images_jpg = {
    pattern = "/(.*%.jpg)$", 
    func = function(matches, stream, headers, body)
        local jpg = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.file(jpg, "libs/ecs/www/"..matches[1])
    end,
}

local images_gif = {
    pattern = "/(.*%.gif)$", 
    func = function(matches, stream, headers, body)
        local gif = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.file(gif, "libs/ecs/www/"..matches[1])
    end,
}

route.routes = {
    images_png, 
    images_jpg,
    images_gif,
}

return route