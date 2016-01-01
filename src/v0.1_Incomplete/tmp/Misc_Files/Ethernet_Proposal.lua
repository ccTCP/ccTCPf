local sidesTable = {top = 1,bottom = 2,left = 3,right = 4,back = 5,front = 6}
local sides = {"top","bottom","left","right","back","front"}
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


  local function check()
    local frame, int = Interface.receive()
    local fields = {"dstMac","srcMac","type_len","payload","fcs"}
    for a=1,5 do 
      if not frame.fields[a] then Utils.debugLog("log","Frame Dropped: Incomplete Frame, Missing field: "..fields[a]) end
    end
    local recvFCS = frame.fcs
    frame.fcs = nil
    if not recvFCS == Utils.crc(frame) then Utils.debugLog("log","Frame Dropped: Invalid FCS") else
      if not frame.dstMac == getMac[int] then
        for a=1,6 do
          if frame.dstMac == getMac[sides[a]] then
            local file = fs.open(config.dir..config.interComm,"a")
            file.writeLine(frame)
            file.close()
          end
          return nil
        end
      else
        return true, frame.payload
      end
    end
  end
  --Simple Recv
  while true do
    local checkPassed, data = check() 
    if checkPassed then 
      return true, data
    end
  end
  
  
end

function send(dst,etherType,data,vlan)
end


