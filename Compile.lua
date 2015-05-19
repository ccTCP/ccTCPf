--[[
	ccTCPf compiler by Creator
]]--

--Variables
local files = fs.list("ccTCPf/src")
local t = {}
local ending = [[
function loadAPI(func)
	local tEnv = {}
	setmetatable( tEnv, { __index = _G } )
    setfenv(func, tEnv )
    local ok, err = pcall(func)
    if not ok then
        printError( err )
        return false
    end
    printError( err )
    return false

    local tAPI = {}
    for k,v in pairs( tEnv ) do
        tAPI[k] =  v
    end

    return tAPI
end


for i,v in pairs(t) do

end]]


--Functions
local function createFile(path)
	local file = fs.open(path,"r")
	local data = file.readAll()
	file.close()
	local name = string.match(fs.getName(path),"[^%.]+")
	print(name)
	local header = "function "..name.."()"
	local footer = "end"
	local endResult = header.."\n"..data.."\n"..footer
	return endResult
end

for i,v in pairs(files) do
	t[v] = createFile("ccTCPf/src/"..v)
end

local file = fs.open("well","w")
file.write("t = "..textutils.serialize(t).."\n")
file.close()