---@type boolean
gIsInGamemasterMode = nil

---@param options? { skipGamemasterModeChecks?: boolean }
---@return boolean
function IsInGamemasterMode( options )

    if not gIsInGamemasterMode and options?.skipGamemasterModeChecks then
        
        return true
    end 

    return gIsInGamemasterMode
end

exports( 'IsInGamemasterMode', IsInGamemasterMode )

---@param args table
---@param options? table
function gamemaster.client.addGroup( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.addGroup', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.removeGroup( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.removeGroup', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.reviveLocation( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.reviveLocation', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.revivePlayer( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.revivePlayer', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.openBackpack( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.openBackpack', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.kickPlayer( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.kickPlayer', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.banPlayer( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.banPlayer', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.copyId( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.copyId', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.discordId( args, options )

    if not IsInGamemasterMode() then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end
end

---@param args table
---@param options? table
function gamemaster.client.giveItem( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.giveItem', args, options )
end

---@param args table
---@param options? table
function gamemaster.client.teleportTo( args, options )

    if not IsInGamemasterMode( options ) then

        -- esta no modo IsInGamemasterMode ?
        
        return
    end

    TriggerServerEvent( 'net.gamemaster.teleportTo', args, options )
end

exports( 'addGroup', gamemaster.client.addGroup )

exports( 'removeGroup', gamemaster.client.removeGroup )

exports( 'reviveLocation', gamemaster.client.reviveLocation )

exports( 'revivePlayer', gamemaster.client.revivePlayer )

exports( 'openBackpack', gamemaster.client.openBackpack )

exports( 'kickPlayer', gamemaster.client.kickPlayer )

exports( 'banPlayer', gamemaster.client.banPlayer )

exports( 'copyId', gamemaster.client.copyId )

exports( 'discordId', gamemaster.client.discordId )

exports( 'giveItem', gamemaster.client.giveItem )

exports( 'teleportTo', gamemaster.client.teleportTo )