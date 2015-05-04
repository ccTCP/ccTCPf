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

--The checksum is 5 chars long in hex
--utils = require('Utils')

--Init Variables
local mac = {}

--L2:Functions

function createMac(side)
	side = tostring(side)
	local sideTable = {top = 0,bottom = 1,left = 2,right = 3,back = 4,front = 5}
	if side and sideTable[side] then
		local macBuffer = tostring(Utils.toHex(os.computerID() * 6 + sideTable[side]))
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

function getMacString(side)
	return Utils.toDec(getMac(side))
end

function receive()
	local msg = Layer1.receive()
	print(msg)
end

--End: L2:Functions]]

--Post Init Variables
frame = {preamble,dstMac,srcMac,packet or data,fcs}
dotQFrame = {preamble,dstMac,srcMac,vlan,packet or data,fcs}

--Active / Test Code
--End: L2:Active / Test Code]]
