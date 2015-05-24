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
  local binNetAddr = ""
  local binNetAddrOctet = {"","","",""}
  local b = 1
  local c = 1
  repeat
    repeat
      if(binMaskOctet[b]:sub(c,c) == "1" and binAddrOctet[b]:sub(c,c) == "1") then 
        binNetAddr = binNetAddr.. "1"
        binNetAddrOctet[b] = binNetAddrOctet[b].. "1"
        c=c+1
      else
        binNetAddr = binNetAddr.. "0"
        binNetAddrOctet[b] = binNetAddrOctet[b].. "0"
        c=c+1
      end
    until c == 9
    b=b+1
    c=1
  until b == 5
  print(Utils.toDec(binNetAddrOctet[1],2).."."..Utils.toDec(binNetAddrOctet[2],2).."."..Utils.toDec(binNetAddrOctet[3],2).."."..Utils.toDec(binNetAddrOctet[4],2))
end

function getAddressInfo(address,rtnAddr)
  if not type(address) == "string" then error("Expected string, got "..type(addr).."!",2) end
  --split address from cidr mask
  local i = 1
  split = {}
  for token in address:gmatch("[^%/]+") do
    split[i] = token
    i=i+1
  end
  
  --init vars
  local vars = {}
    vars.addr = split[1]
    vars.cidr = split[2]
  
    vars.binAddr = getBinaryAddress(vars.addr)
    vars.binAddrOctet = {vars.binAddr:sub(1,8),vars.binAddr:sub(9,16),vars.binAddr:sub(17,24),vars.binAddr:sub(25,32)}
  
    vars.mask = cidrDecTbl[tonumber(vars.cidr)]
    vars.binMask = getBinaryAddress(vars.mask)
    vars.binMaskOctet = {vars.binMask:sub(1,8),vars.binMask:sub(9,16),vars.binMask:sub(17,24),vars.binMask:sub(25,32)}
    vars.wildMask = ""
  
    vars.binNetAddr = ""
    vars.binNetAddrOctet = {"","","",""}
    vars.netAddr = ""
    vars.binBcastAddr = ""
    vars.binBcastAddrOctet = {"","","",""}
    vars.bcastAddr = ""
    vars.netLen = ""
    vars.numHosts = ""
    vars.hostAddr = {}
    
  --Calculate Addresses: network,broadcast and then derive: networkLenght,NumberofHosts,HostsAddressTbl, in the binary, binary_in_table and dotted decimal forms.
  local b = 1
  local c = 1
  repeat
    repeat
      if(vars.binMaskOctet[b]:sub(c,c) == "1" and vars.binAddrOctet[b]:sub(c,c) == "1") then 
        vars.binNetAddr = vars.binNetAddr.. "1"
        vars.binNetAddrOctet[b] = vars.binNetAddrOctet[b].. "1"
        c=c+1
      else
        vars.binNetAddr = vars.binNetAddr.. "0"
        vars.binNetAddrOctet[b] = vars.binNetAddrOctet[b].. "0"
        c=c+1
      end
    until c == 9
    b=b+1
    c=1
  until b == 5
  vars.netAddr = Utils.toDec(tonumber(vars.binNetAddrOctet[1]),2).."."..Utils.toDec(tonumber(vars.binNetAddrOctet[2]),2).."."..Utils.toDec(tonumber(vars.binNetAddrOctet[3]),2).."."..Utils.toDec(tonumber(vars.binNetAddrOctet[4]),2)
  local d = 1
  local e = 1
  repeat
    repeat
      if(vars.binMaskOctet[d]:sub(e,e) == "1") then 
        vars.wildMask = vars.wildMask.. "0"
        e=e+1
      else
        vars.wildMask = vars.wildMask.. "1"
        e=e+1
      end
    until e == 9
    d=d+1
    e=1
  until d == 5
  vars.netLen = tonumber(vars.wildMask,2)
  vars.numHosts = vars.netLen-2
  --End: Calculate Addresses:
  return vars.rtnAddr
end