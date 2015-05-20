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

--Variables
local address_classes = {
	["10.0.0.0/8"] = true,
	["172.16.0.0/12"] = true,
	["192.168.0.0/16"] = true,
}

local cidrDecTbl = {getBinaryAddress("128.0.0.0"),getBinaryAddress("192.0.0.0"),getBinaryAddress("224.0.0.0"),getBinaryAddress("240.0.0.0"),getBinaryAddress("248.0.0.0"),getBinaryAddress("252.0.0.0"),getBinaryAddress("254.0.0.0"),getBinaryAddress("255.0.0.0"),getBinaryAddress("255.128.0.0"),getBinaryAddress("255.192.0.0"),getBinaryAddress("255.224.0.0"),getBinaryAddress("255.240.0.0"),getBinaryAddress("255.248.0.0"),getBinaryAddress("255.252.0.0"),getBinaryAddress("255.254.0.0"),getBinaryAddress("255.255.0.0"),getBinaryAddress("255.255.128.0"),getBinaryAddress("255.255.192.0"),getBinaryAddress("255.255.224.0"),getBinaryAddress("255.255.240.0"),getBinaryAddress("255.255.248.0"),getBinaryAddress("255.255.252.0"),getBinaryAddress("255.255.254.0"),getBinaryAddress("255.255.255.0"),getBinaryAddress("255.255.255.128"),getBinaryAddress("255.255.255.192"),getBinaryAddress("255.255.255.224"),getBinaryAddress("255.255.255.240"),getBinaryAddress("255.255.255.248"),getBinaryAddress("255.255.255.252"),getBinaryAddress("255.255.255.254"),getBinaryAddress("255.255.255.255")}

--Functions
function getNetworkAddress(address)
	if type(address) ~= "string" then error("Expected string, got "..type(address).."!",2) end
	local place = address:find("/")
	local binary = getBinaryAddress(address)
	local mask = tonumber(address:sub(place+1,-1))
	local network = binary:sub(1,mask)
	local machine = binary:sub(mask+1,-1)
	return network, machine, mask
end

function getBinaryAddress(address)
	if type(address) ~= "string" then error("Expected string, got "..type(address).."!",2) end
	local result = ""
	for token in addr:gmatch("[^%.]+") do
		result = result..string.rep("0",8-#tostring(Utils.DecToBase(tonumber(token),2)))..tostring(Utils.DecToBase(tonumber(token),2))
	end
	return result
end
--getNetworkAddress("10.0.0.0/8")

function getNetworkAddress2(addr)
  if not type(addr) = "string" then error("Expected string, got "..type(addr).."!",2) end
  local delim = addr:find("/")
  local binAddr = getBinaryAddress(addr:sub(1,-4))
  local binAddrOctect = {Utils.toDec(binAddr:sub(1,8),2),Utils.toDec(binAddr:sub(9,16),2),Utils.toDec(binAddr(17,24),2),Utils.toDec(binAddr(25,32),2)}
  local binMaskf = cidrDecTbl[addr:sub(-2,-1)]
  
end