gVehicleChamaleonEntityId = nil ---@type number?
gVehicleChamaleonColorData = nil ---@type hud.chamaleon.client.gVehicleColorData?

---@param colourId hud.chamaleon.chamaleonColorId?
function ShowChamaleonUI(colourId)
    local pedId = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(pedId, false)

    if not DoesEntityExist(vehicle) then
        return
    end

    local primary, secondary = GetVehicleColours(vehicle)

    SetNuiFocus(true, true)
    SendNUIMessage({ action = "openChameleonColors", data = { colors = CHAMALEON_SETTINGS.GetColours(), selectedId = colourId } })

    gVehicleChamaleonEntityId = vehicle
    gVehicleChamaleonColorData = { primary = primary, secondary = secondary, colourId = colourId }

    FreezeEntityPosition(vehicle, true)
    CreateChamaleonCamera(vehicle)
end

function CloseChamaleonUI()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeChameleonColors" })

    DestroyChamaleonCamera()

    if gVehicleChamaleonEntityId and DoesEntityExist(gVehicleChamaleonEntityId) then
        FreezeEntityPosition(gVehicleChamaleonEntityId, false)
    end

    gVehicleChamaleonEntityId = nil
end

function ResetChamaleonColourVisual()
    if not (gVehicleChamaleonColorData and gVehicleChamaleonEntityId and DoesEntityExist(gVehicleChamaleonEntityId)) then
        return
    end

    if gVehicleChamaleonColorData.colourId then
        return ApplyChamaleonColour(gVehicleChamaleonEntityId, gVehicleChamaleonColorData.colourId)
    end

    SetVehicleColours(gVehicleChamaleonEntityId, gVehicleChamaleonColorData.primary, gVehicleChamaleonColorData
    .secondary)
end

---@param vehicle number
---@param colourId hud.chamaleon.chamaleonColorId
function ApplyChamaleonColour(vehicle, colourId)
    local data = CHAMALEON_SETTINGS.GetColourById(colourId)

    if not data then
        return
    end

    SetVehicleColours(vehicle, data.colours.primary, data.colours.secondary)
end

AddEventHandler('gameEventTriggered', function(name)
    if name ~= 'CEventNetworkPlayerLeaveVehicle' then
        return
    end

    if not gVehicleChamaleonEntityId then
        return
    end

    if not DoesEntityExist(gVehicleChamaleonEntityId) then
        CloseChamaleonUI()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ResetChamaleonColourVisual()
    CloseChamaleonUI()
end)

RegisterNetEvent('net.chamaleon.show.ui', function(colourId)
    ShowChamaleonUI(colourId)
end)


RegisterNetEvent('net.chamaleon.list.colors.admin', function()
    local options = {} do
        for index, colorData in pairs(CHAMALEON_SETTINGS.GetColours()) do
            table.insert(options, { label = colorData.name, value = colorData.id })
        end
    end
    local input = lib.inputDialog(_t('chamaleon.admin.dialog.title'), {
        { type = 'select', label = _t('chamaleon.admin.dialog.selectColor'), options = options }
    })

    if not input then
        return
    end
    -- explicação de ser assim, querendo ou não, não faz sentido criar mais proteção para isso sendo que é uma native que é do fivem kkk
    local colorId = input[1]
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if not DoesEntityExist(vehicle) then
        return
    end

    ApplyChamaleonColour(vehicle, colorId)
end)

exports('ApplyChamaleonColour', ApplyChamaleonColour)
