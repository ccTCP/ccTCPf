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
--[[REQUIRES
::Utils::

]]--
--[[SPECIFICATIONS
::The checksum is 5 chars long in hex

]]--

--Variables
local mac = {}

--Functions
function createMac(side)
	side = tostring(side)
	if (side and sidesTable[side]) then
		local macBuffer = tostring(utils.toHex(os.computerID() * 6 + sidesTable[side]))
		return string.rep("0",6-#macBuffer).. macBuffer
	end
	return error("Failed: "..side.."is not a side", 2)
end

function getMac(side)
	if not mac[side] then
		mac[side] = createMac(side)
	end
	return mac[side]
end

function getMacDec(side)
	return utils.toDec(getMac(side))
end

--Moved bind to tmp/Ethernet.lua

function receive()
	local msg, identifier = Layer1.receive()
	print(msg)
	local checksum = msg:sub(-5,-1)
	if checksum == Utils.fcs(msg:sub(1,-6)) then
		print("yay")
	else
		--ask for message identifier
	end
end
--End: L2:Functions]]

--Post Init Variables
frame = {preamble,dstMac,srcMac,packet or data,fcs()}
dotQFrame = {preamble,dstMac,srcMac,vlan,packet or data,fcs()}

--Active / Test Code
macBind()
--End: L2:Active / Test Code]]

