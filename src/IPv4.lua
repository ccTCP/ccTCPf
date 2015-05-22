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

function getBinaryAddress(addr)
	if type(addr) ~= "string" then error("Expected string, got "..type(addr).."!",2) end
	local result = ""
	for token in addr:gmatch("[^%.]+") do
		result = result..string.rep("0",8-#tostring(Utils.DecToBase(tonumber(token),2)))..tostring(Utils.DecToBase(tonumber(token),2))
	end
	return result
end

local cidrDecTbl = {"128.0.0.0","192.0.0.0","224.0.0.0","240.0.0.0","248.0.0.0","252.0.0.0","254.0.0.0","255.0.0.0","255.128.0.0","255.192.0.0","255.224.0.0","255.240.0.0","255.248.0.0","255.252.0.0","255.254.0.0","255.255.0.0","255.255.128.0","255.255.192.0","255.255.224.0","255.255.240.0","255.255.248.0","255.255.252.0","255.255.254.0","255.255.255.0","255.255.255.128","255.255.255.192","255.255.255.224","255.255.255.240","255.255.255.248","255.255.255.252","255.255.255.254","255.255.255.255"}

function getNetworkAddress(address)
  if not type(address) == "string" then error("Expected string, got "..type(addr).."!",2) end
  --split address from cidr
  local a = 1
  local split = {}
  for token in address:gmatch("[^%/]+") do --finds values not equal to "/" which will be the address before "/" and the cidr mask after "/"
    split[a] = token
    a=a+1
  end
  local addr = split[1]
  local cidr = split[2]
  local binAddr = getBinaryAddress(addr)
  local binAddrOctet = {binAddr:sub(1,8),binAddr:sub(9,16),binAddr:sub(17,24),binAddr:sub(25,32)}
  local mask = cidrDecTbl[tonumber(cidr)]
  local binMask = getBinaryAddress(mask)
  local binMaskOctet = {binMask:sub(1,8),binMask:sub(9,16),binMask:sub(17,24),binMask:sub(25,32)}
  local netAddr = ""
  local netAddrOctet = {"","","",""}
  local b = 1
  local c = 1
  repeat
    repeat
      if(binMaskOctet[b]:sub(c,c) == "1" and binAddrOctet[b]:sub(c,c) == "1") then 
        netAddr = netAddr.. "1"
        netAddrOctet[b] = netAddrOctet[b].. "1"
        c=c+1
      else
        netAddr = netAddr.. "0"
        netAddrOctet[b] = netAddrOctet[b].. "0"
        c=c+1
      end
    until c == 9
    b=b+1
    c=1
  until b == 5
  print(Utils.toDec(netAddrOctet[1],2).."."..Utils.toDec(netAddrOctet[2],2).."."..Utils.toDec(netAddrOctet[3],2).."."..Utils.toDec(netAddrOctet[4],2))
end

function getAddressInfo(address)
  if not type(address) == "string" then error("Expected string, got "..type(addr).."!",2) end
  --split address from cidr
  local i = 1
  local split = {}
  for token in address:gmatch("[^%/]+") do --finds values not equal to "/" which will be the address before "/" and the cidr mask after "/"
    split[i] = token
    i=i+1
  end
  local addr = split[1]
  local cidr = split[2]
  local binAddr = getBinaryAddress(addr)
  local binAddrOctet = {binAddr:sub(1,8),binAddr:sub(9,16),binAddr:sub(17,24),binAddr:sub(25,32)}
  local mask = cidrDecTbl[tonumber(cidr)]
  local binMask = getBinaryAddress(mask)
  local binMaskOctet = {binMask:sub(1,8),binMask:sub(9,16),binMask:sub(17,24),binMask:sub(25,32)}
  print("input: "..address.."\n")
  print("address: "..addr)
  print(binAddr)
  print(binAddrOctet[1].."\n"..binAddrOctet[2].."\n"..binAddrOctet[3].."\n"..binAddrOctet[4].."\n")
  print("CIDR Mask: "..cidr)
  print("Decimal Mask: "..mask)
  print(binMask)
  print(binMaskOctet[1].."\n"..binMaskOctet[2].."\n"..binMaskOctet[3].."\n"..binMaskOctet[4].."\n")
end