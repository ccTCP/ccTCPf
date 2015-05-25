--[[License

The MIT License (MIT)

Copyright (c) 2015 ccTCP Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

--]]

--Ethernet
--Variables
local sidesTable = {top = 0,bottom = 1,left = 2,right = 3,back = 4,front = 5}
local mac = {}
local stndFrame = {preamble = {100},type_len = {MTU = 1500,TTL = 255}}
local dotQFrame = {preamble = {200},type_len = {MTU = 1504,TTL = 255}}
local stndFrameTemp = {preamble = {100},type_len = {MTU = 1500,TTL = 255}}
local dotQFrameTemp = {preamble = {200},type_len = {MTU = 1504,TTL = 255}}

--Functions
function createMac(side)
	if not side then error("You have to specify a side",2) end
	side = tostring(side)
	if sidesTable[side] then
		local macBuffer = tostring(Utils.DecToBase(os.computerID() * 6 + sidesTable[side],16))
		return string.rep("0",12-#macBuffer).. macBuffer
	end
end

function getMac(side,rtnType)
 	if not side then error("You have to specify a side",2) end
	if not mac[side] then
		mac[side] = createMac(side)
	end
  if not rtnType then
    return mac[side]
  else
    if rtnType == "hex" then 
      return tostring(mac[side]:sub(1,4).."."..mac[side]:sub(5,8).."."..mac[side]:sub(9,12))
    else
      if rtnType == "dec" then
        return tostring(Utils.toDec(mac[side],16))
      end
    end
  end
end

function receive(bNotCheckDest)
	if not bNotCheckDest then
		while true do
			local frame, recvInt = Interface.receive()
			local checksum = frame:sub(-5,-1)
			local destMac = frame:sub(1,6)
			local sourceMac = frame:sub(7,12)
			local payloadLen = string.len(frame:sub(13,-6))
			if destMac == getMac(recvInt) then
				if checksum == Utils.crc(frame:sub(1,-6)) then
					if payloadLen > MTU then
						return error("MTU exceeded. Payload: "..payloadLen.." > MTU: "..MTU,2)
					else
						return frame:sub(13,-6)
					end
				else
					print("Frame invalid")
					--ask for the message to be resent
					--ask for message identifier
				end
			end
		end
	else
		while true do
			local frame, recvInt = Interface.receive()
			local checksum = frame:sub(-5,-1)
			local destMac = frame:sub(1,6)
			local sourceMac = frame:sub(7,12)
			local payloadLen = string.len(frame:sub(13,-6))
			if checksum == Utils.crc(frame:sub(1,-6)) then
				if payloadLen > MTU then
					return error("MTU exceeded. Payload: "..payloadLen.." > MTU: "..MTU,2)
				else
					return frame:sub(13,-6)
				end
			else
				print("Frame invalid")
				--ask for the message to be resent
				--ask for message identifier
			end
		end
	end
end

function typeRecevie()
  local frame, recvInt = Interface.receive()
  
end


function send(destination,data,int,option,vlan)
  if vlan then
    dotQFrame.dstMac = destination
    dotQFrame.srcMac = getMac(int)
    dotQFrame.vlan = vlan
    dotQFrame.data = data
    Interface.send(dotQFrame,int)
    dotQFrame = dotQFrameTemp
  else
    stndFrame.dstMac = destination
    stndFrame.srcMac = getMac(int)
    stndFrame.data = data
    Interface.send(stndFrame,int)
    stndFrame = stndFrameTemp
  end
end