--[[
	ccTCPf compiler by Creator
]]--

--Variables
local files = fs.list("src")
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

if fs.exists("ccTCP/") then 
  fs.delete("ccTCPf/")
else 
  if fs.exists("ccTCPf/") then
    fs.delete("ccTCPf/")
  end
end

t["Utils"] = createFile("src/Utils.lua")

for i,v in pairs(files) do
	if v ~= "Utils.lua" then
		t[string.match(v,"[^%.]+")] = createFile("src/"..v)
	end
end

local file = fs.open("mount.lua","w")
file.write("t = "..textutils.serialize(t).."\n\n"..ending)
file.close()