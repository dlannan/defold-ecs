------------------------------------------------------------------------------------------------------------
-- State - Tiny ECS server
--
-- Decription: A simple http server for interrogating ecs scene
-- 				Can debug ecs objects
--				Can update objects remotely from http (localip)
------------------------------------------------------------------------------------------------------------

local STinyECSServer	= {}

------------------------------------------------------------------------------------------------------------

local tinsert 		= table.insert

local utils 		= require("utils.utils")
local tf 			= require("utils.transforms")
local tiny          = require("libs.ecs.tiny-ecs")
local http_server   = require "defnet.http_server"

------------------------------------------------------------------------------------------------------------

STinyECSServer.entities = {}
STinyECSServer.entities_lookup = {}

------------------------------------------------------------------------------------------------------------

STinyECSServer.port            = 9190
STinyECSServer.host            = "127.0.0.1"

BACKLOG                        = 5

STinyECSServer.updateRate     = 1.0  -- per second
STinyECSServer.lastUpdate     = 0.0 

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

------------------------------------------------------------------------------------------------------------

local function register_get( self, route )

    routes[route].ecs_server = self 
    routes[route].http_server = self.http_server
    for k,v in ipairs(routes[route].routes) do 
        self.http_server.router.get( v.pattern, v.func )
    end
end

------------------------------------------------------------------------------------------------------------

local function register_post( self, route )

    routes[route].ecs_server = self 
    routes[route].http_server = self.http_server
    for k,v in ipairs(routes[route].routes) do 
        self.http_server.router.post( v.pattern, v.func )
    end
end

------------------------------------------------------------------------------------------------------------

local function startServer( self, host, port )
    
    self.http_server = http_server.create(port)

    -- Add routes here if you need to load in specific asset/mime types
    register_get(self, "scripts")
    register_get(self, "fonts")
    register_get(self, "images")
    register_get(self, "custom")
    register_get(self, "xml")
    
    register_post(self, "posts")

    register_get(self, "index")


    self.http_server.router.unhandled(function(method, uri, stream, headers, body)
        return self.http_server.html("404 - cannot find endpoint.", http_server.NOT_FOUND)
    end)
    self.http_server.start()
end 

------------------------------------------------------------------------------------------------------------
-- This occurs on every entity 
STinyECSServer.entitySystemProc = function(self, e, dt)

    if(self.update == false) then return end 
    
    local idx = 1
    if( e.id and STinyECSServer.entities_lookup[e.id] == nil and e.etype ~= "scene" ) then 

        tinsert(STinyECSServer.entities, e)
        idx = utils.tcount(STinyECSServer.entities)
        STinyECSServer.entities_lookup[e.id] = idx
    else
        -- Continually updates the entities
        idx = STinyECSServer.entities_lookup[e.id]
        if(idx) then 
            STinyECSServer.entities[idx] = e
            -- Check for pos/rot updates - check for gamne object 
            if(e.go) then 
                e.pos = go.get_position(e.go)
                e.rot = go.get_rotation(e.go)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------

function STinyECSServer:FindGo( go )
    for k,v in pairs(STinyECSServer.entities) do 
        if (v.go == go) then return v end 
    end 
    return nil
end

------------------------------------------------------------------------------------------------------------

function STinyECSServer:Begin()

    -- Start the server
    startServer( self, STinyECSServer.host, STinyECSServer.port)
end

------------------------------------------------------------------------------------------------------------

function STinyECSServer:Update()

    self.http_server.update()
end

-----------------------------------------------------------------------------------------------------------

function STinyECSServer:Render()
end

------------------------------------------------------------------------------------------------------------

function STinyECSServer:Finish()
    self.http_server.stop()
end

------------------------------------------------------------------------------------------------------------

return STinyECSServer

------------------------------------------------------------------------------------------------------------