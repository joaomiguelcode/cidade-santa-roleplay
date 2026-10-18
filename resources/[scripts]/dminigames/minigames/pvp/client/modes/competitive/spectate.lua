---Client spectator mode used by PVP tournaments.

local spectateState = {
    active = false,
    targetSource = nil,
    returnCoords = nil,
    threadRunning = false,
    tournamentSupervisor = false,
    noclip = false,
    supervisorInputAt = {},
}

local SPECTATE_Z_OFFSET = 99.0
local SPECTATE_TARGET_TIMEOUT_MS = 10000
local SPECTATE_SCENE_LOAD_TIMEOUT_MS = 3000
local SUPERVISOR_INPUT_DEBOUNCE_MS = 500

local function pvpText(key, ...)
    return PvpTranslations.get(key, ...)
end

local function setLocalSpectateState(active)
    LocalPlayer['state']:set('dminigames:spectating', active and 'pvp' or nil, true)
end

local function setPedSpectatorState(active)
    local ped = PlayerPedId()

    SetEntityVisible(ped, not active, false)
    SetEntityCollision(ped, not active, not active)
    SetEntityInvincible(ped, active)
    FreezeEntityPosition(ped, active)
    DisablePlayerFiring(PlayerId(), active)
end

local function applyReturnCoords(coords)
    if not (coords and coords.x and coords.y and coords.z) then return end

    local ped = PlayerPedId()
    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, coords.w or 0.0)
end

local function notifyText(text)
    TriggerEvent('Notify:Text', text or '')
end

local function nuiHud(action, payload)
    TriggerEvent('pvp.hud:' .. action, payload)
end

local function closePvpPanel()
    TriggerEvent('pvp.client:forceClosePanel')
    SetNuiFocus(false, false)
end

local function canUseSupervisorInput(key, debounceMs)
    if not spectateState.tournamentSupervisor then return false end

    local now = GetGameTimer()
    local lastAt = spectateState.supervisorInputAt[key] or 0
    if now - lastAt < (debounceMs or SUPERVISOR_INPUT_DEBOUNCE_MS) then
        return false
    end

    spectateState.supervisorInputAt[key] = now
    return true
end

local function isNoClipActive()
    return vRP and vRP.ReturnNoClip and vRP.ReturnNoClip() == true
end

local function setNoClipActive(active)
    if not (vRP and vRP.noClip and vRP.ReturnNoClip) then
        return false
    end

    if isNoClipActive() ~= (active == true) then
        vRP.noClip()
    end

    return isNoClipActive()
end

local function setSupervisorNoclip(active, options)
    options = type(options) == 'table' and options or {}
    active = active == true

    if active then
        NetworkSetInSpectatorMode(false)
        setPedSpectatorState(false)
        spectateState.noclip = setNoClipActive(true)
    else
        setNoClipActive(false)
        spectateState.noclip = false
    end

    nuiHud('setTournamentSupervisorNoclip', { active = spectateState.noclip == true })

    if not active and not options.skipRefresh and spectateState.active then
        TriggerServerEvent('pvp.spectate:refreshTarget')
    end

    return spectateState.noclip == true
end

local function requestSupervisorManager()
    if not canUseSupervisorInput('manager') then return end

    CreateThread(function()
        local success, message = RPC.pvp_tournamentSupervisorOpenManager()
        if not success and message then
            notifyText(message)
        end
    end)
end

local function requestSupervisorExitConfirm()
    if not canUseSupervisorInput('exit') then return end

    CreateThread(function()
        local success, message = RPC.pvp_tournamentSupervisorOpenExitConfirm()
        if not success and message then
            notifyText(message)
        end
    end)
end

local function toggleSupervisorNoclip()
    if not canUseSupervisorInput('noclip') then return end
    setSupervisorNoclip(not spectateState.noclip)
end

local function closeSupervisorModal()
    if not canUseSupervisorInput('close', 200) then return end

    nuiHud('closeTournamentSupervisorManager')
    nuiHud('closeTournamentSupervisorExitConfirm')
end

local function requestExitSpectate()
    if not spectateState.active then return end
    TriggerServerEvent('pvp.spectate:exit')
end

local function ensureSpectateThread()
    if spectateState.threadRunning then return end

    spectateState.threadRunning = true

    CreateThread(function()
        while spectateState.active do
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 24, true)  -- attack
            DisableControlAction(0, 25, true)  -- aim
            DisableControlAction(0, 37, true)  -- weapon wheel
            DisableControlAction(0, 44, true)  -- cover
            DisableControlAction(0, 140, true) -- melee
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 142, true)

            if IsDisabledControlJustPressed(0, 37) then
                ExecuteCommand('+dminigames_competitive_scoreboard')
            elseif IsDisabledControlJustReleased(0, 37) then
                ExecuteCommand('-dminigames_competitive_scoreboard')
            end

            if spectateState.tournamentSupervisor then
                DisableControlAction(0, 199, true) -- P / pause
                DisableControlAction(2, 199, true)
                DisableControlAction(0, 47, true)  -- G
                DisableControlAction(2, 47, true)
                DisableControlAction(0, 22, true)  -- Space
                DisableControlAction(2, 22, true)
                DisableControlAction(0, 322, true) -- Esc
                DisableControlAction(2, 322, true)
                DisableControlAction(0, 200, true)
                DisableControlAction(2, 200, true)

                if IsDisabledControlJustPressed(0, 199) or IsDisabledControlJustPressed(2, 199) then
                    requestSupervisorManager()
                elseif IsDisabledControlJustPressed(0, 47) or IsDisabledControlJustPressed(2, 47) then
                    requestSupervisorExitConfirm()
                elseif IsDisabledControlJustPressed(0, 22) or IsDisabledControlJustPressed(2, 22) then
                    toggleSupervisorNoclip()
                elseif IsDisabledControlJustPressed(0, 322) or IsDisabledControlJustPressed(2, 322)
                    or IsDisabledControlJustPressed(0, 200) or IsDisabledControlJustPressed(2, 200)
                then
                    closeSupervisorModal()
                end

                if IsPauseMenuActive() then
                    SetPauseMenuActive(false)
                end
            end

            Wait(0)
        end

        spectateState.threadRunning = false
    end)
end

local function waitForTargetPed(targetSource)
    local timeoutAt = GetGameTimer() + SPECTATE_TARGET_TIMEOUT_MS
    local playerId = -1
    local targetPed = 0

    repeat
        playerId = GetPlayerFromServerId(targetSource)
        if playerId ~= -1 then
            targetPed = GetPlayerPed(playerId)
        end

        if targetPed and targetPed ~= 0 and DoesEntityExist(targetPed) then
            return targetPed
        end

        Wait(0)
    until GetGameTimer() >= timeoutAt

    return nil
end

local function setSpectateTarget(data, isInitial)
    data = type(data) == 'table' and data or {}

    local targetSource = tonumber(data.targetSource)
    if not targetSource then
        requestExitSpectate()
        return
    end

    local targetCoords = data.targetCoords
    local hasTargetCoords = targetCoords
        and targetCoords.x
        and targetCoords.y
        and targetCoords.z
    local sceneLoadStarted = false

    if hasTargetCoords then
        NewLoadSceneStop()
        ClearFocus()
        sceneLoadStarted = NewLoadSceneStart(
            targetCoords.x,
            targetCoords.y,
            targetCoords.z,
            0.0,
            0.0,
            0.0,
            50.0,
            0
        ) == true
        SetEntityCoordsNoOffset(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z + SPECTATE_Z_OFFSET, false, false, false)
    end

    spectateState.targetSource = targetSource

    if spectateState.noclip then
        if hasTargetCoords then
            NewLoadSceneStop()
            SetFocusArea(targetCoords.x, targetCoords.y, targetCoords.z, 0.0, 0.0, 0.0)
            ClearFocus()
        end

        return
    end

    setPedSpectatorState(true)

    local targetPed = waitForTargetPed(targetSource)
    if not targetPed then
        NewLoadSceneStop()
        ClearFocus()
        requestExitSpectate()
        return
    end

    if hasTargetCoords then
        local sceneLoadTimeoutAt = GetGameTimer() + SPECTATE_SCENE_LOAD_TIMEOUT_MS

        while spectateState.active
            and sceneLoadStarted
            and not IsNewLoadSceneLoaded()
            and GetGameTimer() < sceneLoadTimeoutAt
        do
            Wait(0)
        end

        NewLoadSceneStop()
        SetFocusArea(targetCoords.x, targetCoords.y, targetCoords.z, 0.0, 0.0, 0.0)
    end

    if not spectateState.active then
        ClearFocus()
        return
    end

    NetworkSetInSpectatorMode(true, targetPed)

    if hasTargetCoords then
        ClearFocus()
    end

    if isInitial then
        ensureSpectateThread()
    end
end

local function stopLocalSpectate(data)
    data = type(data) == 'table' and data or {}

    if not spectateState.active then
        NetworkSetInSpectatorMode(false)
        NewLoadSceneStop()
        ClearFocus()
        setPedSpectatorState(false)
        setLocalSpectateState(false)
        nuiHud('closeTournamentSupervisor')
        return
    end

    setSupervisorNoclip(false, { skipRefresh = true })
    spectateState.active = false
    spectateState.targetSource = nil
    spectateState.tournamentSupervisor = false
    spectateState.supervisorInputAt = {}

    NetworkSetInSpectatorMode(false)
    NewLoadSceneStop()
    ClearFocus()
    setPedSpectatorState(false)
    setLocalSpectateState(false)
    ExecuteCommand('-dminigames_competitive_scoreboard')
    TriggerEvent('pvp.competitive:spectateHudStop')
    nuiHud('closeTournamentSupervisor')
    notifyText('')

    applyReturnCoords(data.returnCoords or spectateState.returnCoords)
    spectateState.returnCoords = nil
end

RegisterNetEvent('pvp.spectate:start')
AddEventHandler('pvp.spectate:start', function(data)
    data = type(data) == 'table' and data or {}

    closePvpPanel()
    spectateState.active = true
    spectateState.tournamentSupervisor = data.tournamentSupervisor == true
    spectateState.returnCoords = data.returnCoords or spectateState.returnCoords or GetEntityCoords(PlayerPedId())
    setLocalSpectateState(true)
    setSpectateTarget(data, true)
end)

RegisterNetEvent('pvp.spectate:setTarget')
AddEventHandler('pvp.spectate:setTarget', function(data)
    if not spectateState.active then return end
    setSpectateTarget(data, false)
end)

RegisterNetEvent('pvp.spectate:stop')
AddEventHandler('pvp.spectate:stop', stopLocalSpectate)

RegisterNetEvent('pvp.tournamentSupervisor:open')
AddEventHandler('pvp.tournamentSupervisor:open', function(payload)
    spectateState.tournamentSupervisor = true
    nuiHud('openTournamentSupervisor', payload or {})
end)

RegisterNetEvent('pvp.tournamentSupervisor:update')
AddEventHandler('pvp.tournamentSupervisor:update', function(payload)
    if not spectateState.tournamentSupervisor then return end
    nuiHud('updateTournamentSupervisor', payload or {})
end)

RegisterNetEvent('pvp.tournamentSupervisor:close')
AddEventHandler('pvp.tournamentSupervisor:close', function()
    setSupervisorNoclip(false, { skipRefresh = true })
    spectateState.tournamentSupervisor = false
    nuiHud('closeTournamentSupervisor')
end)

RegisterNetEvent('pvp.tournamentSupervisor:openManager')
AddEventHandler('pvp.tournamentSupervisor:openManager', function()
    if not spectateState.tournamentSupervisor then return end
    nuiHud('openTournamentSupervisorManager')
end)

RegisterNetEvent('pvp.tournamentSupervisor:openExitConfirm')
AddEventHandler('pvp.tournamentSupervisor:openExitConfirm', function()
    if not spectateState.tournamentSupervisor then return end
    nuiHud('openTournamentSupervisorExitConfirm')
end)

RegisterNetEvent('pvp.tournamentSupervisor:setNoclip')
AddEventHandler('pvp.tournamentSupervisor:setNoclip', function(data)
    data = type(data) == 'table' and data or {}
    setSupervisorNoclip(data.active == true, { skipRefresh = true })
end)

local function sendSupervisorCallbackResponse(requestId, success, message)
    if not requestId then return end

    TriggerEvent('pvp.hud:callbackResponse', requestId, {
        success = success == true,
        message = success == true and nil or message,
    })
end

AddEventHandler('pvp.callback:tournamentSupervisorApplyAndRestart', function(data, requestId)
    sendSupervisorCallbackResponse(requestId, true)

    CreateThread(function()
        local success, message = RPC.pvp_tournamentSupervisorApplyAndRestart(data or {})
        if not success and message then
            notifyText(message)
        end
    end)
end)

AddEventHandler('pvp.callback:tournamentSupervisorPause', function(data, requestId)
    sendSupervisorCallbackResponse(requestId, true)

    CreateThread(function()
        local success, message = RPC.pvp_tournamentSupervisorPause()
        if not success and message then
            notifyText(message)
        end
    end)
end)

AddEventHandler('pvp.callback:tournamentSupervisorExit', function(data, requestId)
    local success, message = RPC.pvp_tournamentSupervisorExit()
    sendSupervisorCallbackResponse(requestId, success, message)
end)

RegisterCommand('pvp.spectate.exit', function()
    requestExitSpectate()
end)

RegisterCommand('pvp.spectate.next', function()
    if spectateState.active then
        TriggerServerEvent('pvp.spectate:switch', 'next')
    end
end)

RegisterCommand('pvp.spectate.previous', function()
    if spectateState.active then
        TriggerServerEvent('pvp.spectate:switch', 'previous')
    end
end)

RegisterKeyMapping('pvp.spectate.exit', pvpText('spectate_key_exit'), 'keyboard', 'BACK')
RegisterKeyMapping('pvp.spectate.next', pvpText('spectate_key_next'), 'keyboard', 'RIGHT')
RegisterKeyMapping('pvp.spectate.previous', pvpText('spectate_key_previous'), 'keyboard', 'LEFT')

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    stopLocalSpectate({ returnCoords = spectateState.returnCoords })
end)
