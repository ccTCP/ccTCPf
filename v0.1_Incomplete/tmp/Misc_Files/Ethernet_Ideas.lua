local sidesTable = {top = 1,bottom = 2,left = 3,right = 4,back = 5,front = 6}
local mac = {}
local Frame = {"00000000","000000","000000","00","","0000"}

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

function send(dst,interface,data,...)
  local option = (...)
  
  local options = {}
  options.etherType = {ethernet = 0x05DC, ip = 0x0800, arp = 0x0806, rarp = 0x8035, lldp = 0x88CC, dot1q = 0x8100}
  options.vlan = 0
  options.ttl = 255
  options.mtu = 1500
  options.srcMac = 0
  
  
  
  local frameCount = math.ceil(#data/options.mtu)
  local segment = {}
  
  if not sidesTable[interface] or Interface.intStatus == 0 or Interface.intStatus == nil then 
    if not option then
      for a=0, frameCount do
        b = a+1
        segment[b] = data:sub((options.mtu*a)+1,options.mtu*(a+1))
        local aFrame = {dstMac = dst, srcMac = getMac(int), type_len = options.etherType[ethernet], segment[b]}
        local bFrame = table.concat(aFrame)
        local bFrame[-1] = Utils.crc(bFrame)
        end
      end
    end
  end
end

function receive(...)
  local option = (...)
  
  local options = {}
  options.time = 0
  options.interface = {--[["interface" = recvTime]]}
  options.capture = {--[["interface" = captureTime]]}
  
  --Spawn coroutine to run receive loop
  
  if not sidesTable[interface] or Interface.intStatus == 0 or Interface.intStatus == nil then 
    if not option then
      --Capture handles from coroutine and perform data parsing / manipulation
      --Kill coroutine
      --Return
    end
  end
end

receive()