exports('IsMatchCityEnabled', function() return NeighborConfig.enabled end)
if not NeighborConfig.enabled then
    exports('IsMatchCityPartner', function() return false end)
    return
end

local phase = 'idle'
local neighborVrp = module('vrp', 'lib/Proxy').getInterface('vRP')
local adminOne = false
local returnCoords
local roomState
local lastMoveCoords
local tableWaiting = false
local waitingForPartner = false
local inviteSnapshot
local worldAllowed = false
local resumeWorldModal = false
local commercialActive = false
local resumeCommercialModal = false
local resumeAffiliateModal = false
local inviteCollapsed = false
local gMatchCardActive = false
local lastMatchQueueKeyAt = -1000
local profileOpen = false
local profileFocused = false
local ClosePartnerProfile
local resultOpen = false
local exitPromptOpen = false
local roomDoors = {}
local tableDui
local tableTextureDictionary
local tableTextureGeneration = 0
local deathRecoveryPending = false

---@return boolean allowed
---@return boolean
local function IsAffiliateInService()

    return LocalPlayer.state['affiliate:inService'] == true
end

local function CanShowMatchCity()

    return worldAllowed and not commercialActive and not IsAffiliateInService()
end

local function IsAliveForInvite()
    local ped = PlayerPedId()
    return ped ~= 0 and GetEntityHealth(ped) > 100 and not IsEntityDead(ped)
end

local function T(key, ...)
    return NeighborTranslations and NeighborTranslations.get(key, ...) or key
end

local function RefreshHudPriority()

    local active = inviteSnapshot and not commercialActive and not IsAffiliateInService()
        and (worldAllowed or phase == 'room' or phase == 'uno' or phase == 'countdown')
        and ((inviteSnapshot.progress or 0) < 3 or phase == 'queue' or phase == 'matched'
        or phase == 'room' or phase == 'uno' or phase == 'countdown')
    TriggerEvent('hud:matchCity:priorityChanged', active == true)
    TriggerEvent('dashboard:x1invite:yieldToSocial', active == true)
end

local function Nui(name, data)

    local payload = data or {}
    if name == 'neighbor:invite' then
        gMatchCardActive = payload.modal ~= true
    elseif name == 'neighbor:setGameState' then
        gMatchCardActive = payload.phase == 'SEARCHING'
    elseif name == 'neighbor:closeNui' or name == 'closeNui' or name == 'neighbor:matched' then
        gMatchCardActive = false
    end
    SendNUIMessage({ type = name, data = payload })
end

local function CanUseMatchCard()

    return gMatchCardActive and inviteSnapshot ~= nil and not inviteCollapsed and CanShowMatchCity()
        and not IsNuiFocused() and not IsPauseMenuActive()
end

local function Focus(enabled)

    if enabled then ClosePartnerProfile() end
    SetNuiFocus(enabled, enabled)
    SetNuiFocusKeepInput(false)
end

local function OpenExitPrompt()

    if exitPromptOpen then return end
    exitPromptOpen = true
    Focus(true)
    Nui('neighbor:exitPrompt')
end

ClosePartnerProfile = function()

    if not profileOpen then return end
    profileOpen = false
    profileFocused = false
    if GetResourceState('radialmenu') == 'started' then
        exports.radialmenu:closeMatchProfile()
    end
end

local function NotifyMatch(message, duration)

    TriggerEvent('BigNotify2', 'azul', message, duration or 4500, T('title'))
end

local function MatchPartnerSource()

    if phase ~= 'room' or waitingForPartner or not roomState then return nil end
    local players = roomState.interactionPlayers or {}
    local myId = roomState.currentPlayer and roomState.currentPlayer.id
    local other = players[1] and players[1].id ~= myId and players[1] or players[2]
    return other and other.source or nil, other
end

exports('IsMatchCityPartner', function(targetSource)

    return MatchPartnerSource() == targetSource
end)

local function OpenPartnerProfile(targetSource, interactive)

    local source, other = MatchPartnerSource()
    if not source or (targetSource and targetSource ~= source)
        or GetResourceState('radialmenu') ~= 'started' then return end
    if profileOpen then
        if interactive and not profileFocused then
            profileFocused = exports.radialmenu:focusMatchProfile() == true
            return
        end
        ClosePartnerProfile()
        return
    end
    if not exports.radialmenu:openMatchProfile(source, other.presentation or '', other.id) then
        NotifyMatch(T('profile_wait'))
        return
    end
    profileOpen = true
    if interactive then profileFocused = exports.radialmenu:focusMatchProfile() == true end
end

local function PutBack()

    TriggerEvent('hud:matchCity:cancelContactRequests')
    if not returnCoords then return end
    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, returnCoords.x, returnCoords.y, returnCoords.z, false, false, false)
    SetEntityHeading(ped, returnCoords.heading)
    returnCoords = nil
end

local function LockRoomDoors()

    -- Modelo E posição: outras folhas do mesmo modelo devem continuar livres.
    for _, entity in ipairs(GetGamePool('CObject')) do
        local model = GetEntityModel(entity) & 0xFFFFFFFF
        local coords = GetEntityCoords(entity)
        local excluded = false
        for _, door in ipairs(NeighborConfig.unfrozenDoors) do
            if #(coords - vector3(door.x, door.y, door.z)) <= 1.0 then
                excluded = true
                break
            end
        end
        if not excluded then
            for _, door in ipairs(NeighborConfig.doors) do
                if model == (door.model & 0xFFFFFFFF)
                    and #(coords - vector3(door.x, door.y, door.z)) <= 1.5 then
                    roomDoors[entity] = model
                    FreezeEntityPosition(entity, true)
                    break
                end
            end
        end
    end
end

local function UnlockRoomDoors()

    local house = NeighborConfig.house
    local center = vector3(house.x, house.y, house.z)

    for entity, model in pairs(roomDoors) do
        if DoesEntityExist(entity) and (GetEntityModel(entity) & 0xFFFFFFFF) == model
            and #(GetEntityCoords(entity) - center) <= house.radius then
            FreezeEntityPosition(entity, false)
        end
    end

    roomDoors = {}
end

local function DestroyTableDui()

    if tableDui then DestroyDui(tableDui) end
    tableDui = nil
    tableTextureDictionary = nil
end

local function DrawTableDui()

    if not tableDui then
        tableTextureGeneration = tableTextureGeneration + 1
        tableDui = CreateDui(('nui://%s/web/cartada-table.html'):format(GetCurrentResourceName()), 512, 256)
        if not tableDui or tableDui == 0 then
            tableDui = nil
            return
        end
    end
    if not tableTextureDictionary then
        if not IsDuiAvailable(tableDui) then return end
        tableTextureDictionary = ('matchcity_table_%d'):format(tableTextureGeneration)
        local txd = CreateRuntimeTxd(tableTextureDictionary)
        CreateRuntimeTextureFromDuiHandle(txd, 'cartada', GetDuiHandle(tableDui))
        SendDuiMessage(tableDui, json.encode({ title = T('table_title'), hint = T('table_hint') }))
    end

    local target = NeighborConfig.tableDui
    SetDrawOrigin(target.x, target.y, target.z, 0)
    local width = 0.13
    local height = width * GetAspectRatio(false) / 2.0 -- textura 512x256, sem achatar letras/cartas
    DrawSprite(tableTextureDictionary, 'cartada', 0.0, 0.0, width, height, 0.0, 255, 255, 255, 255)
    ClearDrawOrigin()
end

local function ClearRoom()

    deathRecoveryPending = false
    ClosePartnerProfile()
    UnlockRoomDoors()
    DestroyTableDui()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, false)
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true, false)
    ResetEntityAlpha(ped)
    SetEntityInvincible(ped, false)
    LocalPlayer.state:set('matchcity:house', false, true)
    PutBack()
    roomState = nil
    tableWaiting = false
    waitingForPartner = false
end

local function Close()

    ClearRoom()
    phase = 'idle'
    resultOpen = false
    exitPromptOpen = false
    Focus(false)
    RefreshHudPriority()
    if inviteSnapshot and CanShowMatchCity() then
        Nui('neighbor:leave')
        Nui('neighbor:invite', { snapshot = inviteSnapshot, modal = false })
    else
        Nui('neighbor:closeNui')
        Nui('closeNui')
    end
end

RegisterNetEvent('dminigames:neighbor:invite', function(snapshot, modal)

    inviteSnapshot = snapshot
    RefreshHudPriority()
    if modal then
        local delayedByWorld = resumeWorldModal or resumeAffiliateModal or resumeCommercialModal
        resumeWorldModal = false
        resumeAffiliateModal = false
        resumeCommercialModal = false
        CreateThread(function()
            local closedAt
            local wasBlocked = delayedByWorld
            while true do
                local combat = GetResourceState('combatsystem') == 'started'
                    and exports.combatsystem:IsInCombat({ showHint = false })
                local blocked = not CanShowMatchCity() or IsNuiFocused() or IsPauseMenuActive()
                    or IsPedInAnyVehicle(PlayerPedId(), false) or combat or not IsAliveForInvite()
                if not blocked then
                    if not wasBlocked then break end
                    closedAt = closedAt or GetGameTimer()
                    if GetGameTimer() - closedAt >= 5000 then break end
                else
                    wasBlocked = true
                    closedAt = nil
                end
                Wait(250)
            end
            if inviteSnapshot ~= snapshot or not CanShowMatchCity() or not IsAliveForInvite() then return end
            phase = 'modal'
            Focus(true)
            Nui('neighbor:invite', { snapshot = snapshot, modal = true })
            if snapshot.telemetryToken then
                TriggerServerEvent('dminigames:neighbor:inviteDisplayed', snapshot.telemetryToken)
            end
        end)
    elseif CanShowMatchCity() then
        Nui('neighbor:invite', { snapshot = snapshot, modal = false })
    end
end)

RegisterNetEvent('dminigames:neighbor:appCard', function(snapshot)
    worldAllowed = true -- O servidor validou o bucket antes de enviar o card.
    inviteSnapshot = snapshot
    inviteCollapsed = false
    phase = 'idle'
    Focus(false)
    RefreshHudPriority()
    if CanShowMatchCity() then
        Nui('neighbor:invite', { snapshot = snapshot, modal = false, expand = true })
    end
    if snapshot.telemetryToken then
        TriggerServerEvent('dminigames:neighbor:inviteDisplayed', snapshot.telemetryToken)
    end
end)

RegisterNetEvent('dminigames:neighbor:worldAllowed', function(allowed)
    if worldAllowed == (allowed == true) then return end
    worldAllowed = allowed == true
    RefreshHudPriority()
    if not worldAllowed then
        if phase == 'modal' then resumeWorldModal = true end
        if phase == 'modal' or phase == 'idle' or phase == 'queue' then
            phase = 'idle'
            Focus(false)
            Nui('neighbor:closeNui')
        end
    elseif inviteSnapshot and phase == 'idle' and CanShowMatchCity() then
        if resumeWorldModal then
            TriggerEvent('dminigames:neighbor:invite', inviteSnapshot, true)
        else
            Nui('neighbor:invite', { snapshot = inviteSnapshot, modal = false })
        end
    end
end)

AddEventHandler( 'dashboard:affiliateCommercialActiveChanged', function( active )

    if commercialActive == ( active == true ) then
        return
    end

    commercialActive = active == true

    if commercialActive then
        resumeCommercialModal = phase == 'modal'

        if phase == 'queue' then
            TriggerServerEvent( 'dminigames:neighbor:leave' )
        end

        if phase == 'modal' or phase == 'idle' or phase == 'queue' then
            phase = 'idle'
            Focus( false )
            Nui( 'neighbor:closeNui' )
            Nui( 'closeNui' )
        end

        RefreshHudPriority()
        return
    end

    RefreshHudPriority()
    if not inviteSnapshot or phase ~= 'idle' or not worldAllowed then
        return
    end

    if not CanShowMatchCity() then return end

    if resumeCommercialModal or resumeAffiliateModal then
        resumeCommercialModal = false
        resumeAffiliateModal = false
        TriggerEvent( 'dminigames:neighbor:invite', inviteSnapshot, true )
        return
    end

    Nui( 'neighbor:invite', { snapshot = inviteSnapshot, modal = false } )
end )

AddEventHandler( 'dashboard:affiliateServiceChanged', function( active )
    active = active == true
    if active then
        if phase == 'modal' then resumeAffiliateModal = true end
        if phase == 'queue' then TriggerServerEvent( 'dminigames:neighbor:leave' ) end
        if phase == 'modal' or phase == 'idle' or phase == 'queue' then
            phase = 'idle'
            Focus(false)
            Nui('neighbor:closeNui')
        end
        RefreshHudPriority()
        return
    end
    RefreshHudPriority()
    if not inviteSnapshot or phase ~= 'idle' or not CanShowMatchCity() then return end
    if resumeAffiliateModal then
        resumeAffiliateModal = false
        TriggerEvent( 'dminigames:neighbor:invite', inviteSnapshot, true )
    else
        Nui('neighbor:invite', { snapshot = inviteSnapshot, modal = false })
    end
end )

CreateThread( function()

    Wait( 0 )

    if GetResourceState( 'dashboard' ) ~= 'started' then
        return
    end

    local ok, active = pcall( function()
        return exports.dashboard:IsAffiliateCommercialActive()
    end )

    commercialActive = ok and active == true
    RefreshHudPriority()
end )
AddEventHandler('onClientResourceStart', function(resource)

    if resource == 'hud' then RefreshHudPriority() end
end)

RegisterNetEvent('dminigames:neighbor:searching', function(profile, snapshot)

    phase = 'queue'
    inviteSnapshot = snapshot or inviteSnapshot
    inviteCollapsed = false
    RefreshHudPriority()
    Focus(false)
    Nui('neighbor:setGameState', {
        phase = 'SEARCHING', currentPlayer = profile, snapshot = inviteSnapshot,
        interactionPlayers = {}, jumpsLeft = 3, jumpsCooldown = 0,
        ranking = { entries = {}, bestNeighbor = profile, currentPage = 1, totalPages = 1 },
    })
end)

RegisterNetEvent('dminigames:neighbor:rankingPosition', function(position, status, xp)

    if phase ~= 'room' and phase ~= 'matched' then return end
    Nui('neighbor:rankingPosition', { position = position, status = status, xp = xp })
end)

RegisterNetEvent('dminigames:neighbor:matched', function(data)

    phase = 'matched'
    Focus(true)
    Nui('neighbor:matched', data)
    RefreshHudPriority()
end)

RegisterNetEvent('dminigames:neighbor:enterRoom', function(data)

    TriggerEvent('inventory:CloseAll')
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 16)
        local deadline = GetGameTimer() + 3000
        while IsPedInAnyVehicle(ped, false) and GetGameTimer() < deadline do Wait(0) end
    end
    if not returnCoords then
        local coords = GetEntityCoords(ped)
        returnCoords = { x = coords.x, y = coords.y, z = coords.z, heading = GetEntityHeading(ped) }
    end
    local spawn = NeighborConfig.spawns[data.seat]
    SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false)
    SetEntityHeading(ped, spawn.heading)
    FreezeEntityPosition(ped, false)
    SetEntityCollision(ped, true, true)
    SetEntityVisible(ped, true, false)
    ResetEntityAlpha(ped)
    SetCurrentPedWeapon(ped, joaat('WEAPON_UNARMED'), true)
    SetEntityInvincible(ped, true)
    LocalPlayer.state:set('matchcity:house', true, true)
    TriggerEvent('Notify:Text', '')
    LockRoomDoors()
    phase = 'room'
    waitingForPartner = false
    roomState = {
        phase = 'INTERACTION', currentPlayer = data.players[data.seat],
        interactionPlayers = data.players, jumpsLeft = data.jumpsLeft, jumpsCooldown = 0,
        ranking = { entries = {}, bestNeighbor = data.players[data.seat], currentPage = 1, totalPages = 1 },
    }
    Focus(false)
    Nui('neighbor:setGameState', roomState)
    ClosePartnerProfile()
    TriggerServerEvent('dminigames:neighbor:roomVisible', data.matchToken)
    if data.confirmation then
        phase = 'matched'
        Focus(true)
        Nui('neighbor:matched', {
            matchToken = data.matchToken,
            other = data.confirmation.other,
            deadline = data.confirmation.deadline,
        })
        RefreshHudPriority()
    end
end)

RegisterNetEvent('dminigames:neighbor:confirmationAccepted', function()

    if phase ~= 'matched' or not roomState then return end
    phase = 'room'
    Focus(false)
    Nui('neighbor:setGameState', roomState)
    RefreshHudPriority()
end)

RegisterNetEvent('dminigames:neighbor:waitingConfirmation', function(deadline)

    if phase ~= 'room' then return end
    waitingForPartner = true
    Nui('neighbor:waitingConfirmation', { deadline = deadline })
end)

RegisterNetEvent('dminigames:neighbor:partnerLeft', function()

    if phase ~= 'room' or not roomState then return end
    TriggerEvent('hud:matchCity:cancelContactRequests')
    waitingForPartner = true
    tableWaiting = false
    ClosePartnerProfile()
    roomState.interactionPlayers = { roomState.currentPlayer }
    Nui('neighbor:partnerLeft')
end)

RegisterNetEvent('dminigames:neighbor:contactSaved', function(name)

    if phase ~= 'room' then return end
    Nui('neighbor:contactSaved', { name = name })
end)

-- O perfil abre quando os dois jogadores aparecem na casa.
RegisterNetEvent('dminigames:neighbor:houseStarted', function()

    if phase ~= 'room' then return end
    waitingForPartner = false
    Nui('neighbor:allConfirmed')
    OpenPartnerProfile()
end)

RegisterNetEvent('dminigames:neighbor:notify', function(message)

    NotifyMatch(message)
end)

RegisterNetEvent('dminigames:neighbor:completion', function(data)

    if inviteSnapshot then
        inviteSnapshot.progress = data.progress
        RefreshHudPriority()
    end
    Nui('neighbor:completion', data)
end)

RegisterNetEvent('dminigames:neighbor:unoWaiting', function()

    tableWaiting = true
    Nui('neighbor:tableWaiting')
end)

RegisterNetEvent('dminigames:neighbor:unoCountdown', function(seconds)

    ClosePartnerProfile()
    phase = 'countdown'
    tableWaiting = false
    Focus(false)
    Nui('neighbor:countdown', { seconds = seconds })
end)

RegisterNetEvent('dminigames:neighbor:unoStart', function()

    ClosePartnerProfile()
    resultOpen = false
    exitPromptOpen = false
    phase = 'uno'
    Nui('uno:searchingPlayers', { currentPlayers = 2, maxPlayers = 2 })
    Focus(true)
end)

RegisterNetEvent('dminigames:neighbor:unoState', function(state)

    Nui('uno:updateGameState', state)
end)

RegisterNetEvent('dminigames:neighbor:unoSound', function(sound)

    if phase ~= 'uno' or (sound ~= 'card' and sound ~= 'hand' and sound ~= 'announcement') then return end
    Nui('neighbor:unoSound', { sound = sound })
end)

RegisterNetEvent('dminigames:neighbor:unoEnd', function(data)

    Nui('uno:gameEnd', data)
end)

RegisterNetEvent('dminigames:neighbor:unoAnnounced', function(player)

    if phase ~= 'uno' then return end
    Nui('uno:announced', player)
end)

RegisterNetEvent('dminigames:neighbor:unoStop', function(data)

    phase = 'room'
    tableWaiting = false
    if data and data.cancelled then
        resultOpen = false
        Focus(false)
        if roomState then Nui('neighbor:setGameState', roomState) end
        Nui('neighbor:tableCancelled')
        return
    end
    resultOpen = true
    Focus(true)
    if roomState then Nui('neighbor:setGameState', roomState) end
    Nui('neighbor:roundResult', data)
end)

RegisterNetEvent('dminigames:neighbor:leave', Close)

-- factionfocus v3 desligada: some o convite; quem está na casa/Cartada segue até sair.
RegisterNetEvent('dminigames:neighbor:disabled', function()

    inviteSnapshot = nil
    if phase == 'idle' or phase == 'modal' or phase == 'queue' then Close() else RefreshHudPriority() end
end)

local function HandleMatchCityQueueKey()

    if not CanUseMatchCard() then return false end
    local now = GetGameTimer()
    if now - lastMatchQueueKeyAt < 100 then return true end
    lastMatchQueueKeyAt = now
    if phase == 'queue' then
        TriggerServerEvent('dminigames:neighbor:leave')
    elseif phase == 'idle' and inviteSnapshot and (inviteSnapshot.progress or 0) < 3 then
        TriggerServerEvent('dminigames:neighbor:join', 'card')
    end
    return true
end

exports('HandleMatchCityQueueKey', HandleMatchCityQueueKey)
RegisterCommand('+matchcityqueue', HandleMatchCityQueueKey)
RegisterCommand('-matchcityqueue', function() end)
RegisterKeyMapping('+matchcityqueue', T('key_queue'), 'keyboard', 'Q')

RegisterCommand('+matchcity_card_toggle', function()

    if not CanShowMatchCity() and (phase == 'queue' or phase == 'idle') then return end
    if inviteSnapshot and (phase == 'queue' or phase == 'idle') then
        if not gMatchCardActive or IsNuiFocused() or IsPauseMenuActive() then return end
        inviteCollapsed = not inviteCollapsed
        Nui('neighbor:collapse', { collapsed = inviteCollapsed })
        TriggerServerEvent('dminigames:neighbor:cardVisibility', inviteCollapsed)
    elseif phase == 'room' then
        if waitingForPartner then
            NotifyMatch(T('searching_house'))
            return
        end
        Focus(true)
        Nui('neighbor:skipPrompt')
    elseif phase == 'uno' then
        NotifyMatch(T('finish_round'))
    end
end)
RegisterCommand('-matchcity_card_toggle', function() end)
RegisterKeyMapping('+matchcity_card_toggle', T('key_toggle'), 'keyboard', 'U')

RegisterCommand('+matchcityprofile', function()

    if exitPromptOpen or resultOpen or (IsNuiFocused() and not profileFocused) then return end
    OpenPartnerProfile(nil, true)
end)
RegisterCommand('-matchcityprofile', function() end)
RegisterKeyMapping('+matchcityprofile', T('key_profile'), 'keyboard', 'LMENU')

AddEventHandler('dminigames:neighbor:openProfileFromInteraction', function(targetSource)

    OpenPartnerProfile(targetSource, true)
end)

AddEventHandler('dminigames:neighbor:profileClosed', function()

    profileOpen = false
    profileFocused = false
end)

AddEventHandler('dminigames:neighbor:requestContactFromInteraction', function(targetSource)

    if MatchPartnerSource() ~= targetSource then return end
    TriggerServerEvent('dminigames:neighbor:requestContact', targetSource)
end)

local function NearbyTable()

    local coords = GetEntityCoords(PlayerPedId())
    local target = NeighborConfig.table
    return #(coords - vector3(target.x, target.y, target.z)) <= 2.2
end

CreateThread(function()

    while true do
        if phase == 'room' or phase == 'uno' or phase == 'countdown' then
            adminOne = tonumber(neighborVrp.GetPlayerGroups()['Admin']) == 1
            LockRoomDoors()
        end

        Wait(1000)
    end
end)

CreateThread(function()

    while true do
        if phase == 'modal' then
            if not IsAliveForInvite() then
                local snapshot = inviteSnapshot
                phase = 'idle'
                Focus(false)
                Nui('neighbor:closeNui')
                if snapshot then TriggerEvent('dminigames:neighbor:invite', snapshot, true) end
            else
                DisableAllControlActions(0)
                DisablePlayerFiring(PlayerId(), true)
            end
            Wait(0)
        elseif phase == 'room' or phase == 'uno' or phase == 'countdown' then
            local ped = PlayerPedId()
            for entity, model in pairs(roomDoors) do
                if DoesEntityExist(entity) and (GetEntityModel(entity) & 0xFFFFFFFF) == model then
                    FreezeEntityPosition(entity, true)
                else
                    roomDoors[entity] = nil
                end
            end
            if IsEntityDead(ped) and not deathRecoveryPending then
                deathRecoveryPending = true
                local safe = NeighborConfig.spawns[1]
                NetworkResurrectLocalPlayer(safe.x, safe.y, safe.z, safe.heading)
                SetEntityHealth(PlayerPedId(), 200)
                TriggerServerEvent('dminigames:neighbor:death')
            end
            if not adminOne then
                DisablePlayerFiring(PlayerId(), true)
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                DisableControlAction(0, 37, true)
                DisableControlAction(0, 140, true)
                DisableControlAction(0, 141, true)
                DisableControlAction(0, 142, true)
                DisableControlAction(0, 257, true)
                SetCurrentPedWeapon(ped, joaat('WEAPON_UNARMED'), true)
                SetEntityInvincible(ped, true)
            end
            if phase == 'room' then
                DisableControlAction(0, 200, true)
                if not IsNuiFocused() and IsDisabledControlJustPressed(0, 200) then
                    OpenExitPrompt()
                end
            end
            HideHudAndRadarThisFrame()
            local coords = GetEntityCoords(ped)
            local house = NeighborConfig.house
            if not adminOne and #(coords - vector3(house.x, house.y, house.z)) > house.radius then
                local safe = NeighborConfig.spawns[1]
                SetEntityCoordsNoOffset(ped, safe.x, safe.y, safe.z, false, false, false)
            end
            if phase == 'room' and not waitingForPartner then
                if not tableWaiting then DrawTableDui() end
            end
            if phase == 'room' and not waitingForPartner and NearbyTable() then
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName(tableWaiting and T('table_wait')
                    or T('table_play'))
                EndTextCommandDisplayHelp(0, false, false, -1)
                if not tableWaiting and IsControlJustPressed(0, 38) then
                    TriggerServerEvent('dminigames:neighbor:unoReady')
                end
            end
            if ((phase == 'room' and tableWaiting) or phase == 'countdown')
                and (IsControlJustPressed(0, 38) or IsControlJustPressed(0, 47)) then
                TriggerServerEvent('dminigames:neighbor:unoQuit')
            end
            if phase == 'uno' and IsControlJustPressed(0, 47) then
                TriggerServerEvent('dminigames:neighbor:unoQuit')
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)

CreateThread(function()

    while true do
        Wait(10000)
        if phase == 'room' or phase == 'uno' or phase == 'countdown' then
            -- A cidade também considera input/mouse/NUI. Não exigir deslocamento para contar atividade.
            TriggerServerEvent('dminigames:neighbor:activePulse', NetworkIsPlayerTalking(PlayerId()))
        else
            lastMoveCoords = nil
        end
    end
end)

RegisterNUICallback('neighbor:closeSearch', function(_, cb)

    TriggerServerEvent('dminigames:neighbor:leave')
    cb({ success = true })
end)
RegisterNUICallback('neighbor:inviteChoice', function(data, cb)

    phase = 'idle'
    Focus(false)
    TriggerServerEvent('dminigames:neighbor:inviteChoice', data.accept == true)
    cb({ success = true })
end)
RegisterNUICallback('neighbor:joinQueue', function(_, cb)

    local canJoin = phase == 'idle' and inviteSnapshot and (inviteSnapshot.progress or 0) < 3
        and CanUseMatchCard()
    if canJoin then TriggerServerEvent('dminigames:neighbor:join', 'card') end
    cb({ success = canJoin == true })
end)
RegisterNUICallback('neighbor:confirm', function(data, cb)

    if phase == 'matched' then
        TriggerServerEvent('dminigames:neighbor:confirm', data.matchToken)
    end
    cb({ success = true })
end)
RegisterNUICallback('neighbor:cancelSkip', function(_, cb)

    Focus(false)
    cb({ success = true })
end)
RegisterNUICallback('neighbor:closeComplete', function(_, cb)

    inviteSnapshot = nil
    RefreshHudPriority()
    Nui('closeNui')
    cb({ success = true })
end)
RegisterNUICallback('neighbor:exitInteraction', function(_, cb)

    TriggerServerEvent('dminigames:neighbor:leave')
    cb({ success = true })
end)
RegisterNUICallback('neighbor:requestExit', function(_, cb)

    if phase == 'room' or phase == 'uno' or phase == 'countdown' then
        OpenExitPrompt()
    end
    cb({ success = true })
end)
RegisterNUICallback('neighbor:cancelExit', function(_, cb)

    exitPromptOpen = false
    Focus(phase == 'uno' or resultOpen)
    cb({ success = true })
end)
RegisterNUICallback('neighbor:closeRoundResult', function(_, cb)

    resultOpen = false
    Focus(false)
    cb({ success = true })
end)
RegisterNUICallback('neighbor:skipPerson', function(_, cb)

    TriggerServerEvent('dminigames:neighbor:skip')
    cb({ success = true })
end)
RegisterNUICallback('neighbor:startUno', function(_, cb)

    if NearbyTable() then TriggerServerEvent('dminigames:neighbor:unoReady') end
    cb({ success = true })
end)
RegisterNUICallback('uno:playCard', function(data, cb)

    TriggerServerEvent('dminigames:neighbor:unoPlay', data.cardId, data.chosenColor)
    cb({ success = true })
end)
RegisterNUICallback('uno:drawCard', function(_, cb)

    TriggerServerEvent('dminigames:neighbor:unoDraw')
    cb({ success = true })
end)
RegisterNUICallback('uno:callUno', function(_, cb)

    TriggerServerEvent('dminigames:neighbor:unoCall')
    cb({ success = true })
end)
RegisterNUICallback('uno:quitGame', function(_, cb)

    TriggerServerEvent('dminigames:neighbor:unoQuit')
    cb({ success = true })
end)

AddEventHandler('onResourceStop', function(resource)

    if resource == GetCurrentResourceName() then
        inviteSnapshot = nil
        RefreshHudPriority()
        Close()
    end
end)
