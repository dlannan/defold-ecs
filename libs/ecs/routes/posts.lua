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

local posts_systems = {
    pattern = "/systems/enable$", 
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local rdata = json.decode(body)
        local sys = route.ecs_server.current_world.systems[rdata.system.index]
        if( rdata.enabled == true) then
            sys.active = true 
        else
            sys.active = false 
        end
        return route.http_server.html("success")
    end,
}

route.routes = {
    posts_form,
    posts_systems,
}

return route