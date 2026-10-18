local blips = {}

---@param entity number
---@param petName string
---@param lastCoords vector3
---@return void
---@diagnostic disable-next-line: lowercase-global
setPetLost = function(entity, petName, lastCoords)
    local netId = NetworkGetNetworkIdFromEntity(entity)

    blips[#blips + 1] = AddBlipForCoord(lastCoords.x, lastCoords.y, lastCoords.z)

    SetBlipSprite(blips[#blips], config.lostBlipSprite)
    SetBlipColour(blips[#blips], 1)
    SetBlipScale(blips[#blips], 0.8)
    SetBlipAsShortRange(blips[#blips], true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(petName)
    EndTextCommandSetBlipName(blips[#blips])

    TriggerEvent('Notify', 'Warning', _t('pet_lost'), 5000)
end

---@return void
---@diagnostic disable-next-line: lowercase-global
setPetFound = function()
    if (#blips == 0) then
        return
    end

    for _, blip in pairs(blips) do
        if (DoesBlipExist(blip)) then
            RemoveBlip(blip)
            blips[blip] = nil
            TriggerEvent('Notify', 'Confirmed', _t('pet_found'), 5000)
        end
    end
end