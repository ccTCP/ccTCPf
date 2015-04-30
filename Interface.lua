-- Interface


int = {}

function int.createMac(side)
	sideNum = {top = 0,bottom = 1,left = 2,right = 3,back = 4}
	local mac = os.computerID() * math.random(1,200) + sideNum[side]
	return mac
end

function int.getMac(side)
end

function int.getMacString(side)
end

function int.setMac(side, newMac)
end
