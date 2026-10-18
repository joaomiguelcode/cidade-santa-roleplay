-- ENG-3724: convite X1 pós-recrutamento (modal, card da fila e teclas Q/U).
local gX1InviteState
local gX1InviteWaiting
local gX1InviteOwnsFocus = false
local gX1InviteSending = false
local gX1InviteCollapsed = false
local gX1InvitePriority = false
-- Cards do hud que dividem o canto da missão e têm prioridade sobre o convite.
local gX1InviteYield = {
    affiliate_service = LocalPlayer.state['affiliate:inService'] == true or nil,
}

-- Modos em que o convite ocupa o canto do card de missão ativa.
local PRIORITY_MODES = { modal = true, invite = true, queue = true, match = true, done = true }
local NULLABLE_FIELDS = { 'shownAt', 'expiresAt', 'queuedAt', 'soundUntil' }
local HUD_CORNER_EVENTS = {
    'hud:punishmentCard:priorityChanged', 'hud:toxicity:priorityChanged', 'hud:AffiliateWorldShortcutsVisibilityChanged',
}

---@return boolean
local function IsBlocked()

    return IsNuiFocused() or IsPauseMenuActive()
        or IsPedInAnyVehicle( PlayerPedId(), false )
        or LocalPlayer.state['affiliate:inService'] == true
end

-- Com proteção de iniciante o PvP recusa a entrada: o modal espera ela acabar.
---@return boolean
local function IsProtected()

    local ok, protected = pcall( function() return exports.player:GetProtectionStatus() end )

    return ok and protected == true
end

-- ENG-3780: na fila, veículo ou interface aberta seguram o pareamento até 10s livres contínuos (bloquear de
-- novo reinicia). O dminigames lê a state bag e só deixa de parear: o player segue na fila.
local HOLD_FREE_MS = 10000
local gX1InviteHeld = false
local gX1InviteFreeAt

---@param now number
local function TickHold( now )

    local held = false

    if gX1InviteState and gX1InviteState.mode == 'queue' then
        if IsBlocked() then
            gX1InviteFreeAt = nil
            held = true
        elseif gX1InviteHeld then
            gX1InviteFreeAt = gX1InviteFreeAt or now
            held = now - gX1InviteFreeAt < HOLD_FREE_MS
        end
    end

    if held == gX1InviteHeld then return end

    gX1InviteHeld = held
    gX1InviteFreeAt = nil
    LocalPlayer.state:set( 'x1invite:hold', held or nil, true )
end

-- O server manda `false` (msgpack não transporta json.null); a NUI espera `null`.
---@param state table
---@return table
local function NuiState( state )

    local data = {}

    for key, value in pairs( state ) do data[ key ] = value end

    for _, key in ipairs( NULLABLE_FIELDS ) do
        if not data[ key ] then data[ key ] = json.null end
    end

    return data
end

-- ENG-3779: o card do convite é dono do Q e do U; os outros atalhos do Q/U checam aqui antes de agir.
-- Q só com o card aberto (o oculto não mostra o Q); U também na tag de oculto, que reexibe o card.
---@param key 'q'|'u'
---@return boolean
function X1InviteOwnsKey( key )

    local mode = gX1InviteState and gX1InviteState.mode

    if ( mode ~= 'invite' and mode ~= 'queue' ) or next( gX1InviteYield ) then return false end

    return key == 'u' or not gX1InviteCollapsed
end

exports( 'X1InviteOwnsKey', X1InviteOwnsKey )

---@param visible boolean
local function SetPriority( visible )

    if visible == gX1InvitePriority then return end

    gX1InvitePriority = visible
    TriggerEvent( 'hud:x1Invite:priorityChanged', visible )
end

---@return boolean hidden
local function IsX1FullyHidden()

    return gX1InviteYield.match_city == true or gX1InviteYield.commercial == true
        or gX1InviteYield.affiliate_service == true
end

local function SendCollapsed()

    SendNUIMessage({ action = 'x1invite:collapsed', data = { collapsed = gX1InviteCollapsed or next( gX1InviteYield ) ~= nil } })
end

---@param collapsed boolean
local function SetCollapsed( collapsed )

    gX1InviteCollapsed = collapsed
    SendCollapsed()
end

---@return boolean
local function IsFullySuppressed()

    return IsX1FullyHidden()
end

---@param state table
local function PublishState( state )

    local previous = gX1InviteState

    if previous and previous.offerId == state.offerId and state.revision <= previous.revision then return end

    gX1InviteState = state
    if IsX1FullyHidden() then
        local hidden = NuiState( state )
        hidden.mode = 'closed'
        SendNUIMessage({ action = 'x1invite:state', data = hidden })
    else
        SendNUIMessage({ action = 'x1invite:state', data = NuiState( state ) })
    end

    -- Ocultar é estado só de tela: a NUI reexibe quando a oferta ou o modo mudam; a cessão
    -- aos cards do hud continua valendo.
    if ( gX1InviteCollapsed or next( gX1InviteYield ) )
        and ( not previous or previous.offerId ~= state.offerId or previous.mode ~= state.mode ) then
        SetCollapsed( false )
    end

    if state.mode == 'modal' and not IsX1FullyHidden() then
        SetNuiFocusKeepInput( false )
        SetNuiFocus( true, true )
        gX1InviteOwnsFocus = true
    elseif gX1InviteOwnsFocus then
        SetNuiFocus( false, false )
        gX1InviteOwnsFocus = false
    end

    -- Só o modal segura anúncios; os 15 min vêm de `hud:dominas:protection`.
    TriggerEvent( 'hud:dominas:occupation', state.mode == 'modal' and not IsX1FullyHidden() )
    SetPriority( PRIORITY_MODES[ state.mode ] == true and not IsX1FullyHidden() )
end

AddEventHandler( 'dashboard:x1invite:yieldToSocial', function( active )

    if ( gX1InviteYield.match_city == true ) == ( active == true ) then return end
    gX1InviteYield.match_city = active == true or nil
    if active and gX1InviteOwnsFocus then
        SetNuiFocus( false, false )
        gX1InviteOwnsFocus = false
    end
    if gX1InviteState then
        local data = NuiState( gX1InviteState )
        if active then data.mode = 'closed' end
        SendNUIMessage({ action = 'x1invite:state', data = data })
        SetPriority( PRIORITY_MODES[ gX1InviteState.mode ] == true and not IsX1FullyHidden() )
        if not active and gX1InviteState.mode == 'modal' then
            local state = gX1InviteState
            gX1InviteState = nil
            gX1InviteWaiting = { state = state, wasBlocked = true }
        end
    end
end )

AddEventHandler( 'dashboard:affiliateCommercialActiveChanged', function( active )

    if ( gX1InviteYield.commercial == true ) == ( active == true ) then
        return
    end

    gX1InviteYield.commercial = active == true or nil

    if active and gX1InviteOwnsFocus then
        SetNuiFocus( false, false )
        gX1InviteOwnsFocus = false
    end

    if not gX1InviteState then
        return
    end

    local data = NuiState( gX1InviteState )

    if active then
        data.mode = 'closed'
    end

    SendNUIMessage({ action = 'x1invite:state', data = data })
    SetPriority( PRIORITY_MODES[ gX1InviteState.mode ] == true and not IsX1FullyHidden() )

    if not active and gX1InviteState.mode == 'modal' then
        local state = gX1InviteState

        gX1InviteState = nil
        gX1InviteWaiting = { state = state, wasBlocked = true }
    end

    if active and gX1InviteState.mode == 'queue' and gX1InviteState.offerId ~= 'preview' then
        local offerId = gX1InviteState.offerId

        CreateThread( function()

            local ok, result = pcall( function()
                return vSERVER.X1InviteLeave( offerId )
            end )

            if ok and type( result ) == 'table' and result.state then
                PublishState( result.state )
            end
        end )
    end
end )

AddEventHandler( 'dashboard:affiliateServiceChanged', function( active )

    active = active == true
    gX1InviteYield.affiliate_service = active or nil

    if active then
        if gX1InviteWaiting then
            gX1InviteWaiting.wasBlocked = true
            gX1InviteWaiting.clearAt = nil
        end
        if gX1InviteOwnsFocus then
            SetNuiFocus( false, false )
            gX1InviteOwnsFocus = false
        end
        if gX1InviteState then
            local hidden = NuiState( gX1InviteState )
            hidden.mode = 'closed'
            SendNUIMessage({ action = 'x1invite:state', data = hidden })
        end
        TriggerEvent( 'hud:dominas:occupation', false )
        SetPriority( false )
        SendCollapsed()
        return
    end

    if gX1InviteState and gX1InviteState.mode == 'modal' then
        local state = gX1InviteState
        gX1InviteState = nil
        gX1InviteWaiting = { state = state, wasBlocked = true }
    elseif gX1InviteState then
        SendNUIMessage({ action = 'x1invite:state', data = NuiState( gX1InviteState ) })
        SetPriority( PRIORITY_MODES[ gX1InviteState.mode ] == true and not IsFullySuppressed() )
    end
    SendCollapsed()
end )

RegisterNetEvent( 'dashboard:x1invite:state', function( state )

    if type( state ) ~= 'table' or type( state.offerId ) ~= 'string' then return end

    if gX1InviteState and gX1InviteState.offerId == state.offerId
        and state.revision <= gX1InviteState.revision then return end

    if state.mode == 'waiting' or ( state.mode == 'modal' and not gX1InviteOwnsFocus ) then
        if gX1InviteWaiting and gX1InviteWaiting.state.offerId == state.offerId then
            gX1InviteWaiting.state = state
        else
            gX1InviteWaiting = { state = state }
        end
        if IsFullySuppressed() then
            gX1InviteWaiting.wasBlocked = true
            gX1InviteWaiting.clearAt = nil
        end
        return
    end

    gX1InviteWaiting = nil
    PublishState( state )
end )

RegisterNUICallback( 'x1invite:get-state', function( _, callback )

    callback( gX1InviteState and NuiState( gX1InviteState ) or json.null )
end )

for _, action in ipairs({ 'accept', 'decline' }) do
    RegisterNUICallback( ( 'x1invite:%s' ):format( action ), function( data, callback )

        if gX1InviteSending or not gX1InviteState or gX1InviteState.mode ~= 'modal'
            or type( data ) ~= 'table' or data.offerId ~= gX1InviteState.offerId then
            callback({ ok = false })
            return
        end

        if data.offerId == 'preview' then
            TriggerEvent( 'dashboard:x1invite:preview', action == 'accept' and 'queue' or 'invite' )
            callback({ ok = true, state = NuiState( gX1InviteState ) })
            return
        end

        gX1InviteSending = true
        local ok, result = pcall( function()
            return vSERVER.X1InviteChoice( data.offerId, action )
        end )
        gX1InviteSending = false

        if not ok or type( result ) ~= 'table' or not result.ok or not result.state then
            callback({ ok = false })
            return
        end

        PublishState( result.state )
        -- Um estado mais novo pode ter chegado pelo net event durante a chamada.
        callback({ ok = true, state = NuiState( gX1InviteState ) })
    end )
end

RegisterCommand( 'x1inviteQueue', function()

    -- Card: entra na fila. Buscando partida: sai da fila (ENG-3745). Oculto não mostra o Q: nada às cegas.
    if not X1InviteOwnsKey( 'q' ) or IsBlocked() or gX1InviteSending then return end

    local mode = gX1InviteState.mode

    if gX1InviteState.offerId == 'preview' then
        TriggerEvent( 'dashboard:x1invite:preview', mode == 'queue' and 'invite' or 'queue' )
        return
    end

    gX1InviteSending = true
    local offerId = gX1InviteState.offerId
    local ok, result = pcall( function()
        return mode == 'queue' and vSERVER.X1InviteLeave( offerId ) or vSERVER.X1InviteQueue( offerId )
    end )
    gX1InviteSending = false

    if ok and type( result ) == 'table' and result.state then PublishState( result.state ) end
end, false )
RegisterKeyMapping( 'x1inviteQueue', _t( 'x1invite.keymap.queue' ), 'keyboard', 'Q' )

RegisterCommand( '+x1invite_card_toggle', function()

    if not X1InviteOwnsKey( 'u' ) or IsNuiFocused() then return end

    SetCollapsed( not gX1InviteCollapsed )
end, false )
RegisterCommand( '-x1invite_card_toggle', function() end, false )
RegisterKeyMapping( '+x1invite_card_toggle', _t( 'x1invite.keymap.toggle' ), 'keyboard', 'U' )

local SHOWN_RETRY_MS = 5000

CreateThread( function()

    Wait( 1000 )
    TriggerServerEvent( 'dashboard:x1invite:restore' )

    while true do
        Wait( gX1InviteOwnsFocus and 0 or 100 )

        if gX1InviteOwnsFocus then
            DisableAllControlActions( 0 )
            DisablePlayerFiring( PlayerId(), true )
            SetNuiFocus( true, true )
        elseif gX1InviteWaiting and not IsX1FullyHidden() then
            local waiting = gX1InviteWaiting

            -- Sem bloqueio abre na hora; depois de bloqueado exige 5s livres contínuos.
            if IsBlocked() or IsProtected() then
                waiting.wasBlocked = true
                waiting.clearAt = nil
            elseif GetGameTimer() < ( waiting.retryAt or 0 ) then
                -- ENG-3824: recusado (ex.: convite social aberto) só tenta de novo em SHOWN_RETRY_MS.
            elseif not waiting.wasBlocked or ( waiting.clearAt and GetGameTimer() - waiting.clearAt >= 5000 ) then
                local ok, result = pcall( function() return vSERVER.X1InviteShown( waiting.state.offerId ) end )

                if gX1InviteWaiting == waiting and ok and result and result.ok and not IsBlocked() then
                    gX1InviteWaiting = nil
                    PublishState( result.state )
                else
                    waiting.retryAt = GetGameTimer() + SHOWN_RETRY_MS
                end
            else
                waiting.clearAt = waiting.clearAt or GetGameTimer()
            end
        end

        TickHold( GetGameTimer() )
    end
end )

-- Vigia do saque (ENG-3748/ENG-3768): o server liga enquanto espera o gatilho. Só a transição
-- desarmado→armado sobe; `fresh` = havia leitura desarmada antes (veterano exige saque novo).
local gX1InviteWatch = false

RegisterNetEvent( 'dashboard:x1invite:watch', function( watch )

    if gX1InviteWatch == ( watch == true ) then return end

    gX1InviteWatch = watch == true

    if not gX1InviteWatch then return end

    CreateThread( function()

        local wasArmed

        while gX1InviteWatch do
            local armed = IsPedArmed( PlayerPedId(), 4 )

            if armed and not wasArmed then TriggerServerEvent( 'dashboard:x1invite:draw', wasArmed == false ) end

            wasArmed = armed
            Wait( 500 )
        end
    end )
end )

-- O card cede o canto enquanto um card prioritário do hud aparece (vira só a tag).
for _, event in ipairs( HUD_CORNER_EVENTS ) do
    AddEventHandler( event, function( visible )

        gX1InviteYield[ event ] = visible == true or nil
        SendCollapsed()
    end )
end

-- Restart do hud zera as flags dele: reemite o slot da missão e a ocupação.
AddEventHandler( 'onClientResourceStart', function( resource )

    if resource ~= 'hud' then return end

    local commercial = gX1InviteYield.commercial
    gX1InviteYield = {
        commercial = commercial,
        affiliate_service = LocalPlayer.state['affiliate:inService'] == true or nil,
    }

    if not gX1InviteState then return end

    SendCollapsed()
    TriggerEvent( 'hud:dominas:occupation', gX1InviteState.mode == 'modal' )

    if gX1InvitePriority then TriggerEvent( 'hud:x1Invite:priorityChanged', true ) end
end )

-- Preview das telas (`/x1invite preview`, Admin): estado local com offerId 'preview', sem server.
local gX1InvitePreview = { legal = false, played = 0 }

RegisterNetEvent( 'dashboard:x1invite:preview', function( mode, legal, played )

    if GetInvokingResource() and GetInvokingResource() ~= GetCurrentResourceName() then return end

    if legal ~= nil then gX1InvitePreview.legal = legal == true end
    if played then gX1InvitePreview.played = math.max( 0, math.min( 3, math.floor( played ) ) ) end

    local collapsed = mode == 'collapsed'
    local now = GetCloudTimeAsInt() * 1000

    mode = collapsed and 'queue' or mode
    gX1InviteWaiting = nil

    PublishState({
        offerId = 'preview', revision = GetGameTimer(), mode = mode, serverNow = now,
        shownAt = now, expiresAt = now + 172800000, queuedAt = mode == 'queue' and now or false, soundUntil = now + 900000,
        played = mode == 'done' and 3 or gX1InvitePreview.played, total = 3,
        reward = gX1InvitePreview.legal and { kind = 'money', perMatch = 250000, total = 750000 }
            or { kind = 'items', perMatch = 240, total = 720, items = {
                { id = 'weedleaf', image = 'weedleaf', name = 'weedleaf' }, { id = 'silk', image = 'silk', name = 'silk' },
            } },
    })

    if collapsed then SetCollapsed( true ) end
end )

AddEventHandler( 'onClientResourceStop', function( resource )

    if resource ~= GetCurrentResourceName() then return end

    if gX1InviteOwnsFocus then SetNuiFocus( false, false ) end
    if gX1InviteHeld then LocalPlayer.state:set( 'x1invite:hold', nil, true ) end

    TriggerEvent( 'hud:dominas:occupation', false )
    TriggerEvent( 'hud:x1Invite:priorityChanged', false )
end )
