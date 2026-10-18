-- Handle budget (128 ceiling). Every live looped handle the host started, across all entries, is counted in
-- gPtfxHandleCount: CreatePtfxLayer increments it (only for a handle the engine actually created),
-- RemovePtfxLayer decrements it (always). Kept honest by funnelling all creates/removes through those two,
-- so it never drifts from the real engine pool occupancy.

---@return boolean -- is the engine handle pool below our budget (room to start one more layer)
function HasFreePtfxHandle()

    return gPtfxHandleCount < PTFX_HANDLE_BUDGET
end

---@param ped number
---@param layer PtfxLayer
---@return number handle
local function StartLayerHandle( ped, layer )

    UseParticleFxAssetNextCall( layer.dict )

    local handle
    if layer.bone then
        handle = StartParticleFxLoopedOnPedBone(
            layer.effect, ped,
            layer.offset.x, layer.offset.y, layer.offset.z,
            layer.rotation.x, layer.rotation.y, layer.rotation.z,
            layer.bone, layer.scale, false, false, false )
    else
        handle = StartParticleFxLoopedOnEntity(
            layer.effect, ped,
            layer.offset.x, layer.offset.y, layer.offset.z,
            layer.rotation.x, layer.rotation.y, layer.rotation.z,
            layer.scale, false, false, false )
    end

    if layer.colour then
        SetParticleFxLoopedColour( handle, layer.colour.r / 255.0, layer.colour.g / 255.0, layer.colour.b / 255.0, false )
    end

    if layer.alpha then
        SetParticleFxLoopedAlpha( handle, layer.alpha )
    end

    return handle
end

-- Fire a one-shot (non-looped) instance of `layer` on `ped`, for layers declared looped=false: there is no
-- persistent handle, so the update re-fires it every tick while the layer is in range. Colour/alpha must be
-- set before the start call (they apply to the next non-looped fx).
---@param ped number
---@param layer PtfxLayer
---@return nil
function StartPtfxNonLooped( ped, layer )

    if layer.colour then
        SetParticleFxNonLoopedColour( layer.colour.r / 255.0, layer.colour.g / 255.0, layer.colour.b / 255.0 )
    end

    if layer.alpha then
        SetParticleFxNonLoopedAlpha( layer.alpha )
    end

    UseParticleFxAssetNextCall( layer.dict )

    if layer.bone then
        StartParticleFxNonLoopedOnPedBone(
            layer.effect, ped,
            layer.offset.x, layer.offset.y, layer.offset.z,
            layer.rotation.x, layer.rotation.y, layer.rotation.z,
            layer.bone, layer.scale, false, false, false )
    else
        StartParticleFxNonLoopedOnEntity(
            layer.effect, ped,
            layer.offset.x, layer.offset.y, layer.offset.z,
            layer.rotation.x, layer.rotation.y, layer.rotation.z,
            layer.scale, false, false, false )
    end
end

-- Start one looped handle for `layer` on `ped` and record it on the entry. Precondition: HasFreePtfxHandle().
-- StartParticleFxLooped* returns -1 / a non-existent handle when the engine pool is full; we only count and
-- keep a handle the engine actually created, so a refused start leaves the layer to retry next pass and never
-- over-counts the budget.
---@param ptfx Ptfx
---@param ped number
---@param layer PtfxLayer
---@return nil
function CreatePtfxLayer( ptfx, ped, layer )

    assert( HasFreePtfxHandle(), 'CreatePtfxLayer called with the handle pool at budget' )

    gStartsThisTick = gStartsThisTick + 1

    local handle = StartLayerHandle( ped, layer )
    if handle <= 0 or not DoesParticleFxLoopedExist( handle ) then
        return
    end

    local rec = { handle = handle, layer = layer }
    ptfx.handles[ #ptfx.handles + 1 ] = rec
    gPtfxHandleCount = gPtfxHandleCount + 1

    -- animated layer: stamp its clock so the update's tick() can compute the handle's age
    if layer.tick then
        rec.startedAt = GetGameTimer()
    end
end

-- Remove the handle record at index `i` (swap-remove; order doesn't matter). The global count is decremented
-- UNCONDITIONALLY: the engine may have already reaped the handle (ped deleted, pool exhaustion), but the
-- record is ours and is gone now — gating the decrement on DoesParticleFxLoopedExist would leak the budget
-- monotonically toward zero and eventually refuse every start.
---@param ptfx Ptfx
---@param i number
---@return nil
function RemovePtfxLayer( ptfx, i )

    local handles = ptfx.handles
    local rec = handles[ i ]

    if DoesParticleFxLoopedExist( rec.handle ) then
        RemoveParticleFx( rec.handle, false )
    end

    local n = #handles
    handles[ i ] = handles[ n ]
    handles[ n ] = nil

    gPtfxHandleCount = gPtfxHandleCount - 1
end

---@param ptfx Ptfx
---@return nil
function RemoveAllPtfxLayers( ptfx )

    for i = #ptfx.handles, 1, -1 do
        RemovePtfxLayer( ptfx, i )
    end
end
