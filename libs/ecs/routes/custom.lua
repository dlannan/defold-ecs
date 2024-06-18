local tinsert           = table.insert

local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local entitydata = {
    pattern = "/data/entities.json", 
    func = function(matches, stream, headers, body)
        local entities = json.encode( { entities = route.ecs_server.entities } )

        entities = string.gsub(entities, "vmath%.vector3%((.-),(.-),(.-)%)", function(a, b, c)
            return string.format("vec3(%.3f, %.3f, %.3f)", a, b, c)
        end)
        entities = string.gsub(entities, "vmath%.quat%((.-),(.-),(.-),(.-)%)", function(a, b, c, d)
            return string.format("quat(%.3f, %.3f, %.3f, %.3f)", a, b, c, d)
        end)        

        entities = entities:gsub("vmath.quat", "quat")
        return route.http_server.json(entities)
    end,
}

local worlddata = {
    pattern = "/data/worlds.json", 
    func = function(matches, stream, headers, body)
        local copy = {}
        for k,v in pairs(route.ecs_server.worlds) do 
            local wrld = {}
            for kk,vv in pairs(v) do 
                if(kk ~= "entities" and kk ~= "systems") then 
                    wrld[kk] = vv
                end
            end
            copy[k] = wrld
        end
        
        local worlds = json.encode( { worlds = copy } )      
        return route.http_server.json(worlds)
    end,
}

local systemdata = {
    pattern = "/data/systems.json", 
    func = function(matches, stream, headers, body)
        local systems = json.encode( { systems = route.ecs_server.systems } )      
        return route.http_server.json(systems)
    end,
}

local routesdata = {
    pattern = "/data/routes.json", 
    func = function(matches, stream, headers, body)
        local copy = {}
        for k,v in pairs(route.ecs_server.routes) do 
            local route = {}
            for kk,vv in pairs(v.routes) do 
                
                if(vv.pattern) then 
                    tinsert(route, vv.pattern)
                end
            end
            copy[k] = route
        end
        
        local routes = json.encode( { routes = copy } )      
        return route.http_server.json(routes)
    end,
}

route.routes = {
    entitydata,
    worlddata,
    systemdata,
    routesdata,
}

return route