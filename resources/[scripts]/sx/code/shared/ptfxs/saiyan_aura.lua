-- Saiyan aura for the weekly #1 (Social Ranking reward visual). 'core'/'ent_amb_smoke_foundry' is a
-- reliable looped column; the gold colour override gives the "aura" read. Registered into gPtfxRegistry;
-- consumers reference it by name via PTFX_SAIYAN_AURA (lib/shared/ptfx_names.lua).
DEFINE_PTFX 'saiyan_aura' {
    layergroups = {
        { layers = {
            { dict = 'core', effect = 'ent_amb_smoke_foundry', offset = vector3( 0.0, 0.0, 0.0 ), rotation = vector3( 0.0, 0.0, 0.0 ), scale = 1.2, colour = { r = 255, g = 215, b = 0 }, alpha = 0.8 },
        } },
    },
}
