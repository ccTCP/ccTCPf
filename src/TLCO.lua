--[[
  A TLCO for CCTCP by Creator
  
  proposal [cmdpwnd]: If you are going to intercept the events and redirect them to the correct coroutine. What about firing custom 'cctcp' events? would look nice and be easier to source for troubleshooting. Not a requirement. Just recommendation
--]]

local oldPrintError = _G.printError


local shellCoroutine = coroutine.create(setfenv(loadfile("rom/programs/shell"),_G))
local rednetCoroutine = coroutine.create(rednet.run)


local function _G.printError()
	while true do
		local event = os.pullEventRaw()
		coroutine.resume(shellCoroutine,unpack(shellCoroutine))
		if event[1] == "modem_message" then
			coroutine.resume(rednetCoroutine,unpack(event))
		end
		--ccTCP.event(event)
	end
end