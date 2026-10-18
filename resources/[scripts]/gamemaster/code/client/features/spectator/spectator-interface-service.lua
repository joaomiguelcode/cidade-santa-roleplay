RegisterNuiCallback( 'SPEC_MENU_ACTION', function( data, cb )

    sx.logger:debug( ( 'SPEC_MENU_ACTION -> data: %s' ):format( json.encode( data ) ) )
    
    local action = data.action
    local args = data.args or {}
    
    args.targetId = data.passport
    
    TriggerServerEvent( 'net.gamemaster.menuAction', action, args )
    cb( { success = true } )
end)

RegisterNuiCallback( 'SPEC_GET_SHORTCUTS', function( data, cb )

    local shortcuts = {}

    local shortcutsData = json.decode( GetResourceKvpString( 'gamemaster_spec_shorcuts' ) ) or {}

    cb( shortcutsData )
end)

RegisterNuiCallback( 'SPEC_SET_SHORTCUT', function( data, cb )

    local action = data.action
    local shortcut = data.shortcut

    local shortcutsData = json.decode( GetResourceKvpString( 'gamemaster_spec_shorcuts' ) ) or {}

    if shortcutsData[ action ] then
        shortcutsData[ action ] = shortcut
    else
        shortcutsData[ action ] = shortcut
    end

    SetResourceKvp( 'gamemaster_spec_shorcuts', json.encode( shortcutsData ) )

    cb( { success = true } )
end)

RegisterNuiCallback( 'SPEC_GETINFO', function( data, cb )

    local info = data

    -- sx.logger:debug( ( 'SPEC_GETINFO -> info: %s, data: %s' ):format( info, json.encode( data ) ) )

    local result = lib.callback.await( 'net.gamemaster.getInfo', false, info )

    -- sx.logger:debug( ( 'SPEC_GETINFO -> result for info "%s": %s' ):format( info, json.encode( result ) ) )

    if not result then

        cb( false )
        
        return
    end

    cb( result )
end)

RegisterNuiCallback( 'SPEC_CHECKITEM', function( data, cb )

    local itemName = data.itemName

    local targetId = data.passport

    local result = lib.callback.await( 'net.gamemaster.getInfo', false, { info = 'getItemIsValid', itemName = itemName, passport = targetId } )

    if not result then

        cb( { exists = false } )

        return
    end

    cb(
        {
            exists = true,
            spawn = itemName,
            name = result.Name,
            image = ('https://santaimagens.roleplayrp.com/img/inventory/%s.png'):format( result.Index ),
            consumable = result.Type == "Usável"
        }
    )
end)

RegisterNuiCallback( 'SPEC_CLOSE', function( data, cb )

    if not data?.display then
        EnableSpectatorVisibleMenu( )
    end 

    cb( { success = true } )
end)

RegisterNUICallback( 'getCityId', function( Data, Callback )
    local cityName = GetConvar( 'cityName', 'Santa' )
    Callback( cityName )
end)

RegisterNUICallback( 'getCityName', function( Data, Callback )
    local cityName = GetConvar( 'cityName', 'Santa' )
    Callback( cityName )
end)

RegisterNUICallback( 'getServerHost', function( Data, Callback )

    local api_url = GetConvar( 'api_url', '' )

    Callback( api_url )
end)

AddEventHandler( 'inventory:CloseAll', function( )

    --[[
    
        ao fechar inventario, caso estiver no IsGamemasterMode,
        força o menu de espectador a ser aberto novamente
    
        - @TkzDev
    ]]

    EnableSpectatorVisibleMenu( nil, { isForced = true } )
end)