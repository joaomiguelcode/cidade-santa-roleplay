local TIME_TO_WAIT_OPEN_CREATOR_MS = 1000 -- qunado o script starta ele verifica se existe o state e espera a ui carregar tbm

AddEventHandler('onResourceStart', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end

    local state = GetPlayerCustomizationState()

    if not state then
        return
    end

    Wait(TIME_TO_WAIT_OPEN_CREATOR_MS)
    StartCreation(state)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then
        return
    end
    StopCreation(true)
end)

RegisterNetEvent('net.character-creator.open', StartCreation)

-- isso serve para usar o sistema legado do barbershop para aplicar customização.
---@param customization number[]
---@param ped number?
RegisterNetEvent('net.character-creator.set-customization', function(customization, ped)
    if not ped then 
        SavePlayerAppearanceState(customization)
    end

    Customizator.ApplyFromData(ImportLegacyAppearance(customization), ped)
end)

-- vamos manter esse evento legado pois usa em muitos scripts diferentes, mas agora vai ser o character-creator que vai aplicar a customização.
RegisterNetEvent("barbershop:Apply", function(customization, ped)
    TriggerEvent('net.character-creator.set-customization', customization, ped)
end)

RegisterNetEvent('net.character-creator.open-ramo', function()
    StartCreation(eCharacterCreatorCreationState.CREATING)
    SendNUIMessage({ action = "creator:openRamo" })
    SendNUIMessage({ action = "debug:setStep", data = "registerRamo" })
end)

RegisterNetEvent('net.character-creator.open-ramo-select', function()
    print(('[character-creator] open-ramo-select from=%s creating=%s tutorial=%s'):format(
        tostring(GetInvokingResource()), tostring(LocalPlayer.state.Creating), tostring(LocalPlayer.state.newHubTutorial)))
    gCreationState = {
        flag = eCharacterCreatorCreationState.CREATING
    }

    local gender = GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') and 'F' or 'M'

    SendNUIMessage({
        action = 'character:update',
        data = { GENDER = gender }
    })

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'creator:openRamo',
        data = true
    })
end)

-- ENG-3989: freeze fixo no spawn (7s); na checagem, sem chão carregado no ponto, segue até o teto (10s) e libera.
-- Liberado, quem cair mais que `fallMeters` abaixo do ponto dentro da janela (30s) volta pro ponto com freeze curto (2s).
-- Spawn mais novo, morte ou fim da janela encerram o monitor.
local SPAWN_GROUND_MAX_DROP = 5.0
local spawnHoldId = 0

---@class CreatorSpawnHoldRules
---@field freezeMs number
---@field maxMs number
---@field refreezeMs number
---@field fallMeters number
---@field fallWindowMs number

---@param position vector3
---@return boolean
local function IsSpawnGroundLoaded(position)
    local ped = PlayerPedId()
    if #(GetEntityCoords(ped) - position) >= 3.0 or not HasCollisionLoadedAroundEntity(ped) then return false end
    local found, groundZ = GetGroundZFor_3dCoord(position.x, position.y, position.z + 0.8, false)
    return found and position.z - groundZ < SPAWN_GROUND_MAX_DROP
end

--- Mantém o ped congelado até `untilAt`; false se um spawn mais novo assumiu o freeze.
---@param holdId number
---@param position vector3
---@param untilAt number
---@return boolean
local function HoldSpawnFreeze(holdId, position, untilAt)
    while GetGameTimer() < untilAt do
        if holdId ~= spawnHoldId then return false end
        FreezeEntityPosition(PlayerPedId(), true)
        RequestCollisionAtCoord(position.x, position.y, position.z)
        Wait(100)
    end
    return holdId == spawnHoldId
end

---@param position vector3
---@param rules CreatorSpawnHoldRules
RegisterNetEvent('net.character-creator.hold-spawn-ground', function(position, rules)
    spawnHoldId = spawnHoldId + 1
    local holdId = spawnHoldId
    local startedAt = GetGameTimer()
    if not HoldSpawnFreeze(holdId, position, startedAt + rules.freezeMs) then return end
    local loaded = IsSpawnGroundLoaded(position)
    if not loaded and not HoldSpawnFreeze(holdId, position, startedAt + rules.maxMs) then return end
    FreezeEntityPosition(PlayerPedId(), false)
    sx.logger:debug(('Spawn liberado em %dms (chão carregado na checagem=%s)'):format(GetGameTimer() - startedAt, tostring(loaded)))

    local windowEndsAt = GetGameTimer() + rules.fallWindowMs
    while GetGameTimer() < windowEndsAt and holdId == spawnHoldId do
        local ped = PlayerPedId()
        if GetEntityHealth(ped) <= 100 then return end
        if not IsPedInAnyVehicle(ped, false) and position.z - GetEntityCoords(ped).z > rules.fallMeters then
            sx.logger:info(('Queda no spawn: puxado de volta ao ponto aos %dms'):format(GetGameTimer() - startedAt))
            SetEntityCoords(ped, position.x, position.y, position.z + 0.8, false, false, false, true)
            if not HoldSpawnFreeze(holdId, position, GetGameTimer() + rules.refreezeMs) then return end
            FreezeEntityPosition(PlayerPedId(), false)
        end
        Wait(100)
    end
end)

exports('IsResourceFocusedUi', function()
    return IsNuiFocused()
end)