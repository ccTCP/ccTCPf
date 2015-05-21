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

function getBinaryAddress(addr)
	if type(addr) ~= "string" then error("Expected string, got "..type(addr).."!",2) end
	local result = ""
	for token in addr:gmatch("[^%.]+") do
		result = result..string.rep("0",8-#tostring(Utils.DecToBase(tonumber(token),2)))..tostring(Utils.DecToBase(tonumber(token),2))
	end
	return result
end

local cidrDecTbl = {"128.0.0.0","192.0.0.0","224.0.0.0","240.0.0.0","248.0.0.0","252.0.0.0","254.0.0.0","255.0.0.0","255.128.0.0","255.192.0.0","255.224.0.0","255.240.0.0","255.248.0.0","255.252.0.0","255.254.0.0","255.255.0.0","255.255.128.0","255.255.192.0","255.255.224.0","255.255.240.0","255.255.248.0","255.255.252.0","255.255.254.0","255.255.255.0","255.255.255.128","255.255.255.192","255.255.255.224","255.255.255.240","255.255.255.248","255.255.255.252","255.255.255.254","255.255.255.255"}

function getNetworkAddress2(addr)
  if not type(addr) == "string" then error("Expected string, got "..type(addr).."!",2) end
  local delim = addr:find("/")
  local binAddr = getBinaryAddress(addr:sub(1,-4)) --full binary addr eg. 192.168.1.1 = 1100000010100000000000100000001
  print(binAddr)
  local binAddrOctet = {binAddr:sub(1,8),binAddr:sub(9,16),binAddr:sub(17,24),binAddr:sub(25,32)} --binary addr segmented by octet
  print("\n"..binAddrOctet[1].."\n"..binAddrOctet[2].."\n"..binAddrOctet[3].."\n"..binAddrOctet[4])
  local binMask = getBinaryAddress(cidrDecTbl[tonumber(addr:sub(-2,-1))]) --gets the full binary value of the converted cidr mask eg. /24 = 255.255.255.0 = 11111111111111111111111100000000 **SOMEHOW WORKING BUT NOT RETURNING ANY VALUE????**
  print(binMask)
  local binMaskOctet = {binMask:sub(1,8),binMask:sub(9,16),binMask:sub(17,24),binMask:sub(25,32)} --binary mask segmented by octect
  print(binMaskOctet[1].." "..binMaskOctet[2].." "..binMaskOctet[3].." "..binMaskOctet[4])
end
