-- Local input: the client-side sx.client.nametags API, with no server involvement. Two events back it,
-- unified across both kinds (ePtfxKind.player | ePtfxKind.entity); the networked path lives in netnametag.lua.
-- These handlers live for the resource lifetime, so there's nothing to detach on termination.
--   * sx:client:nametags:create(kind, id, name) -> resolve the def NAME and draw the label on the bound ped
--   * sx:client:nametags:remove(kind, id)        -> drop the bound label
-- `id` is a server id for the player kind (the ped is resolved from it each frame) or a fixed local entity
-- handle for the entity kind (a podium ped, an object).

---@return nil
function InitializeNametagHostHandlers()

    AddEventHandler( 'sx:client:nametags:create', function( kind, id, name )

        local def = gNametagRegistry.byName[ name ]
        assert( def, ('nametags_host: unknown nametag "%s"'):format( name ) )
        CreateNametag( kind, id, def )
    end )

    AddEventHandler( 'sx:client:nametags:remove', function( kind, id )

        RemoveNametag( kind, id )
    end )
end
