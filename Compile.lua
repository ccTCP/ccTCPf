--[[
	ccTCPf compiler by Creator
]]--

--Variables
local files = fs.list("ccTCPf/src")
local t = {}


--Functions
local function createFile(path)
	local file = fs.open(path)
	local data = file.readAll()
	file.close()
	local name = fs.getName(path)
	local header = "function "..name.."()"
	local footer = "end"
	local endResult = header.."\n"..data.."\n"..footer
	return func = endResult
end

for i,v in pairs(files) do
	t[v] = createFile("ccTCPf/src".."/"..v)
end

local file = fs.open("well","w")
file.write(textutils.serialize(t))
file.close()