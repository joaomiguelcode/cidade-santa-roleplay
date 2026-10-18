-- =============================================================================
-- PvP HUD Bridge (resource `hud`)
-- -----------------------------------------------------------------------------
-- O NUI do PvP (HUD in-game, kill feed, scoreboard, match start/end, level up,
-- map vote, countdown, etc.) está compilado dentro do resource `hud`
-- (`web/assets/index-*.js` com Redux slice `pvp`).
--
-- Outros resources (ex.: `dminigames`) querem disparar esses eventos NUI, mas
-- `SendNUIMessage` só envia para o NUI do *próprio* resource. Para resolver,
-- este arquivo escuta eventos Lua locais (`TriggerEvent` no mesmo cliente é
-- cross-resource) e relaya para `SendNUIMessage` aqui, atingindo o NUI certo.
--
-- Convenção:
--   - Outros resources fazem `TriggerEvent('pvp.hud:<eventName>', payload)`
--   - Callbacks da UI (`fetchNui`) são relayados de volta via
--     `TriggerEvent('pvp.callback:<callbackName>', data, requestId)`.
--   - O resource consumidor responde com
--     `TriggerEvent('pvp.hud:callbackResponse', requestId, response)`.
-- =============================================================================

---@type boolean
local DEBUG = GetConvarInt( 'pvphud_debug', 0 ) ~= 0

---Envia uma mensagem NUI no formato esperado pelo NUI do `hud`:
---`{ action = "...", data = <payload> }`. A UI consome via
---`useNuiEvent(action, payload => ...)` lendo `event.data.data`.
---@param action  string
---@param payload any|nil   nil é permitido (ex.: updateHudWeapon = null)
local function send( action, payload )
    if DEBUG then
        print( ('[pvp.hud][bridge] -> NUI action=%s'):format( action ) )
    end
    SendNUIMessage( { action = action, data = payload } )
end

local function sendWithRootPayload( action, payload )
    local message = { action = action, data = payload }

    if type( payload ) == 'table' then
        for key, value in pairs( payload ) do
            if key ~= 'action' and key ~= 'data' then
                message[ key ] = value
            end
        end
    end

    SendNUIMessage( message )
end

-- =============================================
-- Eventos sem payload (apenas action)
-- =============================================

local SIMPLE_EVENTS = {
    'closeMatchStart',
    'closeMatchResult',
    'closeTournamentBracketResult',
    'closeTournamentResult',
    'closeTournamentSupervisor',
    'openTournamentSupervisorManager',
    'closeTournamentSupervisorManager',
    'openTournamentSupervisorExitConfirm',
    'closeTournamentSupervisorExitConfirm',
    'closeLevelUp',
    'closeMapVote',
    'showHud',
    'hideHud',
    'clearKillFeed',
    'closeScoreboard',
    'hideCountdown',
    'hideKillNotification',
    'hideAllPvP',
    'hideDominationCapture',
    'hideDominationDeath',
    'closeTeamSelection',
    'closePauseOverlay',
    'closeExitMatch',
    'closeLatencyWarning',
}

for _, name in ipairs( SIMPLE_EVENTS ) do
    AddEventHandler( 'pvp.hud:' .. name, function()
        send( name )
    end )
end

-- =============================================
-- Eventos com payload — repassam `data` direto
-- =============================================

local PASSTHROUGH_EVENTS = {
    'openMatchStart',          -- { team1, team2, mapName, mode }
    'openMatchResult',         -- { stats, topPlayers }
    'openRoyaleVictory',       -- { resultId, isWinner, factionName, factionBanner? }; fecha apos 10s na NUI
    'openTournamentResult',    -- { result, team, players, stats }
    'openTournamentSupervisor',
    'updateTournamentSupervisor',
    'setTournamentSupervisorNoclip',
    'openLevelUp',             -- { level, previousLevel }
    'openTeamSelection',       -- (sem payload obrigatório)
    'openMapVote',             -- { maps, duration }
    'updateMapVotes',          -- { [{ mapId, votes }] }
    'updateHudScore',          -- { team1, team2, team1Name, team2Name }
    'updateHudKills',          -- number
    'updateHudPlayerCount',    -- number
    'updateHudWeapon',         -- { name, ammo, maxAmmo, image? } | nil
    'updateHudSlotItems',      -- [{ slot, name, image, active }]
    'updateHudStatus',         -- { health?, armor? }
    'showDominationCapture',   -- { state, zoneName, organizationName, remainingMs, durationMs, stateLabel, timerLabel, color? }
    'showDominationDeath',     -- { durationSeconds, remainingSeconds, stateLabel, respawnLabel, timerLabel }
    'setHudMode',              -- { mode }
    'setPauseHintVisible',     -- { visible = boolean } | boolean
    'setDominationStoreHintVisible', -- { visible, vehiclesVisible?, personalChestVisible? } | boolean
    'updateGunGameRankings',   -- [{ rank, name, avatar, level, isCurrentPlayer }]
    'addKillFeedItem',         -- { id, killer, victim, weapon, isHeadshot, isKillStreak?, killerTeamStr?, victimTeamStr? }
    'openScoreboard',          -- [{ rank, name, avatar, kills?, deaths?, assists?, level?, team?, ping?, packetLoss? }]
    'showCountdown',           -- { count, label }
    'updateCountdown',         -- number  (envolto em { value = ... } na NUI? — repassamos direto)
    'showKillNotification',    -- { killer, victim, isHeadshot }
    'openPauseStartVote',
    'openPauseResumeVote',
    'openOpponentPauseActive',
    'updatePauseOverlay',
}

for _, name in ipairs( PASSTHROUGH_EVENTS ) do
    AddEventHandler( 'pvp.hud:' .. name, function( payload )
        send( name, payload )
    end )
end

-- Card de anuncio com tecla (o "Aperte F3" da Estatua Mortal). O componente e o
-- `NotifyAnnounce` generico; a action carrega o nome do primeiro evento que o usou.
AddEventHandler( 'pvp.hud:showEventAnnounce', function( payload )
    send( 'estatuaMortal:announce', payload )
end )

-- Fecha o card. Neste frame so esse card usa o slice da estatua: o `santa-deathstatue`
-- renderiza as telas dele no proprio NUI, entao o close nao atinge mais nada.
AddEventHandler( 'pvp.hud:closeEventAnnounce', function()
    send( 'estatuaMortal:close' )
end )

AddEventHandler( 'pvp.hud:openExitMatch', function( payload )
    sendWithRootPayload( 'openExitMatch', payload )
end )

AddEventHandler( 'pvp.hud:openLatencyWarning', function( payload )
    sendWithRootPayload( 'openLatencyWarning', payload )
end )

AddEventHandler( 'pvp.hud:openTournamentBracketResult', function( payload )
    sendWithRootPayload( 'openTournamentBracketResult', payload )
    SetNuiFocus( true, true )
end )

-- =============================================
-- Foco NUI para overlays interativas
-- =============================================
-- `openMapVote` e `openTeamSelection` exigem clique do user.
-- Os callbacks (selectTeam/voteMap/exitLobby) tiram o foco quando processados.

AddEventHandler( 'pvp.hud:openMapVote', function()
    SetNuiFocus( true, true )
end )

AddEventHandler( 'pvp.hud:openTeamSelection', function()
    SetNuiFocus( true, true )
end )

AddEventHandler( 'pvp.hud:openExitMatch', function()
    SetNuiFocus( true, true )
end )

AddEventHandler( 'pvp.hud:openLatencyWarning', function()
    SetNuiFocus( true, true )
end )

AddEventHandler( 'pvp.hud:openTournamentSupervisorManager', function()
    SetNuiFocus( true, true )
end )

AddEventHandler( 'pvp.hud:openTournamentSupervisorExitConfirm', function()
    SetNuiFocus( true, true )
end )

-- Hide implícito tira o foco (útil quando o resource consumidor manda fechar
-- antes do user clicar)
AddEventHandler( 'pvp.hud:closeMapVote', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeTeamSelection', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeExitMatch', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeLatencyWarning', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:hideAllPvP', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeTournamentBracketResult', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeTournamentSupervisor', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeTournamentSupervisorManager', function()
    SetNuiFocus( false, false )
end )

AddEventHandler( 'pvp.hud:closeTournamentSupervisorExitConfirm', function()
    SetNuiFocus( false, false )
end )

-- =============================================
-- Callbacks da NUI -> Lua (fetchNui)
-- =============================================
-- A UI roda no resource `hud`, então `fetchNui('selectTeam', ...)` cai num
-- `RegisterNUICallback('selectTeam', ...)` aqui. Repassamos via TriggerEvent
-- para o resource consumidor (ex.: dminigames) tratar.

RegisterNUICallback( 'selectTeam', function( data, cb )
    TriggerEvent( 'pvp.callback:selectTeam', data )
    cb( 'ok' )
end )

RegisterNUICallback( 'voteMap', function( data, cb )
    TriggerEvent( 'pvp.callback:voteMap', data )
    cb( 'ok' )
end )

RegisterNUICallback( 'exitLobby', function( data, cb )
    SetNuiFocus( false, false )
    TriggerEvent( 'pvp.callback:exitLobby', data )
    cb( 'ok' )
end )

RegisterNUICallback( 'exitMatchResponse', function( data, cb )
    SetNuiFocus( false, false )
    TriggerEvent( 'pvp.callback:exitMatchResponse', data )
    cb( {} )
end )

RegisterNUICallback( 'latencyWarningResponse', function( data, cb )
    SetNuiFocus( false, false )
    TriggerEvent( 'pvp.callback:latencyWarningResponse', data )
    cb( {} )
end )

local CALLBACK_RESPONSE_TIMEOUT_MS = 5000
local responseCallbackId = 0
local pendingResponseCallbacks = {}

local function nextResponseCallbackId( name )
    responseCallbackId = responseCallbackId + 1

    if responseCallbackId > 1000000 then
        responseCallbackId = 1
    end

    return ( '%s:%d' ):format( name, responseCallbackId )
end

local function resolveResponseCallback( requestId, response )
    local callback = requestId and pendingResponseCallbacks[ requestId ] or nil

    if not callback then return false end

    pendingResponseCallbacks[ requestId ] = nil
    callback( response or { success = true } )
    return true
end

AddEventHandler( 'pvp.hud:callbackResponse', function( requestId, response )
    resolveResponseCallback( requestId, response )
end )

local function relayResponseCallback( name, data, cb )
    local requestId = nextResponseCallbackId( name )

    pendingResponseCallbacks[ requestId ] = cb
    TriggerEvent( 'pvp.callback:' .. name, data or {}, requestId )

    SetTimeout( CALLBACK_RESPONSE_TIMEOUT_MS, function()
        resolveResponseCallback( requestId, { success = false, message = 'Callback indisponível.' } )
    end )
end

RegisterNUICallback( 'pvp:pauseRequest', function( data, cb )
    relayResponseCallback( 'pauseRequest', data, cb )
end )

RegisterNUICallback( 'pvp:pauseResumeRequest', function( data, cb )
    relayResponseCallback( 'pauseResumeRequest', data, cb )
end )

RegisterNUICallback( 'pvp:pauseVote', function( data, cb )
    relayResponseCallback( 'pauseVote', data, cb )
end )

RegisterNUICallback( 'pvp:tournamentBracketBackToLobby', function( data, cb )
    SetNuiFocus( false, false )
    relayResponseCallback( 'tournamentBracketBackToLobby', data, cb )
end )

RegisterNUICallback( 'pvp:tournamentSupervisorApplyAndRestart', function( data, cb )
    relayResponseCallback( 'tournamentSupervisorApplyAndRestart', data, cb )
end )

RegisterNUICallback( 'pvp:tournamentSupervisorPause', function( data, cb )
    relayResponseCallback( 'tournamentSupervisorPause', data, cb )
end )

RegisterNUICallback( 'pvp:tournamentSupervisorCloseManager', function( data, cb )
    SetNuiFocus( false, false )
    cb({ success = true })
end )

RegisterNUICallback( 'pvp:tournamentSupervisorCloseExitConfirm', function( data, cb )
    SetNuiFocus( false, false )
    cb({ success = true })
end )

RegisterNUICallback( 'pvp:tournamentSupervisorExit', function( data, cb )
    SetNuiFocus( false, false )
    relayResponseCallback( 'tournamentSupervisorExit', data, cb )
end )
