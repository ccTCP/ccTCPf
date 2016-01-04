--[[
  A TLCO for CCTCP by Creator
--]]

local oldPrintError = _G.printError

--load cctpc here

--ccTCP.event -- a function that handles events

local shellCoroutine = coroutine.create(setfenv(loadfile("rom/programs/shell"),_G))


local function _G.printError()
	while true do
		local event = os.pullEventRaw()
		coroutine.resume(shellCoroutine,unpack(shellCoroutine))
		--ccTCP.event(event)
	end
end