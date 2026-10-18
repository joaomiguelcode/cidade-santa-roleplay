-- MinigameClient registra a instancia em MinigameInstances pelo nome funcional.
local gRoyaleClient
local gRoyaleMatchId
local gRoyalePhase
local gAllowVehicles = true
local gPreparationFreeze
local gExitConfirmation
local gProtectionAbort
local gProtectedPed
local gPreparationZone = RoyalePreparationZone()
local gSafeZone = RoyaleSafeZoneClient()
local gRoyaleHud = RoyaleHud()
local gAllies = RoyaleAlliesClient()
local gPreparationBannerKey = 'royale-preparation'
local gVehicleWarningKey = 'royale-vehicle-disabled'
local gVehicleWarningShown = false
local gNextSafeActionCheck = 0
local gPersonalChestAvailable = false
local gPersonalChestRequest
local gDowned = false
local gDeathExpiresAt
local gDeathHudVisible = false
local gLifecycleRevision = 0
local gWorldBlipsHidden = false
local gReviving
local gReconnectRequest
local gReceivedReconnectIds = {}
local gRevive = RoyaleReviveClient( {
    isAlive = function()

        return gRoyalePhase == 'combat' and not gDowned and not gReviving
    end,
} )

---@param hidden boolean
local function SetWorldBlipsHidden( hidden )

    if gWorldBlipsHidden == hidden then return end
    if GetResourceState( 'hud' ) ~= 'started' then return end

    gWorldBlipsHidden = hidden
    exports.hud:SetBlipsHidden( 'dminigames:royale', hidden )
end

---@param matchId any
---@return boolean
local function IsCombatMatch( matchId )

    return gRoyalePhase == 'combat' and gRoyaleMatchId == matchId
end

local function HideDeathHud()

    if not gDeathHudVisible then return end

    gDeathHudVisible = false
    TriggerEvent( 'pvp.hud:hideDominationDeath' )
end

local function ShowDeathHud()

    if not gDowned or not gDeathExpiresAt or GetResourceState( 'hud' ) ~= 'started' then return end

    gDeathHudVisible = true
    TriggerEvent( 'pvp.hud:showDominationDeath', {
        durationSeconds = 120,
        remainingSeconds = math.max( 0, math.ceil( ( gDeathExpiresAt - GetGameTimer() ) / 1000 ) ),
        stateLabel = PvpTranslations.get( 'domination_death_state' ),
        respawnLabel = PvpTranslations.get( 'royale_downed_wait' ),
        timerLabel = PvpTranslations.get( 'royale_downed_timer' ),
    } )
end

---@param isCurrent fun(): boolean
---@return boolean restored
local function RestorePlayerHealth( isCurrent )

    gRoyaleClient:setDownedState( false )

    if not isCurrent() then return false end

    local ped = PlayerPedId()

    if ped == 0 or not DoesEntityExist( ped ) then return false end

    if IsEntityDead( ped ) or IsPedDeadOrDying( ped, true ) or GetEntityHealth( ped ) <= 100 then
        local coords = GetEntityCoords( ped )
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, GetEntityHeading( ped ) )
        Wait( 0 )

        if not isCurrent() then return false end

        ped = PlayerPedId()
    end

    if not DoesEntityExist( ped ) then return false end

    if GetResourceState( 'survival' ) == 'started' then
        exports.survival:Revive( 400 )

        if not isCurrent() or PlayerPedId() ~= ped or not DoesEntityExist( ped ) then return false end

        TriggerServerEvent( 'net.player.revive_status_changed' )
    end

    SetPedMaxHealth( ped, 400 )
    SetEntityHealth( ped, 400 )
    SetEntityInvincible( ped, false )
    SetEntityCanBeDamaged( ped, true )
    LocalPlayer.state.Invincible = false
    FreezeEntityPosition( ped, false )
    SetEntityCollision( ped, true, true )
    SetEntityVisible( ped, true, false )
    ResetEntityAlpha( ped )
    ClearPedTasksImmediately( ped )
    return true
end

---@param data table
local function OnPlayerDowned( data )

    if type( data ) ~= 'table' or not IsCombatMatch( data.matchId ) or gDowned then return end

    gDowned = true
    local localSource = GetPlayerServerId( PlayerId() )
    gRoyaleClient.alivePlayers[ localSource ] = nil
    gRoyaleClient.deadPlayers[ localSource ] = true
    gRevive:Suspend()
    gRoyaleHud:Hide()
    gSafeZone:ClearOutsideWarning()
    TriggerEvent( 'inventory:CloseAll' )
end

---@param matchId any
---@return boolean
local function IsPreparingMatch( matchId )

    return gRoyalePhase == 'preparing' and gRoyaleMatchId == matchId
end

local function ReleasePreparationFreeze()

    local freeze = gPreparationFreeze
    gPreparationFreeze = nil

    if freeze and DoesEntityExist( freeze.ped ) and not ( gDowned and PlayerPedId() == freeze.ped ) then
        FreezeEntityPosition( freeze.ped, false )
    end
end

---@param ped number
---@param coords table
local function FreezePreparationEntry( ped, coords )

    ReleasePreparationFreeze()
    local freeze = { ped = ped }
    gPreparationFreeze = freeze
    FreezeEntityPosition( ped, true )
    RequestCollisionAtCoord( coords.x, coords.y, coords.z )
    SetTimeout( 3000, function()

        if gPreparationFreeze == freeze then ReleasePreparationFreeze() end
    end )
end

---@param matchId any
---@param phase string
---@param isCurrent? fun(): boolean
---@return boolean current
local function DisableRoyalePowers( matchId, phase, isCurrent )

    TriggerEvent( 'admin:setJump', false )

    if gRoyaleMatchId ~= matchId or ( not isCurrent and gRoyalePhase ~= phase )
        or ( isCurrent and not isCurrent() ) then return false end

    TriggerEvent( 'resetEnergetic' )

    if gRoyaleMatchId ~= matchId or ( not isCurrent and gRoyalePhase ~= phase )
        or ( isCurrent and not isCurrent() ) then return false end

    TriggerEvent( 'net.noclip.disable' )

    if gRoyaleMatchId ~= matchId or ( not isCurrent and gRoyalePhase ~= phase )
        or ( isCurrent and not isCurrent() ) then return false end

    -- Desligar noclip pode descongelar o ped; preserva o prazo original de entrada.
    local freeze = gPreparationFreeze

    if gRoyalePhase == 'combat' and freeze and DoesEntityExist( freeze.ped ) then
        FreezeEntityPosition( freeze.ped, true )
    end

    return true
end

---@param data table Payload de preparacao recebido do servidor.
---@param receivedAt number Relogio local no recebimento, antes de chamadas que podem ceder.
local function ShowPreparationBanner( data, receivedAt )

    local remainingMs = math.max( 0, ( tonumber( data.preparationRemainingMs ) or 0 ) - ( GetGameTimer() - receivedAt ) )

    if remainingMs <= 0 then return end

    local organizationName = data.zone and data.zone.name

    SendNUIMessage( {
        action = 'PVP_DOMINATION_NOTIFY',
        type = 'PVP_DOMINATION_NOTIFY',
        data = {
            key = gPreparationBannerKey,
            kind = 'opened',
            title = PvpTranslations.get( 'royale_name' ),
            message = PvpTranslations.get( 'royale_preparation_banner_message' ),
            detail = organizationName and { { text = organizationName, highlight = true } } or nil,
            countdownMs = remainingMs,
            durationMs = remainingMs,
            countdownLabel = PvpTranslations.get( 'royale_preparation_countdown' ),
            countdownDoneLabel = PvpTranslations.get( 'royale_preparation_countdown_done' ),
        },
    } )
end

local function ClosePersonalChest()

    if GetResourceState( 'inventory' ) ~= 'started' then return end

    local success, message = pcall( function() exports.inventory:ClosePersonalChest() end )

    if not success then sx.logger:warn( ( 'Royale: falha ao fechar bau pessoal: %s' ):format( message ) ) end
end

---@return boolean available
local function RefreshSafeActions()

    local ped = PlayerPedId()
    local available = gRoyalePhase == 'preparing' and gRoyaleMatchId ~= nil and DoesEntityExist( ped )
        and GetEntityHealth( ped ) > 100 and gPreparationZone:Contains( GetEntityCoords( ped ) )

    if available ~= gPersonalChestAvailable then
        gPersonalChestAvailable = available
        gRoyaleHud:SetPersonalChestAvailable( available )

        if not available then ClosePersonalChest() end
    end

    return available and gRoyalePhase == 'preparing'
end

local function OpenPersonalChest()

    if not RefreshSafeActions() or gPersonalChestRequest or IsNuiFocused()
        or GetResourceState( 'inventory' ) ~= 'started'
    then
        return
    end

    local matchId = gRoyaleMatchId
    local request = {}
    gPersonalChestRequest = request
    local success, opened = pcall( function() return exports.inventory:OpenPersonalChest() end )

    if gPersonalChestRequest == request then gPersonalChestRequest = nil end

    if not success then
        sx.logger:warn( ( 'Royale: falha ao abrir bau pessoal: %s' ):format( opened ) )
    elseif opened and ( not IsPreparingMatch( matchId ) or not RefreshSafeActions() ) then
        ClosePersonalChest()
    end
end

local function ProtectPreparation()

    if gRoyalePhase ~= 'preparing' then return end

    local ped = PlayerPedId()

    if gPreparationFreeze and gPreparationFreeze.ped ~= ped then ReleasePreparationFreeze() end

    if ped ~= gProtectedPed then
        gProtectedPed = ped
        SetEntityInvincible( ped, true )
        SetEntityCanBeDamaged( ped, false )
    end

    DisablePlayerFiring( PlayerId(), true )

    local now = GetGameTimer()

    if now >= gNextSafeActionCheck then
        gNextSafeActionCheck = now + 250
        RefreshSafeActions()
    end

    Wait( 0 )
end

---@param enabled boolean
local function SetPreparationProtection( enabled )

    local ped = PlayerPedId()
    gProtectedPed = enabled and ped or nil

    SetEntityInvincible( ped, enabled )
    SetEntityCanBeDamaged( ped, not enabled )
    LocalPlayer.state[ 'Invincible' ] = enabled

    if enabled and not gProtectionAbort then
        gProtectionAbort = sx.script.setTick( ProtectPreparation )
    elseif not enabled and gProtectionAbort then
        gProtectionAbort()
        gProtectionAbort = nil
    end
end

---@param confirmed? boolean
local function CloseExitConfirmation( confirmed )

    local confirmation = gExitConfirmation

    if not confirmation then return end

    gExitConfirmation = nil
    RemoveEventHandler( confirmation.handler )
    TriggerEvent( 'pvp.hud:closeExitMatch' )
    confirmation.callback( confirmed == true and gRoyaleMatchId == confirmation.matchId )
end

local function ClearPreparationState()

    SetPreparationProtection( false )
    gPersonalChestAvailable = false
    gNextSafeActionCheck = 0
    gRoyaleHud:SetPersonalChestAvailable( false )
    SendNUIMessage( {
        action = 'PVP_DOMINATION_NOTIFY_CLEAR',
        type = 'PVP_DOMINATION_NOTIFY_CLEAR',
        data = { key = gPreparationBannerKey },
    } )
    gPreparationZone:Close()
    TriggerEvent( 'inventory:CloseAll' )
end

---@param data? table
local function CloseRoyaleMatch( data )

    if not gRoyaleMatchId then return end
    if data and data.matchId and data.matchId ~= gRoyaleMatchId then return end

    local ped = PlayerPedId()
    local restoreHealth = gDowned or gReviving ~= nil
        or ( DoesEntityExist( ped ) and GetEntityHealth( ped ) <= 100 )
    gLifecycleRevision = gLifecycleRevision + 1
    local revision = gLifecycleRevision
    gReconnectRequest = nil
    gDowned, gDeathExpiresAt, gReviving = false, nil, nil
    gRoyaleMatchId = nil
    gRoyalePhase = nil
    gAllowVehicles = true
    if gVehicleWarningShown then
        gVehicleWarningShown = false
        SendNUIMessage( {
            action = 'PVP_DOMINATION_NOTIFY_CLEAR',
            type = 'PVP_DOMINATION_NOTIFY_CLEAR',
            data = { key = gVehicleWarningKey },
        } )
    end
    SetWorldBlipsHidden( false )
    gAllies:Close()
    gRevive:Close()
    HideDeathHud()
    gSafeZone:Close()
    ReleasePreparationFreeze()
    CloseExitConfirmation()
    gRoyaleHud:Hide()
    ClearPreparationState()

    if restoreHealth and gLifecycleRevision == revision then
        RestorePlayerHealth( function() return gLifecycleRevision == revision and not gRoyaleMatchId end )
    end
end

gRoyaleClient = MinigameClient( {
    name = PVP_ROYALE_MINIGAME_NAME,
    match = {
        respawnOnDeath = false,
        enableGhostModeOnDeath = false,
        downedState = { collision = false },
        onPlayerDeath = OnPlayerDowned,
        onLocalPlayerEnteredVehicle = function( vehicle, ped )

            if not gRoyaleMatchId or gAllowVehicles
                or ( gRoyalePhase ~= 'preparing' and gRoyalePhase ~= 'combat' ) then return end

            TaskLeaveVehicle( ped, vehicle, 16 )
            gVehicleWarningShown = true
            SendNUIMessage( {
                action = 'PVP_DOMINATION_NOTIFY',
                type = 'PVP_DOMINATION_NOTIFY',
                data = {
                    key = gVehicleWarningKey,
                    kind = 'closing',
                    title = PvpTranslations.get( 'royale_name' ),
                    message = PvpTranslations.get( 'royale_vehicle_disabled_warning' ),
                    durationMs = 5000,
                },
            } )
        end,
        confirmLeave = function( callback )

            if not gRoyaleMatchId or GetResourceState( 'hud' ) ~= 'started' then
                callback( false )
                return
            end

            CloseExitConfirmation()
            local confirmation = { matchId = gRoyaleMatchId, callback = callback }
            gExitConfirmation = confirmation
            confirmation.handler = AddEventHandler( 'pvp.callback:exitMatchResponse', function( data )

                if gExitConfirmation ~= confirmation then return end

                CloseExitConfirmation( type( data ) == 'table' and data.confirmed == true )
            end )

            TriggerEvent( 'pvp.hud:openExitMatch', {
                title = PvpTranslations.get( 'exit_match_title' ),
                description = PvpTranslations.get( 'exit_match_description' ),
                confirmLabel = PvpTranslations.get( 'exit_match_confirm' ),
                cancelLabel = PvpTranslations.get( 'exit_match_cancel' ),
            } )
        end,
        onLateJoin = function( data )

            -- O Royale nao precisa do loop de visibilidade/roster do ghost mode.
            gRoyaleClient:stopVisibilityLoop()

            if gRoyaleMatchId ~= data.matchId then
                if not gRoyaleMatchId then gRoyaleClient:stopMatchBinds() end
                return
            end

            gRoyaleClient:transitionToState( gDowned and MinigameClient.GameState.MATCH_SPECTATOR
                or MinigameClient.GameState.MATCH_GAMEPLAY, 'royale match' )

            if gPreparationFreeze and gPreparationFreeze.ped == PlayerPedId()
                and DoesEntityExist( gPreparationFreeze.ped ) then
                FreezeEntityPosition( gPreparationFreeze.ped, true )
            end
        end,
        onEnd = CloseRoyaleMatch,
        onLeave = CloseRoyaleMatch,
    },
} )

RegisterNetEvent( 'pvp.royale:prepare', function( data )

    if type( data ) ~= 'table' or not data.matchId then return end
    if gRoyaleMatchId == data.matchId and gRoyalePhase == 'combat' then return end

    local receivedAt = GetGameTimer()
    gLifecycleRevision = gLifecycleRevision + 1
    gReconnectRequest = nil
    gRoyaleMatchId = data.matchId
    gRoyalePhase = 'preparing'
    gAllowVehicles = data.allowVehicles ~= false
    SetWorldBlipsHidden( true )
    local team = type( data.team ) == 'table' and data.team or {}
    gAllies:Open( data.matchId, team.name, team.sources )
    TriggerEvent( 'pvp.client:forceClosePanel' )

    if not IsPreparingMatch( data.matchId ) then return end

    LocalPlayer.state[ 'minigame:active' ] = PVP_ROYALE_MINIGAME_NAME

    if not DisableRoyalePowers( data.matchId, 'preparing' ) then return end

    SetPreparationProtection( true )
    local coords = data.headquarters
    local ped = PlayerPedId()

    ClearPedTasksImmediately( ped )
    SetEntityCoords( ped, coords.x, coords.y, coords.z, false, false, false, false )
    FreezePreparationEntry( ped, coords )

    if coords.w then SetEntityHeading( ped, coords.w ) end

    gRoyaleHud:Show( data.playerCount )

    if not IsPreparingMatch( data.matchId ) then return end

    ShowPreparationBanner( data, receivedAt )

    if not IsPreparingMatch( data.matchId ) then return end

    local opened = gPreparationZone:Open( data.zone )

    if not IsPreparingMatch( data.matchId ) then
        if gRoyaleMatchId == data.matchId then gPreparationZone:Close() end
        return
    end

    if not opened then
        sx.logger:warn( 'Royale: nao foi possivel abrir o visual da preparacao' )
    end

    RefreshSafeActions()
end )

RegisterNetEvent( 'pvp.royale:startCombat', function( data )

    if type( data ) ~= 'table' or not IsPreparingMatch( data.matchId ) then return end

    gRoyalePhase = 'combat'

    if gReconnectRequest then
        gReconnectRequest.phase = 'combat'
        gReconnectRequest.safe = data.safe
        gReconnectRequest.playerCount = data.playerCount
    end

    -- Recebe os alvos mesmo se um export da transicao ceder execucao.
    gRevive:Open( data.matchId )
    gRoyaleHud:SetPlayerCount( data.playerCount )
    CloseExitConfirmation()

    if not DisableRoyalePowers( data.matchId, 'combat' ) then return end

    ClearPreparationState()

    if gRoyaleMatchId ~= data.matchId or gRoyalePhase ~= 'combat' then return end

    gSafeZone:Open( data.matchId, data.safe )
    gRoyaleHud:Show()

    if gRoyaleMatchId ~= data.matchId or gRoyalePhase ~= 'combat' then return end

    TriggerEvent( 'Notify', 'verde', PvpTranslations.get( 'royale_combat_started' ), 10000 )
end )

---@class RoyaleReconnectSnapshot
---@field matchId number
---@field queueId number
---@field reconnectId string
---@field phase 'preparing'|'combat'
---@field coords {x:number,y:number,z:number,w?:number}
---@field health number
---@field armor number
---@field downed boolean
---@field remainingDownedMs? number
---@field playerCount number
---@field team {name:string,sources:number[]}
---@field safe? table
---@field zone? table
---@field preparationRemainingMs? number
---@field preparationIsTest? boolean
---@field allowVehicles? boolean

---@param value any
---@return boolean
local function IsFiniteNumber( value )

    return type( value ) == 'number' and value == value and math.abs( value ) < math.huge
end

---@param data any
---@return boolean
local function IsReconnectSnapshot( data )

    if type( data ) ~= 'table' or data.matchId == nil or type( data.reconnectId ) ~= 'string'
        or data.reconnectId == '' or ( data.phase ~= 'preparing' and data.phase ~= 'combat' )
        or type( data.coords ) ~= 'table' or not IsFiniteNumber( data.coords.x )
        or not IsFiniteNumber( data.coords.y ) or not IsFiniteNumber( data.coords.z )
        or ( data.coords.w ~= nil and not IsFiniteNumber( data.coords.w ) )
        or not IsFiniteNumber( data.health ) or data.health < 0 or data.health > 400
        or not IsFiniteNumber( data.armor ) or data.armor < 0 or data.armor > 100
        or type( data.downed ) ~= 'boolean' or type( data.team ) ~= 'table'
        or type( data.team.name ) ~= 'string' or data.team.name == ''
        or type( data.team.sources ) ~= 'table' then return false end

    if data.downed then
        if data.phase ~= 'combat' or not IsFiniteNumber( data.remainingDownedMs )
            or data.remainingDownedMs <= 0 then return false end
    elseif data.health <= 100 then
        return false
    end

    return data.phase == 'combat' and type( data.safe ) == 'table'
        or data.phase == 'preparing' and type( data.zone ) == 'table'
end

---@param data RoyaleReconnectSnapshot
local function HydrateRoyaleReconnect( data )

    if not IsReconnectSnapshot( data ) or gReceivedReconnectIds[ data.reconnectId ]
        or gRoyaleClient.currentMatchId ~= data.matchId
        or ( gRoyaleMatchId and gRoyaleMatchId ~= data.matchId ) then return end

    local ped, receivedAt = PlayerPedId(), GetGameTimer()

    if ped == 0 or not DoesEntityExist( ped ) then return end

    gReceivedReconnectIds[ data.reconnectId ] = true
    gLifecycleRevision = gLifecycleRevision + 1
    local revision = gLifecycleRevision
    local request = { phase = data.phase, safe = data.safe, playerCount = data.playerCount }
    gReconnectRequest = request
    gRoyaleMatchId, gRoyalePhase = data.matchId, data.phase
    gAllowVehicles = data.allowVehicles ~= false
    gDowned, gReviving = data.downed, nil
    gDeathExpiresAt = data.downed and receivedAt + data.remainingDownedMs or nil

    local function IsCurrent()

        return gReconnectRequest == request and gLifecycleRevision == revision
            and gRoyaleClient.currentMatchId == data.matchId and gRoyaleMatchId == data.matchId
            and gRoyalePhase == request.phase and gDowned == data.downed
            and PlayerPedId() == ped and DoesEntityExist( ped )
    end

    -- Armado antes dos exports: os alvos enviados logo depois deste evento não se perdem.
    if data.phase == 'combat' then gRevive:Open( data.matchId ) else gRevive:Close() end
    if data.downed then gRevive:Suspend() end
    if not IsCurrent() then return end
    gAllies:Open( data.matchId, data.team.name, data.team.sources )
    if not IsCurrent() then return end

    LocalPlayer.state[ 'minigame:active' ] = PVP_ROYALE_MINIGAME_NAME
    gRoyaleClient.isLeaving = false
    gRoyaleClient.currentRoundNumber = 0
    local localSource = GetPlayerServerId( PlayerId() )
    gRoyaleClient.alivePlayers[ localSource ] = not data.downed or nil
    gRoyaleClient.deadPlayers[ localSource ] = data.downed or nil
    gRoyaleClient:transitionToState( data.downed and MinigameClient.GameState.MATCH_SPECTATOR
        or MinigameClient.GameState.MATCH_GAMEPLAY, 'royale reconnect' )
    gRoyaleClient:handleMatchBinds()
    gRoyaleClient:setDownedState( false )
    if not IsCurrent() then return end

    TriggerEvent( 'pvp.client:forceClosePanel' )
    if not IsCurrent() then return end
    if not DisableRoyalePowers( data.matchId, data.phase, IsCurrent ) then return end
    SetWorldBlipsHidden( true )
    if not IsCurrent() then return end
    CloseExitConfirmation()
    ClearPreparationState()
    if not IsCurrent() then return end
    HideDeathHud()

    local coords = data.coords
    local health = data.downed and 100 or data.health

    if IsEntityDead( ped ) or IsPedDeadOrDying( ped, true ) or GetEntityHealth( ped ) <= 100 then
        NetworkResurrectLocalPlayer( coords.x, coords.y, coords.z, coords.w or GetEntityHeading( ped ) )
        Wait( 0 )
        if not IsCurrent() then return end
    end

    if GetResourceState( 'survival' ) == 'started' then
        -- Limpa a morte do RP usando a vida do snapshot; não concede revive de 400 HP.
        exports.survival:Revive( health )
        if not IsCurrent() then return end
    end

    SetPedMaxHealth( ped, 400 )
    SetEntityHealth( ped, health )
    SetPedArmour( ped, data.armor )
    SetEntityCollision( ped, true, true )
    SetEntityVisible( ped, true, false )
    ResetEntityAlpha( ped )
    ClearPedTasksImmediately( ped )
    SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, false, false, false )
    SetEntityVelocity( ped, 0.0, 0.0, 0.0 )
    if coords.w then SetEntityHeading( ped, coords.w ) end
    FreezePreparationEntry( ped, coords )
    gAllies:Refresh( true )
    if not IsCurrent() then return end

    if request.phase == 'combat' then
        gSafeZone:Open( data.matchId, request.safe )
        if not IsCurrent() then return end
    else
        SetPreparationProtection( true )
        ShowPreparationBanner( data, receivedAt )
        if not IsCurrent() then return end
        if request.phase == 'preparing' then
            gPreparationZone:Open( data.zone )
            if not IsCurrent() then return end

            if request.phase == 'preparing' then RefreshSafeActions() else gPreparationZone:Close() end
            if not IsCurrent() then return end
        end
    end

    gRoyaleHud:SetPlayerCount( request.playerCount )
    if data.downed then
        gRoyaleClient:setDownedState( true )
        if not IsCurrent() then return end
        gRoyaleHud:Hide()
        gSafeZone:ClearOutsideWarning()
        ShowDeathHud()
    else
        gRoyaleHud:Show()
    end

    if IsCurrent() then gReconnectRequest = nil end
end

RegisterNetEvent( 'pvp.royale:reconnect', function( data )

    if source ~= 65535 then return end

    HydrateRoyaleReconnect( data )
end )

---@class RoyaleVictoryResult
---@field resultId string
---@field isWinner boolean
---@field factionName string
---@field factionBanner? string

---@param data RoyaleVictoryResult
RegisterNetEvent( 'pvp.royale:victory', function( data )

    if source ~= 65535 or type( data ) ~= 'table'
        or type( data.resultId ) ~= 'string' or data.resultId == ''
        or type( data.isWinner ) ~= 'boolean'
        or type( data.factionName ) ~= 'string' or data.factionName == '' then return end

    -- Eliminados tambem recebem o resultado; a HUD controla os 10s fora do ciclo da partida.
    TriggerEvent( 'pvp.hud:openRoyaleVictory', {
        resultId = data.resultId,
        isWinner = data.isWinner,
        factionName = data.factionName,
        factionBanner = data.factionBanner,
    } )
end )

RegisterNetEvent( 'pvp.royale:safeState', function( data )

    if type( data ) ~= 'table' or gRoyalePhase ~= 'combat' or data.matchId ~= gRoyaleMatchId then return end

    if gReconnectRequest then gReconnectRequest.safe = data.safe end
    gSafeZone:Apply( data.safe )
end )

RegisterNetEvent( 'pvp.royale:safeSync', function( data )

    if type( data ) ~= 'table' or gRoyalePhase ~= 'combat' or data.matchId ~= gRoyaleMatchId then return end

    gSafeZone:Synchronize( data )
end )

RegisterNetEvent( 'pvp.royale:toggleSafeBoundaryDebug', function( matchId )

    if source ~= 65535 or gRoyalePhase ~= 'combat' or matchId ~= gRoyaleMatchId then return end

    local enabled = gSafeZone:ToggleBoundaryDebug()

    if enabled == nil then return end

    TriggerEvent( 'Notify', 'amarelo', PvpTranslations.get( enabled
        and 'royale_test_safe_boundary_enabled' or 'royale_test_safe_boundary_disabled' ), 7000 )
end )

RegisterNetEvent( 'pvp.royale:safeDamage', function( data )

    if source ~= 65535 or type( data ) ~= 'table' or gRoyalePhase ~= 'combat'
        or data.matchId ~= gRoyaleMatchId or gDowned or gReviving then return end

    local applied, fatal = gSafeZone:ApplyDamage( data )

    -- SetEntityHealth nao garante CEventNetworkEntityDamage; confirma a queda pelo mesmo fluxo do framework.
    if applied and fatal then
        TriggerServerEvent( ( '%s.server:onPlayerDeath' ):format( PVP_ROYALE_MINIGAME_NAME ), {
            matchId = gRoyaleMatchId,
            health = GetEntityHealth( PlayerPedId() ),
            isHeadshot = false,
        } )
    end
end )

RegisterNetEvent( 'pvp.royale:downed', function( data )

    if source ~= 65535 or type( data ) ~= 'table' or not IsCombatMatch( data.matchId ) then return end

    OnPlayerDowned( data )

    if not IsCombatMatch( data.matchId ) or not gDowned or gDeathExpiresAt then return end

    gDeathExpiresAt = GetGameTimer() + 120000
    ShowDeathHud()
end )

RegisterNetEvent( 'pvp.royale:revived', function( data )

    if source ~= 65535 or type( data ) ~= 'table' or not IsCombatMatch( data.matchId )
        or not gDowned or gReviving then return end

    local revision, request = gLifecycleRevision, {}
    gReviving = request
    local restored = RestorePlayerHealth( function()

        return gLifecycleRevision == revision and IsCombatMatch( data.matchId ) and gReviving == request
    end )

    if gReviving ~= request then return end

    gReviving = nil

    if not restored then return end

    gDowned, gDeathExpiresAt = false, nil
    local localSource = GetPlayerServerId( PlayerId() )
    gRoyaleClient.deadPlayers[ localSource ] = nil
    gRoyaleClient.alivePlayers[ localSource ] = true
    gRoyaleClient:transitionToState( MinigameClient.GameState.MATCH_GAMEPLAY, 'royale ally revived' )
    gAllies:Refresh( true )
    HideDeathHud()
    gRevive:Resume()
    gRoyaleHud:Show()
end )

RegisterNetEvent( 'pvp.royale:allyChanged', function( data )

    if source ~= 65535 or type( data ) ~= 'table' or not gRoyaleMatchId
        or data.matchId ~= gRoyaleMatchId then return end

    gAllies:ApplyDelta( data )
end )

for eventName, method in pairs( {
    reviveTargets = 'SetTargets',
    reviveEligibility = 'SetEligibility',
    reviveStarted = 'OnStarted',
    reviveCancelled = 'OnCancelled',
    reviveFinished = 'OnFinished',
} ) do
    RegisterNetEvent( ( 'pvp.royale:%s' ):format( eventName ), function( data )

        if source ~= 65535 or type( data ) ~= 'table' or not IsCombatMatch( data.matchId ) then return end

        gRevive[ method ]( gRevive, data )
    end )
end

RegisterCommand( '+dminigames_royale_personal_chest', OpenPersonalChest, false )
RegisterCommand( '-dminigames_royale_personal_chest', function() end, false )
RegisterKeyMapping( '+dminigames_royale_personal_chest', PvpTranslations.get( 'royale_personal_chest_key_mapping' ), 'keyboard', 'F4' )

RegisterNetEvent( 'pvp.royale:returnToHeadquarters', function( data )

    if type( data ) ~= 'table' or not IsPreparingMatch( data.matchId ) then return end

    TriggerEvent( 'inventory:CloseAll' )

    if not IsPreparingMatch( data.matchId ) then return end

    local ped = PlayerPedId()

    if not DoesEntityExist( ped ) then return end

    local coords = data.headquarters

    ClearPedTasksImmediately( ped )
    SetEntityCoordsNoOffset( ped, coords.x, coords.y, coords.z, false, false, false )
    SetEntityVelocity( ped, 0.0, 0.0, 0.0 )

    if coords.w then SetEntityHeading( ped, coords.w ) end
end )

RegisterNetEvent( 'pvp.royale:playerCount', function( data )

    if type( data ) ~= 'table' or not gRoyaleMatchId or data.matchId ~= gRoyaleMatchId then return end

    if gReconnectRequest then gReconnectRequest.playerCount = data.playerCount end
    gRoyaleHud:SetPlayerCount( data.playerCount )
end )

AddEventHandler( 'onClientResourceStart', function( resourceName )

    if resourceName == 'hud' and gRoyaleMatchId then
        SetWorldBlipsHidden( true )
        if gDowned then ShowDeathHud() else gRoyaleHud:Show() end
    end
end )

AddEventHandler( 'onClientResourceStop', function( resourceName )

    if resourceName == 'hud' then gWorldBlipsHidden = false end

    if resourceName == 'hud' and gRoyaleMatchId then
        CloseExitConfirmation()
        gRoyaleHud:Hide()
        HideDeathHud()
    end

    if resourceName == GetCurrentResourceName() then
        if gRoyaleMatchId then
            LocalPlayer.state[ 'minigame:active' ] = nil
        end

        CloseRoyaleMatch()
    end
end )
