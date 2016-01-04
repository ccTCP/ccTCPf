--[[
  A TLCO for CCTCP by Creator
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