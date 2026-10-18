local menuId = 'garages:bulletproof:menu'
local modelStateKey = 'garages:bulletproof:models'
local protectedHashes = {}

local function SetProtectedModels(models)
    local nextHashes = {}
    if type(models) == 'table' then
        for index = 1, #models do
            local model = models[index]
            if type(model) == 'string' then nextHashes[GetHashKey(model)] = true end
        end
    end
    protectedHashes = nextHashes
end

AddStateBagChangeHandler(modelStateKey, nil, function(bagName, _, value)
    if bagName == 'global' then SetProtectedModels(value) end
end)
SetProtectedModels(GlobalState[modelStateKey])

local function HasBrokenDoor(vehicle)
    for doorIndex = 0, 5 do
        if IsVehicleDoorDamaged(vehicle, doorIndex) then return true end
    end
    return false
end

local protectedPed = 0
local wasInvincibleBeforeProtection = false
local lastInvincibleStateCheckAt = 0

local function StopProtection()
    if protectedPed == 0 then return end

    local state = LocalPlayer.state
    local otherProtection = state.InSafeZone == true or state.inSafeMode == true or state.psnc == true
    if not otherProtection and (not wasInvincibleBeforeProtection or state.Invincible ~= true) then
        if DoesEntityExist(protectedPed) then SetEntityInvincible(protectedPed, false) end
        if state.Invincible == true then state.Invincible = false end
    end

    protectedPed = 0
    wasInvincibleBeforeProtection = false
    lastInvincibleStateCheckAt = 0
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local waitTime = vehicle == 0 and 50 or 250
        local shouldProtect = false

        if vehicle ~= 0 and protectedHashes[GetEntityModel(vehicle)] then
            waitTime = 0
            shouldProtect = not IsEntityDead(ped) and not HasBrokenDoor(vehicle)
        end

        if shouldProtect then
            if protectedPed ~= ped then
                StopProtection()
                wasInvincibleBeforeProtection = LocalPlayer.state.Invincible == true
                protectedPed = ped
            end

            local now = GetGameTimer()
            if lastInvincibleStateCheckAt == 0 or now - lastInvincibleStateCheckAt >= 100 then
                lastInvincibleStateCheckAt = now
                if LocalPlayer.state.Invincible ~= true then
                    wasInvincibleBeforeProtection = false
                    LocalPlayer.state.Invincible = true
                end
            end
            SetEntityInvincible(ped, true)
        else
            StopProtection()
        end

        Wait(waitTime)
    end
end)

AddEventHandler('onClientResourceStop', function(resource)
    if resource == GetCurrentResourceName() then StopProtection() end
end)

local function NotifyResult(result, successKey)
    local code = result and result.code or 'unavailable'
    local key = result and result.ok and successKey or ('garages.bulletproof.%s'):format(code)
    local description = _t(key)
    if result and result.ok and result.model then description = description:format(result.model) end
    lib.notify({
        title = _t('garages.bulletproof.name'),
        description = description,
        type = result and result.ok and 'success' or 'error'
    })
end

local ShowBulletproofMenu

local function AddModel()
    local input = lib.inputDialog(_t('garages.bulletproof.add'), {
        { type = 'input', label = _t('garages.bulletproof.spawn'), required = true, min = 1, max = 64 }
    })
    if not input then return ShowBulletproofMenu() end

    local result = lib.callback.await('garages:bulletproof:add', false, input[1])
    NotifyResult(result, 'garages.bulletproof.added')
    if result and result.code ~= 'denied' and result.code ~= 'duty' and result.code ~= 'unavailable' then
        ShowBulletproofMenu()
    end
end

local function RemoveModel(model)
    local choice = lib.alertDialog({
        header = _t('garages.bulletproof.remove'),
        content = _t('garages.bulletproof.confirm_remove'):format(model),
        centered = true,
        cancel = true
    })
    if choice ~= 'confirm' then return ShowBulletproofMenu() end

    local result = lib.callback.await('garages:bulletproof:remove', false, model)
    NotifyResult(result, 'garages.bulletproof.removed')
    if result and result.code ~= 'denied' and result.code ~= 'duty' and result.code ~= 'unavailable' then
        ShowBulletproofMenu()
    end
end

ShowBulletproofMenu = function()
    local result = lib.callback.await('garages:bulletproof:list', false)
    if not result or not result.ok then
        NotifyResult(result)
        return
    end

    local models = result.models
    table.sort(models, function(left, right) return left:lower() < right:lower() end)

    local options = {
        {
            title = _t('garages.bulletproof.add'),
            description = _t('garages.bulletproof.add_description'),
            icon = 'plus',
            onSelect = AddModel
        }
    }

    for index = 1, #models do
        local model = models[index]
        options[#options + 1] = {
            title = model,
            description = _t('garages.bulletproof.remove_description'),
            icon = 'shield-halved',
            onSelect = function() RemoveModel(model) end
        }
    end

    lib.registerContext({
        id = menuId,
        title = _t('garages.bulletproof.title'):format(#models),
        canShowTextFilter = true,
        options = options
    })
    lib.showContext(menuId)
end

RegisterNetEvent('garages:bulletproof:open', function()
    ShowBulletproofMenu()
end)
