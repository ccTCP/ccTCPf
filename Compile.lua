--[[
	ccTCPf compiler by Creator
]]--

--Variables
local files = fs.list("ccTCPf/src")
local t = {}
local ending = [[
function loadAPI(func)
	if type(func) ~= "function" then error("Expected function, got "..type(func).."!",2) end
	local tEnv = {}
	setmetatable( tEnv, { __index = _G } )
    setfenv(func,tEnv)
    pcall(func)
    local tAPI = {}
    for k,v in pairs( tEnv ) do
        tAPI[k] =  v
    end

    return tAPI
end


for i,v in pairs(t) do
	local funct = loadstring(v)
	setfenv(funct,getfenv())
	print(i)
	_G[i] = loadAPI(funct)
end]]


--Functions
local function createFile(path)
	local file = fs.open(path,"r")
	local data = file.readAll()
	file.close()
	local name = string.match(fs.getName(path),"[^%.]+")
	print(name)
	return data
end

for i,v in pairs(files) do
	t[string.match(v,"[^%.]+")] = createFile("ccTCPf/src/"..v)
end

local file = fs.open("well.lua","w")
file.write("t = "..textutils.serialize(t).."\n\n"..ending)
file.close()