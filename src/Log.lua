--[[
	Log API
	by Creator
	for TheOS
]]--

function log(destination,message,app)
	if not doLog then return end
	local finalMsg = "["..os.day()..":"..os.time().."]"
	if app then
		finalMsg = finalMsg..".["..tostring(app).."]:"..tostring(message)
	else
		finalMsg = finalMsg..":"..tostring(message)
	end
	local m = fs.open(config.dir.."Logs/"..destination..".log","a")
	m.write(finalMsg.."\n")
	m.close()
end