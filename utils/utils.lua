local tinsert 	= table.insert
local tremove 	= table.remove
local tcount 	= table.getn
local bit 		= require("bit")

-- ---------------------------------------------------------------------------

local struct    = require("utils.struct")
local tween 	= require("utils.tween")

-- ---------------------------------------------------------------------------

local function genname()
	m,c = math.random,("").char 
	name = ((" "):rep(9):gsub(".",function()return c(("aeiouy"):byte(m(1,6)))end):gsub(".-",function()return c(m(97,122))end))
	return(string.sub(name, 1, math.random(4) + 5))
end

-- ---------------------------------------------------------------------------

local function tcount(tbl)
	local cnt = 0
	if(tbl == nil) then return cnt end
	for k,v in pairs(tbl) do 
		cnt = cnt + 1
	end 
	return cnt
end 

-- ---------------------------------------------------------------------------

local function uinttocolor( ucolor )

	return {
		bit.band(ucolor, 0xff) / 255.0,
		bit.band(bit.rshift(ucolor, 8), 0xff) / 255.0,
		bit.band(bit.rshift(ucolor, 16), 0xff) / 255.0,
		bit.band(bit.rshift(ucolor, 24), 0xff) / 255.0,
	}
end

-- -----------------------------------------------------------------------

local function processPngHeader(header)
	local pnginfo = {}
	local filesig = header:sub(1, 8)
	if (filesig == string.format("%c%c%c%c%c%c%c%c", 0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a)) then
		local tmp = struct.unpack("<L", header, 9)-- we dont care about length and chunktype (iHDR is always first)
		pnginfo.width = struct.unpack(">I", header, 17)
		pnginfo.height = struct.unpack(">I", header, 21)
		pnginfo.depth = struct.unpack(">B", header, 25)
		pnginfo.type = struct.unpack(">B", header, 26)
		pnginfo.comp = struct.unpack(">B", header, 27)
		pnginfo.filter = struct.unpack(">B", header, 28)
		pnginfo.interlace = struct.unpack(">B", header, 29)
		return pnginfo
	end
	return nil
end

-- -----------------------------------------------------------------------
-- PNG header loader
local function getpngfile(filenamepath)
    -- Try to open first - return nil if unsuccessful
    local fh = io.open(filenamepath, 'rb')
    if (fh == nil) then
        print("[Error] png file not found: " .. filenamepath)
        return nil
    end
	local header = fh:read(8 + 8 + 4 + 4 + 1 + 1 + 1 + 1 + 1)
	fh:close()
	local pnginfo = processPngHeader(header)
	if (pnginfo) then return pnginfo end

    print("[Error] Png header unreadable: " .. filenamepath)
    return nil
end

-- ---------------------------------------------------------------------------

function tmerge(t1, t2)
	if(t1 == nil) then t1 = {} end 
	if(t2 == nil) then return t1 end 
	
	for k, v in pairs(t2) do
		if (type(v) == "table") and (type(t1[k] or false) == "table") then
			tmerge(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

-- ---------------------------------------------------------------------------

local function tablejson( list )

	local p = "{"
	local i = 1
	for k,v in pairs(list) do 
		if(i ~= 1) then p = p.."," end

		if(type(v) == "table") then 
			p = p.."\""..k.."\":\""..tablejson(v)
		elseif(type(v) == "number") then 
			p = p.."\""..k.."\":"..v
		else
			p = p.."\""..k.."\":\""..v.."\""
		end
		i = i + 1
	end
	p = p.." }"

	return p
end

-- ---------------------------------------------------------------------------
-- Deep Copy
-- This is good for instantiating tables/objects without too much effort :)

function deepcopy(t)
	if type(t) ~= 'table' then return t end
	local mt = getmetatable(t)
	local res = {}
	for k,v in pairs(t) do
		if type(v) == 'table' then
		v = deepcopy(v)
		end
		res[k] = v
	end
	setmetatable(res,mt)
	return res
end

-- ---------------------------------------------------------------------------

local function loaddata(filepath)
	local data = nil
	local fh = io.open(filepath, "rb")
	if(fh) then 
		data = fh:read("*a")
		fh:close()
	else 
		print("[Error] utils.loaddata: Unable to load - "..filepath)
	end
	return data 
end

-- ---------------------------------------------------------------------------

local function tickround(self, dt, callback)

	if(self.round == nil) then return end 
	
	self.round.timeout = self.round.timeout - dt
	-- Selection done
	if(self.round.timeout < 0.0) then 
		self.round.timeout = 0.0
		callback()
	end
end 

------------------------------------------------------------------------------------------------------------
-- Remove quotes from string start and end
local function cleanstring(str)
	if(str == nil) then return str end
	if(string.sub(str, 1, 1) == "'") then 
		str = string.sub(str, 2, -1)
	end 
	if(string.sub(str, -1) == "'") then 
		str = string.sub(str, 1, -2)
	end 
	str = string.gsub(str, "%%20", " " ) 
	
	-- str = string.gsub(str, "'", "")
	-- str = string.gsub(str, '"', "")
	return str
end

------------------------------------------------------------------------------------------------------------

local function csplit(str,sep)
	local ret={}
	local n=1
	for w in str:gmatch("([^"..sep.."]*)") do
		-- only set once (so the blank after a string is ignored)
		if w=="" then
			n = n + 1
		else 
			ret[n] = ret[n] or w
		end -- step forwards on a blank but not a string
	end
	return ret
end

------------------------------------------------------------------------------------------------------------

local function windows_dir( folder )
	local result = nil
	local f = io.popen("dir /AD /b \""..tostring(folder).."\"")
	if f then
		result = f:read("*a")
	else
		print("[Error] failed to read - "..tostring(folder))
	end
	return result
end

------------------------------------------------------------------------------------------------------------

local function unix_dir( folder )
	local result = nil
	local f = io.popen("ls -d -A -G -N -1 * \""..tostring(folder).."\"")
	if f then
		result = f:read("*a")
	else
		print("[Error] failed to read - "..tostring(folder))
	end
	return result
end

------------------------------------------------------------------------------------------------------------

local function getdirs( folder )
	local info = sys.get_sys_info()
	local dirstr = ""
	if info.system_name == "HTML5" then

	elseif info.system_name == "Windows" then
		dirstr = windows_dir(folder)
	else
		dirstr = unix_dir(folder)
	end

	-- split string by line endings into a nice table
	local restbl = nil
	if(dirstr) then 
		restbl = csplit(dirstr, "\n")
	end

	return restbl
end

-- ---------------------------------------------------------------------------

local function ByteCRC(sum, data)
    sum = bit.bxor(sum, data)
    for i = 0, 7 do     -- lua for loop includes upper bound, so 7, not 8
        if (bit.band(sum, 1) == 0) then
            sum = bit.rshift(sum , 1)
        else
            sum = bit.bxor(bit.rshift(sum , 1), 0xA001)  -- it is integer, no need for string func
        end
    end
    return sum
end

-- ---------------------------------------------------------------------------

local function CRC(data, length)
    local sum = 65535
    local d
    for i = 1, length do
        d = string.byte(data, i)    -- get i-th element, like data[i] in C
        sum = ByteCRC(sum, d)
    end
    return sum
end

-- ---------------------------------------------------------------------------
return {

	getdirs 		= getdirs,
	csplit			= csplit,
	cleanstring		= cleanstring,

	uinttocolor 	= uinttocolor,
	getpngfile		= getpngfile,
	getpngheader	= processPngHeader,

	crc 			= CRC,
	
	genname 		= genname,
	tcount 			= tcount,
	tmerge			= tmerge,
	tablejson		= tablejson,

	deepcopy		= deepcopy,

	isjudge			= isjudge,
	getpeoplecount	= getpeoplecount,
	getpeopletext	= getpeopletext,
	getscenariotext = getscenariotext,
	gettimetext		= gettimetext,
	getjudgetext	= getjudgetext,

	tickround		= tickround,

	loaddata		= loaddata,
	saveconfig 		= saveconfig,
	loadconfig 		= loadconfig,
}
-- ---------------------------------------------------------------------------
