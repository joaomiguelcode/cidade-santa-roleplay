-- Networked input: the replicated 'sxPtfx' player-state. The server authority (code/server/ptfx_authority)
-- is the sole writer and reverts client forgeries; the value is a def INDEX. This is the only networked way
-- an effect is commanded — the local API lives in localptfx.lua. Owns its statebag cookie so it can detach
-- on termination.

---@type number? -- the AddStateBagChangeHandler cookie; owned here so TerminateNetPtfxHandlers can detach it
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
    assert( serverId, ('ptfx_host: unparseable player bag "%s"'):format( bagName ) )

    return serverId
end

---@return nil
function InitializeNetPtfxHandlers()

    -- Player bags replicate globally (not culled by scope like entity bags), so a nil here means the server
    -- cleared it or the player disconnected — either way, free the entry (which stops the live handles and
    -- releases the assets). Ped stream in/out is handled by the FSM, not here.
    gNetworkCookie = AddStateBagChangeHandler( 'sxPtfx', nil, function( bagName, _key, value )

        local serverId = ServerIdFromBagName( bagName )

        if value == nil then
            RemovePtfx( ePtfxKind.player, serverId )
        else
            local def = gPtfxRegistry.byIndex[ value ]
            assert( def, ('ptfx_host: no def for index %s'):format( tostring( value ) ) )
            CreatePtfx( ePtfxKind.player, serverId, def )
        end
    end )
end

---@return nil
function TerminateNetPtfxHandlers()

    if gNetworkCookie ~= nil then
        RemoveStateBagChangeHandler( gNetworkCookie )
        gNetworkCookie = nil
    end
end
