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

function getAddressInfo(address,rtnAddr,index)

--[[Args_List
addr
binAddr

cidr

mask
wildMask
binMask
binWildMask

netAddr
bcastAddr
binNetAddr
binBcastAddr

netLen
numHosts

#=index
binAddrOctet#
binMaskOctet#
binWildMaskOCtet#
binNetAddrOctet#
binBcastAddrOctet#

hostAddr#
--]]
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
    vars.binMask = getBinaryAddress(tostring(vars.mask))
    vars.binMaskOctet = {vars.binMask:sub(1,8),vars.binMask:sub(9,16),vars.binMask:sub(17,24),vars.binMask:sub(25,32)}
    vars.binWildMask = ""
    vars.binWildMaskOctet = {"","","",""}
    vars.wildMask = ""
    vars.wildMaskOctet = {"","","",""}

    vars.binNetAddr = ""
    vars.binNetAddrOctet = {"","","",""}
    vars.netAddr = ""
    vars.netAddrOctet = {"","","",""}
    vars.binBcastAddr = ""
    vars.binBcastAddrOctet = {"","","",""}
    vars.bcastAddr = ""
    vars.bcasAddrOctet = {"","","",""}
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
        vars.netAddrOctet[b] = tonumber(vars.binNetAddrOctet[b],2)
        c=c+1
      else
        vars.binNetAddr = vars.binNetAddr.. "0"
        vars.binNetAddrOctet[b] = vars.binNetAddrOctet[b].. "0"
        vars.netAddrOctet[b] = tonumber(vars.binNetAddrOctet[b],2)
        c=c+1
      end
    until c == 9
    b=b+1
    c=1
  until b == 5
  vars.netAddr = tostring(vars.netAddrOctet[1].."."..vars.netAddrOctet[2].."."..vars.netAddrOctet[3].."."..vars.netAddrOctet[4])
  local d = 1
  local e = 1
  repeat
    repeat
      if(vars.binMaskOctet[d]:sub(e,e) == "1") then
        vars.binWildMask = vars.binWildMask.. "0"
        vars.binWildMaskOctet[d] = vars.binWildMaskOctet[d].. "0"
        vars.wildMaskOctet[d] = tonumber(vars.binWildMaskOctet[d],2)
        e=e+1
      else
        vars.binWildMask = vars.binWildMask.. "1"
        vars.binWildMaskOctet[d] = vars.binWildMaskOctet[d].. "1"
        vars.wildMaskOctet[d] = tonumber(vars.binWildMaskOctet[d],2)
        e=e+1
      end
    until e == 9
    d=d+1
    e=1
  until d == 5
  vars.wildMask = tostring(vars.wildMaskOctet[1].."."..vars.wildMaskOctet[2].."."..vars.wildMaskOctet[3].."."..vars.wildMaskOctet[4])
  vars.netLen = tonumber(vars.binWildMask,2)+1
  vars.numHosts = vars.netLen-2

  --End: Calculate Addresses:

  --Most simple magic ever
  if not index then
      return vars[rtnAddr]
  elseif index == "all" then
      return unpack(vars[rtnAddr])
  else
    return vars[rtnAddr][index]
  end
  --End: Simple Magic
end
