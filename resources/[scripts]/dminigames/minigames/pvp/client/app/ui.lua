local isUIVisible    = false
local isScheduledEventsVisible = false
local gScheduledEventsVoiceWatchActive = false
local gScheduledEventsVoiceWatchRevision = 0
local currentRoomId   = nil
local currentRoomType = nil
local currentPanelPlayerData = nil
local currentWeaponSelectorData = nil
local currentMapSelectorData = nil
local currentChallengeBetConfirmData = nil
local panelListsRefreshScheduled = false
local panelListsRefreshInFlight = false
local panelListsRefreshPending = false
local gDominationMigrationOpen = false
local gDominationMigrationReady = false
local gDominationMigrationRevision = 0
local gDominationMigrationFrozenVehicle = nil

local function pvpText( key, ... )
    return PvpTranslations.get( key, ... )
end

local function isBetDebugEnabled()
    return tostring( GetConvar( 'pvp_bet_debug', '0' ) ) == '1'
end

local function betDebug( message, ... )
    if not isBetDebugEnabled() then return end

    local ok, formatted = pcall( string.format, message, ... )
    print( '[PVP][BetConfirm] ' .. ( ok and formatted or tostring( message ) ) )
end

local function isCompetitiveBetEnabled()
    if PvpIsCompetitiveBetEnabled then
        return PvpIsCompetitiveBetEnabled() == true
    end

    return true
end

local function getCompetitiveBetFeaturePayload()
    return {
        enabled = isCompetitiveBetEnabled(),
        minAmount = PVP_COMPETITIVE_BET_MIN_AMOUNT or 100000,
        city = PvpGetCurrentCityName and PvpGetCurrentCityName() or '',
    }
end

local function isCompetitiveMinigameActive()
    local activeMinigame = LocalPlayer["state"]["minigame:active"]
    return type( activeMinigame ) == 'string' and activeMinigame:find( 'Competitivo', 1, true ) ~= nil
end

local function sendPvpNuiMessage( name, data )
    SendNUIMessage({
        action = name,
        type = name,
        data = data,
    })
end

---@param watched boolean
local function SetScheduledEventsVoiceWatch( watched )
    watched = watched == true

    if watched == gScheduledEventsVoiceWatchActive then
        return
    end

    gScheduledEventsVoiceWatchActive = watched
    gScheduledEventsVoiceWatchRevision = gScheduledEventsVoiceWatchRevision + 1

    if not watched then
        return
    end

    local revision = gScheduledEventsVoiceWatchRevision

    CreateThread( function()
        local lastTalking = nil

        while gScheduledEventsVoiceWatchActive and gScheduledEventsVoiceWatchRevision == revision do
            local activeMinigame = LocalPlayer.state['minigame:active']

            if type(activeMinigame) == 'string' and activeMinigame ~= '' then
                local talking = MumbleIsPlayerTalking( PlayerId() ) == 1

                if talking ~= lastTalking then
                    TriggerServerEvent( 'events.server:voiceTalking', talking )
                    lastTalking = talking
                end
            elseif lastTalking ~= nil then
                if lastTalking then
                    TriggerServerEvent( 'events.server:voiceTalking', false )
                end

                lastTalking = nil
            end

            Wait( 200 )
        end
    end )
end

local function ReleaseDominationMigrationVehicle()

    local vehicle = gDominationMigrationFrozenVehicle
    gDominationMigrationFrozenVehicle = nil

    if vehicle and DoesEntityExist( vehicle ) then
        FreezeEntityPosition( vehicle, false )

        SetTimeout(1000, function()
            if DoesEntityExist( vehicle ) then
                SetVehicleFixed( vehicle )
            end
        end)
    end
end

---@param releaseFocus? boolean
---@return boolean closed
local function CloseDominationMigrationNotice( releaseFocus )

    if not gDominationMigrationOpen then
        return false
    end

    ReleaseDominationMigrationVehicle()
    gDominationMigrationOpen = false
    gDominationMigrationRevision = gDominationMigrationRevision + 1
    sendPvpNuiMessage( 'PVP_DOMINATION_MIGRATION', { show = false } )

    if releaseFocus ~= false then
        SetNuiFocus( false, false )
    end

    return true
end

---@return boolean eligible
local function CanShowDominationMigrationNotice()

    return LocalPlayer.state.Route == 1
        and not LocalPlayer.state['minigame:active']
        and GetEntityHealth( PlayerPedId() ) > 101
        and not IsPauseMenuActive()
end

exports( 'ShowDominationMigrationNotice', function()

    if gDominationMigrationOpen then
        return true
    end

    if not gDominationMigrationReady or isUIVisible or currentWeaponSelectorData
        or currentMapSelectorData or currentChallengeBetConfirmData
        or IsNuiFocused() or not CanShowDominationMigrationNotice() then
        return false
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn( ped, false )

    if vehicle ~= 0 and GetPedInVehicleSeat( vehicle, -1 ) == ped
        and NetworkHasControlOfEntity( vehicle ) and not IsEntityPositionFrozen( vehicle ) then
        gDominationMigrationFrozenVehicle = vehicle
        FreezeEntityPosition( vehicle, true )
    end

    gDominationMigrationOpen = true
    gDominationMigrationRevision = gDominationMigrationRevision + 1
    local revision = gDominationMigrationRevision
    SetNuiFocus( true, true )
    sendPvpNuiMessage( 'PVP_DOMINATION_MIGRATION', { show = true } )

    CreateThread( function()
        if gDominationMigrationFrozenVehicle then
            Wait(100)

            if revision ~= gDominationMigrationRevision then
                return
            end

            ReleaseDominationMigrationVehicle()
        end

        while gDominationMigrationOpen and revision == gDominationMigrationRevision do
            if not CanShowDominationMigrationNotice() then
                CloseDominationMigrationNotice()
                return
            end

            Wait(250)
        end
    end )

    return true
end )

RegisterNUICallback( 'pvp:dominationMigrationReady', function( _, cb )
    gDominationMigrationReady = true
    cb({ success = true })
end )

RegisterNUICallback( 'pvp:dominationMigrationDismiss', function( data, cb )
    local wasOpen = CloseDominationMigrationNotice()
    cb({ success = true })

    if wasOpen and type(data) == 'table' and data.openPvp == true then
        TriggerServerEvent( 'pvp.server:openPanel', 'pvp', { activeTab = 'pvp' } )
    end
end )

AddEventHandler( 'onResourceStop', function( resourceName )
    if resourceName == GetCurrentResourceName() or resourceName == 'warsystem' then
        CloseDominationMigrationNotice()
    end
end )

local function releaseChallengeBetConfirmFocus()
    currentChallengeBetConfirmData = nil

    if not isUIVisible and not currentWeaponSelectorData and not currentMapSelectorData then
        SetNuiFocus( false, false )
    end
end

exports( 'IsChallengeBetConfirmOpen', function()
    return currentChallengeBetConfirmData ~= nil
end )

local function keepChallengeBetConfirmOpen()
    if not currentChallengeBetConfirmData then
        return false
    end

    currentChallengeBetConfirmData.show = true
    SetNuiFocus( true, true )
    sendPvpNuiMessage( 'PVP_CHALLENGE_BET_CONFIRM', currentChallengeBetConfirmData )
    return true
end

local function forceClosePvpPanel()
    CloseDominationMigrationNotice()
    isUIVisible = false
    currentPanelPlayerData = nil
    currentChallengeBetConfirmData = nil
    panelListsRefreshPending = false
    SetNuiFocus( false, false )
    TriggerServerEvent( 'net.pvp.setPanelOpen', false )

    sendPvpNuiMessage( 'PVP_SHOWUI', {
        show   = false,
        player = nil,
    })
end

local function closeScheduledEventsPanel(releaseFocus)
    if not isScheduledEventsVisible then return end

    isScheduledEventsVisible = false
    TriggerServerEvent( 'events.server:scheduledEventsPanelClosed' )
    TriggerServerEvent( 'events.server:voiceUnwatch' )
    sendPvpNuiMessage('EVENTOS_SHOWUI', { show = false })

    if releaseFocus ~= false then
        SetNuiFocus(false, false)
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SetScheduledEventsVoiceWatch( false )
        closeScheduledEventsPanel()
    end
end)

local function sendPanelListMessages( rooms, teams )
    sendPvpNuiMessage( 'PVP_UPDATE_PANEL_LISTS', {
        rooms = rooms,
        teams = teams,
        competitiveBet = getCompetitiveBetFeaturePayload(),
    })
    sendPvpNuiMessage( 'PVP_COMPETITIVE_ROOMS', {
        rooms = rooms,
        competitiveBet = getCompetitiveBetFeaturePayload(),
    })
    sendPvpNuiMessage( 'PVP_CHALLENGE_TEAMS', {
        teams = teams,
        competitiveBet = getCompetitiveBetFeaturePayload(),
    })
end

local function sendPanelListsToNui( rooms, teams )
    if not isUIVisible then return end

    rooms = rooms or {}
    teams = teams or {}

    sendPanelListMessages( rooms, teams )
end

local function panelPlayerHasLobby()
    return type( currentPanelPlayerData ) == 'table'
        and type( currentPanelPlayerData.lobby ) == 'table'
        and next( currentPanelPlayerData.lobby ) ~= nil
end

local function refreshPanelLists()
    if not isUIVisible then return end
    if panelListsRefreshInFlight then
        panelListsRefreshPending = true
        return
    end

    panelListsRefreshInFlight = true

    CreateThread( function()
        local rooms = RPC.PVP_COMPETITIVE_ROOMS() or {}
        local teams = {}

        if panelPlayerHasLobby() then
            teams = RPC.PVP_CHALLENGE_TEAMS() or {}
        end

        panelListsRefreshInFlight = false
        sendPanelListsToNui(
            rooms,
            teams
        )

        if panelListsRefreshPending then
            panelListsRefreshPending = false
            refreshPanelLists()
        end
    end )
end

local function schedulePanelListsRefresh()
    if not isUIVisible or panelListsRefreshScheduled then return end

    panelListsRefreshScheduled = true

    CreateThread( function()
        Wait( 150 )
        panelListsRefreshScheduled = false
        refreshPanelLists()
    end )
end

local function normalizePanelPlayerData( playerData )
    if playerData ~= nil and playerData[1] ~= nil then
        return {
            id     = tostring( playerData[2] ),
            name   = playerData[3],
            level  = playerData[4] or 0,
            avatar = nil,
            lobby  = (playerData[6] and next( playerData[6] )) and playerData[6] or nil,
        }
    end

    return playerData
end

---@param visible boolean
---@param playerData table|nil
---@param panelOptions table|nil
local function setPvpPanelVisible( visible, playerData, panelOptions )
    CloseDominationMigrationNotice( false )
    if visible then
        closeScheduledEventsPanel(false)
    end
    isUIVisible = visible == true
    SetNuiFocus( isUIVisible, isUIVisible )
    TriggerServerEvent( 'net.pvp.setPanelOpen', isUIVisible )

    playerData = normalizePanelPlayerData( playerData )
    currentPanelPlayerData = isUIVisible and playerData or nil

    sendPvpNuiMessage( 'PVP_SHOWUI', {
        show   = isUIVisible,
        player = playerData,
        activeTab = type( panelOptions ) == 'table' and panelOptions.activeTab or nil,
    })

    if isUIVisible and playerData ~= nil then
        refreshPanelLists()
    end
end

---Abre/fecha a UI do PVP. Aceita o formato objeto {id,name,level,avatar,lobby}.
---@param playerData table|nil
function GameModeToggleUI( playerData )
    CloseDominationMigrationNotice()
    if keepChallengeBetConfirmOpen() then
        return
    end

    isUIVisible = not IsNuiFocused()
    SetNuiFocus( isUIVisible, isUIVisible )
    TriggerServerEvent( 'net.pvp.setPanelOpen', isUIVisible )

    -- Formato legado (array) → converte para objeto
    if playerData ~= nil and playerData[1] ~= nil then
        playerData = {
            id     = tostring( playerData[2] ),
            name   = playerData[3],
            level  = playerData[4] or 0,
            avatar = nil,
            lobby  = (playerData[6] and next( playerData[6] )) and playerData[6] or nil,
        }
    end
    playerData = normalizePanelPlayerData( playerData )
    currentPanelPlayerData = isUIVisible and playerData or nil

    sendPvpNuiMessage( 'PVP_SHOWUI', {
        show   = isUIVisible,
        player = playerData,
    })

    if isUIVisible and playerData ~= nil then
        refreshPanelLists()
    end
end

-- =============================================
-- Net events — servidor → NUI
-- =============================================

RegisterNetEvent( 'net.pvp.gameModeToggleUI' )
AddEventHandler( 'net.pvp.gameModeToggleUI', function( playerData )
    GameModeToggleUI( playerData )
end )

RegisterNetEvent( 'net.pvp.openPanel', function( playerData, panelOptions )
    setPvpPanelVisible( true, playerData, panelOptions )
end )

RegisterNetEvent('net.events.openPanel', function()
    if isUIVisible then
        forceClosePvpPanel()
    end

    CloseDominationMigrationNotice(false)
    isScheduledEventsVisible = true
    SetNuiFocus(true, true)
    sendPvpNuiMessage('EVENTOS_SHOWUI', { show = true })
end)

RegisterNetEvent( 'events.client:voiceWatch', function( watched )
    SetScheduledEventsVoiceWatch( watched )
end )

RegisterNetEvent( 'events.client:voiceTalking', function( source, talking )
    if isScheduledEventsVisible then
        sendPvpNuiMessage( 'EVENTOS_VOICE_TALKING', { source = source, talking = talking } )
    end
end )

RegisterNetEvent( 'events.client:scheduledEventsChanged', function( data )
    if isScheduledEventsVisible then
        sendPvpNuiMessage( 'EVENTOS_CHANGED', data )
    end
end )

RegisterNetEvent( 'net.pvp.closePanel' )
AddEventHandler( 'net.pvp.closePanel', forceClosePvpPanel )
AddEventHandler( 'pvp.client:forceClosePanel', forceClosePvpPanel )

-- Atualiza estado do lobby/player na NUI sem fechar
RegisterNetEvent( 'net.pvp.updatePlayer' )
AddEventHandler( 'net.pvp.updatePlayer', function( playerData )
    currentPanelPlayerData = normalizePanelPlayerData( playerData )
    sendPvpNuiMessage( 'PVP_UPDATE_PLAYER', { player = currentPanelPlayerData } )
end )

RegisterNetEvent( 'net.pvp.panelListsChanged' )
AddEventHandler( 'net.pvp.panelListsChanged', function()
    schedulePanelListsRefresh()
end )

RegisterNetEvent( 'net.pvp.updatePanelLists' )
AddEventHandler( 'net.pvp.updatePanelLists', function( data )
    if type( data ) ~= 'table' then return end

    sendPanelListsToNui( data.rooms, data.teams )
end )

RegisterNetEvent( 'net.pvp.tournamentData' )
AddEventHandler( 'net.pvp.tournamentData', function( data )
    sendPvpNuiMessage( 'PVP_TOURNAMENT_DATA', data or {} )
end )

RegisterNetEvent( 'net.pvp.mapSelector' )
AddEventHandler( 'net.pvp.mapSelector', function( data )
    data = data or {}

    local show = data.show ~= false
    local wasMapSelectorOpen = currentMapSelectorData ~= nil
    if show then
        closeScheduledEventsPanel(false)
        CloseDominationMigrationNotice( false )
        data.allowLeave = false
        data.canLeave = false
        currentMapSelectorData = data

        if not wasMapSelectorOpen then
            isUIVisible = false
            currentPanelPlayerData = nil
            panelListsRefreshPending = false
            TriggerServerEvent( 'net.pvp.setPanelOpen', false )
            sendPvpNuiMessage( 'PVP_SHOWUI', {
                show = false,
                player = nil,
            })
        end

        SetNuiFocus( true, true )
    else
        currentMapSelectorData = nil
        SetNuiFocus( false, false )
    end

    sendPvpNuiMessage( 'PVP_MAP_SELECTOR', data )
end )

RegisterNetEvent( 'net.pvp.weaponSelector' )
AddEventHandler( 'net.pvp.weaponSelector', function( data )
    data = data or {}

    local show = data.show ~= false
    local wasWeaponSelectorOpen = currentWeaponSelectorData ~= nil
    if show then
        closeScheduledEventsPanel(false)
        CloseDominationMigrationNotice( false )
        data.allowLeave = false
        data.canLeave = false
        currentWeaponSelectorData = data

        if not wasWeaponSelectorOpen then
            isUIVisible = false
            currentPanelPlayerData = nil
            panelListsRefreshPending = false
            TriggerServerEvent( 'net.pvp.setPanelOpen', false )
            sendPvpNuiMessage( 'PVP_SHOWUI', {
                show = false,
                player = nil,
            })
        end

        SetNuiFocus( true, true )
    else
        currentWeaponSelectorData = nil
        SetNuiFocus( false, false )
    end

    sendPvpNuiMessage( 'PVP_WEAPON_SELECTOR', data )
end )

-- Notificação de convite para lobby
RegisterNetEvent( 'net.pvp.notifyLobbyInvite' )
AddEventHandler( 'net.pvp.notifyLobbyInvite', function( data )
    if isCompetitiveMinigameActive() then return end

    sendPvpNuiMessage( 'PVP_NOTIFY_LOBBY_INVITE', data )
end )

-- Notificação de desafio Team vs Team
RegisterNetEvent( 'net.pvp.notifyChallengeInvite' )
AddEventHandler( 'net.pvp.notifyChallengeInvite', function( data )
    if isCompetitiveMinigameActive() then return end

    CreateThread( function()
        sendPvpNuiMessage( 'PVP_NOTIFY_CHALLENGES_INVITE', data )
    end )
end )

RegisterNetEvent( 'net.pvp.confirmChallengeBetDifference' )
AddEventHandler( 'net.pvp.confirmChallengeBetDifference', function( data )
    data = data or {}
    data.show = data.show ~= false
    betDebug(
        'client event received challenge=%s show=%s active=%s challengerBet=%s targetBet=%s matchBet=%s remainingMs=%s',
        tostring( data.challengeId or data.inviteId or data.id ),
        tostring( data.show ),
        tostring( LocalPlayer["state"]["minigame:active"] ),
        tostring( data.challengerBetAmount ),
        tostring( data.targetBetAmount ),
        tostring( data.matchBetAmount ),
        tostring( data.remainingMs or data.time )
    )

    currentChallengeBetConfirmData = data
    closeScheduledEventsPanel(false)
    CloseDominationMigrationNotice( false )
    isUIVisible = false
    currentPanelPlayerData = nil
    panelListsRefreshPending = false

    TriggerServerEvent( 'net.pvp.setPanelOpen', false )

    SetNuiFocus( true, true )
    sendPvpNuiMessage( 'PVP_CHALLENGE_BET_CONFIRM', data )
end )

-- =============================================
-- NUI Callbacks — frontend → backend
-- =============================================

RegisterNUICallback( 'getCityName', function( data, cb )
    local cityName = CURRENT_CITY_NAME or GetConvar( 'cityName', '' )

    cb( string.lower( tostring( cityName or '' ) ) )
end )

RegisterNUICallback( 'getServerHost', function( data, cb )
    cb( GetConvar( 'api_url', '' ) )
end )

RegisterNUICallback( 'PVP_MINIGAMES_ROOMS', function( data, cb )
    local rooms = RPC.GetAvailableRooms( eGamemodeCategories.Minigame )
    cb( rooms or {} )
end )

RegisterNUICallback( 'PVP_GAME_MODE_ROOMS', function( data, cb )
    local rooms = RPC.GetAvailableRooms( eGamemodeCategories.Pvp )
    cb( rooms or {} )
end )

RegisterNUICallback( 'PVP_COMPETITIVE_ROOMS', function( data, cb )
    CreateThread( function()
        local rooms = RPC.PVP_COMPETITIVE_ROOMS() or {}
        cb( rooms )
    end )
end )

RegisterNUICallback( 'pvp:reconnect', function( data, cb )
    local success, err = RPC.pvp_reconnectCompetitive()
    cb({ success = success, error = not success and err or nil, message = err })
end )

RegisterNUICallback( 'pvp:enterRoom', function( data, cb )

    local roomId   = data.roomId
    local roomType = data.roomType

    assert( type( roomId )   == 'string', 'roomId deve ser uma string' )
    assert( type( roomType ) == 'string', 'roomType deve ser uma string' )

    if roomId == eGamemodeTypes.COMPETITIVE then
        cb({ success = false, message = pvpText( 'create_competitive_lobby_to_enter' ) })
        return
    end

    -- Sala competitiva: entra no lobby sem fechar a UI
    if roomType == 'competitive' then
        local success, err = RPC.pvp_joinLobby( roomId )
        cb({ success = success, message = err })
        return
    end

    -- Minigame: fecha UI e entra na fila
    currentRoomId   = roomId
    currentRoomType = roomType

    GameModeToggleUI()

    local success, err = RPC.GameModeEnterRoom( roomId, roomType )

    if not success then
        currentRoomId   = nil
        currentRoomType = nil
    end

    cb({ success = success, message = err })
end )

RegisterNUICallback( 'pvp:leaveRoom', function( data, cb )

    local roomType = data.roomType or currentRoomType
    local roomId   = data.roomId   or currentRoomId

    if not roomId then
        cb({ success = false, message = pvpText( 'not_in_any_room' ) })
        return
    end

    local success, err = RPC.pvp_leaveRoom( roomId, roomType )

    if success and roomType ~= 'competitive' then
        currentRoomId   = nil
        currentRoomType = nil
    end

    cb({ success = success, message = err })
end )

-- Criar lobby competitivo
RegisterNUICallback( 'pvp:createLobby', function( data, cb )
    data = type( data ) == 'table' and data or {}

    local name      = data.name or pvpText( 'default_lobby_name' )
    local isPrivate = data.isPrivate == true
    local isBet     = data.isBet == true
    local betAmount = tonumber( data.betAmount ) or 0
    local tournamentId = data.tournamentId
    local success, lobbyIdOrErr = RPC.pvp_createLobby( name, isPrivate, isBet, betAmount, tournamentId )
    cb({
        success = success,
        lobbyId = success and lobbyIdOrErr or nil,
        message = not success and lobbyIdOrErr or nil,
        error   = not success and lobbyIdOrErr or nil,
    })
end )

RegisterNUICallback( 'pvp:getCompetitiveBetFeature', function( data, cb )
    cb( getCompetitiveBetFeaturePayload() )
end )

local function updateLobbyBetAmount( data, cb )
    data = type( data ) == 'table' and data or {}

    local rawBetAmount = data.betAmount or data.amount or data.value
    local betAmount = tonumber( rawBetAmount ) or 0
    local success, amountOrErr = RPC.pvp_updateLobbyBetAmount( betAmount )

    cb({
        success = success,
        betAmount = success and amountOrErr or nil,
        message = not success and amountOrErr or nil,
        error = not success and amountOrErr or nil,
    })
end

RegisterNUICallback( 'pvp:updateLobbyBetAmount', updateLobbyBetAmount )
RegisterNUICallback( 'pvp:setLobbyBetAmount', updateLobbyBetAmount )
RegisterNUICallback( 'pvp:editLobbyBet', updateLobbyBetAmount )

local ready = false
-- Marcar/cancelar pronto no lobby (callback atual do frontend)
RegisterNUICallback( 'pvp:lobbySetReady', function( data, cb )
    ready = not ready

    local success, err = RPC.pvp_setReady( ready )
    cb({ success = success, message = err })
end )

RegisterNUICallback( 'pvp:setReady', function( data, cb )
    local ready = type( data ) == 'table' and data.ready == true
    local success, err = RPC.pvp_setReady( ready )
    cb({ success = success, message = err })
end )

local function leaveCompetitiveLobby( cb )
    local success, err = RPC.pvp_leaveParty()
    if success then
        ready = false
    end
    cb({ success = success, message = err })
end

RegisterNUICallback( 'pvp:leaveParty', function( data, cb )
    leaveCompetitiveLobby( cb )
end )

RegisterNUICallback( 'pvp:leaveLobby', function( data, cb )
    leaveCompetitiveLobby( cb )
end )

RegisterNUICallback( 'pvp:lobbyLeave', function( data, cb )
    leaveCompetitiveLobby( cb )
end )

RegisterNUICallback( 'pvp:lobbyKickPlayer', function( data, cb )
    local playerId = type( data ) == 'table' and data.playerId or nil
    local lobbyId = type( data ) == 'table' and data.lobbyId or nil

    if not playerId or not lobbyId then
        cb({ success = false, message = pvpText( 'invalid_player_or_lobby' ) })
        return
    end

    local success, err = RPC.pvp_kickLobbyPlayer( playerId, lobbyId )
    cb({ success = success, message = err })
end )

-- Convidar jogador
RegisterNUICallback( 'pvp:invitePlayer', function( data, cb )
    local targetId = tonumber( type( data ) == 'table' and data.playerId or nil )
    if not targetId then
        local message = pvpText( 'invalid_id' )
        cb({ success = false, message = message, error = message })
        return
    end

    local success, err = RPC.pvp_invitePlayer( targetId )
    cb({ success = success, message = err, error = not success and err or nil })
end )

-- Responder convite de lobby
RegisterNUICallback( 'pvp:lobbyInviteResponse', function( data, cb )
    local inviteId = data.id
    local accepted = data.accepted == true
    if not inviteId then
        local message = pvpText( 'invalid_invite_id' )
        cb({ success = false, message = message, error = message })
        return
    end
    local success, err = RPC.pvp_lobbyInviteResponse( inviteId, accepted )
    cb({ success = success, message = err, error = not success and err or nil })
end )

-- Listar times desafiáveis
RegisterNUICallback( 'PVP_CHALLENGE_TEAMS', function( data, cb )
    CreateThread( function()
        local teams = RPC.PVP_CHALLENGE_TEAMS() or {}
        cb( teams )
    end )
end )

-- Torneio
local tournamentUnpack = table.unpack or unpack

local function respondTournamentRpc( cb, rpcName, ... )
    local args = { ... }

    CreateThread( function()
        local rpcFn = RPC[ rpcName ]
        if not rpcFn then
            cb({
                success = false,
                message = pvpText( 'internal_error' ),
                error = pvpText( 'internal_error' ),
            })
            return
        end

        local success, result = rpcFn( tournamentUnpack( args ) )
        local details = not success and type( result ) == 'table' and result or nil
        local errorMessage = details and details.message or result
        cb({
            success = success,
            data = success and result or nil,
            message = not success and errorMessage or nil,
            error = not success and errorMessage or nil,
            code = details and details.code or nil,
            field = details and details.field or nil,
            earliestAllowedTime = details and details.earliestAllowedTime or nil,
        })
    end )
end

-- O painel de eventos usa o mesmo envelope NUI/RPC dos demais controles de staff.
RegisterNUICallback('eventos:open', function(_, cb)
    TriggerServerEvent('events.server:openPanel')
    cb({ success = true })
end)

RegisterNUICallback( 'pvp:scheduledEventsGet', function( _, cb )
    respondTournamentRpc( cb, 'pvp_getScheduledEvents' )
end )

RegisterNUICallback( 'pvp:scheduledEventParticipants', function( data, cb )
    respondTournamentRpc( cb, 'pvp_getScheduledEventParticipants', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:scheduledEventVoiceWatch', function( data, cb )
    respondTournamentRpc( cb, 'pvp_watchScheduledEventVoice', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:scheduledEventParticipantAction', function( data, cb )
    respondTournamentRpc( cb, 'pvp_actOnScheduledEventParticipant', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:scheduledEventSave', function( data, cb )
    respondTournamentRpc( cb, 'pvp_saveScheduledEvent', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:scheduledEventSetPaused', function( data, cb )
    respondTournamentRpc( cb, 'pvp_setScheduledEventPaused', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'PVP_TOURNAMENT_DATA', function( data, cb )
    respondTournamentRpc( cb, 'pvp_getTournamentData' )
end )

RegisterNUICallback( 'pvp:tournamentPrizeItems', function( data, cb )
    respondTournamentRpc( cb, 'pvp_getTournamentPrizeItems' )
end )

RegisterNUICallback( 'PVP_TOURNAMENT_PRIZE_ITEMS', function( data, cb )
    respondTournamentRpc( cb, 'pvp_getTournamentPrizeItems' )
end )

RegisterNUICallback( 'pvp:tournamentCreate', function( data, cb )
    respondTournamentRpc( cb, 'pvp_createTournament', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentEdit', function( data, cb )
    respondTournamentRpc( cb, 'pvp_editTournament', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentUpdate', function( data, cb )
    respondTournamentRpc( cb, 'pvp_editTournament', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentSetupBracket', function( data, cb )
    respondTournamentRpc( cb, 'pvp_setupTournamentBracket', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentSetBracket', function( data, cb )
    respondTournamentRpc( cb, 'pvp_setupTournamentBracket', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentMountBracket', function( data, cb )
    respondTournamentRpc( cb, 'pvp_setupTournamentBracket', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentSetRegistrations', function( data, cb )
    respondTournamentRpc( cb, 'pvp_setTournamentRegistrations', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentToggleRegistrations', function( data, cb )
    respondTournamentRpc( cb, 'pvp_setTournamentRegistrations', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentOpenRegistrations', function( data, cb )
    data = type( data ) == 'table' and data or {}
    data.open = true
    respondTournamentRpc( cb, 'pvp_setTournamentRegistrations', data )
end )

RegisterNUICallback( 'pvp:tournamentCloseRegistrations', function( data, cb )
    data = type( data ) == 'table' and data or {}
    data.open = false
    respondTournamentRpc( cb, 'pvp_setTournamentRegistrations', data )
end )

RegisterNUICallback( 'pvp:tournamentRegisterTeam', function( data, cb )
    respondTournamentRpc( cb, 'pvp_registerTournamentTeam' )
end )

RegisterNUICallback( 'pvp:tournamentStartMatch', function( data, cb )
    data = type( data ) == 'table' and data or {}
    respondTournamentRpc( cb, 'pvp_startTournamentMatch', data.matchId )
end )

RegisterNUICallback( 'pvp:tournamentStartAllMatches', function( data, cb )
    respondTournamentRpc( cb, 'pvp_startAllTournamentMatches' )
end )

RegisterNUICallback( 'pvp:tournamentStartMatches', function( data, cb )
    respondTournamentRpc( cb, 'pvp_startAllTournamentMatches' )
end )

RegisterNUICallback( 'pvp:tournamentStartAll', function( data, cb )
    respondTournamentRpc( cb, 'pvp_startAllTournamentMatches' )
end )

RegisterNUICallback( 'pvp:tournamentWatchMatch', function( data, cb )
    data = type( data ) == 'table' and data or {}
    respondTournamentRpc( cb, 'pvp_watchTournamentMatch', data.matchId )
end )

RegisterNUICallback( 'pvp:tournamentConfigureMatch', function( data, cb )
    data = type( data ) == 'table' and data or {}
    respondTournamentRpc( cb, 'pvp_configureTournamentMatch', data.matchId, data )
end )

RegisterNUICallback( 'pvp:tournamentToggleMatchPause', function( data, cb )
    data = type( data ) == 'table' and data or {}
    respondTournamentRpc( cb, 'pvp_toggleTournamentMatchPause', data.matchId )
end )

RegisterNUICallback( 'pvp:tournamentSetWinner', function( data, cb )
    data = type( data ) == 'table' and data or {}
    respondTournamentRpc( cb, 'pvp_setTournamentWinner', data.matchId, data.teamId )
end )

RegisterNUICallback( 'pvp:tournamentEnd', function( data, cb )
    respondTournamentRpc( cb, 'pvp_endTournament', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentCancel', function( data, cb )
    respondTournamentRpc( cb, 'pvp_endTournament', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentClose', function( data, cb )
    respondTournamentRpc( cb, 'pvp_endTournament', type( data ) == 'table' and data or {} )
end )

RegisterNUICallback( 'pvp:tournamentCreateTeam', function( data, cb )
    data = type( data ) == 'table' and data or {}

    CreateThread( function()
        local success, lobbyIdOrErr = RPC.pvp_createTournamentTeam( data )
        cb({
            success = success,
            lobbyId = success and lobbyIdOrErr or nil,
            data = success and { lobbyId = lobbyIdOrErr } or nil,
            message = not success and lobbyIdOrErr or nil,
            error = not success and lobbyIdOrErr or nil,
        })
    end )
end )

-- Enviar desafio para time adversário
RegisterNUICallback( 'pvp:sendChallenge', function( data, cb )
    local targetLobbyId = data.targetId or data.id
    if not targetLobbyId then
        cb({ success = false, message = pvpText( 'invalid_team_id' ) })
        return
    end
    local success, err = RPC.pvp_sendChallenge( tostring( targetLobbyId ) )
    cb({ success = success, message = err })
end )

RegisterNUICallback( 'pvp:sendChallengeTeam', function( data, cb )
    local teamId = data.teamId
    if not teamId then
        cb({ success = false, message = pvpText( 'invalid_team_id' ) })
        return
    end

    local success, err = RPC.pvp_sendChallenge( tostring( teamId ) )
    cb({ success = success, message = err })
end )

RegisterNUICallback( 'pvp:lobbyRoomClosed', function( data, cb )
    local closed = type( data ) == 'table' and data.closed == true
    local success, err = RPC.pvp_setLobbyClosed( closed )
    cb({ success = success, message = err })
end )

-- Responder desafio Team vs Team
RegisterNUICallback( 'pvp:challengeInviteResponse', function( data, cb )
    local challengeId = type( data ) == 'table' and ( data.challengeId or data.inviteId or data.id ) or nil
    local accepted    = type( data ) == 'table' and data.accepted == true
    if not challengeId then
        local message = pvpText( 'invalid_challenge_id' )
        cb({ success = false, message = message, error = message })
        return
    end
    local success, err = RPC.pvp_challengeInviteResponse( challengeId, accepted )
    cb({ success = success, message = err, error = not success and err or nil })
end )

RegisterNUICallback( 'pvp:challengeBetConfirmResponse', function( data, cb )
    data = type( data ) == 'table' and data or {}

    local challengeId = data.challengeId or data.inviteId or data.id
    local accepted = data.accepted == true

    if not challengeId and type( currentChallengeBetConfirmData ) == 'table' then
        challengeId = currentChallengeBetConfirmData.challengeId
            or currentChallengeBetConfirmData.inviteId
            or currentChallengeBetConfirmData.id
    end

    if not challengeId then
        local message = pvpText( 'invalid_challenge_id' )
        releaseChallengeBetConfirmFocus()
        cb({ success = false, message = message, error = message })
        return
    end

    local success, err = RPC.pvp_challengeInviteResponse( challengeId, accepted )
    betDebug(
        'client callback response challenge=%s accepted=%s success=%s error=%s',
        tostring( challengeId ),
        tostring( accepted ),
        tostring( success ),
        tostring( err )
    )

    releaseChallengeBetConfirmFocus()
    sendPvpNuiMessage( 'PVP_CHALLENGE_BET_CONFIRM', { show = false })

    cb({ success = success, message = err, error = not success and err or nil })
end )

RegisterNUICallback( 'pvp:mapSelectorVote', function( data, cb )
    local mapId = type( data ) == 'table' and data.mapId or nil
    local success, err = RPC.pvp_mapSelectorVote( mapId )
    cb({ success = success, message = err, error = not success and err or nil })
end )

RegisterNUICallback( 'pvp:mapSelectorLeave', function( data, cb )
    local message = pvpText( 'map_vote_leave_disabled' )
    cb({ success = false, message = message, error = message })
end )

RegisterNUICallback( 'pvp:weaponSelectorVote', function( data, cb )
    local weaponId = type( data ) == 'table' and data.weaponId or nil
    local success, err = RPC.pvp_weaponSelectorVote( weaponId )
    cb({ success = success, message = err, error = not success and err or nil })
end )

RegisterNUICallback( 'pvp:weaponSelectorLeave', function( data, cb )
    local message = pvpText( 'weapon_vote_leave_disabled' )
    cb({ success = false, message = message, error = message })
end )

-- Ranking PVP
RegisterNUICallback( 'PVP_RANKING', function( data, cb )
    data = data or {}
    local gameMode = data.gameMode or 'all'
    local page     = data.page or 1
    local perPage  = data.perPage or 9
    local rankingScope = data.rankingScope or 'players'
    local result   = RPC.pvp_getRanking( gameMode, page, perPage, rankingScope )
    cb( result or { players = {} } )
end )

-- Fechar UI lobby/menu (chamado pelo frontend)
RegisterNUICallback( 'hideFrame', function( data, cb )
    if isScheduledEventsVisible then
        closeScheduledEventsPanel()
        cb({ success = true })
        return
    end

    if CloseDominationMigrationNotice() then
        cb({ success = true })
        return
    end

    if keepChallengeBetConfirmOpen() then
        cb({ success = false })
        return
    end

    if currentWeaponSelectorData then
        local message = pvpText( 'weapon_vote_leave_disabled' )
        cb({ success = false, message = message, error = message })
        return
    end

    if currentMapSelectorData then
        local message = pvpText( 'map_vote_leave_disabled' )
        cb({ success = false, message = message, error = message })
        return
    end

    GameModeToggleUI()
    cb({ success = true })
end )

-- Sair do lobby pelo botão in-lobby (overlay de team selection / exitLobby)
RegisterNUICallback( 'exitLobby', function( data, cb )
    if currentWeaponSelectorData then
        local message = pvpText( 'weapon_vote_leave_disabled' )
        cb({ success = false, message = message, error = message })
        return
    end

    if currentMapSelectorData then
        local message = pvpText( 'map_vote_leave_disabled' )
        cb({ success = false, message = message, error = message })
        return
    end

    local success, err = RPC.pvp_leaveParty()
    cb({ success = success, message = err })
end )

-- Seleção de time (TeamA / TeamB via overlay — times são pré-atribuídos no competitivo)
RegisterNUICallback( 'selectTeam', function( data, cb )
    -- Teams sao definidos pelo sistema de lobby; payload ignorado no competitivo.
    cb({ success = true })
end )

-- Votação de mapa — defer para após implementação de map voting
RegisterNUICallback( 'voteMap', function( data, cb )
    cb({ success = false, message = pvpText( 'map_vote_unavailable' ) })
end )

-- =============================================
-- Callbacks vindos da NUI do resource `hud`
-- =============================================
-- A HUD/overlays in-game (MatchStart, MapVote, TeamSelection, etc.) vivem no
-- NUI do resource `hud`. Quando o user clica em "Sair", "Votar" ou "Escolher
-- time", o callback `fetchNui` é capturado pelo `hud/client/hud/pvp.lua`, que
-- repassa via `TriggerEvent('pvp.callback:<name>', data)` (cross-resource no
-- mesmo cliente). Tratamos aqui pra reaproveitar a mesma lógica dos callbacks
-- diretos acima.

AddEventHandler( 'pvp.callback:exitLobby', function( data )
    if currentWeaponSelectorData then
        return
    end

    if currentMapSelectorData then
        return
    end

    RPC.pvp_leaveParty()
end )

AddEventHandler( 'pvp.callback:selectTeam', function( data )
    -- Times pre-atribuidos no competitivo; noop por enquanto.
end )

AddEventHandler( 'pvp.callback:voteMap', function( data )
    -- Votação de mapa ainda não implementada
end )
