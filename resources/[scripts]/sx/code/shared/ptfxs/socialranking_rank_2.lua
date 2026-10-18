-- Social Ranking weekly #2 reward visual (from qb-efeitotop2). A misting barrel smoke on both feet plus a
-- green wheel-flame on hands, feet and shoulders. Both effects self-loop, so they run as persistent engine
-- looped handles (no re-emit, no LOD). The green read comes from the effect asset itself; the qb colour
-- multipliers were >=1 on every channel (i.e. no tint), so no colour override is applied. Registered into
-- gPtfxRegistry; consumers reference it by its DEFINE_PTFX name ('SOCIALRANKING_RANK_2', upper-cased).
DEFINE_PTFX 'socialranking_rank_2' {
    layergroups = {
        { layers = {
            -- barrel mist on both feet
            { dict = 'scr_xt_src', effect = 'scr_xt_src_barrel_mist', bone = 52301 --[[ foot R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.4, alpha = 1.0 },
            { dict = 'scr_xt_src', effect = 'scr_xt_src_barrel_mist', bone = 14201 --[[ foot L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.4, alpha = 1.0 },

            -- green flame on hands, feet and shoulders
            { dict = 'scr_sum2_hal', effect = 'scr_sum2_hal_bike_wheel_flame_green', bone = 57005 --[[ hand R    ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.8, alpha = 1.0 },
            { dict = 'scr_sum2_hal', effect = 'scr_sum2_hal_bike_wheel_flame_green', bone = 18905 --[[ hand L    ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.8, alpha = 1.0 },
            { dict = 'scr_sum2_hal', effect = 'scr_sum2_hal_bike_wheel_flame_green', bone = 52301 --[[ foot R    ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.8, alpha = 1.0 },
            { dict = 'scr_sum2_hal', effect = 'scr_sum2_hal_bike_wheel_flame_green', bone = 14201 --[[ foot L    ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.8, alpha = 1.0 },
            { dict = 'scr_sum2_hal', effect = 'scr_sum2_hal_bike_wheel_flame_green', bone = 40269 --[[ shoulder R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.8, alpha = 1.0 },
            { dict = 'scr_sum2_hal', effect = 'scr_sum2_hal_bike_wheel_flame_green', bone = 45509 --[[ shoulder L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.8, alpha = 1.0 },
        } },
    },
}
