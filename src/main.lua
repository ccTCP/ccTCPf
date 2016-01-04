--[[
	Script: ccTCP loader.
]]--

local ccTCPfPath = "ccTCPf/src/"

local dofile = function(path)
	local file = fs.open(ccTCPfPath..path,"r")
	local data = file.readAll()
	file.close()
	local func, err = loadstring(data)
end

local Internal = {}

local API = {} -- Outside interface.
