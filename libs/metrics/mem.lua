local M = {}

function M.create()
	local instance = {}

	local mem = collectgarbage("count")

	function instance.update()
		mem = collectgarbage("count")
	end

	function instance.mem()
		return mem
	end
	
	return instance
end

local singleton = M.create()

function M.update()
	singleton.update()
end

function M.mem()
	return singleton.mem()
end

return M