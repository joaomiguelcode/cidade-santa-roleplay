-- Worn reward visuals (data-derived path). The weekly top-MAX_REWARD_RANKS each wear the rank nametag plus
-- (ranks with a PtfxForRank) a rider-trail aura. Unlike a per-player statebag push, the visual is DERIVED
-- locally from the per-rank GlobalState bags the leaderboard already replicates: each rank's bag carries the
-- ranked player's online `source` (or false when offline) plus the owner's visual preference. This file maps source -> rank and drives the sx
-- client ptfx/nametag host for each in-roster player; the host re-resolves the ped from the server id every
-- tick, so stream-in/out and respawn need no work here.
--
-- Liveness is client-side and keyed BY SOURCE: onPlayerDropped tears a leaver's visual down instantly,
-- onPlayerJoining (re)applies a roster member, initialization registers the whole roster (even outside
-- local scope), and any rank-bag change re-evaluates the roster. create/remove are idempotent
-- (same id+def = no-op; a different def swaps in place), so a rank move is a flicker-free in-place swap.

---@type table<number, number> -- source -> rank we've issued create() for
local gApplied = {}
---@type table<number, { source: number|false, effectsEnabled: boolean }>
local gRankVisuals = {}

-- A rank bag carries the occupant's online source on `.source` (number) or false when offline/vacant; nil
-- bag = vacant rank.
---@param bag { source: number|false }?
---@return number|false
local function RankBagSource( bag )

    local source = type( bag ) == 'table' and bag.source or false
    return type( source ) == 'number' and source > 0 and source % 1 == 0 and source or false
end

---@param bag { effectsEnabled: boolean? }?
---@return boolean
local function RankBagEffectsEnabled( bag )

    return type( bag ) ~= 'table' or bag.effectsEnabled ~= false
end

-- (Re)issue the worn visual for one in-roster source. Disabling the package removes both aura and nametag. The host
-- def-swap is idempotent, so calling this on a tier move swaps the aura in place without a flicker.
---@param source number
---@param rank number
---@param effectsEnabled boolean
---@return nil
local function ApplyRewardVisual( source, rank, effectsEnabled )

    -- GlobalState includes players outside local scope. The sx host retains the desired visual
    -- while dormant and resolves the ped when it streams in; absence here is not an error.

    local ptfxName = PtfxForRank( rank )
    if ptfxName and effectsEnabled then
        sx.client.ptfx.create( ePtfxKind.player, source, ptfxName )
    else
        sx.client.ptfx.remove( ePtfxKind.player, source ) -- disabled or nametag-only: drop any aura from a higher tier
    end

    if effectsEnabled then
        sx.client.nametags.create( ePtfxKind.player, source, NAMETAG_SOCIAL_RANK )
    else
        sx.client.nametags.remove( ePtfxKind.player, source )
    end

    gApplied[ source ] = rank
end

---@return { available: boolean, enabled: boolean }
local function GetLocalPedEffectsState()

    local localSource = GetPlayerServerId( PlayerId() )

    for rank = 1, MAX_REWARD_RANKS do

        local bag = GlobalState[ PodiumBagKey( rank ) ]

        if RankBagSource( bag ) == localSource then
            return {
                available = true,
                enabled = RankBagEffectsEnabled( bag ),
            }
        end
    end

    return { available = false, enabled = true }
end

exports( 'GetPedEffectsState', GetLocalPedEffectsState )

---@param source number
---@return nil
local function ClearRewardVisual( source )

    sx.client.ptfx.remove( ePtfxKind.player, source )
    sx.client.nametags.remove( ePtfxKind.player, source )

    gApplied[ source ] = nil
end

---@param source number|false
local function ReconcileRewardVisual( source )

    if not source then return end

    for rank = 1, MAX_REWARD_RANKS do
        local visual = gRankVisuals[ rank ]
        if visual and visual.source == source then
            ApplyRewardVisual( source, rank, visual.effectsEnabled )
            return
        end
    end

    if gApplied[ source ] then
        ClearRewardVisual( source )
    end
end

-- Seed the complete roster before applying it, including players outside local scope.
---@return nil
function InitSocialRewardVisuals()

    for rank = 1, MAX_REWARD_RANKS do

        local rankStatebagKey = PodiumBagKey( rank )

        local bag = GlobalState[ rankStatebagKey ]
        gRankVisuals[ rank ] = {
            source = RankBagSource( bag ),
            effectsEnabled = RankBagEffectsEnabled( bag ),
        }

        -- a rank's bag changing updates that rank's online source and re-evaluates the roster
        AddStateBagChangeHandler( rankStatebagKey, 'global', function( _bag, _key, value )

            local previousSource = gRankVisuals[ rank ].source
            local serverId = RankBagSource( value )
            -- Use the callback value: GlobalState can still contain the previous value here.
            gRankVisuals[ rank ] = {
                source = serverId,
                effectsEnabled = RankBagEffectsEnabled( value ),
            }
            if previousSource ~= serverId then
                ReconcileRewardVisual( previousSource )
            end
            ReconcileRewardVisual( serverId )
        end )
    end

    -- a roster player connecting (re)applies their visual; a player dropping tears it down instantly
    RegisterNetEvent( 'onPlayerJoining', function( serverId )

        ReconcileRewardVisual( RankBagSource( { source = tonumber( serverId ) } ) )
    end )

    RegisterNetEvent( 'onPlayerDropped', function( serverId )

        serverId = tonumber( serverId )
        if serverId and gApplied[ serverId ] then
            ClearRewardVisual( serverId )
        end
    end )

    for rank = 1, MAX_REWARD_RANKS do
        ReconcileRewardVisual( gRankVisuals[ rank ].source )
    end
end

-- Termination (called by client/main.lua). The ptfx/nametag entries live in the sx render host (a separate
-- resource that keeps running), so they outlive this resource. Clear every applied source.
---@return nil
function TerminateSocialRewardVisuals()

    for source in pairs( gApplied ) do
        ClearRewardVisual( source )
    end
end
