---@return boolean
hasAdminGroup = function()
    local groups = getPlayerGroups()
    for group, level in pairs(groups) do
        if config.adminGroups[group] and config.adminGroups[group] >= level then
            return true
        end
    end
    return false
end

---@return table
getProperties = function()
    return config.interiors
end

---@return table
getPlayerData = function()
    return vRP.GetPlayerData()
end

---@return table
getPlayerGroups = function()
    local pdata = getPlayerData()
    local groups = pdata.groups
    return groups
end

---@param interior table
---@param key string
---@param value any
local function assignConfigValue(interior, key, value)
    if value ~= nil then
        interior[key] = value
    end
end
---@param data table
---@return boolean
setPenthouseConfig = function(data)
    local city = string.lower(GetConvar("cityName", ""))

    if (#data == 0) then
        for key, v in pairs(config.interiors) do
            v.storeLink = config.storeLink[city]
        end
    end

    for key, value in pairs(data) do
        local interiorId = tonumber(value.interior) or tonumber(key)
        local interior = interiorId and config.interiors[interiorId]

        if interior then
            assignConfigValue(interior, 'people', value.people)
            assignConfigValue(interior, 'weight', value.weight)
            assignConfigValue(interior, 'address', value.address)
            assignConfigValue(interior, 'furnished', value.furnished)
            assignConfigValue(interior, 'rooms', value.rooms)
            assignConfigValue(interior, 'price', value.price)
            assignConfigValue(interior, 'images', value.images)
            assignConfigValue(interior, 'title', value.name)
            assignConfigValue(interior, 'big', value.big)
            interior.storeLink = config.storeLink[city]
        end
    end

    return true
end


---@param data table
---@return void
enterPenthouse = function(data)
    if PenthouseManager then
        PenthouseManager:enterPenthouse(data)
    end
end

---@param data table
---@param visible boolean
---@return boolean
setEditPenthouse = function(data, visible)
    if PenthouseManager then
        return PenthouseManager:editPenthouse(data, visible)
    end
    return false
end

---@param visible boolean
---@param data table|nil
---@return void
setVisibleDoorbellModal = function(visible, data)
    if PenthouseManager then
        PenthouseManager:showDoorbellModal(visible, data)
    end
end

---@param visible boolean
---@return void
setRealEstateMenuVisible = function(visible)
    if PenthouseManager then
        PenthouseManager.ui:showRealEstateMenu(visible)
    end
end

function SetPenthouseVersion()
    SendNUIMessage({ action = 'PENTHOUSE_SETVIEWMODE', data = GetPenthouseVerstion() })
end