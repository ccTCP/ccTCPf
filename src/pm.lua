--processManager.lua


function _init_()
	if not _PM_RUN_STATUS then
		--print('pm.init = active')
		_G._PM_RUN_STATUS=1
		return
	end
end

function cctcpReceive(...) --This will evolve to become the core of the switching engine and route processor. Receive is currently the top level init function of this daemon.
	tArgs = {...}
	print('tArgs: '..unpack(tArgs))
	while true do
		--print('inside')
		--print('wrapNum = '..interface.tInterface.count)
		for i=1,interface.tInterface.count do
			local event = {os.pullEventRaw()}
			--print('pullinside')
			print('pull: '..unpack(event))
			if event and event[2] == "modem_message" and event[4] == interface.channel and interface.tInterface[event[3]].state == 'up' and event[6] then
				--print('msg')
				table.insert(interface.tInterface[i].ingressQueue,event[6])
			end
		end
		coroutine.yield()
	end
end

local pullEventRaw_Backup = os.pullEventRaw
local co_cctcpReceive = coroutine.create(cctcpReceive)

function os.pullEventRaw(sFilter)
  while true do
    local event = {pullEventRaw_Backup()}
	--print('pullevent')
    if coroutine.status(co_cctcpReceive) == "suspended" then
	--print('+')
      coroutine.resume(co_cctcpReceive, table.unpack(event))
    end
    --Return any events
    if sFilter == event[1] or not sFilter then
      return table.unpack(event)
    end
  end
end

_init_()


--[[Overwrite]]--

local rawMessages = {}


local oldPullEventRaw = os.pullEventRaw
local unpack = unpack or table.unpack

function os.pullEventRaw(filter)
	local event = {oldPullEventRaw()}
	if event[1] == "modem_message" then

	end

	if event[1] == filter or filter == nil then
		return unpack(event)
	end
end