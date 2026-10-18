-- Render step: how an entry loads its assets, drives layers onto the bound ped with LOD, and tears that down
-- again. Only the three FSM entry points are global (TeardownPtfxRender for the stop paths, PtfxKeepAlive +
-- ProcessPtfx for the update thread); the rest is local to this file.

-- ============================================================================ asset loading

-- Enter 'loading': take an asset hold for every layer (which requests any not yet resident). Holds are taken
-- for ALL layers regardless of LOD, so an LOD promotion can start its handle instantly with no reload stall.
-- Pairs with TeardownPtfxRender, which releases these holds on EVERY exit from loading/playing.
---@param ptfx Ptfx
---@return nil
local function BeginPtfxLoading( ptfx )

    local layers = ptfx.def.layers
    for i = 1, #layers do
        AcquirePtfxAsset( layers[ i ].dict )
    end

    ptfx.state = 'loading'
end

-- FSM 'loading' poll: are all of this def's layer assets resident yet? (The requests were issued by the
-- AcquirePtfxAsset holds taken in BeginPtfxLoading, so this only reads readiness.)
---@param def PtfxDef
---@return boolean ready
local function AreDefAssetsLoaded( def )

    for i = 1, #def.layers do
        if not HasNamedPtfxAssetLoaded( def.layers[ i ].dict ) then
            return false
        end
    end

    return true
end

-- ============================================================================ teardown

-- The single render teardown, reused by every stop path (dormant transition, def swap, bag clear, resource
-- stop). Idempotent: a no-op unless the entry is actually rendering (loading/playing), so callers never
-- guard it. Removes any live handles (decrementing the budget) and releases the asset holds taken in
-- BeginPtfxLoading. Must run before ptfx.def is changed/cleared (it reads def.layers to release).
---@param ptfx Ptfx
---@return nil
function TeardownPtfxRender( ptfx )

    if ptfx.state ~= 'loading' and ptfx.state ~= 'playing' then
        return
    end

    RemoveAllPtfxLayers( ptfx )

    local layers = ptfx.def.layers
    for i = 1, #layers do
        ReleasePtfxAsset( layers[ i ].dict )
    end
end

-- Drop back to the non-rendering 'dormant' state from loading/playing: tear the render down and forget the
-- bound ped, so the dormant pass re-resolves and re-starts once the ped is present and in range again.
---@param ptfx Ptfx
---@return nil
local function EnterPtfxDormant( ptfx )

    TeardownPtfxRender( ptfx )
    ptfx.ped   = 0
    ptfx.state = 'dormant'
end

-- ============================================================================ ped resolution

---@param serverId number
---@return number ped -- 0 when the player is out of scope / has no valid ped
local function GetPlayerPedFromServerId( serverId )

    local playerId = GetPlayerFromServerId( serverId )
    if playerId == -1 then
        return 0
    end

    local ped = GetPlayerPed( playerId )
    return DoesEntityExist( ped ) and ped or 0
end

-- The ped this entry should render on right now, by kind. 'player' re-resolves from the server id (so
-- respawns/stream-in are picked up); 'entity' is the fixed handle (0 once it's been deleted). 0 means
-- "no ped" — the FSM then waits/teardowns exactly as it does for an out-of-scope player.
---@param ptfx Ptfx
---@return number ped -- 0 when there is no valid ped
local function ResolvePtfxPed( ptfx )

    if ptfx.kind == 'entity' then
        return DoesEntityExist( ptfx.entity ) and ptfx.entity or 0
    end

    return GetPlayerPedFromServerId( ptfx.serverId )
end

-- ============================================================================ distance / LOD

---@param ped number
---@param focusCoords vector3
---@param maxDistance number
---@return boolean
local function IsPtfxPedWithin( ped, focusCoords, maxDistance )

    return #( GetEntityCoords( ped ) - focusCoords ) <= maxDistance
end

-- True while a playing/loading effect should keep rendering: its ped must still be the bound one and within
-- the outer (hysteresis) range. The ped-identity check short-circuits, so a stale ptfx.ped is never passed
-- to the distance native.
---@param ptfx Ptfx
---@param focusCoords vector3
---@return boolean
local function ShouldKeepPtfxRendering( ptfx, focusCoords )

    return ResolvePtfxPed( ptfx ) == ptfx.ped
        and IsEntityVisible( ptfx.ped )
        and IsPtfxPedWithin( ptfx.ped, focusCoords, PTFX_RENDER_DISTANCE + PTFX_RENDER_HYSTERESIS )
end

-- Is `layer` within its LOD cull distance? `isLive` selects the threshold so the boundary has hysteresis:
-- an off layer turns on at lodDist, an on layer stays on until lodDist + margin. A layer with lodDist =
-- math.huge (no LOD) is always desired.
---@param layer PtfxLayer
---@param dist number -- focus distance to the ped
---@param isLive boolean -- does a handle for this layer already exist
---@return boolean
local function LayerDesired( layer, dist, isLive )

    local threshold = isLive and ( layer.lodDist + PTFX_LOD_HYSTERESIS ) or layer.lodDist
    return dist <= threshold
end

-- Does the entry already have a live handle for this exact layer? (layer is the def.layers ref, so identity
-- compares.) The handle list is tiny (≤ a handful), so the linear scan is cheaper than a keyed map.
---@param ptfx Ptfx
---@param layer PtfxLayer
---@return boolean
local function HasLiveLayer( ptfx, layer )

    local handles = ptfx.handles
    for i = 1, #handles do
        if handles[ i ].layer == layer then
            return true
        end
    end

    return false
end

-- ============================================================================ render step

-- Run once per update for a playing entry: bring its layers in line with the LOD-desired set for the current
-- distance, then drive any custom motion. Persistent layers keep one engine-looped handle (created when
-- desired, removed when culled, budget + per-tick-cap gated so far layers retry next pass when the pool is
-- tight). A layer with loopEveryMilliseconds has no handle: it is re-fired as a one-shot at that rate while
-- in range (floored at the update tick). Finally each live handle whose layer has a tick() is repositioned.
-- State/render/LOD gating all come from being called here.
---@param ptfx Ptfx
---@param focusCoords vector3
---@return nil
local function ApplyPtfxLod( ptfx, focusCoords )

    EnterPtfxProfilerScope( 'ptfx:lod' )

    local ped    = ptfx.ped
    local dist   = #( GetEntityCoords( ped ) - focusCoords )
    local layers = ptfx.def.layers
    local now    = GetGameTimer()

    -- cull: drop live (looped) handles whose layer left its LOD range (backwards: RemovePtfxLayer swap-removes)
    for i = #ptfx.handles, 1, -1 do
        if not LayerDesired( ptfx.handles[ i ].layer, dist, true ) then
            RemovePtfxLayer( ptfx, i )
        end
    end

    -- start/emit each desired layer
    for i = 1, #layers do
        local layer = layers[ i ]
        if LayerDesired( layer, dist, false ) then

            local rate = layer.loopEveryMilliseconds
            if rate then

                -- one-shot fx re-fired at its own rate (floored at the update tick) while in range
                local at = ptfx.emitAt[ layer ]
                if not at or now >= at then
                    StartPtfxNonLooped( ped, layer )
                    ptfx.emitAt[ layer ] = now + rate
                end

            elseif not HasLiveLayer( ptfx, layer ) and HasFreePtfxHandle() and gStartsThisTick < PTFX_STARTS_PER_TICK then

                CreatePtfxLayer( ptfx, ped, layer ) -- persistent engine-looped handle (else retry next pass)
            end
        end
    end

    -- custom motion: reposition each live looped handle whose layer declared a tick()
    local handles = ptfx.handles
    for i = 1, #handles do
        local rec = handles[ i ]
        if rec.layer.tick then
            rec.layer.tick( rec.handle, now - rec.startedAt )
        end
    end

    ExitPtfxProfilerScope()
end

-- Cheap per-tick upkeep for every active entry: a loading/playing effect whose ped swapped or drifted past
-- the outer range drops back to dormant (releasing its handles + asset holds). Runs every tick so teardown is
-- responsive; the heavier pass below is what's spread across ticks.
---@param ptfx Ptfx
---@param focusCoords vector3
---@return nil
function PtfxKeepAlive( ptfx, focusCoords )

    if ptfx.state == 'loading' or ptfx.state == 'playing' then
        if not ShouldKeepPtfxRendering( ptfx, focusCoords ) then
            EnterPtfxDormant( ptfx )
        end
    end
end

-- One heavy FSM step for a single entry (run for a round-robin slice each tick): dormant acquires the ped and
-- begins loading once it's in the inner range; loading enters playing once assets are resident AND the pool
-- has room (else it holds in loading and retries); playing applies LOD to its layer handles.
-- Out-of-range / ped-swap teardown is handled by PtfxKeepAlive every tick, so it isn't repeated here.
---@param ptfx Ptfx
---@param focusCoords vector3
---@return nil
function ProcessPtfx( ptfx, focusCoords )

    if ptfx.state == 'dormant' then

        local ped = ResolvePtfxPed( ptfx )
        if ped ~= 0 and IsEntityVisible( ped ) and IsPtfxPedWithin( ped, focusCoords, PTFX_RENDER_DISTANCE ) then
            ptfx.ped = ped
            BeginPtfxLoading( ptfx )
        end

    elseif ptfx.state == 'loading' then

        if AreDefAssetsLoaded( ptfx.def ) and HasFreePtfxHandle() then
            ptfx.state = 'playing'
            ApplyPtfxLod( ptfx, focusCoords ) -- start the in-range layers that fit the budget
        end

    elseif ptfx.state == 'playing' then

        ApplyPtfxLod( ptfx, focusCoords )
    end
end
