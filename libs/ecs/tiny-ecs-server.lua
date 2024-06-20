------------------------------------------------------------------------------------------------------------
-- State - Tiny ECS server
--
-- Decription: A simple http server for interrogating ecs scene
-- 				Can debug ecs objects
--				Can update objects remotely from http (localip)
------------------------------------------------------------------------------------------------------------

local tinsert 		= table.insert

local utils 		= require("utils.utils")
local tf 			= require("utils.transforms")
local tiny          = require("libs.ecs.tiny-ecs")
local http_server   = require "defnet.http_server"

local fps 		    = require("libs.metrics.fps")
local mem 		    = require("libs.metrics.mem")

------------------------------------------------------------------------------------------------------------

local tinyserver	= {

    entities            = {},
    entities_lookup     = {},
    cameras_lookup      = {},

    update              = true,
    fps                 = 0,
    mem                 = 0, 
    deltas              = {},
}

------------------------------------------------------------------------------------------------------------

tinyserver.port            = 9190
tinyserver.host            = "127.0.0.1"

BACKLOG                        = 5

tinyserver.updateRate     = 1.0  -- per second
tinyserver.lastUpdate     = 0.0 

------------------------------------------------------------------------------------------------------------

local routes = {
    index       = require("libs.ecs.routes.index"),
    scripts     = require("libs.ecs.routes.scripts"),
    fonts       = require("libs.ecs.routes.fonts"),
    images      = require("libs.ecs.routes.images"),
    custom      = require("libs.ecs.routes.custom"),
    xml         = require("libs.ecs.routes.xml"),
    posts       = require("libs.ecs.routes.posts"),
}

tinyserver.routes = routes

------------------------------------------------------------------------------------------------------------

local function register_get( route )

    routes[route].ecs_server = tinyserver 
    routes[route].http_server = tinyserver.http_server
    for k,v in ipairs(routes[route].routes) do 
        tinyserver.http_server.router.get( v.pattern, v.func )
    end
end

------------------------------------------------------------------------------------------------------------

local function register_post( route )

    routes[route].ecs_server = tinyserver 
    routes[route].http_server = tinyserver.http_server
    for k,v in ipairs(routes[route].routes) do 
        tinyserver.http_server.router.post( v.pattern, v.func )
    end
end

------------------------------------------------------------------------------------------------------------

local function startServer( host, port )
    
    tinyserver.http_server = http_server.create(port)

    -- Add routes here if you need to load in specific asset/mime types
    register_get( "custom")

    register_get( "scripts")
    register_get( "fonts")
    register_get( "images")
    register_get( "xml")
    
    register_post( "posts")

    register_get( "index")

    tinyserver.http_server.router.unhandled(function(method, uri, stream, headers, body)
        return tinyserver.http_server.html("404 - cannot find endpoint.", http_server.NOT_FOUND)
    end)
    tinyserver.http_server.start()
end 

------------------------------------------------------------------------------------------------------------
-- This occurs on every entity 
tinyserver.entitySystemProc = function(self, e, dt)

    if(tinyserver.update == false) then return end 
    
    local idx = 1
    if( e.id and tinyserver.entities_lookup[e.id] == nil ) then 
        
        tinsert(tinyserver.entities, e)
        idx = utils.tcount(tinyserver.entities)
        tinyserver.entities_lookup[e.id] = idx
        if(e.etype == "camera") then 
            tinyserver.cameras_lookup[e.id] = idx
        end
    else

        -- Continually updates the entities
        idx = tinyserver.entities_lookup[e.id]
        if(idx) then 
            tinyserver.entities[idx] = e
            -- Check for pos/rot updates - check for gamne object 
            if(e.go) then 

                e.pos = go.get_position(e.go)
                e.rot = go.get_rotation(e.go)
                e.scale = go.get_scale(e.go)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------

tinyserver.setSystems = function( systems )
    tinyserver.systems = systems
end

------------------------------------------------------------------------------------------------------------

tinyserver.setWorlds = function( worlds )
    tinyserver.worlds = worlds
end

------------------------------------------------------------------------------------------------------------

tinyserver.setEntities = function(  entities )
    tinyserver.entities = entities
    tinyserver.entities_lookup = {}
end

------------------------------------------------------------------------------------------------------------

tinyserver.findGo = function( go )
    for k,v in pairs(tinyserver.entities) do 
        if (v.go == go) then return v end 
    end 
    return nil
end

------------------------------------------------------------------------------------------------------------

tinyserver.init = function()

    -- Start the server
    startServer( tinyserver.host, tinyserver.port)
end

------------------------------------------------------------------------------------------------------------

tinyserver.update = function ()
    -- metrics updated 
    tinyserver.fps = fps.fps()
    tinyserver.mem = mem.mem()
    tinyserver.deltas = fps.deltas()
    
    tinyserver.http_server.update()
end

------------------------------------------------------------------------------------------------------------

tinyserver.final = function(self)
    tinyserver.http_server.stop()
end

------------------------------------------------------------------------------------------------------------

return tinyserver

------------------------------------------------------------------------------------------------------------