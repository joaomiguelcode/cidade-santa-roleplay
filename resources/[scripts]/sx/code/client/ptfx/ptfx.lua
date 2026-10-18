-- Singleton render host for the replicated-ptfx subsystem. Runs ONCE (sx code/). It watches the 'sxPtfx'
-- player-state key and drives the particle onto each player's ped, re-applying on stream-in and clearing
-- on detach. The bag value is the def INDEX written by the server authority (code/server/ptfx_authority);
-- both sides resolve it against gPtfxRegistry (code/shared/ptfx_registry) — no local mirror. Local control
-- comes in via the sx:client:ptfx:create / :remove bridge (CreatePtfx / RemovePtfx) with a def NAME instead.
--
-- Effects are plain LOOPED particles: each layer is started once (StartParticleFxLooped*) and loops on the
-- engine with zero host involvement until removed. There is no re-emit. Two things bound cost:
--   * LOD — each layer carries a lodDist; layers cull beyond it, so a distant ped renders fewer layers.
--   * a HANDLE BUDGET — GTA renders at most ~128 looped scripted fx at once, and one effect is many layers,
--     so the host counts every live handle and refuses to start past PTFX_HANDLE_BUDGET (the pool exhausting
--     would make StartParticleFxLooped* silently fail for everyone, the local player included).
-- A layer may declare loopEveryMilliseconds (a one-shot fx re-fired at that rate while in range, for fx that
-- don't self-loop) and/or a tick() to reposition its looped handle each update (e.g. a rotating particle).
-- Both run in the update pass, so they inherit its state / render-distance / LOD gating — no separate thread.
--
-- This subsystem is split across one folder: config + entry table + entry lifecycle (start/stop) here
-- (ptfx.lua), then ptfxassetstreaming / ptfxhandlepool / ptfxrenderer / ptfxupdateloop, plus the netptfx +
-- localptfx inputs, hang off the globals declared here. init.lua is the entrypoint that installs the inputs
-- and owns the init/termination flow. See FLOW.md for the diagram.

-- ============================================================================ config / tunables

MAX_PTFX_SLOTS = 128 -- in-scope player cap; the desired-effect table is preallocated to this

-- Effects render only while their ped is near the local view. Distance is from the FOCUS position
-- (sx.client.player.getFocusPosition) so it tracks the freecam during noclip, not the ped. The threshold
-- has hysteresis so a ped sitting at the edge doesn't start/stop the effect every tick.
PTFX_RENDER_DISTANCE   = 50.0 -- metres from the focus position; start/keep effects within this
PTFX_RENDER_HYSTERESIS = 5.0  -- only stop once beyond DISTANCE + this, so the boundary doesn't flicker

-- LOD: a layer culls beyond its lodDist. The same hysteresis margin applies at each layer's edge so a ped
-- loitering on a layer's lodDist boundary doesn't add/remove that handle every pass.
PTFX_LOD_HYSTERESIS = 5.0

-- Engine handle pool (~128 looped scripted fx). Budget below it leaves headroom for world ptfx (fire,
-- weapons, ...). Creation is refused at the budget; LOD keeps distant effects cheap so far layers are the
-- first shed when the pool is tight.
PTFX_HANDLE_CEILING = 128 -- the engine limit, documented; the budget stays under it
PTFX_HANDLE_BUDGET  = 120

-- Thread cadence + per-tick work caps, so LOD transitions spread across frames instead of bursting one frame.
PTFX_TICK_MS         = 100 -- FSM tick; looped fx need no per-frame upkeep, so this is coarse
PTFX_STARTS_PER_TICK = 12  -- cap on new layer handles created per tick
PTFX_EVAL_PER_TICK   = 16  -- entries given the heavy ped/LOD pass per tick (round-robin)

-- ============================================================================ debug profiler

-- DEBUG: wrap the host's hot paths (the per-tick keep-alive + process passes and the per-entry LOD pass) in
-- named profiler scopes so `profiler record N` / `profiler view` attribute their cost. Off by default — when
-- disabled the Enter/Exit calls are skipped entirely, so production pays nothing. The update loop refreshes
-- this from the convar each tick, so `setr sx_ptfx_profiler 1` toggles it live (no restart). Only ever wrap
-- BALANCED regions (an Enter and its Exit with no early return between) so the profiler scope stack never desyncs.
gPtfxProfilerEnabled = false

---@param scope string -- a short label shown in the profiler timeline (e.g. 'ptfx:lod')
---@return nil
function EnterPtfxProfilerScope( scope )

    if gPtfxProfilerEnabled then
        ProfilerEnterScope( scope )
    end
end

---@return nil
function ExitPtfxProfilerScope()

    if gPtfxProfilerEnabled then
        ProfilerExitScope()
    end
end

-- ============================================================================ entry table

-- One Ptfx = one player's (or entity's) desired effect together with its live render state. isValid=false
-- marks a free entry; once valid, serverId/def are set and the FSM drives the particle onto the ped:
--   dormant -> not rendering: each pass, once the ped is present AND within render distance, begin loading
--   loading -> hold every layer's asset (no Wait); once resident AND the handle pool has room, start playing
--   playing -> a looped handle per in-range layer lives on the bound ped; LOD adds/removes layer handles as
--              the ped's distance crosses each layer's lodDist; leaving render range or a ped swap -> dormant
-- Leaving loading/playing always routes through EnterPtfxDormant (the one teardown that releases handles +
-- asset holds), so the entry persists to resume later — a player bag replicates globally and won't re-fire.
---@alias PtfxState 'dormant' | 'loading' | 'playing'

-- An entry binds a def to a PED, resolved each pass. The binding is one of two kinds:
--   'player' -> the ped is resolved from serverId (survives respawn/stream — the player path)
--   'entity' -> the ped IS a fixed local entity handle (a podium ped, an object's ped, etc.)
-- The FSM is identical for both; only how the ped is resolved differs (ResolvePtfxPed).
---@alias PtfxKind 'player' | 'entity'

-- One live looped handle and the layer it renders. The layer ref (identity into def.layers) is what the LOD
-- pass matches against the desired set; it also carries lodDist + dict.
---@class PtfxHandle
---@field handle    number
---@field layer     PtfxLayer
---@field startedAt? number -- GetGameTimer() at creation; set only when layer.tick exists (drives the tick's elapsedMs)

---@class Ptfx
---@field isValid  boolean        -- false = free entry; true guarantees def + (serverId|entity) are set
---@field kind     PtfxKind
---@field serverId number         -- 'player' kind: the owner server id (0 for 'entity')
---@field entity   number         -- 'entity' kind: the bound entity handle (0 for 'player')
---@field def      PtfxDef|false  -- the registry def being rendered
---@field state    PtfxState
---@field ped      number         -- the ped handles are bound to (0 unless loading/playing)
---@field handles  PtfxHandle[]   -- live looped handles (one per in-range layer); every rec counts against the budget
---@field emitAt   table<PtfxLayer, number> -- per loopEveryMilliseconds layer: next GetGameTimer() ms to re-fire it

---@param ptfx Ptfx -- the one definition of an empty entry, shared by init and RemovePtfx
---@return nil
function ResetPtfx( ptfx )

    ptfx.isValid  = false
    ptfx.kind     = 'player'
    ptfx.serverId = 0
    ptfx.entity   = 0
    ptfx.def      = false
    ptfx.state    = 'dormant'
    ptfx.ped      = 0
    ptfx.handles  = {}
    ptfx.emitAt   = {}
end

---@type Ptfx[]
gPtfx = table.create( MAX_PTFX_SLOTS, 0 )
for i = 1, MAX_PTFX_SLOTS do
    gPtfx[ i ] = {}
    ResetPtfx( gPtfx[ i ] )
end

---@type table<number, number> -- serverId -> slot index (player kind)
gPtfxSlotByServerId = {}
---@type table<number, number> -- entity handle -> slot index (entity kind)
gPtfxSlotByEntity = {}
gActiveCount   = 0
gThreadRunning = false
gEvalCursor    = 0 -- round-robin cursor for the per-tick heavy-pass slice

-- Asset hold refcount (dict -> users; ptfxassetstreaming.lua), live handle-pool occupancy + per-tick start
-- budget (ptfxhandlepool.lua). Declared here so every file in the folder reads/writes the one shared state.
gPtfxAssetUsers  = {} -- dict -> number of entries (loading or playing) holding it
gPtfxHandleCount = 0  -- every live looped handle the host started, across all entries
gStartsThisTick  = 0  -- reset each tick; bounds CreatePtfxLayer calls to PTFX_STARTS_PER_TICK

---@return number? slot
function FindFreeSlot()

    for i = 1, MAX_PTFX_SLOTS do
        if not gPtfx[ i ].isValid then
            return i
        end
    end

    return nil
end

-- ============================================================================ entry lifecycle

-- Claim/free a slot for a player- or entity-bound effect, keyed by `kind` (ePtfxKind.player | ePtfxKind.entity).
-- `id` is a server id for the player kind (the ped is resolved from it each pass, surviving respawn/stream)
-- or a fixed local entity handle for the entity kind (the caller owns it and must RemovePtfx before deleting
-- it). Create is idempotent (a re-create with the same def is a no-op; a different def swaps it, tearing the
-- old render down first). Remove releases the render and frees the slot. The update thread is spawned lazily
-- on the first effect (StartPtfxUpdateThread, ptfxupdateloop.lua) and drains itself when the last is freed.

-- The slot map for `kind`: player effects key by server id, entity effects by entity handle. The two kinds
-- share the one gPtfx entry table and FSM; only the lookup map and which entry field is set differ.
---@param kind PtfxKind
---@return table<number, number> slotMap -- id -> slot index for this kind
local function PtfxSlotMap( kind )

    return kind == ePtfxKind.entity and gPtfxSlotByEntity or gPtfxSlotByServerId
end

---@param kind PtfxKind -- ePtfxKind.player | ePtfxKind.entity
---@param id   number   -- server id (player kind) or local entity handle (entity kind)
---@param def  PtfxDef
---@return nil
function CreatePtfx( kind, id, def )

    local slotMap = PtfxSlotMap( kind )

    local slot = slotMap[ id ]
    if slot then

        local ptfx = gPtfx[ slot ]
        if ptfx.def ~= def then

            TeardownPtfxRender( ptfx ) -- release the OLD def's render before swapping def (no-op if dormant)

            ptfx.def   = def
            ptfx.ped   = 0
            ptfx.state = 'dormant'
        end

        return
    end

    slot = FindFreeSlot()
    if not slot then
        sx.logger:warn( ('ptfx_host: no free slot for kind=%s id=%d (cap=%d)'):format( kind, id, MAX_PTFX_SLOTS ) )
        return
    end

    local ptfx = gPtfx[ slot ]
    ptfx.isValid  = true
    ptfx.kind     = kind
    ptfx.serverId = kind == ePtfxKind.player and id or 0
    ptfx.entity   = kind == ePtfxKind.entity and id or 0
    ptfx.def      = def
    ptfx.ped      = 0
    ptfx.state    = 'dormant'
    slotMap[ id ] = slot
    gActiveCount  = gActiveCount + 1

    if not gThreadRunning then
        StartPtfxUpdateThread()
    end
end

---@param kind PtfxKind -- ePtfxKind.player | ePtfxKind.entity
---@param id   number   -- server id (player kind) or local entity handle (entity kind)
---@return nil
function RemovePtfx( kind, id )

    local slotMap = PtfxSlotMap( kind )

    local slot = slotMap[ id ]
    if not slot then
        return
    end

    local ptfx = gPtfx[ slot ]
    TeardownPtfxRender( ptfx ) -- release render before freeing the slot (no-op if dormant)

    ResetPtfx( ptfx )
    slotMap[ id ] = nil
    gActiveCount  = gActiveCount - 1
end
