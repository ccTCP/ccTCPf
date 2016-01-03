
function loadAPI( _sPath )
    local sName = fs.getName( _sPath )
    local tEnv = {}
    setmetatable( tEnv, { __index = _G } )
    local fnAPI, err = loadfile( _sPath )
    if fnAPI then
        setfenv( fnAPI, tEnv )
        local ok, err = pcall( fnAPI )
        if not ok then
            printError( err )
            return false
        end
    else
        printError( err )
        return false
    end

    local tAPI = {}
    for k,v in pairs( tEnv ) do
        tAPI[k] =  v
    end

    _G[sName:match("[^%.]+")] = tAPI    
    return true
end

for i,v in pairs(fs.list("src")) do
    if not fs.isDir("src/"..v) then
        loadAPI("src/"..v)
    end
end

--[[
```lua
table.concat:
table.concat({1=1,2="two",3=3,4="four"})
==> 1two3four

pairs:
final = ""
for key,value in pairs({1,"two",3,"four"}) do
    final = final..value
end
==> 1two3four
```
--]]