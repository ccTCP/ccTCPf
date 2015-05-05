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

function macBind(...)
--[[
	No Args: generates a mac for each interface found, sets a default-interface, and writes the bindings to macBindings
	One Arg: Will generate a mac for the interface given, and write the data to macBindings file.
	Two Arg: Will assign the given interface with the given mac address. This data will be recorded in macBindings.
]]
	
	local bindArgs = {...}
	
	local function isFile()
		if (not fs.isDir("ccTCP")) then
			fs.makeDir("ccTCP")
		end
		if (not fs.exists("ccTCP/macBindings")) then
			local file = fs.open("ccTCP/macBindings", "w")
			file.close()
			return false
		else
			return true
		end
	end
	
	local function macFile(mode,int,addr)
		if (mode = "w" and int == nil) then
			local num = 1
			local genAddr = createMac(sides[num])
			local file = fs.open("ccTCP/macBindings", "w")
			repeat
				file.writeLine(sides[num].." = "..genAddr)
				num = num+1
			until num = 5
			file.close()
			fixMac()
		else
			if (mode = "w" and not int == nil) then 
				local file = fs.open("ccTCP/macBindings", "w")
				file.writeLine(int,addr)
				file.close()
				fixMac()
			else
				if (mode = "a") then
					local file = fs.open("ccTCP/macBindings", "a")
					file.writeLine(int,addr)
					file.close()
					fixMac()
				end
			end
		end
	end
	
	local function fixMac()
		local file = fs.open("ccTCP/macBindings", "r")
		mac = nil
		local num = 1
		repeat
			mac[num] = file.readLine()
			num = num+1
		until line[1] == nil
	end
	
	--Running Code
	if (bindArgs[1] == nil and bindArgs[2] == nil) then
		if (isFile() == false) then
			wrap()
			macFile("w")
		end
	else 
		if (peripheral.isPresent(bindArgs[1]) and bindArgs[2] == nil) then
			local bind = createMac(bindArgs[1])
			if (isFile() == false) then
				macFile("w",bindArgs[1],bind)
			else
				macFile("a",bindArgs[1],bind)
			end
		else
			if () then ---NEED HELP HERE
				isFile()
				macFile("a",bindArgs[1],bindArgs[2])
				return "Interface on: "..bindArgs[1].."given MAC "..bindArgs[2]
			else
			
			end
		end
		return
	end
	return error("Failed: something went wrong",2)
	--End: Running Code
end
--End: L2:Functions]]

--Post Init Variables
frame = {preamble,dstMac,srcMac,packet or data,fcs}
dotQFrame = {preamble,dstMac,srcMac,vlan,packet or data,fcs}

--Active / Test Code
macBind()
--End: L2:Active / Test Code]]

