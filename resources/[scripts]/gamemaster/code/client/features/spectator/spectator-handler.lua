local function SpectatorModeTick()
    local currentTarget = gamemaster.client.state.GetCurrentSpectatingTarget()

    if not currentTarget then
        return
    end

    local hit, entCoords, entity = RayCastGamePlayCamera()

    if hit and entity and DoesEntityExist( entity ) and IsEntityAPed( entity ) and IsPedAPlayer( entity ) then
        local playerIndex = NetworkGetPlayerIndexFromPed( entity )

        if playerIndex and playerIndex ~= -1 then
            if exports.wall then
                exports.wall:DrawBoxAroundEntity( entity, entCoords, 255, 0, 0, 255 )
            end
        end
    end
end

---@param spectators gamemaster.SpectatorStaffInfo[]
RegisterNetEvent( 'gamemaster:spectatingStateChanged', function( spectators )
    
    if gamemaster.client.state.GetCurrentSpectatingTarget() ~= nil then
        SendNUIMessage(
            {
                action = 'SPEC_UPDATE_USERSPECTATORS',
                data = spectators
            }
        )

        sx.logger:debug( ( 'gamemaster:spectatingStateChanged -> spectators: %s' ):format( json.encode( spectators, { indent = true } ) ) )
    end
end)

---@param spectatorData gamemaster.SpectatorData
RegisterNetEvent( 'net.gamemaster.spectatingStarted', function( spectatorData )

    assert( type( spectatorData ) == 'table', 'spectatorData must be a table' )

    gamemaster.client.state.SetCurrentSpectatingTarget( spectatorData[ 3 ] )

    if gamemaster.client.spectator.tickAbortSignal == nil then
        gamemaster.client.spectator.tickAbortSignal = sx.script.setTick( SpectatorModeTick )
    end

    TriggerEvent( 'gamemaster.spectatingReceivedData', spectatorData )

    -- sx.logger:info( ( 'net.gamemaster.spectatingStarted -> spectatorData: %s' ):format( json.encode( spectatorData ) ) )
end)

RegisterNetEvent( 'net.gamemaster.spectatingStopped', function()

    gamemaster.client.state.SetCurrentSpectatingTarget( nil )
    
    if gamemaster.client.spectator.tickAbortSignal then
        
        gamemaster.client.spectator.tickAbortSignal()
        gamemaster.client.spectator.tickAbortSignal = nil

        -- sx.logger:debug( 'net.gamemaster.spectatingStopped -> stopped SpectatorModeTick' )
    end
    
    TriggerEvent( 'gamemaster.spectatingCleanData' )

    -- sx.logger:info( 'net.gamemaster.spectatingStopped -> stopping spectator mode' )
end)

---@param spectatorData gamemaster.SpectatorData
AddEventHandler( 'gamemaster.spectatingReceivedData', function( spectatorData )

    assert( type( spectatorData ) == 'table', 'spectatorData must be a table' )

    local picture = GetProfilePicture( spectatorData[ 3 ] )
    
    gIsInGamemasterMode = spectatorData[ 1 ]
    spectatorData[ 5 ] = ('https://nui-img/%s/%s'):format( picture, picture )
    spectatorData[ 8 ] = GetPlayerMetricStatus( spectatorData[ 3 ] )

    SendNUIMessage(
        {
            action       = 'SPEC_VISIBILESPEC',
            data         = {
                display           = true,
                menuType          = spectatorData[ 1 ],
                currentPlayerId   = spectatorData[ 2 ],
                targetsByGroup    = spectatorData[ 11 ],
                players           = {
                    {
                        source         = spectatorData[ 3 ],
                        name           = spectatorData[ 4 ],
                        avatar         = spectatorData[ 5 ],
                        id             = spectatorData[ 2 ],
                        customId       = spectatorData[ 12 ],
                        kd             = spectatorData[ 6 ],
                        discordId      = spectatorData[ 7 ],
                        status         = spectatorData[ 8 ],
                        staffCount     = spectatorData[ 9 ],
                        playerRestrict = spectatorData[ 10 ],
                        -- ENG-3714: a NUI do gamemaster ainda nao le este campo; o fonte
                        -- React dela nao esta no repo. Vai no payload pra nao precisar
                        -- mexer no server quando a tela for atualizada.
                        staffOnDuty    = spectatorData[ 13 ]
                    }
                },
            }
        }
    )

    -- TriggerEvent( 'hud:setHudStatus',  false )
    -- TriggerEvent( 'hud:Active', false )

    sx.logger:info( ( 'spectatingReceivedData -> spectatorData: %s' ):format( json.encode( spectatorData ) ) )
end)

AddEventHandler( 'gamemaster.spectatingCleanData', function()
    
    gIsInGamemasterMode = nil
    SetNuiFocus( false, false )
    SendNUIMessage(
        {
            action = 'SPEC_VISIBILESPEC',
            data = {
                display = false
            }
        }
    )

    -- TriggerEvent( 'hud:setHudStatus',  true )
    -- TriggerEvent( 'hud:Active', true )
end)

---@param options? { isForced?: boolean }
function EnableSpectatorVisibleMenu( _, options )

    if IsInGamemasterMode() then
        
        gCurrentSpectatorVisibleMenu = options?.isForced or not gCurrentSpectatorVisibleMenu
        
        SetNuiFocus( gCurrentSpectatorVisibleMenu, gCurrentSpectatorVisibleMenu )
        SetPlayerControl( PlayerId(), not gCurrentSpectatorVisibleMenu, 0 | ( 1 << 9 ) )
    
        SendNUIMessage( 
            {
                action = 'SPEC_VISIBLE_MENU',
                data = {
                    active = gCurrentSpectatorVisibleMenu
                }
            }
        )
    end
end

RegisterNetEvent( 'net.gamemaster.enableSpectatorVisibleMenu', EnableSpectatorVisibleMenu)

RegisterCommand( '+enable.spectator.visible_menu', EnableSpectatorVisibleMenu )
RegisterCommand( '-disable.spectator.visible_menu', EnableSpectatorVisibleMenu )

RegisterKeyMapping('+enable.spectator.visible_menu','Enable Spectator Visible Menu','keyboard','LMENU')


RegisterCommand( 'spectator.nextplayer', function()

    if gamemaster.client.state.GetCurrentSpectatingTarget() ~= nil then
        TriggerServerEvent( 'net.spectator.changePlayerInSpectator', eChangePlayerInSpectator.nextPlayer )
    end
end)

RegisterCommand('spectator.previousplayer',function()

    if gamemaster.client.state.GetCurrentSpectatingTarget() ~= nil then
        TriggerServerEvent( 'net.spectator.changePlayerInSpectator', eChangePlayerInSpectator.previousPlayer )
    end
end)

RegisterKeyMapping( 'spectator.nextplayer', 'Next Player', 'keyboard', 'RIGHT' )
RegisterKeyMapping( 'spectator.previousplayer', 'Previous Player', 'keyboard', 'LEFT' )