--interface.lua

tInterfaceType = {}
tInterfaceWrap = {}
tInterfaceState = {}
channel = 2016

local function _init_()
	if not _INTERFACE_RUN_STATUS then 
		_INTERFACE_RUN_STATUS=1
		wrap()
		return 
	end
end

function wrap()
	local peripherals = peripheral.getNames()
	for i=1,#peripherals do
		if not (peripheral.getType(peripherals[i])=="modem") then i=i+1 else
			local index = peripherals[i]
			tInterfaceWrap[index] = peripheral.wrap(index)
			tInterfaceWrap[index].ingressQueue = {}
			tInterfaceWrap[index].egressQueue = {}
			if tInterfaceWrap[index].isWireless() then
				tInterfaceType[index] = 'wireless' 
			else
				tInterfaceType[index] = 'wired'
			end
			if tInterfaceWrap[index].isOpen(channel) then 
				tInterfaceState[index] = 'up'
			else 
				tInterfaceState[index] = 'administratively down'
			end
		end
	end
	return true
end

function shut(interface)
	tInterfaceWrap[interface].close(channel)
	tInterfaceState[interface] = 'administratively down'
	return true
end

function noshut(interface)
	tInterfaceWrap[interface].open(channel)
	tInterfaceState[interface] = 'up'
	return true
end

function transmit(interface,...)
	if not (tInterfaceState[interface] == "up") then return error('Interface down',2) end
	local data = {...}
	tInterfaceWrap[interface].transmit(channel,channel,data)
	return true
end

function receive(...)
	local interface = {...}
	if interface[1] == "all" or not interface[1] then
		local t = {}
		for i=1,#tInterfaceWrap do
			if not tInterfaceWrap[i].ingressQueue[1] then i=i+1 else
				t[tInterfaceWrap[i]] = tInterfaceWrap[i].ingressQueue[1]
				table.remove(tInterfaceWrap[i].ingressQueue,1)
			end
		end
		if #t < 1 then return else
		return t
		end
	else
		local t = {}
		for i=1,#interface do
			if not tInterfaceWrap[interface[i]].ingressQueue[1] then i=i+1 else
				t[interface[i]] = tInterfaceWrap[i].ingressQueue[1]
				table.remove(tInterfaceWrap[interface[i]].ingressQueue,1)
			end
		end
		if #t < 1 then return else
		return t
		end
	end
end

_init_()
