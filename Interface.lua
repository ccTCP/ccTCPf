--[[
    Defines OSI L1 & L2
    Defines TCP L1
]]

function getMac(side)
    local sideNum = {top = 0,bottom = 1,left = 2,right = 3,back = 4}
    return os.computerID() * 6 + sideNum[side]
end
