--interface.lua

channel = 2016

function _init_()
	if not _INTERFACE_RUN_STATUS then 
		--print('interface.init = active')
		_G._INTERFACE_RUN_STATUS=1
		tInterface = {}
		tInterface.count = 0
		wrap()
		return 
	end
end

function wrap()
	local peripherals = peripheral.getNames()
	--print(#peripherals)
	for i=1,#peripherals do
		if not (peripheral.getType(peripherals[i])=="modem") then --print('index: '..peripherals[i]..' skipped') ; i=i+1 else
			tInterface.count = tInterface.count+1
			local index = peripherals[i]
			--print('index: '..index)
			tInterface[index] = {}
			tInterface[index].wrap = peripheral.wrap(index)
			tInterface[index].ingressQueue = {'_'}
			tInterface[index].egressQueue = {'_'}
			if tInterface[index].wrap.isWireless() then
				tInterface[index].type = 'wireless' 
				--print(tInterface[index].type)
			else
				tInterface[index].type = 'wired'
				--print(tInterface[index].type)
			end
			if tInterface[index].wrap.isOpen(channel) then 
				tInterface[index].state = 'up'
				--print(tInterface[index].state)
			else 
				tInterface[index].state = 'administratively down'
				--print(tInterface[index].state)
			end
		end
	end
	return true
end

function shut(interface)
	tInterface[interface].state = 'administratively down'
	return tInterface[interface].wrap.close(channel)
end

function noshut(interface)
	print(interface)
	tInterface[interface].state = 'up'
	return tInterface[interface].wrap.open(channel)
end

function transmit(interface,...)
	if not (tInterface[interface].state == "up") then return error('Interface down',2) end
	local data = {...}
	return tInterface[interface].wrap.transmit(channel,channel,data)
end

function receive(...)
	local interface = {...}
	if interface[1] == "all" or not interface[1] then
		local t = {}
		for i=1,#tInterface do
			if not tInterface[i].ingressQueue[1] then i=i+1 else
				t[tInterface[i]] = tInterface[i].ingressQueue[1]
				table.remove(tInterface[i].ingressQueue,1)
			end
		end
		if #t < 1 then return else
		return unpack(t)
		end
	else
		local t = {}
		for i=1,#interface do
			if not tInterface[interface[i]].ingressQueue[1] then i=i+1 else
				t[interface[i]] = tInterface[i].ingressQueue[1]
				table.remove(tInterface[interface[i]].ingressQueue,1)
			end
		end
		if #t < 1 then return else
		return t
		end
	end
end

_init_()
