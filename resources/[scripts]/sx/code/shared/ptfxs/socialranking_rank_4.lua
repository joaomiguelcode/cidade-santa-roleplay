-- Social Ranking weekly #4 reward visual (from qb-efeitotop4). A soft skid-smoke on both hands and both feet.
-- The effect self-loops, so it runs as persistent engine looped handles (no re-emit, no LOD). The qb colour
-- multipliers were >=1 on every channel (no tint), so no colour override is applied. Registered into
-- gPtfxRegistry; consumers reference it by its DEFINE_PTFX name ('SOCIALRANKING_RANK_4', upper-cased).
DEFINE_PTFX 'socialranking_rank_4' {
    layergroups = {
        { layers = {
            { dict = 'cut_tn', effect = 'cut_tn_swat_van_skid_smoke', bone = 57005 --[[ hand R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.2, alpha = 1.0 },
            { dict = 'cut_tn', effect = 'cut_tn_swat_van_skid_smoke', bone = 18905 --[[ hand L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.2, alpha = 1.0 },
            { dict = 'cut_tn', effect = 'cut_tn_swat_van_skid_smoke', bone = 52301 --[[ foot R ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.2, alpha = 1.0 },
            { dict = 'cut_tn', effect = 'cut_tn_swat_van_skid_smoke', bone = 14201 --[[ foot L ]], offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 0.2, alpha = 1.0 },
        } },
    },
}
