local sidesTable = {top = 1,bottom = 2,left = 3,right = 4,back = 5,front = 6}
local Bind = {--[[    "interface" = localAddr                  ]]}
local CAM = {--[[    "interface" = {remote device(s) addr}    ]]}
local Frame = {}

function createMac(side)
  if not side then error("No side given",2) end
  side = tostring(side)
  if sidesTable[side] then 
    local macBuffer = tostring(Utils.DecToBase(os.computerID() * 6 + sidesTable[side],16))
    local MACaddr = string.rep("0",12-#macBuffer).. macBuffer
    Bind[side] = MACaddr
    return MACaddr
  end
end

function getMac(side,rtnType)
  if not side then error("No side given",2) end
	if not Bind[side] then
		createMac(side)
	end
  	if not rtnType then
    	return Bind[side]
  	elseif rtnType == ".hex" then
    		return tostring(Bind[side]:sub(1,4).."."..Bind[side]:sub(5,8).."."..Bind[side]:sub(9,12))
    elseif rtnType == "dec" then
       	return tostring(Utils.toDec(Bind[side],16))
    end
end

function receive()
  local frame, int = Interface.receive()
  frame = textutils.unserialize(frame)
  
  
  
end

function send()
  
end

--[[
function t()
return {one = 1,two = 2}, "three"
end
frame, int = t()
print(frame.one)

------------------

function send()
  local frame = {dst = 0, src =  1}
  Interface.send(textutils.serialize(frame),int)
end

function recv()
  while true do
    local e = {os.pullEvent()}
    if e and e[2] == "modem_message" and e[6] then
      local frame = textutils.unserialize(e[6])
      --do my stuff from here
    end
  end
end

--]]


