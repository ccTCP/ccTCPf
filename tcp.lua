--[[
	Main file
	License: like the other ones
	Creators: ccTCP -- get the irony
]]--

--Variables
local dir = "ccTCPf/src/"
local Ethernet = {}
local Event_Hook = {}
local Interface = {}
local Utils = {}

--Function

local function requireAPI(_sPath)
	local sName = fs.getName( _sPath )
	local tEnv = {}
	setmetatable( tEnv, { __index = _G } )
	local fnAPI, err = loadfile( _sPath )
	if fnAPI then
		setfenv( fnAPI, tEnv )
		local ok, err = pcall( fnAPI )
		if not ok then
			printError( err )
			return false
		end
	else
		printError( err )
		return false
	end
	
	local tAPI = {}
	for k,v in pairs( tEnv ) do
		tAPI[k] =  v
	end
	return tAPI	
end(_sPath)
	local sName = fs.getName( _sPath )
	local tEnv = {}
	setmetatable( tEnv, { __index = _G } )
	local fnAPI, err = loadfile( _sPath )
	if fnAPI then
		setfenv( fnAPI, tEnv )
		local ok, err = pcall( fnAPI )
		if not ok then
			printError( err )
			return false
		end
	else
		printError( err )
		return false
	end
	
	local tAPI = {}
	for k,v in pairs( tEnv ) do
		tAPI[k] =  v
	end
	return tAPI	
end

local function loadModules()

end