---@return table
getClosestCoord = function()
    local ped     = PlayerPedId()
    local pos     = GetEntityCoords(ped)
    local x, y, z = pos.x, pos.y, pos.z

    return {x = x, y = y, z = z}
end