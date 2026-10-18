---@param pos vector3
---@return string
getStreetName = function(pos)
    local x,y,z       = pos.x, pos.y, pos.z
    local road, cross = GetStreetNameAtCoord(x, y, z)
    local nameRoad    = GetStreetNameFromHashKey(road)
    local nameCross   = GetStreetNameFromHashKey(cross)

    local fullName = nameCross == '' and ('%s'):format(nameRoad, nameCross) or ('%s | %s'):format(nameRoad, nameCross)

    return fullName
end