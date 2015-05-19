--Variables
local sides = {"top","bottom","left","right","back","front"}
local sidesTable = {top = 0,bottom = 1,left = 2,right = 3,back = 4,front = 5}
local modem = {}
local mac = {}
local defaultSide = ""
local channel  = 20613


--Utils
function fcs()
	local buffer = {frame or dotQFrame:byte(1,#msg)}
	local add = 0
	for i,v in pairs(buffer) do
		add = add + v
	end
	return string.rep("0",5-#tostring(toHex(add)))..tostring(toHex(add))
end

function toHex(num)
	local hexTemp = '0123456789abcdef'
	hex = ''
	while num > 0 do
		local mod = math.fmod(num, 16)
		hex = string.sub(hexTemp, mod+1, mod+1) .. hex
		num = math.floor(num / 16)
	end
	return hex == " " and 0 or hex
end

function toDec(num)
	local hexTable = {["0"]=0,["1"]=1,["2"]=2,["3"]=3,["4"]=4,["5"]=5,["6"]=6,["7"]=7,["8"]=8,["9"]=9,["a"]=10,["b"]=11,["c"]=12,["d"]=13,["e"]=14,["f"]=15}	
	local final = 0
	local str = tostring(num)
	local pow = 0
	for i = #str,1,-1 do
		final = final + hexTable[str:sub(i,i)]*math.pow(16,pow)
		pow = pow + 1
	end
	return final
end

function toBinary(num, bits)
    local t = {}
	print("running")
    for b = bits,1,-1 do
		print("in loop")
        rest = math.fmod(num,2)
		print("fmod")
        t[b] = rest
		print("assigned")
        num = (num-rest)/2
		print("converted")
    end
    if num == 0 then
		print("writing to file")
		local file = fs.open("ccTCP/binary", "w")
		file.writeLine(t)
		file.close()
		return t
	else
		return {'Too few bits specified'}end
end


function binHex(s)
        if type(s) == 'number' then
                return string.format('%08.8x', s)
        end
                return (s:gsub('.', function(c)
                  return string.format('%02x', byte(c))
                end))
   end
 
function hexBin(s)
        return (s:gsub('..', function(cc)
          return string.char(tonumber(cc, 16))
        end))
end
 

--Functions
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
	frame = {preamble == " ",dstMac == " ",srcMac == " ",packet == " " or data == " ",fcs()}
	dotQFrame = {preamble == " ",dstMac == " ",srcMac == " ",vlan == " ",packet == " " or data == " ",fcs()}
	end
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

------------------------------

function createMac(side)
	side = tostring(side)
	if (side and sidesTable[side]) then
		local compVal = toBinary(os.computerID() * 6 + sidesTable[side])
		local macBuffer = tostring(binHex(compVal))
		return string.rep("0",6-#macBuffer).. macBuffer
	end
	return error("Failed: "..side.."is not a side", 2)
end

function getMac(side)
	if not mac[side] then
		mac[side] = createMac(side)
	end
	return mac[side]
end

function getMacDec(side)
	return toDec(getMac(side))
end

function macBind(...)
--[[
	No Args: generates a mac for each interface found, sets a default-interface, and writes the bindings to macBindings
	One Arg: Will generate a mac for the interface given, and write the data to macBindings file.
	Two Arg: Will assign the given interface with the given mac address. This data will be recorded in macBindings.
]]
	
	local bindArgs = {...}
	
	local function isFile()
		if (not fs.isDir("ccTCP")) then
			fs.makeDir("ccTCP")
		end
		if (not fs.exists("ccTCP/macBindings")) then
			local file = fs.open("ccTCP/macBindings", "w")
			file.close()
			return false
		else
			return true
		end
	end
	
	local function macFile(mode,int,addr)
		if (mode == "w" and int == nil) then
			local num = 1
			local genAddr = createMac(sides[num])
			local file = fs.open("ccTCP/macBindings", "w")
			repeat
				file.writeLine(sides[num].." = "..genAddr)
				num = num+1
			until num == 5
			file.close()
			fixMac()
		else
			if (mode == "w" and not int == nil) then 
				local file = fs.open("ccTCP/macBindings", "w")
				file.writeLine(int,addr)
				file.close()
				fixMac()
			else
				if (mode == "a") then
					local file = fs.open("ccTCP/macBindings", "a")
					file.writeLine(int,addr)
					file.close()
					fixMac()
				end
			end
		end
	end
	
	local function fixMac()
		local file = fs.open("ccTCP/macBindings", "r")
		mac = nil
		local num = 1
		repeat
			mac[num] = file.readLine()
			num = num+1
		until line[1] == nil
	end
	
	--Running Code
	if (bindArgs[1] == nil and bindArgs[2] == nil) then
		if (isFile() == false) then
			wrap()
			macFile("w")
		end
	else 
		if (peripheral.isPresent(bindArgs[1]) and bindArgs[2] == nil) then
			local bind = createMac(bindArgs[1])
			if (isFile() == false) then
				macFile("w",bindArgs[1],bind)
			else
				macFile("a",bindArgs[1],bind)
			end
		else
			isFile()
			macFile("a",bindArgs[1],bindArgs[2])
			return "Interface on: "..bindArgs[1].."given MAC "..bindArgs[2]
		end
	end
	--End: Running Code
end

function receive()
	local msg, identifier = Layer1.receive()
	print(msg)
	local checksum = msg:sub(-5,-1)
	if checksum == fcs(msg:sub(1,-6)) then
		print("yay")
	else
		--ask for message identifier
	end
end


--Active / Test Code
wrap()
macBind()
