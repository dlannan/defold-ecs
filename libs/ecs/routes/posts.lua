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

local posts_cameraenable = {
    pattern = "/world/camera/enable$", 
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        route.ecs_server.change_camera = cdata.go        
        return route.http_server.html("success")
    end,
}

local posts_cameraeffect = {
    pattern = "/world/camera/effect$",
    func = function(matches, stream, headers, body)

        if(body == nil) then 
            return route.http_server.html("failed. no post data.")
        end

        local cdata = json.decode(body)
        if(cdata.effect) then msg.post("/ecs", cdata.effect) end
        return route.http_server.html("success")
    end,
}

route.routes = {
    posts_form,
    posts_systems,

    posts_cameraenable,
    posts_cameraeffect,
}

return route