--processManager.lua

function _init_()
	if not _PM_RUN_STATUS then
		_PM_RUN_STATUS=1
		return
	end
end

function cctcpReceive() --This will evolve to become the core of the switching engine and route processor. Receive is currently the top level init function of this daemon.
	while true do
		for i=1,#interface.tInterfaceWrap do
			local event = {os.pullEventRaw()}
			if event and event[2] == "modem_message" and event[4] == interface.channel and interface.tInterfaceState[event[3]] == 'up' and event[6] then
				table.insert(interface.tInterfaceWrap[i].ingressQueue,event[6])
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
    if coroutine.status(co_cctcpReceive) == "suspended" then
      coroutine.resume(co_cctcpReceive, table.unpack(event))
    end
    --Return any events
    if sFilter == event[1] or not sFilter then
      return table.unpack(event)
    end
  end
end

_init_()