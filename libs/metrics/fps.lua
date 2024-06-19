local tinsert = table.insert
local tremove = table.remove

local M = {}

function M.create(samples)
	samples = samples or 60
	
	local instance = {}

	local frames = {}
	local deltas = {}

	local fps = 0

	function instance.update( dt )
		tinsert(frames, socket.gettime())
		tinsert(deltas, dt)
		if #frames == samples + 1 then
			tremove(frames, 1)
			tremove(deltas, 1)
			fps = 1 / ((frames[#frames] - frames[1]) / (#frames - 1))
		end
	end

	function instance.fps()
		return fps
	end

	function instance.frames()
		return frames
	end
	
	function instance.deltas()
		return deltas
	end
		
	return instance
end

local singleton = M.create()

function M.update( dt )
	singleton.update( dt )
end

function M.fps()
	return singleton.fps()
end

function M.frames()
	return singleton.frames()
end

function M.deltas()
	return singleton.deltas()
end


return M