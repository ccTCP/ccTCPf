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

--Functions
function createMac(side)
	if not side then error("No side specified",2) end
	side = tostring(side)
	if sidesTable[side] then
		local macBuffer = tostring(Utils.DecToBase(os.computerID() * 6 + sidesTable[side],16))
    local MACaddr = string.rep("0",12-#macBuffer).. macBuffer
    mac[side] = MACaddr
		return MACaddr
	end
end

function getMac(side,rtnType)
 	if not side then error("No side specified",2) end
	if not mac[side] then
		mac[side] = createMac(side)
	end
  	if not rtnType then
    	return mac[side]
  	elseif rtnType == "dotHex" then
    		return tostring(mac[side]:sub(1,4).."."..mac[side]:sub(5,8).."."..mac[side]:sub(9,12))
    elseif rtnType == "dec" then
       	return tostring(Utils.toDec(mac[side],16))
    end
end

function send()

end

function receive()
  if not Interface.msgBuffer then return error("No messages in buffer",2)
  local r = Interface.msgBuffer[1]
  local frame = r[1]
  local interface = r[2]
  
  table.remove(Interface.msgBuffer,1)
  return 
end