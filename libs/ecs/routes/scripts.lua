local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local scripts_json = {
    pattern = "/(.*%.json)%??.*$", 
    func = function(matches, stream, headers, body)
        local json = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.json(json)
    end,
}


local scripts_js = {
    pattern = "/(.*%.js)%??.*$", 
    func = function(matches, stream, headers, body)
        local js = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.script(js)
    end,
}

local scripts_css = {
    pattern = "/(.*%.css)%??.*$", 
    func = function(matches, stream, headers, body)
        local css = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.css(css)
    end,
}

local scripts_css_map = {
    pattern = "/(.*%.css.map)$", 
    func = function(matches, stream, headers, body)
        local css = utils.loaddata("libs/ecs/www/"..matches[1])		
        return route.http_server.file(css, "libs/ecs/www/"..matches[1])
    end,
}

-- Order is important!!
route.routes = {
    scripts_json,
    scripts_js,
    scripts_css,
    scripts_css_map,
}

return route