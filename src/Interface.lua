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

local sides = {"top","bottom","left","right","back","front"}
local sidesTable = {top = 0,bottom = 1,left = 2,right = 3,back = 4,front = 5}
local modem = {}
local defaultSide = ""
local channel  = 20613

function wrap()
	for a = 1,6 do 
		if peripheral.isPresent(sides[a]) then 
			if peripheral.getType(sides[a]) == "wireless_modem" or peripheral.getType(sides[a]) == "modem" then
				if defaultSide == "" then defaultSide = sides[a] end
				modem[sides[a]] = peripheral.wrap(sides[a])
			end
		end
		a = a+1
	end
end

function open(int)
	modem[int].open(channel)
end

function close(int)
	modem[int].close()
end

function send(int,data)
	local frame = standFrame or QFrame
	if data then 
		modem[int or defaultSide].transmit(channel,channel,data)
	else
		modem[int or defaultSide].transmit(channel,channel,frame)
		standFrame = standFrame_Temp
		QFrame = QFrame_Temp
	end
end

function receive()
	while true do
		local event = {os.pullEvent("modem_message")}
		if event[3] == channel then
			return event[5], event[2]
		end
	end
end
wrap()