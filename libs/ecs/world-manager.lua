------------------------------------------------------------------------------------------------------------

local tinsert 		= table.insert

local tiny 		= require('libs.ecs.tiny-ecs')
local tinysrv	= require('libs.ecs.tiny-ecs-server')
local utils 	= require('utils.utils')

------------------------------------------------------------------------------------------------------------

local worldmanager = {
	worlds = {},
	worlds_lookup = {},
	systems = {},
	systems_lookup = {},
	entities = {},
	entities_lookup = {},
}

------------------------------------------------------------------------------------------------------------

worldmanager.addEntity = function( self, pos, rot, obj )
	
	if(obj.name == nil) then 
		print("[Error] Entity doesnt have a name.")
		return nil 
	end 

	local id = utils.tcount(self.entities)
	if(obj.go) then 
		id = hash_to_hex(obj.go) 
	end 

	obj.id = id
	obj.etype = obj.etype or "entity"
	obj.created = socket.gettime()
	obj.visible = obj.visible or 1
	obj.pos = tostring(obj.pos or pos)
	obj.rot = tostring(obj.rot or rot)
	obj.scale = { 1, 1, 1 }

	-- Keep some handles so we can easily remove
	tinsert(self.entities, obj)
	self.entities_lookup[obj.id] = utils.tcount(self.entities)
	
	return tiny.addEntity(self.current_world, obj)
end

------------------------------------------------------------------------------------------------------------

worldmanager.addGameObject = function( self, name, objurl )
	
	if(name == nil) then 
		print("[Error] Entity doesnt have a name.")
		return nil 
	end 
	local pos = go.get_position(objurl)
	local rot = go.get_rotation(objurl)

	local id = hash_to_hex(hash(objurl))
	local obj = {
		id = id,
		go = objurl,
		name = name, 
		etype = "gameobject",
		created = socket.gettime(),
		visible = 1,
		pos = { x=pos.x, y=pos.y, z=pos.z },
		rot = { x=rot.x, y=rot.y, z=rot.z, w=rot.w },
		scale = { 1, 1, 1 },
	}

	-- Keep some handles so we can easily remove
	tinsert(self.entities, obj)
	self.entities_lookup[obj.id] = utils.tcount(self.entities)
	return tiny.addEntity(self.current_world, obj)
end

------------------------------------------------------------------------------------------------------------

worldmanager.removeEntity = function( self, eid )

	if(eid == nil) then 
		print("[Error] removeEntity: Entity eid is nil?")
		return nil 
	end 
	local ent = self.entities[self.entities_lookup[eid]]
	if(ent == nil) then 
		print("[Error] removeEntity: Entity not found?")
		return nil 
	end
	if(eid) then go.delete(eid, true) end
	local oldent = tiny.removeEntity(self.current_world, ent)
    return oldent
end

------------------------------------------------------------------------------------------------------------

worldmanager.addSystem = function( self, systemname, filters, processFunc )

	if(self.systems_lookup[systemname]) then 
		print("[Error] System already exists: "..systemname)
		return nil
	else
		local new_system = tiny.processingSystem()
		new_system.filter = tiny.requireAll( unpack(filters) )
		new_system.process = processFunc
		local out_system = tiny.addSystem(self.current_world, new_system)
		self.current_world:update(0)

		local systeminfo = {
			name = systemname,
			filters = filters,
			index = out_system.index,
			active = out_system.active,
			modified = out_system.modified,
		}
		
		tinsert(self.systems, systeminfo)
		self.systems_lookup[systemname] = utils.tcount(self.systems)
	end
end

------------------------------------------------------------------------------------------------------------
-- Each world thats created we make a default proc to process for http server
worldmanager.addWorld = function(self, worldname)

	if(self.worlds_lookup[worldname]) then 
		print("[Error] World already exists: "..worldname)
		return nil
	else
		self.current_world = tiny.world()
		self.current_world.name = worldname
		-- Add an updater for entities in the httpserver
		self:addSystem( worldname.."Entities", { "name", "etype" }, tinysrv.entitySystemProc )

		tinsert(self.worlds, self.current_world)
		self.systems_lookup[worldname] = utils.tcount(self.worlds)
		return utils.tcount(self.worlds)
	end
end

------------------------------------------------------------------------------------------------------------

worldmanager.processOptions = function(self, options) 
	if(options) then 
		if(options.noserver == true) then 
			tinysrv.init = function() end 
			tinysrv.final = tinysrv.init
			tinysrv.update = tinysrv.init
		end
		if(options.host) then 
			tinysrv.host = options.host
		end
		if(options.port) then 
			tinysrv.port = options.port
		end
	end
end

------------------------------------------------------------------------------------------------------------

worldmanager.init = function(self, options)

	self:processOptions(options)
	tinysrv.init()
	tinysrv.setWorlds(self.worlds)
	tinysrv.setEntities(self.entities)
	tinysrv.setSystems(self.systems)
end

------------------------------------------------------------------------------------------------------------

worldmanager.final = function (self)

	tinysrv.final()
	tiny.clearEntities(self.current_world)
	tiny.clearSystems(self.current_world)
end

------------------------------------------------------------------------------------------------------------

worldmanager.update = function(self, dt)
	-- Handle direct world swapping
	tinysrv.current_world = self.current_world
	for k,v in pairs(self.worlds) do
		v:update(dt)
	end
	tinysrv.update(dt)
end

------------------------------------------------------------------------------------------------------------

worldmanager.default = worldmanager.default or worldmanager.addWorld(worldmanager, "DefaultWorld")

------------------------------------------------------------------------------------------------------------

return worldmanager

------------------------------------------------------------------------------------------------------------
