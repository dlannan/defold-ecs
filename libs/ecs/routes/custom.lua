local tinsert           = table.insert

local utils 		    = require("utils.utils")
local route = {
    http_server = nil,
    ecs_server = nil,
}

local entitydata = {
    pattern = "/data/entities", 
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
    pattern = "/data/worlds$", 
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
    pattern = "/data/systems$", 
    func = function(matches, stream, headers, body)

        -- Add data from the systems on data requests
        for k,v in pairs(route.ecs_server.systems) do 
            -- Fetch current system info
            local sys = route.ecs_server.current_world.systems[v.index]
            v.modified = sys.modified
            v.active = sys.active
            v.entity_count = utils.tcount(sys.entities)
            v.calls = sys.calls or 0
        end

        local systems = json.encode( { systems = route.ecs_server.systems } )      
        return route.http_server.json(systems)
    end,
}

local routesdata = {
    pattern = "/data/routes$", 
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

local worldcurrent = {
    pattern = "/data/world/current$", 
    func = function(matches, stream, headers, body)

        local curr_world = route.ecs_server.current_world
        local world = {
            name = curr_world.name, 
            entities_count = utils.tcount(curr_world.entities),
            systems_count = utils.tcount(curr_world.systems),
            systems = {},
        }
        for k,v in pairs(curr_world.systems) do 
            local sys = {
                index = v.index,
                calls = v.calls, 
                modified = v.modified, 
                active = v.active,
                entities_count = utils.tcount(v.entities),
            }
            tinsert(world.systems, sys)
        end

        local world = json.encode( { world = world } )      
        return route.http_server.json(world)
    end,
}

local worldcameras = {
    pattern = "/data/world/cameras$", 
    func = function(matches, stream, headers, body)

        local curr_world = route.ecs_server.current_world
        local entities = route.ecs_server.entities
        local cameras = {
            world = curr_world.name, 
            cameras = {},
        }
        for k,v in pairs(route.ecs_server.cameras_lookup) do 
            local cam = entities[v]
            local camera = {
                id = cam.id,
                name = cam.name,
                pos = { x=cam.pos.x, y=cam.pos.y, z=cam.pos.z },
                rot = { x=cam.rot.x, y=cam.rot.y, z=cam.rot.z, w=cam.rot.w },
                go = cam.go,
                created = cam.created,

                fov = cam.fov,
                near = cam.near,
                far = cam.far,
                aspect = cam.aspect,
            }
            tinsert(cameras.cameras, camera)
        end
        return route.http_server.json( json.encode(cameras) )
    end,
}

local defoldmetrics = {
    pattern = "/data/defold/metrics$", 
    func = function(matches, stream, headers, body)

        local srcdata = route.ecs_server
        local data = {
            fps = srcdata.fps,
            mem = srcdata.mem,
            deltas = srcdata.deltas,
        }

        local metrics = json.encode( { metrics = data } )      
        return route.http_server.json(metrics)
    end,
}

route.routes = {
    entitydata,
    worlddata,
    systemdata,
    routesdata,

    worldcurrent,
    worldcameras,
    defoldmetrics,
}

return route