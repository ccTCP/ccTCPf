--utils.lua

_G.cctcpfErr = {}
config = {modeDebug = false}

function split(str,Char)
	local Matches = {}
	local i = 1
	tostring(str)
	for token in str:gmatch("[^%"..Char.."]+") do
		Matches[i] = token
		i=i+1
	end
	return {true,Matches}
end

function err(val,func)
	if func then
		cctcpfErr = {val,func}
		return true
	else
		if not val then 
			err(0x050202)
			return false
		else
			cctcpfErr = {val,nil}
			return true
		end
	end
end

function log(path,txt)
	if not path or not txt then err(0x050001) return false end
	return true
end

function logDebug(path,txt)
	if not config.modeDebug then err(0x050401) return false end
	if not path or not txt then err(0x050001) return false end
	return true
end

function load()
end

function unload()
end

function write()
end

local prePullEventRaw = os.pullEventRaw
local Co = config.load()
local turn = 0
function os.pullEventRaw(sFilter)
  while true do
    local event = {pullEventRaw_Backup()}
	turn = turn+1
	coroutine.resume(Co[turn])
    if sFilter == event[1] or not sFilter then
      return unpack(event)
    end
  end
end

