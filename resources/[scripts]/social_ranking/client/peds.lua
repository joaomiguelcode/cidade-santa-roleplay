-- Plaza podium peds (Part D). Spawned only while the local player is within the podium render
-- radius (ox_lib sphere zone); appearance applied through the shared player facade. ESC interact
-- opens the Hub on the ranking route.
--
-- Model (mirrors sx/code/client/nametags_host.lua): each rank is an independent replicated cell.
-- gNetSocialPodium[rank] is the latest NETWORKED (desired) entry for that rank (one global statebag
-- per rank, see shared/config.lua PodiumBagKey). gSocialPodium[rank] is the live PHYSICAL ped.
--
-- Two concepts, two drivers:
--   * The zone MOUNTS/UNMOUNTS the whole podium (render gate): MountSocialPodium / UnmountSocialPodium.
--   * A rank's statebag RECONCILES that one slot's data while mounted: SyncSocialPodiumSlot.
-- An unchanged slot is never touched (no flicker, no appearance re-apply).

-- SocialPodiumEntry is defined in shared/config.lua (one is published per PodiumBagKey(rank)).

-- Per-ped dance FSM states (asset loads are async — never block the tick on RequestAnimDict).
local PODIUM_PED_STATE = {
    DANCE_LOAD = 'dance_load', -- requesting the chosen clip's dict; play it + go DANCE once loaded
    DANCE      = 'dance',      -- dancing a clip; at the beat end switch clips or rest; rest now if far
    REST       = 'rest',       -- standing still (blended out); resume dancing once the rest elapses and near
}

-- Identity sentinel for a faded default ped filling an empty top-3 slot (no winner yet). A real ped's
-- identity is its occupant passport; a unique table can never collide with a passport.
local SOCIAL_PODIUM_PLACEHOLDER = {}

---@class PodiumPed
---@field ped         number?          -- nil while the slot is claimed but the ped isn't created yet
---@field identity    number|table     -- occupant passport, or SOCIAL_PODIUM_PLACEHOLDER for an empty slot
---@field token       number           -- spawn token; a slot re-claim invalidates an in-flight spawn
---@field coords      vector3
---@field rank        number           -- this ped's podium rank (RNG key, so each rank dances differently)
---@field state       string           -- dance FSM state (PODIUM_PED_*)
---@field anim        PodiumDanceAnim? -- the dance clip currently playing/loading (nil = standing still)
---@field markers     table[]          -- precreated lib.marker objects (each carries a baseAlpha); alpha faded by distance each frame
---@field isPlaceholder boolean        -- true for a faded default ped (no card/interact)

---@type table<number, SocialPodiumEntry?> -- rank -> latest networked entry (nil = vacant rank)
local gNetSocialPodium = {}
---@type table<number, PodiumPed?>          -- slot (rank) -> live ped (nil = empty slot)
local gSocialPodium = {}

---@type CZone?               -- ox_lib sphere render zone
local gSocialPodiumRenderZone = nil
---@type fun()?               -- aborts the update tick (returned by sx.script.setTick)
local gSocialPodiumTickAbortSignal = nil
---@type number               -- monotonic spawn-token source
local gSocialPodiumSpawnSeq = 0
---@type boolean              -- is the podium currently rendered (peds spawned)? toggled by the zone
local gSocialPodiumMounted = false
---@type number?              -- the podium prop object (created on mount, deleted on unmount)
local gSocialPodiumProp = nil
---@type number               -- shared dance seed from the server (GlobalState SOCIAL_PODIUM_SEED_KEY); syncs the timeline across clients
local gSocialPodiumSeed = 0

---@param model number|string -- model hash or name
---@return boolean loaded
local function LoadSocialPodiumModel( model )

    RequestModel( model )

    local startedAt = GetGameTimer()
    while not HasModelLoaded( model ) do
        if GetGameTimer() - startedAt > 10000 then
            return false
        end
        Wait( 0 )
    end

    return true
end

-- Non-blocking: kick off the request if needed and report whether the dict is ready THIS frame.
-- The FSM polls this each tick instead of spinning on a wait-loop.
---@param dict string
---@return boolean loaded
local function EnsureSocialPodiumAnimDict( dict )

    if HasAnimDictLoaded( dict ) then
        return true
    end

    RequestAnimDict( dict )
    return false
end

---@param cfg PodiumCityConfig
---@return vector3 centroid of the configured ped coords
local function SocialPodiumCenter( cfg )

    local sx, sy, sz, n = 0.0, 0.0, 0.0, 0
    for _, slot in pairs( cfg.peds ) do
        sx = sx + slot.coords.x
        sy = sy + slot.coords.y
        sz = sz + slot.coords.z
        n = n + 1
    end

    if n == 0 then
        return vector3( 0.0, 0.0, 0.0 )
    end

    return vector3( sx / n, sy / n, sz / n )
end

---@return boolean -- is the local player's focus within the render zone
local function ComputeIsSocialPodiumInScope()

    return gSocialPodiumRenderZone:contains( sx.client.player.getFocusPosition() )
end

---@param rank number
---@return SocialPodiumEntry|table -- desired occupant for a slot: its entry, or the empty-slot sentinel
local function DesiredSocialPodiumOccupant( rank )

    return gNetSocialPodium[ rank ] or SOCIAL_PODIUM_PLACEHOLDER
end

---@param entry SocialPodiumEntry
---@return SocialCardPayload
local function SocialPodiumCardPayload( entry )

    return {
        name      = entry.name,
        passport  = entry.passport,
        position  = entry.position,
        level     = entry.level,
        xpWeek    = entry.xpWeek,
    }
end

-- flag 1 (AF_LOOPING): a dance clip loops until we explicitly stop it (at the beat end or when far).
---@param entry PodiumPed
---@return nil
local function PlaySocialPodiumDance( entry )

    TaskPlayAnim( entry.ped, entry.anim.dict, entry.anim.name, 8.0, 8.0, -1, 1, 0.0, false, false, false )
end

-- Blend the looping dance out smoothly so the ped settles back to a standing pose instead of snapping.
---@param entry PodiumPed
---@return nil
local function StopSocialPodiumDance( entry )

    StopAnimTask( entry.ped, entry.anim.dict, entry.anim.name, 2.0 )
end

-- Deterministic [0,1) from integer inputs (splitmix64 finaliser). Lua 5.4 integer ops wrap mod 2^64,
-- so this is identical on every client — the basis for syncing the dance timeline without per-frame
-- network traffic. `salt` separates independent sub-streams drawn for the same beat.
---@param seed number
---@param rank number
---@param slot number
---@param salt number
---@return number -- [0,1)
local function SocialPodiumHashUnit( seed, rank, slot, salt )

    local x = seed * 0x9E3779B1 + rank * 0x85EBCA77 + slot * 0xC2B2AE3D + salt * 0x27D4EB2F
    x = ( x ~ ( x >> 30 ) ) * 0xBF58476D1CE4E5B9
    x = ( x ~ ( x >> 27 ) ) * 0x94D049BB133111EB
    x = x ~ ( x >> 31 )

    return ( x & 0x1FFFFFFFFFFFFF ) / 0x20000000000000
end

-- The dance every client should render for this rank RIGHT NOW: a pure function of the shared seed, the
-- rank, and the network-synced beat slot — so all clients agree without messaging. Returns the chosen
-- clip, or nil to rest this slot. (Distance gating is layered on top by the caller, per-client.)
---@param behavior PodiumBehaviorConfig
---@param rank     number
---@param now      number -- GetNetworkTime() ms (synced across clients)
---@return PodiumDanceAnim? -- clip to play, or nil = rest
local function DesiredSocialPodiumDance( behavior, rank, now )

    -- Stagger each rank's beat timeline by a fraction of a slot so the peds re-roll out of phase. Without
    -- this they share the same slot boundary and tend to land on the same dance/rest at the same instant;
    -- the offset (still derived from the synced clock) keeps every client in lockstep per rank.
    local slot = ( now + ( rank * behavior.slotMs ) // MAX_PODIUM_ENTRIES ) // behavior.slotMs

    -- roll dance-vs-rest, then which clip — separate salts keep the two draws uncorrelated
    if SocialPodiumHashUnit( gSocialPodiumSeed, rank, slot, 1 ) >= behavior.intensity then
        return nil
    end

    local idx = math.floor( SocialPodiumHashUnit( gSocialPodiumSeed, rank, slot, 2 ) * #behavior.anims ) + 1
    return behavior.anims[ idx ]
end

-- Reconcile a ped's actual animation to the deterministic desired beat. The randomness is no longer
-- owned here (it's the seeded DesiredSocialPodiumDance) — this only drives the async dict load and the
-- TaskPlayAnim/StopAnimTask, so two clients near the same ped converge to the same move. The FSM state
-- exists purely for the async load: DANCE_LOAD = waiting on the dict, DANCE = playing it, REST = still.
---@param entry    PodiumPed
---@param cfg      PodiumCityConfig
---@param distance number -- ped -> local player
---@param now      number -- GetNetworkTime() ms
---@return nil
local function StepSocialPodiumBehavior( entry, cfg, distance, now )

    local behavior = cfg.behavior

    -- far peds always rest (local override); otherwise follow the synced timeline
    local desired = distance > behavior.nearDistance and nil or DesiredSocialPodiumDance( behavior, entry.rank, now )

    if desired == nil then

        if entry.state ~= PODIUM_PED_STATE.REST then
            if entry.anim then
                StopSocialPodiumDance( entry )
            end
            entry.anim  = nil
            entry.state = PODIUM_PED_STATE.REST
        end

        return
    end

    -- already dancing the right clip: nothing to do
    if entry.state == PODIUM_PED_STATE.DANCE and entry.anim == desired then
        return
    end

    -- (re)load the desired clip; the previous clip keeps looping until this one is ready (smooth blend)
    entry.anim = desired
    if EnsureSocialPodiumAnimDict( desired.dict ) then
        PlaySocialPodiumDance( entry )
        entry.state = PODIUM_PED_STATE.DANCE
    else
        entry.state = PODIUM_PED_STATE.DANCE_LOAD
    end
end

-- Distance-fade factor for a ped's markers: 1.0 at the ped, falling linearly to 0.0 at fadeDistance and
-- clamped there. It scales each marker's spec alpha; the absolute minAlpha floor (applied at the draw)
-- keeps a marker faintly visible the whole time the ped is rendered, so it never fully disappears.
---@param distance number -- ped -> local player
---@param cfg      PodiumCityConfig
---@return number factor -- 0..1
local function SocialPodiumMarkerAlphaFactor( distance, cfg )

    local t = ( cfg.markers.fadeDistance - distance ) / cfg.markers.fadeDistance

    return math.max( math.min( t, 1.0 ), 0.0 )
end

-- Singleton update tick (started once at init, like nametags_host's DrawNametagHost): draws each live
-- ped's ground markers and advances its non-blocking dance FSM. No-op (cheap sleep) when nothing is
-- rendered; skips slots still mid-spawn (ped not yet created).
---@return nil
local function TickSocialPodium()

    if next( gSocialPodium ) == nil then
        Wait( 500 )
        return
    end

    local cfg = GetPodiumConfig()
    local playerCoords = GetEntityCoords( PlayerPedId() )
    -- network time is synced across clients, so the per-beat slot index is identical everywhere
    local now = GetNetworkTime()

    for _, entry in pairs( gSocialPodium ) do

        if entry.ped and DoesEntityExist( entry.ped ) then

            local distance = #( playerCoords - entry.coords )

            -- Markers render as long as the ped does; distance only fades their alpha, floored at minAlpha.
            local fade = SocialPodiumMarkerAlphaFactor( distance, cfg )
            for _, marker in ipairs( entry.markers ) do
                marker.color.a = math.floor( math.max( marker.baseAlpha * fade, cfg.markers.minAlpha ) )
                marker:draw()
            end

            StepSocialPodiumBehavior( entry, cfg, distance, now )
        end
    end
end

-- Tear down one slot's ped (+ its card/interact if it had them). Releasing the slot first invalidates
-- any in-flight spawn for it via the token check.
---@param rank number
---@return nil
local function DespawnSocialPodiumSlot( rank )

    local entry = gSocialPodium[ rank ]
    if entry == nil then
        return
    end

    gSocialPodium[ rank ] = nil

    -- card + ptfx are only attached once the ped exists; nothing to remove for a pending claim
    if entry.ped then

        if not entry.isPlaceholder then
            RemoveSocialCard( rank )
            sx.client.ptfx.remove( ePtfxKind.entity, entry.ped ) -- detach the aura before the ped handle goes away
            sx.client.nametags.remove( ePtfxKind.entity, entry.ped )
        end

        if DoesEntityExist( entry.ped ) then
            DeleteEntity( entry.ped )
        end
    end
end

-- Spawn one slot's ped from its desired occupant (a SocialPodiumEntry, or the empty-slot sentinel).
-- The slot is CLAIMED synchronously before the async model/appearance loads, so a concurrent
-- SyncSocialPodiumSlot for the same rank sees it occupied and skips it (idempotency guard). After each
-- yield we re-check we still own the slot via our token; if superseded, we delete and bail.
---@param rank number
---@param want SocialPodiumEntry|table -- entry, or SOCIAL_PODIUM_PLACEHOLDER
---@return nil
local function SpawnSocialPodiumSlot( rank, want )

    local cfg  = GetPodiumConfig()
    local slot = cfg.peds[ rank ]
    if slot == nil then
        return -- this city has fewer slots than MAX_PODIUM_ENTRIES
    end

    local isPlaceholder = want == SOCIAL_PODIUM_PLACEHOLDER

    -- a real occupant is spawned as the freemode ped matching their sex so the appearance actually
    -- renders (clothing/head-blend only apply to freemode peds); empty slots use the static config model
    local model = slot.model
    if not isPlaceholder then
        model = want.isFemale and `mp_f_freemode_01` or `mp_m_freemode_01`
    end

    gSocialPodiumSpawnSeq = gSocialPodiumSpawnSeq + 1

    ---@type PodiumPed
    local entry = {
        ped           = nil,
        identity      = isPlaceholder and SOCIAL_PODIUM_PLACEHOLDER or want.passport,
        token         = gSocialPodiumSpawnSeq,
        coords        = vector3( slot.coords.x, slot.coords.y, slot.coords.z ),
        rank          = rank,
        -- the tick reconciles to the seeded timeline from here; start still (no clip playing yet)
        state         = PODIUM_PED_STATE.REST,
        anim          = nil,
        markers       = {},
        isPlaceholder = isPlaceholder,
    }

    gSocialPodium[ rank ] = entry -- claim the slot before any yield

    if not LoadSocialPodiumModel( model ) then
        if gSocialPodium[ rank ] == entry then
            gSocialPodium[ rank ] = nil
        end
        return
    end

    if gSocialPodium[ rank ] ~= entry then
        return -- superseded during the model load
    end

    local c = slot.coords
    local ped = CreatePed( 4, model, c.x, c.y, c.z - 1.0, c.w, false, false )

    SetEntityInvincible( ped, true )
    FreezeEntityPosition( ped, true )
    SetBlockingOfNonTemporaryEvents( ped, true )
    -- initialise the freemode head/components before applying appearance: on a fresh CreatePed, head
    -- blend (skin tone) and hair colour silently no-op unless the default variation is set first.
    SetPedDefaultComponentVariation( ped )
    SetModelAsNoLongerNeeded( model )

    -- precreate this ped's ground markers (peds are frozen, so coords are fixed). Each marker gets its OWN
    -- color table (lib.marker keeps the reference and we mutate .a per frame to fade — the spec table is
    -- shared config and must not be touched); baseAlpha remembers the spec alpha the fade scales from.
    local markers = {}
    for _, spec in ipairs( cfg.markers.specs ) do
        local marker = lib.marker.new( {
            type   = spec.type,
            coords = vector3( c.x, c.y, c.z + spec.zOffset ),
            width  = spec.width,
            height = spec.height,
            color  = { r = spec.color.r, g = spec.color.g, b = spec.color.b, a = spec.color.a },
            rotate = spec.rotate,
        } )
        marker.baseAlpha = spec.color.a
        markers[#markers + 1] = marker
    end

    if not isPlaceholder then

        exports['player']:ApplyFullAppearanceToPed( ped, want.customisations )

        if gSocialPodium[ rank ] ~= entry then
            DeleteEntity( ped ) -- superseded during the appearance apply
            return
        end
    end

    -- commit: no yield from here, so the slot goes fully live atomically
    entry.ped     = ped
    entry.markers = markers

    if isPlaceholder then
        -- empty slot: faded default ped, no appearance/card/ptfx (just idle + markers)
        SetEntityAlpha( ped, cfg.placeholderAlpha, false )
    else

        -- register the floating 3D card (DUI) for this ped (host tick + projection live in cards.lua)
        AddSocialCard( rank, ped, SocialPodiumCardPayload( want ) )

        -- looped aura on the ped (reuses the player rider-trail defs) — attached straight onto the local
        -- ped via the entity-bound sx ptfx path. Cleared in DespawnSocialPodiumSlot before the ped is deleted.
        local ptfxName = PtfxForRank( rank )
        if ptfxName then
            sx.client.ptfx.create( ePtfxKind.entity, ped, ptfxName )
        end

        sx.client.nametags.create( ePtfxKind.entity, ped, NAMETAG_SOCIAL_RANK )
    end
end

-- Reconcile a single slot's DATA (its bag changed) while the podium is mounted: respawn only when the
-- occupant identity changes, refresh the card in place when it's the same passport with new numbers.
-- The render gate is the zone's concern (Mount/UnmountSocialPodium) — not re-checked per slot here.
---@param rank number
---@return nil
local function SyncSocialPodiumSlot( rank )

    local want   = DesiredSocialPodiumOccupant( rank )
    local wantId = want == SOCIAL_PODIUM_PLACEHOLDER and SOCIAL_PODIUM_PLACEHOLDER or want.passport
    local have   = gSocialPodium[ rank ]

    -- different occupant -> tear the slot down so it respawns below
    if have ~= nil and have.identity ~= wantId then
        DespawnSocialPodiumSlot( rank )
        have = nil
    end

    if have == nil then
        SpawnSocialPodiumSlot( rank, want )
    elseif want ~= SOCIAL_PODIUM_PLACEHOLDER then
        -- same passport kept: refresh card numbers in place (no ped churn)
        UpdateSocialCard( rank, SocialPodiumCardPayload( want ) )
    end
end

-- Spawn the podium prop once, frozen at its configured placement. The model load is async; if the
-- player leaves the zone (unmount) while it streams in, we bail without creating the object.
---@param cfg PodiumCityConfig
---@return nil
local function SpawnSocialPodiumProp( cfg )

    assert( gSocialPodiumProp == nil )

    if not LoadSocialPodiumModel( cfg.object.model ) then
        return
    end

    if not gSocialPodiumMounted then
        SetModelAsNoLongerNeeded( cfg.object.model )
        return -- player left the zone while the model streamed in
    end

    local c = cfg.object.coords
    local object = CreateObject( cfg.object.model, c.x, c.y, c.z, false, false, false )

    SetEntityHeading( object, c.w )
    FreezeEntityPosition( object, true )
    SetModelAsNoLongerNeeded( cfg.object.model )

    gSocialPodiumProp = object
end

-- Delete the podium prop if it exists.
---@return nil
local function DeleteSocialPodiumProp()

    if gSocialPodiumProp == nil then
        return
    end

    if DoesEntityExist( gSocialPodiumProp ) then
        DeleteEntity( gSocialPodiumProp )
    end

    gSocialPodiumProp = nil
end

-- A single ESC interact at the podium centre (replaces the old per-ped ones). Opens the Hub ranking
-- route. Coords-based so it stands independent of which slots have real peds / placeholders.
local SOCIAL_PODIUM_INTERACT_ID = 'social_podium_center'

---@param cfg PodiumCityConfig
---@return nil
local function AddSocialPodiumInteract( cfg )

    interact.addCoords( {
        id             = SOCIAL_PODIUM_INTERACT_ID,
        coords         = SocialPodiumCenter( cfg ),
        renderDistance = cfg.interact.renderDistance,
        activeDistance = cfg.interact.activeDistance,
        options        = {
            {
                label    = cfg.interact.label,
                icon     = 'trophy',
                onSelect = function()
                    TriggerServerEvent( 'social_ranking:requestOpenRanking' )
                end,
            },
        },
    } )
end

-- Render the whole podium: spawn the prop + every configured slot from its desired occupant. Driven by
-- the zone (player entered the render radius). Aborts if the player leaves mid-load (a spawn yields).
---@return nil
local function MountSocialPodium()

    if gSocialPodiumMounted then
        return
    end
    gSocialPodiumMounted = true

    -- prop is placed on the map (ymap), not spawned here
    -- SpawnSocialPodiumProp( GetPodiumConfig() )

    AddSocialPodiumInteract( GetPodiumConfig() )

    for rank = 1, MAX_PODIUM_ENTRIES do
        if not gSocialPodiumMounted then
            return -- player left the zone while an earlier slot was still loading
        end
        SpawnSocialPodiumSlot( rank, DesiredSocialPodiumOccupant( rank ) )
    end

    -- StartSocialPodiumBillboard() -- 3D video billboard above the podium (see client/billboard.lua)
end

-- Tear the whole podium down: despawn every slot. Driven by the zone (player left the render radius).
---@return nil
local function UnmountSocialPodium()

    if not gSocialPodiumMounted then
        return
    end
    gSocialPodiumMounted = false

    interact.removeById( SOCIAL_PODIUM_INTERACT_ID )
    -- StopSocialPodiumBillboard()

    DeleteSocialPodiumProp()

    for rank = 1, MAX_PODIUM_ENTRIES do
        DespawnSocialPodiumSlot( rank )
    end
end

-- One handler per rank: a rank's bag changing reconciles only that slot, and only while mounted.
for rank = 1, MAX_PODIUM_ENTRIES do

    AddStateBagChangeHandler( PodiumBagKey( rank ), 'global', function( _bag, _key, value )

        gNetSocialPodium[ rank ] = value

        if gSocialPodiumMounted then
            SyncSocialPodiumSlot( rank )
        end
    end )
end

-- Track the shared dance seed if the server publishes/changes it after this client already started.
AddStateBagChangeHandler( SOCIAL_PODIUM_SEED_KEY, 'global', function( _bag, _key, value )

    gSocialPodiumSeed = value or 0
end )

-- Startup (called by client/main.lua): create the render zone, seed desired entries from the replicated
-- bags, mount immediately if we spawn inside the zone, and start the draw/emote tick. The zone drives
-- ped spawning from here on (onEnter -> MountSocialPodium); this just stands the renderer up.
---@return nil
function InitSocialPodiumRenderer()

    local cfg = GetPodiumConfig()

    gSocialPodiumRenderZone = lib.zones.sphere( {
        coords  = SocialPodiumCenter( cfg ),
        radius  = cfg.renderRadius or 60.0,
        onEnter = MountSocialPodium,   -- entered the render radius -> spawn the podium
        onExit  = UnmountSocialPodium, -- left it -> tear the podium down
    } )

    -- seed the desired entries from the currently replicated bags
    for rank = 1, MAX_PODIUM_ENTRIES do
        gNetSocialPodium[ rank ] = GlobalState[ PodiumBagKey( rank ) ]
    end

    -- read the shared dance seed (published once by the server); the handler below catches a later set
    gSocialPodiumSeed = GlobalState[ SOCIAL_PODIUM_SEED_KEY ] or 0

    -- mount now if we start inside the zone (onEnter won't fire for an already-occupied zone)
    if ComputeIsSocialPodiumInScope() then
        MountSocialPodium()
    end

    gSocialPodiumTickAbortSignal = sx.script.setTick( TickSocialPodium )
end

-- Termination (called by client/main.lua): despawn every ped, stop the tick, drop the zone.
---@return nil
function TerminateSocialPodiumRenderer()

    UnmountSocialPodium()

    if gSocialPodiumTickAbortSignal then
        gSocialPodiumTickAbortSignal()
        gSocialPodiumTickAbortSignal = nil
    end

    if gSocialPodiumRenderZone then
        gSocialPodiumRenderZone:remove()
        gSocialPodiumRenderZone = nil
    end
end
