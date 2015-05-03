--[[

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
local side = {"top","bottom","left","right","back"}
local modem = {}
local channelReceive = 20613
local channelSend = 20614
local defaultSide = ""


--Functions
function send(msg,interface)
	modem[interface or defaultSide].transmit(channelSend,channelSend,msg)
end

function receive(interface)

end

--Wraps peripherals under modem array
local a = 1
repeat
	if peripheral.isPresent(side[a]) then 
		if peripheral.getType(side[a]) == "wireless_modem" or peripheral.getType(side[a]) == "modem" then
			if defaultSide == "" then defaultSide = side[a] end
			modem[side[a]] = peripheral.wrap(side[a])
		end
	end
	a = a+1
until a = 5