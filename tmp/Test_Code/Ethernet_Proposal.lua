local sidesTable = {top = 1,bottom = 2,left = 3,right = 4,back = 5,front = 6}
local mac = {}
local stndFrame = {preamble = {100},type_len = {MTU = 1500,TTL = 255}}
local dotQFrame = {preamble = {200},type_len = {MTU = 1504,TTL = 255}}

function createMac(side)
  if not side then error("No side given",2) end
  side = tostring(side)
  if sidesTable[side] then 
    local macBuffer = tostring(Utils.DecToBase(os.computerID() * 6 + sidesTable[side],16))
    local MACaddr = string.rep("0",12-#macBuffer).. macBuffer
    mac[side] = MACaddr
    return MACaddr
  end
end

function getMac(side,rtnType)
  if not side then error("No side given",2) end
	if not mac[side] then
		mac[side] = createMac(side)
	end
  	if not rtnType then
    	return mac[side]
  	elseif rtnType == ".hex" then
    		return tostring(mac[side]:sub(1,4).."."..mac[side]:sub(5,8).."."..mac[side]:sub(9,12))
    elseif rtnType == "dec" then
       	return tostring(Utils.toDec(mac[side],16))
    end
end

function send(dst,interface,data,option,...)
  local optionArg = (...)
  
  local options = {}
  options.vlan = 0
  options.ttl = 0
  options.mtu = 0
  
  if not sidesTable[interface] or Interface.intStatus == 0 or Interface.intStatus == nil then 
    if not option then
      local frameBuffer = stndFrame
      frameBuffer.dstMac = dst
      frameBuffer.srcMac = getMac(interface)
      frameBuffer.payload = data
      local crc = table.concat(frameBuffer)
      frameBuffer.fcs = crc
      local frame = table.concat(frameBuffer)
      Interface.send(frame,interface)
    end
  end
end

function receive(option,...)
  local optionArg = (...)
  
  local options = {}
  options.time = 0
  options.interface = {--[["interface" = recvTime]]}
  options.capture = {--[["interface" = captureTime]]}
  
  if not sidesTable[interface] or Interface.intStatus == 0 or Interface.intStatus == nil then 
    if not option then
      
    end
  end
end

receive()