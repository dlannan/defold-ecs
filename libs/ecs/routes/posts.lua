local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local posts_form = {
    pattern = "/handleform$", 
    func = function(matches, stream, headers, body)
        if body then
            return route.http_server.html("Got form data: " .. tostring(body))
        else
            return route.http_server.html("Got no form data. Using http?")
        end
    end,
}

local posts_post = {
    pattern = "/handlepost$", 
    func = function(matches, stream, headers, body)
        return route.http_server.html("Got post data: " .. tostring(body))
    end,
}

route.routes = {
    posts_form,
    posts_post,
}

return route