-- TEST-ONLY: client-side benchmark for the sx ptfx render host. Spawns N local peds in a ring around the
-- local ped, drops each onto the ground (GetGroundZFor_3dCoord), attaches an sx ptfx to every one via
-- sx.client.ptfx.create(ePtfxKind.entity, ...), and samples frametime before vs after so the per-effect cost is visible.
-- Not networked, not loaded in prod intent — just a profiling aid. Cleanup with /benchptfxclear.
--
--   /benchptfx [count] [ptfxName] [radius]
--   /benchptfxclear

local BENCH_PED_MODEL    = `a_m_y_skater_01` -- a cheap streamable ped; the test is about ptfx cost, not the ped
local BENCH_DEFAULT_PTFX = 'SOCIALRANKING_RANK_1'     -- gPtfxRegistry name (see sx code/shared/ptfxs/*)
local BENCH_SAMPLE_MS    = 12000             -- frametime sampling window per measurement
local BENCH_SETTLE_MS    = 2000              -- let the ptfx host's FSM load + start the effects before sampling

---@type number[] -- local handles of the peds this bench spawned
local gBenchPeds = {}

-- Sample GetFrameTime() (seconds) every frame for `durationMs`, returning frametimes in MILLISECONDS.
---@param durationMs number
---@return number[] frametimesMs
local function SampleFrametimes( durationMs )

    local samples = {}
    local deadline = GetGameTimer() + durationMs

    while GetGameTimer() < deadline do
        samples[ #samples + 1 ] = GetFrameTime() * 1000.0
        Wait( 0 )
    end

    return samples
end

-- Nearest-rank percentile over a copy (the input is left unsorted for the caller).
---@param sorted number[] -- MUST be pre-sorted ascending
---@param pct number -- 0-100
---@return number
local function Percentile( sorted, pct )

    local n = #sorted
    if n == 0 then
        return 0.0
    end

    local rank = math.ceil( ( pct / 100.0 ) * n )
    if rank < 1 then rank = 1 end
    if rank > n then rank = n end

    return sorted[ rank ]
end

---@class FrametimeStats
---@field count  number
---@field median number
---@field p95    number
---@field p99    number
---@field min    number
---@field max    number
---@field avg    number

---@param samples number[] -- frametimes in ms
---@return FrametimeStats
local function ComputeStats( samples )

    local sorted = {}
    local sum = 0.0
    for i = 1, #samples do
        sorted[ i ] = samples[ i ]
        sum = sum + samples[ i ]
    end
    table.sort( sorted )

    local n = #sorted

    return {
        count  = n,
        median = Percentile( sorted, 50 ),
        p95    = Percentile( sorted, 95 ),
        p99    = Percentile( sorted, 99 ),
        min    = n > 0 and sorted[ 1 ] or 0.0,
        max    = n > 0 and sorted[ n ] or 0.0,
        avg    = n > 0 and ( sum / n ) or 0.0,
    }
end

---@param label string
---@param stats FrametimeStats
---@return nil
local function LogStats( label, stats )

    sx.logger:info( ( '[benchptfx] %s | samples=%d median=%.3fms avg=%.3fms p95=%.3fms p99=%.3fms min=%.3fms max=%.3fms (~%.1f fps median)' ):format(
        label, stats.count, stats.median, stats.avg, stats.p95, stats.p99, stats.min, stats.max,
        stats.median > 0 and ( 1000.0 / stats.median ) or 0.0
    ) )
end

-- Drop a coord onto the ground. Collision around the local ped is already resident (small ring), but request
-- it anyway and give it a couple of frames so GetGroundZFor_3dCoord returns a hit rather than the fallback z.
---@param x number
---@param y number
---@param z number -- a z safely ABOVE the surface to probe downward from
---@return number groundZ
local function ResolveGroundZ( x, y, z )

    RequestCollisionAtCoord( x, y, z )

    local found, groundZ = false, z
    for _ = 1, 10 do
        found, groundZ = GetGroundZFor_3dCoord( x, y, z, false )
        if found then
            return groundZ
        end
        Wait( 0 )
    end

    return z -- never resolved (no collision) — fall back to the probe z
end

---@param model number
---@return boolean
local function LoadPedModel( model )

    if not IsModelInCdimage( model ) or not IsModelValid( model ) then
        sx.logger:error( ( '[benchptfx] invalid ped model %s' ):format( tostring( model ) ) )
        return false
    end

    RequestModel( model )
    local deadline = GetGameTimer() + 5000
    while not HasModelLoaded( model ) and GetGameTimer() < deadline do
        Wait( 0 )
    end

    return HasModelLoaded( model )
end

---@return nil
local function ClearBench()

    for i = 1, #gBenchPeds do
        local ped = gBenchPeds[ i ]
        if DoesEntityExist( ped ) then
            sx.client.ptfx.remove( ePtfxKind.entity, ped ) -- detach before the handle goes away
            DeleteEntity( ped )
        end
    end

    gBenchPeds = {}
    sx.logger:info( '[benchptfx] cleared all bench peds' )
end

---@param count number
---@param ptfxName string
---@param radius number
---@return nil
local function RunBench( count, ptfxName, radius )

    if #gBenchPeds > 0 then
        sx.logger:warn( '[benchptfx] previous bench still active — running /benchptfxclear first' )
        ClearBench()
    end

    if not LoadPedModel( BENCH_PED_MODEL ) then
        return
    end

    -- PHASE 1 — baseline: settle so the scene is quiet, then sample with nothing spawned
    sx.logger:info( ( '[benchptfx] phase 1/3 (baseline): settling %dms then sampling %dms' ):format( BENCH_SETTLE_MS, BENCH_SAMPLE_MS ) )
    Wait( BENCH_SETTLE_MS )
    local baseline = ComputeStats( SampleFrametimes( BENCH_SAMPLE_MS ) )

    -- PHASE 2 — peds only: spawn the ring (no ptfx), settle so they finish streaming in, then sample
    local origin = GetEntityCoords( PlayerPedId() )

    for i = 1, count do
        local angle = ( i / count ) * 2.0 * math.pi
        local x = origin.x + math.cos( angle ) * radius
        local y = origin.y + math.sin( angle ) * radius
        local groundZ = ResolveGroundZ( x, y, origin.z + 2.0 )

        local ped = CreatePed( 4, BENCH_PED_MODEL, x, y, groundZ, math.deg( angle ), false, false )
        SetEntityAsMissionEntity( ped, true, true ) -- keep it from being culled by the population manager
        FreezeEntityPosition( ped, true )
        SetBlockingOfNonTemporaryEvents( ped, true )

        gBenchPeds[ #gBenchPeds + 1 ] = ped
    end

    SetModelAsNoLongerNeeded( BENCH_PED_MODEL )
    sx.logger:info( ( '[benchptfx] phase 2/3 (peds only): spawned %d peds (radius=%.1f), settling %dms then sampling %dms' ):format(
        #gBenchPeds, radius, BENCH_SETTLE_MS, BENCH_SAMPLE_MS
    ) )
    Wait( BENCH_SETTLE_MS )
    local pedsOnly = ComputeStats( SampleFrametimes( BENCH_SAMPLE_MS ) )

    -- PHASE 3 — peds + ptfx: attach the effect to every ped, settle so the host FSM loads/starts them, then sample
    for i = 1, #gBenchPeds do
        sx.client.ptfx.create( ePtfxKind.entity, gBenchPeds[ i ], ptfxName )
    end

    sx.logger:info( ( '[benchptfx] phase 3/3 (peds + ptfx): attached ptfx=%s to %d peds, settling %dms then sampling %dms' ):format(
        ptfxName, #gBenchPeds, BENCH_SETTLE_MS, BENCH_SAMPLE_MS
    ) )
    Wait( BENCH_SETTLE_MS )
    local pedsAndPtfx = ComputeStats( SampleFrametimes( BENCH_SAMPLE_MS ) )

    LogStats( 'BASELINE     ', baseline )
    LogStats( 'PEDS ONLY    ', pedsOnly )
    LogStats( 'PEDS + PTFX  ', pedsAndPtfx )

    local n = #gBenchPeds
    sx.logger:info( ( '[benchptfx] ped cost vs baseline: median=%+.3fms p95=%+.3fms p99=%+.3fms (%.4fms/ped median)' ):format(
        pedsOnly.median - baseline.median, pedsOnly.p95 - baseline.p95, pedsOnly.p99 - baseline.p99,
        n > 0 and ( ( pedsOnly.median - baseline.median ) / n ) or 0.0
    ) )
    sx.logger:info( ( '[benchptfx] ptfx cost vs peds-only: median=%+.3fms p95=%+.3fms p99=%+.3fms (%.4fms/ptfx median)' ):format(
        pedsAndPtfx.median - pedsOnly.median, pedsAndPtfx.p95 - pedsOnly.p95, pedsAndPtfx.p99 - pedsOnly.p99,
        n > 0 and ( ( pedsAndPtfx.median - pedsOnly.median ) / n ) or 0.0
    ) )
    sx.logger:info( '[benchptfx] run /benchptfxclear to remove the bench peds' )
end

-- RegisterCommand( 'benchptfx', function( _source, args )
--
--     local count    = tonumber( args[ 1 ] ) or 32
--     local ptfxName = args[ 2 ] or BENCH_DEFAULT_PTFX
--     local radius   = tonumber( args[ 3 ] ) or 8.0
--
--     if count < 1 then
--         sx.logger:warn( '[benchptfx] count must be >= 1' )
--         return
--     end
--
--     -- the host caps rendered effects at MAX_PTFX_SLOTS (128); warn rather than silently under-render
--     if count > 128 then
--         sx.logger:warn( ( '[benchptfx] count=%d exceeds the ptfx host slot cap (128); only 128 will render' ):format( count ) )
--     end
--
--     CreateThread( function()
--         RunBench( count, ptfxName, radius )
--     end )
-- end, false )

RegisterCommand( 'benchptfxclear', function()
    ClearBench()
end, false )

-- leave no bench peds (or their attached ptfx) behind on restart
AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ClearBench()
end )
