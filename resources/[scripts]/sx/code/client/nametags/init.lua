-- Entrypoint for the nametag render host. Loaded LAST in the folder (after the state + functions it wires).
-- Owns the init/termination flow:
--   InitNametagHost()      -- install the network + local-API inputs; the draw thread is still lazy (first nametag spawns it)
--   TerminateNametagHost() -- detach the network input so a restart leaves no dangling statebag handler
-- Unlike the ptfx host, the draw loop holds no engine resources (it is a per-frame DrawText — nothing
-- persists), so there is nothing to tear down on stop beyond the statebag cookie. The thread ends on its own
-- when the resource unloads. See FLOW.md for the diagram — keep it in sync.

---@return nil
function InitNametagHost()

    InitializeNetNametagHandlers()  -- netnametag.lua: the replicated 'sxNametag' statebag (owns its own cookie)
    InitializeNametagHostHandlers() -- localnametag.lua: the sx.client.nametags events
end

---@return nil
function TerminateNametagHost()

    TerminateNetNametagHandlers() -- netnametag.lua detaches its statebag handler
end

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    TerminateNametagHost()
end )

InitNametagHost()
