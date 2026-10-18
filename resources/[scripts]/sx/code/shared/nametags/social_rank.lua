-- "Gente Boa 🚀" rank nametag for the weekly top-15 (Social Ranking reward visual). Gold is reserved for
-- this rank nametag + the #1 aura. Registered into gNametagRegistry; consumers reference it by name via
-- NAMETAG_SOCIAL_RANK (lib/shared/nametag_names.lua).
local labels = {
    ar = 'شخص طيب',
    en = 'Good Person',
    es = 'Buena Persona',
    pt = 'Gente Boa',
}

local language = GetConvar( 'language' ):sub( 1, 2 ):lower()

DEFINE_NAMETAG 'social_rank' {
    label = labels[ language ],
    emoji = '🚀',
    color = { r = 255, g = 215, b = 0 },
}
