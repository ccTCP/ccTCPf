--[[
	Log API
	by Creator
	for TheOS
	License: The thing that obtsucts you the most from doing anything without having to pay me 1 million dollars
]]--

args = {...}
--args[1,2,3] represent: destination,message,app

	if not doLog then return end
	local finalMsg = "["..os.day()..":"..os.time().."]"
	if args[3] then
		finalMsg = finalMsg..".["..tostring(args[3]).."]:"..tostring(args[2])
	else
		finalMsg = finalMsg..":"..tostring(args[2])
	end
	local m = fs.open(config.dir.."Logs/"..args[1]..".log","a")
	m.write(finalMsg.."\n")
	m.close()