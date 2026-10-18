local function IsMatchCityEnabled()
    if GetResourceState('dminigames') ~= 'started' then return false end
    local ok, enabled = pcall(function() return exports.dminigames:IsMatchCityEnabled() end)
    return ok and enabled == true
end

local gMatchPanelOpen = false
local gMatchPanelSpec = nil
local gMatchPanelPedState = nil
local gMatchPanelGeneration = 0
local gMatchPanelOpening = false
local gMatchPanelProbe = 0
local gMatchPanelReady = 0

local function OpeningFailure(reason)
    sx.logger:warn(('MatchPanel opening failed: %s'):format(tostring(reason)))
    local key = (reason == 'forbidden' or reason == 'busy' or reason == 'ui_unavailable')
        and reason or 'unavailable'
    TriggerEvent('Notify', 'vermelho', _t(('matchPanel.%s'):format(key)), 5000)
end

RegisterNUICallback('matchPanel:ready', function(data, cb)
    if type(data) == 'table' and data.probe == gMatchPanelProbe then
        gMatchPanelReady = data.probe
    end
    cb({ ok = true })
end)

local function Close()
    if not gMatchPanelOpen then return end
    gMatchPanelOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ action = 'matchPanel:close' })
end

local function StopSpec()
    gMatchPanelGeneration = gMatchPanelGeneration + 1
    if gMatchPanelSpec then NetworkSetInSpectatorMode(false, PlayerPedId()) end
    gMatchPanelSpec = nil
    if gMatchPanelPedState then
        local ped = PlayerPedId()
        SetEntityVisible(ped, gMatchPanelPedState.visible, false)
        FreezeEntityPosition(ped, gMatchPanelPedState.frozen)
        gMatchPanelPedState = nil
    end
end

RegisterCommand('painelmatch', function()
    if not IsMatchCityEnabled() then return end
    if gMatchPanelOpening then return end
    if gMatchPanelOpen then Close(); vSERVER.MatchPanelRequest('close', {}); return end
    gMatchPanelOpening = true
    CreateThread(function()
        -- Deixa o callback do chat terminar, sem retirar o foco de outra interface.
        Wait(0)
        local ok, err = pcall(function()
            if IsNuiFocused() or IsPauseMenuActive() then OpeningFailure('busy'); return end
            local result = vSERVER.MatchPanelRequest('open', {})
            if type(result) ~= 'table' or not result.ok then
                OpeningFailure(type(result) == 'table' and result.error or 'unavailable')
                return
            end
            gMatchPanelProbe = gMatchPanelProbe + 1
            local deadline = GetGameTimer() + 3000
            repeat
                SendNUIMessage({ action = 'matchPanel:probe', probe = gMatchPanelProbe })
                Wait(100)
            until gMatchPanelReady == gMatchPanelProbe or GetGameTimer() >= deadline
            if gMatchPanelReady ~= gMatchPanelProbe then
                vSERVER._MatchPanelRequest('close', {})
                OpeningFailure('ui_unavailable')
                return
            end
            if IsNuiFocused() or IsPauseMenuActive() then
                vSERVER._MatchPanelRequest('close', {})
                OpeningFailure('busy')
                return
            end
            gMatchPanelOpen = true
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
            SendNUIMessage({ action = 'matchPanel:open', data = result, locale = GetConvar('language', 'en-us') })
        end)
        gMatchPanelOpening = false
        if not ok then OpeningFailure(err) end
    end)
end, false)

RegisterNUICallback('matchPanel:request', function(data, cb)
    if not gMatchPanelOpen or type(data) ~= 'table' then cb({ ok = false, error = 'closed' }); return end
    if data.action == 'close' then Close() end
    local ok, result = pcall(function() return vSERVER.MatchPanelRequest(data.action, data.payload or {}) end)
    if not ok then cb({ ok = false, error = 'unavailable' }); return end
    if result and (result.error == 'forbidden' or result.error == 'closed') then Close() end
    cb(result or { ok = false, error = 'unavailable' })
end)

RegisterNetEvent('dashboard:matchPanel:close', Close)
RegisterNetEvent('dashboard:matchPanel:visit', function(data)
    StopSpec()
    if not data or not data.spec then
        SendNUIMessage({ action = 'matchPanel:visitStopped' })
        return
    end
    local ped = PlayerPedId()
    gMatchPanelPedState = { visible = IsEntityVisible(ped), frozen = IsEntityPositionFrozen(ped) }
    SetEntityVisible(ped, false, false)
    FreezeEntityPosition(ped, true)
    local generation = gMatchPanelGeneration
    CreateThread(function()
        local deadline = GetGameTimer() + 5000
        while generation == gMatchPanelGeneration and GetGameTimer() < deadline do
            local player = GetPlayerFromServerId(data.source)
            if player ~= -1 and DoesEntityExist(GetPlayerPed(player)) then
                gMatchPanelSpec = data.source
                NetworkSetInSpectatorMode(true, GetPlayerPed(player))
                return
            end
            Wait(100)
        end
        if generation == gMatchPanelGeneration then
            StopSpec()
            vSERVER.MatchPanelRequest('stopSpec', {})
        end
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    Close()
    StopSpec()
end)
