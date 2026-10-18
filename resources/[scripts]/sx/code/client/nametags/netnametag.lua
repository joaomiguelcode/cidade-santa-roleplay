-- Networked input: the replicated 'sxNametag' player-state. The server authority
-- (code/server/nametags_authority) is the sole writer and reverts client forgeries; the value is a def
-- INDEX. This is the only networked way a nametag is commanded — the local API lives in localnametag.lua.
-- Owns its statebag cookie so it can detach on termination.

---@type number? -- the AddStateBagChangeHandler cookie; owned here so TerminateNetNametagHandlers can detach it
local gNetworkCookie = nil

---@param bagName string
---@return number serverId -- always a real id; a player bag name always carries one
local function ServerIdFromBagName( bagName )

    local player = GetPlayerFromStateBagName( bagName )
    if player ~= 0 then
        return GetPlayerServerId( player )
    end

    -- player already gone (disconnect): parse the id from the 'player:<id>' bag name
    local serverId = tonumber( bagName:match( 'player:(%d+)' ) )
    assert( serverId, ('nametags_host: unparseable player bag "%s"'):format( bagName ) )

    return serverId
end

---@return nil
function InitializeNetNametagHandlers()

    -- Player bags replicate globally (not culled by scope), so a nil here means the server cleared it or the
    -- player disconnected — either way, free the entry. Ped stream in/out is handled by the draw loop
    -- re-resolving the ped each frame, not here.
    gNetworkCookie = AddStateBagChangeHandler( 'sxNametag', nil, function( bagName, _key, value )

        local serverId = ServerIdFromBagName( bagName )

        if value == nil then
            RemoveNametag( ePtfxKind.player, serverId )
        else
            local def = gNametagRegistry.byIndex[ value ]
            assert( def, ('nametags_host: no def for index %s'):format( tostring( value ) ) )
            CreateNametag( ePtfxKind.player, serverId, def )
        end
    end )
end

---@return nil
function TerminateNetNametagHandlers()

    if gNetworkCookie ~= nil then
        RemoveStateBagChangeHandler( gNetworkCookie )
        gNetworkCookie = nil
    end
end
