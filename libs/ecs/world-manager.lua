------------------------------------------------------------------------------------------------------------

local tiny 		= require('libs.ecs.tiny-ecs')
local tinysrv	= require('libs.ecs.tiny-ecs-server')
local utils 	= require('utils.utils')

------------------------------------------------------------------------------------------------------------

local worldmanager = {
    systems = {},
    entities = {},
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
	if(obj.go) then self.entities[obj.go] = obj end
	local ent = tiny.addEntity(self.world, obj)
    return ent
end

------------------------------------------------------------------------------------------------------------

worldmanager.addGameObject = function( self, name, objurl )

	if(name == nil) then 
		print("[Error] Entity doesnt have a name.")
		return nil 
	end 
	local pos = go.get_position(objurl)
	local rot = go.get_rotation(objurl)

	local id = go.get_id(objurl)
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
	self.entities[objurl] = obj
	return tiny.addEntity(self.world, obj)
end

------------------------------------------------------------------------------------------------------------

worldmanager.removeEntity = function( self, eid )

	if(eid == nil) then 
		print("[Error] removeEntity: Entity eid is nil?")
		return nil 
	end 
	local ent = self.entities[eid]
	if(ent == nil) then 
		print("[Error] removeEntity: Entity not found?")
		return nil 
	end
	if(eid) then go.delete(eid, true) end
	local oldent = tiny.removeEntity (self.world, ent)
    return oldent
end

------------------------------------------------------------------------------------------------------------

worldmanager.addSystem = function( self, systemname, filters, processFunc )

	if(self.systems[systemname]) then 
		print("[Error] System already exists: "..systemname)
		return nil
	else
		local new_system = tiny.processingSystem()
		new_system.filter = tiny.requireAll( unpack(filters) )
		new_system.process = processFunc
		self.systems[systemname] = tiny.addSystem(self.world, new_system)
	end
end

------------------------------------------------------------------------------------------------------------

worldmanager.init = function(self)

	self.world = tiny.world()
	tinysrv:Begin()

	-- Add an updater for entities in the httpserver
	self:addSystem( "ECS_Entities", { "name", "etype" }, tinysrv.entitySystemProc )
end

------------------------------------------------------------------------------------------------------------

worldmanager.final = function (self)

	tinysrv:Finish()
	tiny.clearEntities (self.world)
	tiny.clearSystems (self.world)
end

------------------------------------------------------------------------------------------------------------

worldmanager.update = function(self, dt)
	self.world:update(dt)
	tinysrv:Update(dt)
end

------------------------------------------------------------------------------------------------------------

return worldmanager

------------------------------------------------------------------------------------------------------------
