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
debug = true
config = {}
config.dir = "ccTCP/"

function log(dest,msg,app)
	local finalMsg = "["..os.day()..":"..os.time().."]"
	if app then
		finalMsg = finalMsg..".["..tostring(app).."]:"..tostring(msg)
	else
		finalMsg = finalMsg..":"..tostring(msg)
	end
	local m = fs.open("Logs/"..dest..".log","a")
	m.write(finalMsg.."\n")
	m.close()
end

function debugLog(dest,msg,app)
	if not debug then return end
	local finalMsg = "["..os.day()..":"..os.time().."]"
	if app then
		finalMsg = finalMsg..".["..tostring(app).."]:"..tostring(msg)
	else
		finalMsg = finalMsg..":"..tostring(msg)
	end
	local m = fs.open("Logs/Debug"..dest..".log","a")
	m.write(finalMsg.."\n")
	m.close()
end

function debugPrint(...)
	if debug then
		print("["..os.day()..":"..os.time().."]")
	end
end

function DecToBase(val,base)
	if val == 0 then return 0 end
	local b, k, result, d = base or 10, "0123456789ABCDEFGHIJKLMNOPQRSTUVW",""
	while val > 0 do
		val, d = math.floor(val/b), math.fmod(val,b)+1
		result = string.sub(k,d,d)..result
	end
	return result
end

function toDec(val,base)
	return tonumber(val,base)
end

function crc(data)
  local msg = tostring(data)
	local buffer = {msg:byte(1,#msg)}
	local add = 0
	for i,v in pairs(buffer) do
		add = add + v
	end
	return string.rep("0",5-#tostring(DecToBase(add,16)))..tostring(DecToBase(add,16))
end

function assert(test,errorMsg,lvl)
	if not type(lvl) == "number" then error(lvl..' is not a number',2) end
	if not test then error(errorMsg,lvl+1) end
end

--Backup os.pullEventRaw
local pullEventRaw_Backup = os.pullEventRaw
--Create coroutines
local coMsgBuffer = coroutine.create(Interface.receive)
--Override os.pullEventRaw()
function os.pullEventRaw(sFilter)
  while true do
    local event = {pullEventRaw_Backup()}
    --Define internal coroutines to check for
    if coroutine.status(coMsgBuffer) == "suspended" then
      coroutine.resume(coMsgBuffer, unpack(event))
    end
    --Return any events
    if sFilter == event[1] or not sFilter then
      return unpack(event)
    end
  end
end