---Mapas e constantes do modo competitivo.

COMPETITIVE_MAPS = {
    {
        id    = 'fazenda_ffa',
        key   = 'fazenda_ffa',
        name  = PvpTranslations.get( 'map_fazenda' ),
        image = 'https://cdn.santagroup.gg/fazenda.webp',
        teamA = {
            vec4( 1461.72, 1190.79, 114.25, 177.48 ),
        },
        teamB = {
            vec4( 1467.69, 1032.63, 114.26, 355.15 ),
        },
    },
    {
        id    = 'arena_dupla',
        key   = 'arena_dupla',
        name  = PvpTranslations.get( 'map_arena_dupla' ),
        image = 'https://cdn.santagroup.gg/minigame/map1.webp',
        teamA = {
            vec4( -1663.09, 5864.77, 212.36, 34.02 ),
        },
        teamB = {
            vec4( -1675.43, 5886.27, 212.36, 218.27 ),
        },
    },
    {
        id    = 'fazenda',
        key   = 'fazenda',
        name  = PvpTranslations.get( 'map_fazenda' ),
        image = 'https://cdn.santagroup.gg/minigame/map2.webp',
        teamA = {
            vec4( -1815.79, 5754.90, 210.38, 36.86 ),
        },
        teamB = {
            vec4( -1842.76, 5803.05, 210.38, 215.44 ),
        },
    },
    {
        id    = 'predio',
        key   = 'predio',
        name  = PvpTranslations.get( 'map_predio' ),
        image = 'https://cdn.santagroup.gg/minigame/map3.webp',
        teamA = {
            vec4( -1543.85, 5947.64, 214.54, 121.89 ),
        },
        teamB = {
            vec4( -1577.19, 5928.45, 214.54, 300.48 ),
        },
    },
    {
        id    = 'arena',
        key   = 'arena',
        name  = PvpTranslations.get( 'map_arena' ),
        image = 'https://cdn.santagroup.gg/minigame/map4.webp',
        teamA = {
            vec4( -1895.64, 5958.80, 208.48, 241.15 ),
        },
        teamB = {
            vec4( -1952.62, 5927.41, 208.48, 61.15 ),
        },
    },
}

COMPETITIVE_DEFAULT_MAP_ID = 'arena'
COMPETITIVE_MAP_VOTE_DURATION_MS = 30000
COMPETITIVE_MAP_VOTE_RESULT_MS = 2500
COMPETITIVE_WEAPON_VOTE_DURATION_MS = 30000
COMPETITIVE_WEAPON_VOTE_RESULT_MS = 1000
COMPETITIVE_ROUNDS_TO_WIN = 13
COMPETITIVE_WEAPON             = 'WEAPON_SPECIALCARBINE_MK2'
COMPETITIVE_WEAPON_HUD         = 'G3'
COMPETITIVE_KILLFEED_WEAPON    = 'rifle'
COMPETITIVE_WEAPON_IMAGE       = 'https://santaimagens.roleplayrp.com/img/inventory/g36c.png'
COMPETITIVE_AMMO               = 300
COMPETITIVE_FREEZE_MS          = 5000                    -- Freeze no inicio de cada round (ms)
COMPETITIVE_ROUND_TRANSITION_MS = 700              -- Pausa entre round end e proximo spawn/countdown
COMPETITIVE_MAX_PLAYERS   = 10                      -- Jogadores por time
COMPETITIVE_REQUIRED_PLAYERS_PER_TEAM = 1           -- MVP permite desafios a partir de 1 jogador por time

COMPETITIVE_WEAPONS = {
    {
        id       = 'rifle',
        key      = 'rifle',
        name     = PvpTranslations.get( 'weapon_rifle' ),
        weapon   = 'WEAPON_SPECIALCARBINE_MK2',
        hud      = 'G3',
        killfeed = 'rifle',
        image    = 'https://cdn.santagroup.gg/minigame/fuzil.webp',
        hudImage = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_carbinerifle_mk2.webp',
        ammo     = 300,
        slotItem = 'weapon_carbinerifle',
    },
    {
        id       = 'pistol',
        key      = 'pistol',
        name     = PvpTranslations.get( 'weapon_pistol' ),
        weapon   = 'WEAPON_PISTOL_MK2',
        hud      = 'Pistol',
        killfeed = 'pistol',
        image    = 'https://cdn.santagroup.gg/minigame/pistol.webp',
        hudImage = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_pistol_mk2.webp',
        ammo     = 300,
        slotItem = 'weapon_pistol_mk2',
    },
}

function GetCompetitiveMapById( mapId )
    local expectedId = tostring( mapId or '' )

    for _, mapDef in ipairs( COMPETITIVE_MAPS or {} ) do
        if tostring( mapDef.id ) == expectedId or tostring( mapDef.key ) == expectedId then
            return mapDef
        end
    end

    return nil
end

function GetCompetitiveDefaultMap()
    return GetCompetitiveMapById( COMPETITIVE_DEFAULT_MAP_ID ) or ( COMPETITIVE_MAPS and COMPETITIVE_MAPS[ 1 ] ) or nil
end

function GetCompetitiveWeaponById( weaponId )
    local expectedId = tostring( weaponId or '' )

    for _, weaponDef in ipairs( COMPETITIVE_WEAPONS or {} ) do
        if tostring( weaponDef.id ) == expectedId or tostring( weaponDef.key ) == expectedId then
            return weaponDef
        end
    end

    return nil
end

function GetCompetitiveDefaultWeapon()
    return GetCompetitiveWeaponById( 'rifle' ) or ( COMPETITIVE_WEAPONS and COMPETITIVE_WEAPONS[ 1 ] ) or nil
end
