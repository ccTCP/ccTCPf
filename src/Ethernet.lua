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
local sidesTable = {top = 1,bottom = 2,left = 3,right = 4,back = 5,front = 6}
local mac = {}
local stndFrame = {preamble = {100},type_len = {MTU = 1500,TTL = 255}}
local dotQFrame = {preamble = {200},type_len = {MTU = 1504,TTL = 255}}
local stndFrameTemp = {preamble = {100},type_len = {MTU = 1500,TTL = 255}}
local dotQFrameTemp = {preamble = {200},type_len = {MTU = 1504,TTL = 255}}
local MTU = stndFrame.type_len.MTU

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
  	elseif rtnType == "hex" then
    		return tostring(mac[side]:sub(1,4).."."..mac[side]:sub(5,8).."."..mac[side]:sub(9,12))
    elseif rtnType == "dec" then
       	return tostring(Utils.toDec(mac[side],16))
    end
end

function receive(bNotCheckDest)
	if not bNotCheckDest then
		while true do
			local frame, recvInt = Interface.receive()
			Utils.log("log",frame)
			Utils.debugPrint(frame)
			Utils.debugPrint(getMac(recvInt))
			local checksum = frame:sub(-5,-1)
			local destMac = frame:sub(1,12)
			local sourceMac = frame:sub(13,24)
			local payloadLen = string.len(frame:sub(25,-6))
			if destMac == getMac(recvInt) then
				Utils.log("log","Macs match")
				Utils.debugPrint("Macs match")
				if checksum == Utils.crc(frame:sub(1,-6)) then
					Utils.log("log","CRC matches")
					Utils.debugPrint("CRC matches")
					if payloadLen > MTU then
						return error("MTU exceeded. Payload: "..payloadLen.." > MTU: "..MTU,2)
					else
						return frame:sub(25,-6)
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
	if not sidesTable[int] then error("The interface does not exist!",2) end
	if vlan then
   		dotQFrame.dstMac = destination
   		dotQFrame.srcMac = getMac(int)
   		dotQFrame.vlan = vlan
   		dotQFrame.data = data
   		print(table.concat(dotQFrame))
   		Interface.send(dotQFrame,int)
   		dotQFrame = dotQFrameTemp
	else
		local msg = destination..getMac(int)..data..Utils.crc(destination..getMac(int)..data)
   		Interface.send(msg,int)
	end
end

function altSend(destination,data,int,option)
	--Frame structure: destination, sender, packetID, total#packets, the usual things
	if not sidesTable[int] then error("The interface does not exist!",2) end
	local numPackets = math.ceil(#data,MTU)
	local numBase256 = string.char(math.floor(numPackets/256))..string.char(((numPackets/256)-math.floor(numPackets/256))*256)
	for i=0,numPackets do
		local id = string.char(math.floor(i/256))..string.char(((i/256)-math.floor(i/256))*256)
		local msg = destination..getMac(int)..id..numBase256..data..Utils.crc(destination..getMac(int)..data)
		Interface.send(msg,int)
	end
end
