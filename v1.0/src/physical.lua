--physical.lua

side = {"top","bottom","left","right","front","back"}
sideNum = {top = 1,bottom = 2,left = 3,right = 4,front = 5,back = 6}
DOWN = 0
UP = 1
local channel = 1721
local recvBuffer = {}
interface = {}
Attrib = {}


function detectInt()
	for a = 1,6 do
		if peripheral.isPresent(side[a]) then
			if peripheral.getType(side[a]) == "wireless_modem" or peripheral.getType(side[a]) == "modem" then
				interface[side[a]] = peripheral.wrap(side[a])
				Attrib[side[a]] = {}
        interface[side[a]].close(channel)
		Attrib[side[a]].Status = DOWN
			end
		end
		a = a+1
	end
	return true
end

function typeInt(t,int)
	if not interface[int] then utils.err(0x010001,"physical.typeInt()") return false end
	if not t == "WAN" or t == "WWAN" then utils.err() return false end
end

function protocolInt(proto,int)
	if not interface[int] then utils.err(0x01001,"physical.protocolInt()") return false end
end

function noShut(int)
	if not interface[int] then utils.err(0x01001,"physical.noShut()") return false end
	interface[int].open(channel)
    Attrib[int].Status = UP
	utils.log("log","%LINK-UPDOWN: Interface\""..int.."\" changed state to up")
	return true
end

function shut(int)
	if not interface[int] then utils.err(0x01001,"physical.shut()") return false end
	interface[int].close(channel)
    Attrib[int].Status = DOWN
	utils.log("log","%LINK-UPDOWN: Interface\""..int.."\" changed state to down")
	return true
end

function Transmit(data,int)
	return true
end

--Run
detectInt()