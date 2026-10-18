-- Social Ranking weekly #1 reward visual (from qb-efeitotop1). Electric 'blood_stungun' pulses run up both
-- arms (hand -> forearm -> shoulder) as re-fired one-shots, plus a coloured 'rider_death_trail_blue' streamer
-- on each foot. The trail/stungun effects don't self-loop, so they carry loopEveryMilliseconds and are re-fired
-- while the ped is in range. Registered into gPtfxRegistry; consumers reference it by its DEFINE_PTFX name
-- ('SOCIALRANKING_RANK_1', upper-cased).
DEFINE_PTFX 'socialranking_rank_1' {
    layergroups = {
        { layers = {
            -- electric pulse up the right arm
            { dict = 'core', effect = 'blood_stungun', bone = 57005 --[[ hand R    ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.6, alpha = 1.0, loopEveryMilliseconds = 1000 },
            { dict = 'core', effect = 'blood_stungun', bone = 28252 --[[ forearm R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.6, alpha = 1.0, loopEveryMilliseconds = 1000 },
            { dict = 'core', effect = 'blood_stungun', bone = 40269 --[[ shoulder R]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.6, alpha = 1.0, loopEveryMilliseconds = 1000 },

            -- electric pulse up the left arm
            { dict = 'core', effect = 'blood_stungun', bone = 18905 --[[ hand L    ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.6, alpha = 1.0, loopEveryMilliseconds = 1000 },
            { dict = 'core', effect = 'blood_stungun', bone = 61163 --[[ forearm L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.6, alpha = 1.0, loopEveryMilliseconds = 1000 },
            { dict = 'core', effect = 'blood_stungun', bone = 45509 --[[ shoulder L]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.6, alpha = 1.0, loopEveryMilliseconds = 1000 },

            -- coloured streamers off both feet
            { dict = 'scr_sum2_hal', effect = 'sp_sum2_hal_rider_death_trail_blue', bone = 52301 --[[ foot R ]], offset = vector3( 0.0, 0.0, 0.13 ), rotation = vector3( 0.0, -90.0, 90.0 ), scale = 2.0, alpha = 0.18, colour = { r = 255, g = 255, b = 153 }, loopEveryMilliseconds = 300 },
            { dict = 'scr_sum2_hal', effect = 'sp_sum2_hal_rider_death_trail_blue', bone = 14201 --[[ foot L ]], offset = vector3( 0.0, 0.0, 0.13 ), rotation = vector3( 0.0, -90.0, 90.0 ), scale = 2.0, alpha = 0.18, colour = { r = 76,  g = 255, b = 255 }, loopEveryMilliseconds = 300 },
        } },
    },
}
