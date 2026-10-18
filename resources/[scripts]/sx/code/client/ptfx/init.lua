-- Entrypoint for the ptfx render host. Loaded LAST in the folder (after the state + functions it wires).
-- Owns the init/termination flow:
--   InitPtfxHost()      -- install the network + local-API inputs; the update thread is still lazy (first effect spawns it)
--   TerminatePtfxHost() -- detach the network input, tear every live entry's render down (handles + asset holds)
-- Termination runs on resource stop so a restart leaves no orphaned particles or dangling asset requests
-- (TeardownPtfxRender is a no-op for dormant entries). See FLOW.md for the diagram — keep it in sync.

---@return nil
function InitPtfxHost()

    InitializeNetPtfxHandlers()  -- netptfx.lua: the replicated 'sxPtfx' statebag (owns its own cookie)
    InitializePtfxHostHandlers() -- localptfx.lua: the sx.client.ptfx events
end

---@return nil
function TerminatePtfxHost()

    TerminateNetPtfxHandlers() -- netptfx.lua detaches its statebag handler

    for i = 1, MAX_PTFX_SLOTS do
        local ptfx = gPtfx[ i ]
        if ptfx.isValid then
            TeardownPtfxRender( ptfx )
        end
    end
end

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    TerminatePtfxHost()
end )

InitPtfxHost()
