-- Local input: the client-side sx.client.ptfx API, with no server involvement. Two events back it, unified
-- across both kinds (ePtfxKind.player | ePtfxKind.entity); the networked path lives in netptfx.lua. These
-- handlers live for the resource lifetime, so there's nothing to detach on termination.
--   * sx:client:ptfx:create(kind, id, name) -> resolve the def NAME and drive the effect onto the bound ped
--   * sx:client:ptfx:remove(kind, id)        -> tear the bound effect down
-- `id` is a server id for the player kind (the ped is resolved from it each frame) or a fixed local entity
-- handle for the entity kind (a podium ped, an object).

---@return nil
function InitializePtfxHostHandlers()

    AddEventHandler( 'sx:client:ptfx:create', function( kind, id, name )

        local def = gPtfxRegistry.byName[ name ]
        assert( def, ('ptfx_host: unknown ptfx "%s"'):format( name ) )
        CreatePtfx( kind, id, def )
    end )

    AddEventHandler( 'sx:client:ptfx:remove', function( kind, id )

        RemovePtfx( kind, id )
    end )
end
