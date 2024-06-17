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

route.routes = {
    entitydata,
}

return route