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
local side = {"top","bottom","left","right","back","front"}
local modem = {}
local channel = 20613
local defaultSide = ""
--End: L1:Variables]]

--L1:Functions
function send(msg,interface)
	modem[interface or defaultSide].transmit(channel,channel,msg)
end

function receive()
	while true do
		local event = {os.pullEvent("modem_message")}
		if event[3] == channel then
			local destMac = string.sub(event[5],1,6)
			local sendMac = string.sub(event[5],7,12)
			if destMac == Layer2.getMac(event[2]) then
				return event[5], event[4]
			end
		end
	end
end
--End: L1:Functions]]


--L1:Active / Test Code

--Wraps interfaces to modem{} and assigns defaultSide to first wrapped interface
for a = 1,6 do 
	if peripheral.isPresent(side[a]) then 
		if peripheral.getType(side[a]) == "wireless_modem" or peripheral.getType(side[a]) == "modem" then
			if defaultSide == "" then defaultSide = side[a] end
			modem[side[a]] = peripheral.wrap(side[a])
			modem[side[a]].open(channel)
		end
	end
	a = a+1
end
--End: L1:Active / Test Code]]