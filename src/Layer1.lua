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

--L1:Variables
local sides = {"top","bottom","left","right","back","front"}
local sidesTable = {top = 0,bottom = 1,left = 2,right = 3,back = 4,front = 5}
local modem = {}
local defaultSide = ""
local channel  = 20613
--End: L1:Variables]]

--L1:Functions
local function wrap()
	for a = 1,6 do 
		if peripheral.isPresent(sides[a]) then 
			if peripheral.getType(sides[a]) == "wireless_modem" or peripheral.getType(sides[a]) == "modem" then
				if defaultSide == "" then defaultSide = sides[a] end
				modem[sides[a]] = peripheral.wrap(sides[a])
				modem[sides[a]].open(channel)
			end
		end
		a = a+1
	end
end

function intOpen(int)
	modem[sides[int]].open(channel)
end

function intClose(int)
	modem[sides[int]].close()
end

function send(int,data)
	
	if (not data == nil) then
		modem[int or defaultSide].transmit(channel,channel,data)
	else
	modem[int or defaultSide].transmit(channel,channel,frame)
	frame = {preamble = "",dstMac = "",srcMac = "",packet = "" or data = "",fcs()}
	dotQFrame = {preamble = "",dstMac = "",srcMac = "",vlan = "",packet = "" or data = "",fcs()}
	end
end

function receive()
	while true do
		local event = {os.pullEvent("modem_message")}
		if event[3] == channel then
			local destMac = event[4]:sub(1,6)
			local sendMac = event[4]:sub(7,12)
			if destMac == getMac(event[2]) then
				return event[4]
			end
		end
	end
end
--End: L1:Functions]]


--L1:Active / Test Code
wrap()
--End: L1:Active / Test Code]]