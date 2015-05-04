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

for i,v in pairs(fs.list("ccTCPf/src")) do
    if not fs.isDir("ccTCPf/src/"..v) then
        loadAPI("ccTCPf/src/"..v)
    end
end