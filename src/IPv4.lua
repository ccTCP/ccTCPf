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
local local_addresses = {
	["10.0.0.0/8"] = true,
	["172.16.0.0/12"] = true,
	["192.168.0.0/16"] = true,
}

--Functions

local function getBinaryAddress(address)
	if type(address) ~= "string" then error("Expected string, got "..type(address).."!",2) end
	local place = address:find("/")
	local addr = address:sub(1,place-1)
	local mask = address:sub(place+1,-1)
	local result = ""
	for token in addr:gmatch("[^%.]+") do
		result = result..string.rep("0",8-#tostring(Utils.DecToBase(tonumber(token),2)))..tostring(Utils.DecToBase(tonumber(token),2))
	end
	print(result)
	print(#result)
end
getBinaryAddress("10.0.0.0/8")