-- Social Ranking weekly #3 reward visual (from qb-efeitotop3). A torch-fire base plus a fire-limb accent on
-- both hands and feet, and two 'fairy' blowtorch flames that wander above the shoulders (entity-root
-- offsets + tick motion, matching qb FairyMotion: random target every ~1.2s, lerp toward it, flutter on
-- top). Body layers self-loop as persistent handles; fairies also loop but reposition every host tick via
-- SetParticleFxLoopedOffsets. Registered into gPtfxRegistry; consumers reference it by its DEFINE_PTFX name
-- ('SOCIALRANKING_RANK_3', upper-cased).

-- Per-fairy wander+flutter tick. Mirrors qb-efeitotop3 FairyMotion (targetInterval/smoothness/flutter*),
-- with smoothness scaled for the ptfx host's ~100 ms tick (qb ran at ~16 ms). State is keyed by handle so
-- left/right fairies (and recreates after LOD/stream) each keep their own current/target.
---@param baseX number
---@param baseY number
---@param baseZ number
---@param sidePhase number -- phase offset so left/right flutter don't sync
---@return fun( handle: number, elapsedMs: number )
local function MakeFairyTick( baseX, baseY, baseZ, sidePhase )

    local RANDOM_X, RANDOM_Y, RANDOM_Z = 0.14, 0.12, 0.14
    local TARGET_INTERVAL_MS           = 1200
    -- qb smoothness 0.040 @ ~16 ms ≈ 0.22 @ ~100 ms: 1 - (1 - 0.04)^(100/16)
    local SMOOTHNESS                   = 0.22
    local FLUTTER_XY, FLUTTER_Z        = 0.020, 0.035

    ---@type table<number, { cx: number, cy: number, cz: number, tx: number, ty: number, tz: number, nextAt: number }>
    local state = {}

    local function rand( amp )
        return ( ( math.random() * 2.0 ) - 1.0 ) * amp
    end

    local function newAroundBase()
        return baseX + rand( RANDOM_X ), baseY + rand( RANDOM_Y ), baseZ + rand( RANDOM_Z )
    end

    return function( handle, elapsedMs )

        local s = state[ handle ]
        if not s then
            local cx, cy, cz = newAroundBase()
            local tx, ty, tz = newAroundBase()
            s = { cx = cx, cy = cy, cz = cz, tx = tx, ty = ty, tz = tz, nextAt = elapsedMs + TARGET_INTERVAL_MS }
            state[ handle ] = s
        end

        if elapsedMs >= s.nextAt then
            s.tx, s.ty, s.tz = newAroundBase()
            s.nextAt = elapsedMs + TARGET_INTERVAL_MS + math.random( -200, 300 )
        end

        s.cx = s.cx + ( s.tx - s.cx ) * SMOOTHNESS
        s.cy = s.cy + ( s.ty - s.cy ) * SMOOTHNESS
        s.cz = s.cz + ( s.tz - s.cz ) * SMOOTHNESS

        SetParticleFxLoopedOffsets(
            handle,
            s.cx + ( math.cos( ( elapsedMs / 380.0 ) + sidePhase ) * FLUTTER_XY ),
            s.cy + ( math.sin( ( elapsedMs / 430.0 ) + sidePhase ) * FLUTTER_XY ),
            s.cz + ( math.sin( ( elapsedMs / 260.0 ) + sidePhase ) * FLUTTER_Z ),
            0.0, 0.0, 0.0
        )
    end
end

DEFINE_PTFX 'socialranking_rank_3' {
    layergroups = {
        { layers = {
            -- torch-fire base on hands and feet
            { dict = 'core', effect = 'ent_amb_torch_fire', bone = 57005 --[[ hand R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.3, alpha = 0.5 },
            { dict = 'core', effect = 'ent_amb_torch_fire', bone = 18905 --[[ hand L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.3, alpha = 0.5 },
            { dict = 'core', effect = 'ent_amb_torch_fire', bone = 52301 --[[ foot R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.3, alpha = 0.5 },
            { dict = 'core', effect = 'ent_amb_torch_fire', bone = 14201 --[[ foot L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.3, alpha = 0.5 },

            -- fire-limb accent on the same bones
            { dict = 'core', effect = 'fire_ped_limb', bone = 57005 --[[ hand R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.7, alpha = 1.0 },
            { dict = 'core', effect = 'fire_ped_limb', bone = 18905 --[[ hand L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.7, alpha = 1.0 },
            { dict = 'core', effect = 'fire_ped_limb', bone = 52301 --[[ foot R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.7, alpha = 1.0 },
            { dict = 'core', effect = 'fire_ped_limb', bone = 14201 --[[ foot L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.7, alpha = 1.0 },

            -- two fairy flames on the entity root (qb FairyMotion bases), wandering via tick
            { dict = 'scr_sv_rob_sub', effect = 'scr_sv_rob_sub_blowtorch_flame', offset = vector3(  0.48, -0.08, 1.12 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.15, alpha = 1.0,
                tick = MakeFairyTick(  0.48, -0.08, 1.12, 1.4 ),
            },
            { dict = 'scr_sv_rob_sub', effect = 'scr_sv_rob_sub_blowtorch_flame', offset = vector3( -0.48, -0.08, 1.12 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.15, alpha = 1.0,
                tick = MakeFairyTick( -0.48, -0.08, 1.12, 0.0 ),
            },
        } },
    },
}
