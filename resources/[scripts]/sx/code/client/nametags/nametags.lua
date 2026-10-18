-- Singleton render host for the replicated-nametag subsystem. Runs ONCE (sx code/). It watches the
-- 'sxNametag' player-state key and draws the matching label above each player's ped. The bag value is the
-- def INDEX written by the server authority (code/server/nametags_authority); both sides resolve it against
-- gNametagRegistry (code/shared/nametag_registry) — no local mirror. Local control comes in via the
-- sx:client:nametags:create / :remove bridge (CreateNametag / RemoveNametag) with a def NAME instead.
--
-- This subsystem is split across one folder mirroring the ptfx host: config + entry table + entry lifecycle
-- here (nametags.lua), then nametagrenderer (the per-frame draw loop), plus the netnametag + localnametag
-- inputs, hang off the globals declared here. init.lua is the entrypoint that installs the inputs and owns
-- the init/termination flow. Globals are NAMETAG-prefixed so they never collide with the ptfx host that
-- shares this Lua state. See FLOW.md for the diagrams.

-- ============================================================================ config

-- Desired nametags live in a fixed-size table preallocated to the in-scope player cap. An entry is free
-- when isValid is false; gNametagSlotByServerId / gNametagSlotByEntity map an active id to its index so
-- updates and clears are O(1). The render thread walks the table directly, so there is no per-frame hash
-- walk. (MAX_NAMETAG_SLOTS is global because the renderer file walks the same table.)
MAX_NAMETAG_SLOTS = 128

-- ============================================================================ entry table

-- One Nametag = one player's (or entity's) desired nametag. isValid=false marks the entry free; once valid,
-- exactly one of serverId / entity is set (by kind) and def is set. isVisible caches the last
-- line-of-sight result; it starts true so a fresh entry draws immediately and is corrected within the
-- renderer's staggered visibility refresh window.
--
-- An entry binds a def to a PED, resolved each frame by kind (ePtfxKind.player | ePtfxKind.entity):
--   'player' -> the ped is resolved from serverId (survives respawn/stream)
--   'entity' -> the ped IS the fixed local entity handle
---@alias NametagKind 'player' | 'entity'

---@class Nametag
---@field isValid   boolean          -- false = free entry
---@field serverId  number?          -- player kind: the owner server id; nil for entity slots
---@field entity    number?          -- entity kind: the bound ped/object handle; nil for player slots
---@field def       NametagDef|false
---@field isVisible boolean          -- cached LOS result

---@param nametag Nametag -- the one definition of an empty entry, shared by init and RemoveNametag
---@return nil
function ResetNametag( nametag )

    nametag.isValid   = false
    nametag.serverId  = nil
    nametag.entity    = nil
    nametag.def       = false
    nametag.isVisible = true
end

---@type Nametag[]
gNametag = table.create( MAX_NAMETAG_SLOTS, 0 )
for i = 1, MAX_NAMETAG_SLOTS do
    gNametag[ i ] = {}
    ResetNametag( gNametag[ i ] )
end

---@type table<number, number> -- serverId -> slot index (player kind)
gNametagSlotByServerId = {}
---@type table<number, number> -- entity handle -> slot index (entity kind)
gNametagSlotByEntity = {}
gNametagActiveCount   = 0
gNametagThreadRunning = false

---@return number? slot
function FindFreeNametagSlot()

    for i = 1, MAX_NAMETAG_SLOTS do
        if not gNametag[ i ].isValid then
            return i
        end
    end

    return nil
end

-- ============================================================================ entry lifecycle

-- Claim/free a slot for a player- or entity-bound nametag, keyed by `kind` (ePtfxKind.player | ePtfxKind.entity).
-- `id` is a server id for the player kind (the ped is resolved from it each frame) or a fixed local entity
-- handle for the entity kind (the caller owns it and must RemoveNametag before deleting it). Create is
-- idempotent: a re-create with a different def swaps the label in place (no churn). The draw thread is
-- spawned lazily on the first nametag (StartNametagRenderThread, nametagrenderer.lua) and drains itself when
-- the last entry is freed.

-- The slot map for `kind`: player nametags key by server id, entity nametags by entity handle. The two
-- kinds share the one gNametag entry table and draw loop; only the lookup map and which entry field is set
-- differ.
---@param kind NametagKind
---@return table<number, number> slotMap -- id -> slot index for this kind
local function NametagSlotMap( kind )

    return kind == ePtfxKind.entity and gNametagSlotByEntity or gNametagSlotByServerId
end

---@param kind NametagKind -- ePtfxKind.player | ePtfxKind.entity
---@param id   number      -- server id (player kind) or local entity handle (entity kind)
---@param def  NametagDef
---@return nil
function CreateNametag( kind, id, def )

    local slotMap = NametagSlotMap( kind )

    local slot = slotMap[ id ]
    if slot then
        gNametag[ slot ].def = def
        return
    end

    slot = FindFreeNametagSlot()
    if not slot then
        sx.logger:warn( ('nametags_host: no free slot for kind=%s id=%d (cap=%d)'):format( kind, id, MAX_NAMETAG_SLOTS ) )
        return
    end

    local nametag = gNametag[ slot ]
    nametag.isValid  = true
    nametag.serverId = kind == ePtfxKind.player and id or nil
    nametag.entity   = kind == ePtfxKind.entity and id or nil
    nametag.def      = def
    slotMap[ id ] = slot
    gNametagActiveCount = gNametagActiveCount + 1

    if not gNametagThreadRunning then
        StartNametagRenderThread()
    end
end

---@param kind NametagKind -- ePtfxKind.player | ePtfxKind.entity
---@param id   number      -- server id (player kind) or local entity handle (entity kind)
---@return nil
function RemoveNametag( kind, id )

    local slotMap = NametagSlotMap( kind )

    local slot = slotMap[ id ]
    if not slot then
        return
    end

    ResetNametag( gNametag[ slot ] )
    slotMap[ id ] = nil
    gNametagActiveCount = gNametagActiveCount - 1
end
