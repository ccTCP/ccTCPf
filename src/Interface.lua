
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

local sides = {"top","bottom","left","right","back","front"}
local sidesTable = {top = 1,bottom = 2,left = 3,right = 4,back = 5,front = 6}
local modem = {}
intStatus = {}
local channel = 20613

function wrap()
	for a = 1,6 do
		if peripheral.isPresent(sides[a]) then
			if peripheral.getType(sides[a]) == "wireless_modem" or peripheral.getType(sides[a]) == "modem" then
				modem[sides[a]] = peripheral.wrap(sides[a])
        close(modem[sides[a]])
			end
		end
		a = a+1
	end
end

function open(int)
  int = int
  if not modem[int] then error("L1: Interface: \""..int.."\" does not exist",2) end
	modem[int].open(channel)
  intStatus[int] = 1
  Utils.log("log","L1: \""..int.."\" state changed to up")
end

function close(int)
  int = int
  if not modem[int] then error("L1: Interface: \""..int.."\" does not exist",2) end
	modem[int].close(channel)
  intStatus[int] = 0
  Utils.log("log","L1: \""..int.."\" state changed to administratively down")
end

function send(data,int)
  if intStatus[int] == 0 or intStatus[int] == nil then return error("Invalid source interface, interface is down",2) else 
    modem[int].transmit(channel,channel,data)
  end
end

function receive(waitTime)
  if waitTime and type(waitTime) == "number" then
    local timer = os.startTimer(waitTime)
    while true do
<<<<<<< HEAD
      local event, timerEvent = os.pullEvent("timer")
      if timerEvent == timer then break else
      local event = {os.pullEvent("modem_message")}
      if event[3] == channel and intStatus[event[2]] == 1 then
        return event[5], event[2]
      else
        print("00")
      end
      end
    end
  else
    while true do
      local event = {os.pullEvent("modem_message")}
      if event[3] == channel and intStatus[event[2]] == 1 then
        return event[5], event[2]
      end
    end
  end
end

wrap()