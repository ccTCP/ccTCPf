local macTable = {}
local standFrame_Temp = {preamble = "",dstMac = "",srcMac = "",packet = "" or data = "",crc()}
local QFrame_Temp = {preamble = "",dstMac = "",srcMac = "",vlan = "",packet = "" or data = "",crc()}

standFrame = {preamble = "",dstMac = "",srcMac = "",packet = "" or data = "",crc()}
QFrame = {preamble = "",dstMac = "",srcMac = "",vlan = "",packet = "" or data = "",crc()}

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
			if () then ---NEED HELP HERE
				isFile()
				macFile("a",bindArgs[1],bindArgs[2])
				return "Interface on: "..bindArgs[1].."given MAC "..bindArgs[2]
			else
			
			end
		end
		return
	end
	return error("Failed: something went wrong",2)
	--End: Running Code
end

function NOTmacBind(...)
--[[
	No Args: generates a mac for each interface found, sets a default-interface, and writes the bindings to macBindings
	One Arg: Will generate a mac for the interface given, and write the data to macBindings file.
	Two Arg: Will assign the given interface with the given mac address. This data will be recorded in macBindings.
]]

	local Args = {...}
	
	local function macGen(side)
	side = tostring(side)
	if (side and sidesTable[side]) then
		local macBuffer = tostring(DecToBase(os.computerID() * 6 + sidesTable[side],16))
		return string.rep("0",6-#macBuffer).. macBuffer
	end
end
	
	--Running Code
	if(no args) then 
		if(isFile() == false) then--look for file
			--no, but file has now been created.
				wrap()--poll and open interfaces
				local r=1
				local file = fs.open("ccTCP/macBindings","w")
				repeat --write bindings to file
					file.writeLine(sides[r] "=" macGen(r))
				until r=6
				file.close()
		else
			--yes
				wrap()--poll and open interfaces
				--are there any new interfaces?
					--yes
						--generate a mac for each new interface and write it to file
					--no
						--generate a mac for each interface and write it to file
		end
	else
		if(1 arg) then 
			--generate a mac
			--take side given and write binding to file
		else
			if(2 args) then 
				--is this mac valid?
					--yes
						--write binding to file
					--no
						--give me a REAL MAC dimby
			else 
				--So you dont want me to give you a mac nor did you give me a mac to remember? WHATS YOUR PROBLEM?!!
			end 
		end 
	end
	--End: Running Code
end


function DecToBase(val,base)
	local b,k,result,d=base or 10, "0123456789ABCDEFGHIJKLMNOPQRSTUVW",""
	while val>0 do
		val,d=math.floor(val/b),math.fmod(val,b)+1
		result=string.sub(k,d,d)..result
	end
	return result
end

function toDec(val,base)
	return tonumber(val,base)
end

function crc(msg)
	local buffer = {msg:byte(1,#msg)}
	local add = 0
	for i,v in pairs(buffer) do
		add = add + v
	end
	return string.rep("0",5-#tostring(DecToBase(add,16)))..tostring(DecToBase(add,16))
end

config = {}

function config.macBindings()

end