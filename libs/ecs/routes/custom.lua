local route = {
    http_server = nil,
    ecs_server = nil,
}

local entitydata = {
    pattern = "/data/entities.dat", 
    func = function(matches, stream, headers, body)
        local entities = json.encode( { entities = route.ecs_server.entities } )

        entities = string.gsub(entities, "vmath%.vector3%((.-),(.-),(.-)%)", function(a, b, c)
            return string.format("vec3(%.3f, %.3f, %.3f)", a, b, c)
        end)
        entities = string.gsub(entities, "vmath%.quat%((.-),(.-),(.-),(.-)%)", function(a, b, c, d)
            return string.format("quat(%.3f, %.3f, %.3f, %.3f)", a, b, c, d)
        end)        

        entities = entities:gsub("vmath.quat", "quat")
        return route.http_server.script(entities)
    end,
}

local worlddata = {
    pattern = "/data/worlds.dat", 
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
        return route.http_server.script(worlds)
    end,
}

local systemdata = {
    pattern = "/data/systems.dat", 
    func = function(matches, stream, headers, body)
        pprint(route.ecs_server.worlds[1].systems)
        local systems = json.encode( { systems = route.ecs_server.systems } )      
        return route.http_server.script(systems)
    end,
}

route.routes = {
    entitydata,
    worlddata,
    systemdata,
}

return route