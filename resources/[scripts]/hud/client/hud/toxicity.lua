-- ENG-3437: apresentacao na HUD. Pontuacao, confirmacoes e relogio pertencem ao servidor.
-- Desativa guards da versao anterior caso ainda estejam carregados em outras NUIs.
LocalPlayer.state:set('toxicityModal', false, false)
local gNotice = nil
local gModalOpen = false
local gMuted = false
local gSlotActive = false
local gReady = false
local gSynced = false
local gQueue = {}
local gLastTalkSound = -5000
local gTalkPressed = false
local gAckCallback = nil
local gAutomaticModal = nil

---@param active boolean
local function SetSlot( active )
    if gSlotActive == active then return end
    gSlotActive = active
    TriggerEvent( 'hud:toxicity:priorityChanged', active )
end

---@return nil
local function RefreshSlot()
    SetSlot( gMuted or ( gNotice ~= nil and (not gNotice.ackId or gNotice.nonBlocking) ) )
end

---@return nil
local function CloseNotice()
    if gAckCallback then
        gAckCallback({ ok = false })
        gAckCallback = nil
    end
    gQueue.toxicity = nil
    gNotice = nil
    if gModalOpen then
        gModalOpen = false
        SetNuiFocus( false, false )
    end
    SendNUIMessage( { action = 'toxicity:hideNotice' } )
    RefreshSlot()
end

---@param data table
---@return table copy
local function NoticeCopy( data )
    local kind = data.level or ( data.degree == 3 and 'island' or 'mute' )
    local time = data.degree == 3 and math.floor( data.islandSeconds / 3600 )
        or math.floor( ( data.muteSeconds or 0 ) / 60 )
    return {
        kind = kind,
        badge = _t( kind == 'attention' and 'hud.toxicity.attention.badge'
            or kind == 'last_warning' and 'hud.toxicity.last_warning.badge' or 'hud.toxicity.punishment' ),
        tag = _t( 'hud.toxicity.tag' ),
        title = _t( ('hud.toxicity.%s.title'):format( kind ) ):format( time ),
        body = _t( ('hud.toxicity.%s.body'):format( kind ) ),
        detail = _t( ('hud.toxicity.%s.detail'):format( kind ) ):format( time ),
        footer = _t( kind == 'last_warning' and 'hud.toxicity.last_warning.footer' or 'hud.toxicity.footer' ),
        confirm = _t( 'hud.toxicity.confirm' ),
    }
end

---@param data table
local function PresentNotice( data )
    if gNotice ~= data then return end
    local modal = data.ackId ~= nil and not data.nonBlocking
    if modal then
        if gAutomaticModal then
            local previous = gAutomaticModal
            gAutomaticModal = nil
            TriggerEvent(previous.name == 'punishment' and 'hud:punishmentModal:close' or 'hud:recruitmentPunishmentModal:close')
            gQueue[previous.name] = previous.show
        end
        gModalOpen = true
        SetNuiFocus( true, true )
    end
    SendNUIMessage( {
        action = 'toxicity:notice',
        data = { ackId = data.ackId, presentationId = data.presentationId, modal = modal, duration = data.duration or 60, copy = NoticeCopy( data ) },
    } )
    RefreshSlot()
    if not modal then
        SetTimeout( ( data.duration or 60 ) * 1000, function()
            if gNotice == data then CloseNotice() end
        end )
    end
end

---@param data table
local function ReceiveNotice( data )
    if type( data ) ~= 'table' then return end
    if gNotice and data.ackId and data.ackId == gNotice.ackId then return end
    if data.level == 'attention' and ( gMuted or gNotice ) then return end

    CloseNotice()
    gNotice = data
    if data.ackId and not data.nonBlocking then
        gQueue.toxicity = function() PresentNotice( data ) end
    elseif gReady and LocalPlayer.state.Active then
        PresentNotice( data )
    else
        -- Atencao nao reabre depois do spawn ou de uma tela de carregamento.
        gNotice = nil
    end
end

RegisterNetEvent( 'toxicity:warn', ReceiveNotice )
RegisterNetEvent( 'toxicity:punish', ReceiveNotice )
RegisterNetEvent( 'toxicity:muteState', function( data )
    if type( data ) ~= 'table' then return end
    gMuted = data.active == true
    SendNUIMessage( { action = 'toxicity:muteState', data = {
        active = gMuted,
        remainingSeconds = data.remainingSeconds,
        title = _t( 'hud.toxicity.punishment' ),
        tag = _t( 'hud.toxicity.tag' ),
        body = _t( 'hud.toxicity.card.body' ),
        remainingLabel = _t( 'hud.toxicity.card.remaining' ),
    } } )
    RefreshSlot()
end )
RegisterNetEvent( 'toxicity:clear', function()
    gMuted = false
    SendNUIMessage({action='toxicity:muteState',data={active=false,remainingSeconds=0}})
    if not gNotice or not gNotice.ackId or gNotice.nonBlocking then CloseNotice() end
    RefreshSlot()
end )

RegisterNUICallback( 'toxicity:ack', function( data, callback )
    if not gNotice or not gModalOpen or data.ackId ~= gNotice.ackId then
        callback( { ok = false } )
        return
    end
    if gAckCallback then callback({ ok = false }); return end
    gAckCallback = callback
    TriggerServerEvent( 'toxicity:ack', gNotice.ackId, gNotice.presentationId )
    SetTimeout(10000, function()
        if gAckCallback == callback then
            gAckCallback = nil
            callback({ ok = false })
        end
    end)
end )

RegisterNUICallback('toxicity:shown', function(data, callback)
    -- O render anterior pode responder depois de a punicao substituir o aviso.
    -- SQL valida que a apresentacao foi emitida para este personagem/conta.
    if type(data.ackId) == 'string' and #data.ackId == 36
        and type(data.presentationId) == 'string' and #data.presentationId == 36 then
        TriggerServerEvent('toxicity:shown', data.ackId, data.presentationId)
    end
    callback({ ok = true })
end)

RegisterNetEvent('toxicity:acknowledged', function(ackId)
    if not gNotice or gNotice.ackId ~= ackId then return end
    local callback = gAckCallback
    gAckCallback = nil
    CloseNotice()
    if callback then callback({ ok = true }) end
end)

RegisterNUICallback( 'toxicity:ready', function( _, callback )
    gReady = true
    -- A NUI perdeu o estado React; reapresenta mesmo se ackId nao mudou.
    if gNotice and LocalPlayer.state.Active and (gModalOpen or gSynced) then PresentNotice(gNotice) end
    if LocalPlayer.state.Active then TriggerServerEvent( 'toxicity:ready' ) end
    callback( { ok = true } )
end )

RegisterNetEvent( 'toxicity:ready', function()
    gSynced = true
end )

-- Fila pequena para os modais automaticos existentes. Toxicidade vence no mesmo ciclo.
AddEventHandler( 'hud:automaticModal:queue', function( name, show )
    gQueue[name] = show
end )
AddEventHandler( 'hud:automaticModal:cancel', function( name )
    gQueue[name] = nil
    if gAutomaticModal and gAutomaticModal.name == name then gAutomaticModal = nil end
end )

---@return string? name
local function NextAutomaticModal()
    if not gReady or not gSynced then return nil end
    if gReady and gSynced and gQueue.toxicity then
        return 'toxicity'
    end

    for name in pairs( gQueue ) do
        if name ~= 'toxicity' then
            return name
        end
    end

    return nil
end

CreateThread( function()
    local wasActive = false
    local nextSync = 0
    while true do
        Wait( 100 )
        local active = LocalPlayer.state.Active == true
        if active and gReady and ( not wasActive or ( not gSynced and GetGameTimer() >= nextSync ) ) then
            nextSync = GetGameTimer() + 2000
            TriggerServerEvent( 'toxicity:ready' )
        end
        wasActive = active
        if active and not gModalOpen and (gQueue.toxicity or (not IsNuiFocused() and not IsPauseMenuActive())) then
            local name = NextAutomaticModal()
            if name then
                local show = gQueue[name]
                gQueue[name] = nil
                if name ~= 'toxicity' then gAutomaticModal = {name=name,show=show} end
                show()
            end
        end
    end
end )

CreateThread( function()
    while true do
        Wait( ( gMuted or gModalOpen ) and 0 or 200 )
        if gModalOpen then
            DisableAllControlActions(0)
            SetNuiFocus(true, true)
        end
        local pressed = IsControlPressed( 0, 249 ) or IsDisabledControlPressed( 0, 249 )
        if gMuted and pressed and not gTalkPressed and GetGameTimer() - gLastTalkSound >= 5000 then
            gLastTalkSound = GetGameTimer()
            SendNUIMessage( { action = 'toxicity:sound' } )
        end
        gTalkPressed = pressed
    end
end )

AddEventHandler( 'onResourceStop', function( resource )
    if resource == GetCurrentResourceName() then
        -- SQL conserva a pendencia e a reenvia no handshake apos restart.
        if gModalOpen then SetNuiFocus(false, false) end
    end
end )

AddEventHandler('onClientResourceStart', function(resource)
    if resource == 'pma-voice' or resource == 'admin' then
        gSynced = false
        if gReady and LocalPlayer.state.Active then TriggerServerEvent('toxicity:ready') end
    end
end)
