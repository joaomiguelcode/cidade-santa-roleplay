---Config do modo Apenas Sniper.

PVP_FFA_SNIPER_MINIGAME_NAME = 'Apenas Sniper'

FFA_SNIPER_MAX_PLAYERS = 128
FFA_SNIPER_BOUNDARY_RADIUS = 200.0
FFA_SNIPER_RESPAWN_SETUP_DELAY_MS = 250

local ffaSniperWeaponFallback = {
    id       = 'sniper',
    key      = 'sniper',
    name     = PvpTranslations.get( 'weapon_sniper' ),
    weapon   = 'WEAPON_SNIPERRIFLE',
    hud      = 'Sniper',
    killfeed = 'sniper',
    image    = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_heavysniper.webp',
    ammo     = 300,
    slotItem = 'weapon_heavysniper',
}

FFA_SNIPER_MAPS = {
    {
        id    = 'sandy',
        key   = 'sandy',
        name  = PvpTranslations.get( 'ffa_sniper_map_sandy' ),
        image = 'https://cdn.santagroup.gg/minigame/sniper.webp',
        spawns = {
            vec4( 1771.24, 3718.87, 34.22, 235.28 ),
            vec4( 1790.93, 3719.17, 34.12, 272.13 ),
            vec4( 1783.73, 3731.53, 34.12, 238.12 ),
            vec4( 1879.61, 3753.74, 32.92, 286.30 ),
            vec4( 1847.93, 3804.64, 32.92, 5.67 ),
            vec4( 1818.03, 3860.22, 33.90, 82.21 ),
            vec4( 1789.17, 3900.43, 34.29, 104.89 ),
            vec4( 1742.80, 3871.01, 34.76, 93.55 ),
            vec4( 1714.57, 3848.79, 34.88, 147.41 ),
            vec4( 1702.25, 3841.19, 34.93, 198.43 ),
            vec4( 1739.66, 3795.24, 34.27, 198.43 ),
            vec4( 1774.95, 3801.68, 34.26, 198.43 ),
            vec4( 1691.57, 3771.47, 34.69, 198.43 ),
            vec4( 1772.72, 3635.29, 34.69, 198.43 ),
            vec4( 1719.17, 3677.83, 34.78, 246.62 ),
            vec4( 1744.50, 3793.61, 34.22, 294.81 ),
            vec4( 1739.39, 3815.83, 34.56, 266.46 ),
        },
    },
}

function GetFfaSniperWeapon()
    local source = ffaSniperWeaponFallback

    return {
        id       = source.id or ffaSniperWeaponFallback.id,
        key      = source.key or source.id or ffaSniperWeaponFallback.key,
        name     = source.name or ffaSniperWeaponFallback.name,
        weapon   = source.weapon or ffaSniperWeaponFallback.weapon,
        hud      = source.hud or source.name or ffaSniperWeaponFallback.hud,
        killfeed = source.killfeed or ffaSniperWeaponFallback.killfeed,
        image    = source.hudImage or source.image or ffaSniperWeaponFallback.image,
        ammo     = source.ammo or ffaSniperWeaponFallback.ammo,
        slotItem = source.slotItem or ffaSniperWeaponFallback.slotItem,
    }
end

function GetFfaSniperDefaultMap()
    return FFA_SNIPER_MAPS[ 1 ]
end

function GetFfaSniperSpawnpoints()
    local mapDef = GetFfaSniperDefaultMap()
    return mapDef and mapDef.spawns or {}
end
