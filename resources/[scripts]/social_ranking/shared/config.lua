---@class SocialPodiumEntry
---@field passport       number
---@field name           string
---@field rank           number
---@field position       number -- same as rank, named for the card
---@field level          number -- derived social level
---@field xpWeek         number -- weekly social XP total
---@field customisations table -- vrp:GetCharacterCustomisations result (Clothings/Barbershop/Tattooshop)
---@field isFemale       boolean -- occupant's sex; the client spawns the matching freemode ped (appearance only renders on a freemode ped)
---@field source         number|false -- occupant's current online server id (false when offline); the reward-visuals reconciler keys the worn aura/nametag by this
---@field effectsEnabled boolean -- client KVP preference replicated for the complete worn reward package (particle + nametag)

---@class PodiumPedSlot
---@field model  number   -- model hash
---@field coords vector4  -- x, y, z (ground), heading

---@class PodiumCardConfig
---@field cardOffsetZ   number -- card anchor height above the ped origin (low = by the feet)
---@field bodySpanZ     number -- top of the facing-sample span (~head height); the camera counts as facing the ped when it points anywhere from the feet up to this
---@field nearDistance  number -- create/draw a card only when the player is within this distance (the DUI's render range)
---@field facingMinDot  number -- only draw while dot(camForward, dirToPed) exceeds this (camera roughly facing the ped)
---@field unloadDelayMs number -- park the atlas DUI (about:blank) this long after the player leaves nearDistance (re-enter cancels it)
---@field pageName      string -- sx nui_loader page name (DUI url is resolved from the same convars)
---@field width         number -- DUI browser width in px
---@field height        number -- DUI browser height in px
---@field scale         number -- DrawSprite size at the draw origin (worldspace billboard)

---@class PodiumDanceAnim
---@field dict string -- anim dict
---@field name string -- anim clip (a looping dance pose)

---@class PodiumBehaviorConfig
---@field nearDistance number          -- only animate while the player is within this distance
---@field intensity    number          -- 0..1; chance the ped dances (vs rests) on a given beat slot. Higher = dances more, rests less
---@field slotMs       number          -- beat length: every slot the ped re-rolls dance/rest + which clip. The slot boundary is on the network-synced clock, so all clients switch together
---@field anims        PodiumDanceAnim[] -- dance clips the peds randomly switch between (the choice is seeded, so synced across clients)

---@class PodiumMarkerSpec
---@field type    MarkerType|number -- ox_lib marker type
---@field width   number
---@field height  number
---@field zOffset number -- offset from the ped's ground coords (peds sit at z-1.0)
---@field color   { r: number, g: number, b: number, a: number }
---@field rotate  boolean?

---@class PodiumMarkerConfig
---@field fadeDistance number          -- distance over which a marker fades from its spec alpha down to minAlpha
---@field minAlpha     number          -- alpha floor (0-255); markers never fade fully out while the ped renders
---@field specs        PodiumMarkerSpec[] -- markers stacked under each ped (drawn each frame, alpha faded by distance)

---@class PodiumCityConfig
---@field renderRadius number -- only spawn/render peds within this radius of the podium
---@field behavior     PodiumBehaviorConfig -- per-ped dance/rest cycle (switches clips, pauses, resumes); distance-gated
---@field markers      PodiumMarkerConfig
---@field card            PodiumCardConfig
---@field interact        { renderDistance: number, activeDistance: number, label: string } -- single ESC interact at the podium centre
---@field placeholderAlpha number -- alpha (0-255) for a default ped filling a top-3 slot with no winner yet
---@field object          { model: number|string, coords: vector4 } -- podium prop spawned while the podium is mounted
---@field peds            table<number, PodiumPedSlot>   -- rank -> placement

---@class SocialRankingConfigType
---@field activeTimeThresholdSecs number
---@field retentionEnabled        boolean
---@field podiumIntervalSecs      number
---@field podiumDebounceSecs      number
---@field podium                  table<string, PodiumCityConfig> -- cityName -> config (incl. 'default')

---@type SocialRankingConfigType
SocialRankingConfig = {}

-- Trail mission groups (PRD trilhas): Trilha Inicial = `connect`, Trilha Criminal = `criminal`.
-- Used for both per-mission (`trail_mission`) and whole-group (`trail_complete_bonus`) awards.
-- Both groups are non-recurring auto_activate groups, so `missions` fires group_completed for them.
TRAIL_GROUPS = { connect = true, criminal = true }

-- Active-time banking: award `active_time` every 1 hour of (non-AFK) playtime.
SocialRankingConfig.activeTimeThresholdSecs = 60 * 60 -- 3600

-- Retention daily job (PRD §4). Enabled by default now the accounts_login (account-keyed) source
-- is wired; set SOCIAL_RANKING_RETENTION_ENABLED=false to disable.
SocialRankingConfig.retentionEnabled = GetConvar('SOCIAL_RANKING_RETENTION_ENABLED', 'true') == 'true'

-- Podium snapshot refresh (Part D / PRD §6).
SocialRankingConfig.podiumIntervalSecs   = 45    -- baseline poll
SocialRankingConfig.podiumDebounceSecs   = 8     -- re-poll window after an EmitSocialXp burst

-- Podium anchor: the prop's world placement. Ped/prop coords are expressed as LOCAL offsets from this
-- anchor (see PodiumLocal), so the whole arrangement moves/rotates with the podium — re-place the prop
-- and only the anchor changes. Heading is derived from the prop's yaw-only spawn quaternion.
local PODIUM_ANCHOR = vector3( 164.098282, -987.2021, 29.3339119 )

-- GTA heading (degrees) from a yaw-only rotation quaternion (x=y=0) as stored in a ymap. ymap entity
-- rotations are the CONJUGATE (inverse) of the world rotation, so the real heading is the negated yaw.
-- Lua's math.atan takes (y, x).
---@param z number -- quat z (as written in the ymap)
---@param w number -- quat w
---@return number heading
local function HeadingFromYawQuat( z, w )
    return math.deg( math.atan( -2.0 * w * z, 1.0 - 2.0 * z * z ) )
end

-- ≈ 16.55° for the current prop. If the cluster is still rotated off the prop in-game, hand-tune this
-- value directly (the offsets below are prop-relative and never need touching).
local PODIUM_HEADING = HeadingFromYawQuat( 0.1439407, -0.9895864 )

-- Resolve a podium-local offset to a world vector4. The offset is in the podium's own frame: +right is
-- the podium's right, +forward is the direction it faces, +up is world Z. The XY is rotated by the
-- podium heading so offsets stay fixed to the prop regardless of how it's turned.
---@param right      number -- metres to the podium's right
---@param forward    number -- metres in front of the podium
---@param up         number -- metres up (world Z)
---@param relHeading number -- ped facing relative to the podium (0 = same way the podium faces)
---@return vector4
local function PodiumLocal( right, forward, up, relHeading )

    local h        = math.rad( PODIUM_HEADING )
    local fwdX, fwdY   = -math.sin( h ), math.cos( h )
    local rightX, rightY = math.cos( h ), math.sin( h )

    return vector4(
        PODIUM_ANCHOR.x + rightX * right + fwdX * forward,
        PODIUM_ANCHOR.y + rightY * right + fwdY * forward,
        PODIUM_ANCHOR.z + up,
        ( PODIUM_HEADING + relHeading ) % 360.0
    )
end

-- Build a complete city config from the fields that actually vary by city. Presentation and behavior
-- stay in one place, while labels and world placements remain explicit in the city table below.
---@class PodiumCityDefinition
---@field label string
---@field peds table<number, PodiumPedSlot>
---@field renderRadius number?
---@field behavior PodiumBehaviorConfig?
---@field markers PodiumMarkerConfig?
---@field card PodiumCardConfig?
---@field interactRenderDistance number?
---@field interactActiveDistance number?
---@field placeholderAlpha number?
---@field object { model: number|string, coords: vector4 }?

---@param definition PodiumCityDefinition
---@return PodiumCityConfig
local function CreatePodiumCityConfig( definition )

    return {
        -- only spawn/render the peds while the local player is within this radius of the podium
        renderRadius = definition.renderRadius or 60.0,
        -- Per-ped dance/rest cycle: on each beat slot the ped rolls dance-or-rest and which clip, then
        -- holds it for the slot. `intensity` biases dance vs rest; consecutive rest slots = a longer pause.
        -- Only animates within `nearDistance`; beyond it the ped blends out and stands still.
        -- The roll is seeded (server seed) and keyed by the network-synced clock + rank, so every client
        -- renders the SAME ped doing the SAME move at the same time, while different ranks stay desynced.
        behavior = definition.behavior or {
            nearDistance = 25.0,
            intensity    = 0.6,  -- 60% chance to dance on a slot; 40% to rest (consecutive rests = longer pause)
            slotMs       = 6000,
            anims = {
                { dict = '67brazil@animation',                                 name = '67brazil_clip' },
                { dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', name = 'med_center'  },
                -- { dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', name = 'high_center' },
                -- { dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', name = 'high_left'   },
                -- { dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_a@', name = 'high_right'  },
                -- { dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', name = 'med_center'  },
                { dict = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', name = 'low_center'  },
                { dict = 'melee@wfire@wmg@capoeira_moveset',                    name = 'wfire_wmg_cap_jumping_spin_kicks_clip' },
            },
        },
        -- placeholder round ground markers under each ped (style TBD — tweak type/color/size here).
        -- Markers draw the whole time the ped is rendered; distance only fades their alpha toward minAlpha.
        markers = definition.markers or {
            fadeDistance = 20.0,
            minAlpha     = 51,
            specs = {
                { type = 'HorizontalCircleFat',    width = 1.4, height = 0.4, zOffset = -1.0, color = { r = 255, g = 215, b = 0, a = 70 }, rotate = true },
                { type = 'VerticalCylinder'   ,    width = 1.2, height = 1.0, zOffset = -1.0, color = { r = 255, g = 215, b = 0, a = 70 }, rotate = true },
            },
        },
        -- floating 3D card (DUI billboard) anchored above each ped (see client/cards.lua)
        card = definition.card or {
            cardOffsetZ   = -0.95,  -- anchor the billboard down by the ped's feet
            bodySpanZ     = 1.1,  -- but still treat the camera as facing the ped anywhere up to head height
            nearDistance  = 6.0,
            -- only draw a card while the camera is pointing nearly straight at the ped: dot(camForward,
            -- dirToPed) must exceed this (1.0 = dead-on, 0 = 90° off). ~0.93 ≈ a 21° cone near screen centre.
            facingMinDot  = 0.93,
            unloadDelayMs = 5000, -- keep the page a few seconds after the player walks off before parking the DUI
            pageName      = 'social-ranking-cards',
            -- DUI canvas px (also the card aspect): wide banner — much wider than tall.
            -- Higher res = crisper text when drawn as a worldspace sprite.
            width        = 690,
            height       = 100,
            scale        = 0.18, -- sprite width as a screen fraction at the draw origin; auto-shrinks with distance (SetDrawOrigin). Bumped for the wider/shorter banner so text stays readable.
        },
        -- single ESC interact at the podium centre (replaces the old per-ped interactions). Distances
        -- bumped so it's reachable from further away (PRD: aumentar a distância).
        interact = {
            renderDistance = definition.interactRenderDistance or 10.0,
            activeDistance = definition.interactActiveDistance or 5.0,
            label          = definition.label
                or SocialRankingText( SocialRankingConfig.podiumLabelByLanguage ),
        },
        -- a top-3 slot with no winner yet still spawns a faded default ped (no card, no interact)
        placeholderAlpha = definition.placeholderAlpha or 51,
        -- podium prop spawned while the podium is mounted (created on mount, deleted on unmount).
        -- The prop sits exactly on the anchor (offsets all 0); it faces the anchor heading.
        object = definition.object or { model = `prop_podio_sg`, coords = PodiumLocal( 0.0, 0.0, 0.0, 0.0 ) },
        peds = definition.peds,
    }
end

SocialRankingConfig.podiumLabelByLanguage = {
    pt = 'Ver Ranking Social',
    en = 'View Social Ranking',
    es = 'Ver Ranking Social',
    fr = 'Voir le Classement Social',
    ar = 'عرض التصنيف الاجتماعي',
    de = 'Soziale Rangliste ansehen',
}

-- Plaza podium peds, keyed by the exact `cityName` convar. Configured Z is one metre above the final
-- ped origin because SpawnSocialPodiumSlot applies `coords.z - 1.0` when creating the entity.
SocialRankingConfig.podium = {
    default = CreatePodiumCityConfig( {
        peds = {
            -- Default placements are podium-local: winner in the centre and runners-up at each side.
            [1] = { model = `a_m_y_business_01`, coords = PodiumLocal( -0.10,  1.00, 1.61, 180.0 ) },
            [2] = { model = `a_m_y_business_01`, coords = PodiumLocal( -1.35, -0.35, 1.20, 180.0 ) },
            [3] = { model = `a_m_y_business_01`, coords = PodiumLocal(  1.05, -0.45, 0.90, 180.0 ) },
        },
    } ),
    Kingdom = CreatePodiumCityConfig( {
        peds = {
            [1] = { model = `a_m_y_business_01`, coords = vector4( 154.37,-982.58,31.85,189.93 ) },
            [2] = { model = `a_m_y_business_01`, coords = vector4( 153.7,-984.22,31.44,184.26 ) },
            [3] = { model = `a_m_y_business_01`, coords = vector4( 155.99,-983.63,31.12,206.93 ) },
        },
    } ),
    Royal = CreatePodiumCityConfig( {
        peds = {
            [1] = { model = `a_m_y_business_01`, coords = vector4( 155.58,-983.67,31.9,184.26 ) },
            [2] = { model = `a_m_y_business_01`, coords = vector4( 154.66,-985.26,31.49,192.76 ) },
            [3] = { model = `a_m_y_business_01`, coords = vector4( 156.99,-984.79,31.17,184.26 ) },
        },
    } ),
}

---@return PodiumCityConfig -- podium config for the current city (falls back to `default`)
function GetPodiumConfig()
    local city = GetConvar('cityName', '')
    return SocialRankingConfig.podium[city] or SocialRankingConfig.podium.default
end

-- Each rank replicates as its own global statebag (GlobalState['socialRankingPodium:<rank>']) so a
-- single-slot change doesn't rebuild the whole roster. The bags span the whole reward roster (top
-- MAX_REWARD_RANKS): ranks 1..MAX_PODIUM_ENTRIES carry the heavy plaza appearance the statues need PLUS the
-- occupant's online `source`; ranks beyond carry only `{ source }`. Two client consumers read them — the
-- plaza peds (ranks 1..MAX_PODIUM_ENTRIES, client/peds.lua) and the worn reward-visuals reconciler (all
-- ranks, keyed by `source`, client/reward_visuals.lua).
--
-- MAX_PODIUM_ENTRIES is the plaza transport cap across all cities; a city with fewer `peds` slots simply
-- leaves the surplus ranks empty.
MAX_PODIUM_ENTRIES = 3

-- Reward visuals (the player-worn rank nametag + rider aura) reach further down the leaderboard than the
-- 3 physical plaza peds: the weekly top-15 all wear the rank nametag, and ranks 4-10 share the rank-4
-- aura. Kept separate from MAX_PODIUM_ENTRIES so the plaza stays 3 peds while rewards span the top 15.
MAX_REWARD_RANKS = 15

-- Rider-trail aura by rank (DEFINE_PTFX names, upper-cased). Shared by the plaza peds
-- (client/peds.lua) and the player reward visuals (server/rewards.lua) so a rank shows the SAME aura
-- in both. Top 3 each get their own; ranks 4-10 share the rank-4 aura; ranks 11-15 are nametag-only.
---@param rank number
---@return string? -- ptfx name, or nil for nametag-only ranks
function PtfxForRank( rank )
    if rank == 1 then return 'SOCIALRANKING_RANK_1' end
    if rank == 2 then return 'SOCIALRANKING_RANK_3' end -- fogo
    if rank == 3 then return 'SOCIALRANKING_RANK_2' end -- fumaca verde
    if rank >= 4 and rank <= 10 then return 'SOCIALRANKING_RANK_4' end
    return nil
end

---@param rank number
---@return string -- global statebag key for this rank
function PodiumBagKey( rank )
    return ('socialRankingPodium:%d'):format( rank )
end

-- Single global statebag carrying the shared RNG seed. The server publishes it once on init; every
-- client folds it into the per-beat hash so the podium dance timeline is identical across clients
-- (the beat index comes from the network-synced clock, see client/peds.lua DesiredSocialPodiumDance).
SOCIAL_PODIUM_SEED_KEY = 'socialRankingPodiumSeed'
