---Config do modo FFA Fuzil.

PVP_FFA_RIFLE_MINIGAME_NAME = 'FFA Fuzil'

FFA_RIFLE_MAX_PLAYERS = 128
FFA_RIFLE_BOUNDARY_RADIUS = 200.0
FFA_RIFLE_RESPAWN_SETUP_DELAY_MS = 250
FFA_RIFLE_MAP_ROTATION_INTERVAL_SECONDS = 15 * 60

local ffaRifleWeaponFallback = {
    id       = 'rifle',
    key      = 'rifle',
    name     = PvpTranslations.get( 'weapon_rifle' ),
    weapon   = 'WEAPON_SPECIALCARBINE_MK2',
    hud      = 'G3',
    killfeed = 'rifle',
    image    = 'https://hudimg.roleplayrp.com/img/imagens_variadas/iconesnotify/fronteira/weapons/weapon_carbinerifle_mk2.webp',
    ammo     = 300,
    slotItem = 'weapon_carbinerifle',
}

FFA_RIFLE_ROTATION_MAP_KEYS = { 'fazenda', 'containers' }

FFA_RIFLE_MAPS = {
    {
        id    = 'sandy',
        key   = 'sandy',
        name  = PvpTranslations.get( 'ffa_rifle_map_sandy' ),
        image = 'https://cdn.santagroup.gg/minigame/fuzil.webp',
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
    {
        id    = 'fazenda',
        key   = 'fazenda',
        name  = PvpTranslations.get( 'map_fazenda' ),
        image = 'https://cdn.santagroup.gg/minigame/fuzil.webp',
        spawns = {
            vec4( 1461.84, 1070.52, 118.76, 223.94 ),
            vec4( 1461.82, 1070.59, 114.33, 320.32 ),
            vec4( 1450.19, 1032.60, 114.22, 348.67 ),
            vec4( 1496.72, 1033.53, 114.16, 22.68 ),
            vec4( 1502.91, 1059.35, 114.28, 28.35 ),
            vec4( 1495.69, 1099.59, 114.33, 90.71 ),
            vec4( 1494.47, 1130.96, 114.33, 70.87 ),
            vec4( 1503.63, 1160.73, 114.22, 116.23 ),
            vec4( 1456.66, 1148.55, 114.33, 246.62 ),
            vec4( 1434.02, 1168.53, 114.17, 164.41 ),
            vec4( 1458.23, 1178.95, 114.22, 133.23 ),
            vec4( 1490.75, 1168.33, 114.29, 164.41 ),
            vec4( 1466.56, 1107.97, 114.33, 172.92 ),
        },
    },
    {
        id    = 'containers',
        key   = 'containers',
        name  = PvpTranslations.get( 'map_containers' ),
        image = 'https://cdn.santagroup.gg/minigame/fuzil.webp',
        spawns = {
            vec4( -1543.52, 6123.42, 205.8, 22.68 ),
            vec4( -1542.73, 6123.25, 205.8, 113.39 ),
            vec4( -1555.46, 6104.72, 205.8, 31.19 ),
            vec4( -1551.15, 6132.37, 205.8, 85.04 ),
            vec4( -1562.10, 6145.88, 205.8, 153.08 ),
            vec4( -1573.59, 6136.83, 205.8, 113.39 ),
            vec4( -1579.35, 6151.68, 205.8, 249.45 ),
            vec4( -1591.70, 6142.67, 205.8, 198.43 ),
            vec4( -1585.92, 6126.70, 205.8, 19.85 ),
            vec4( -1598.58, 6124.20, 205.8, 255.12 ),
            vec4( -1580.76, 6110.85, 205.8, 22.68 ),
            vec4( -1565.38, 6104.17, 205.8, 17.01 ),
            vec4( -1605.85, 6122.23, 205.8, 297.64 ),
            vec4( -1611.27, 6133.57, 205.8, 306.15 ),
            vec4( -1595.77, 6153.70, 205.8, 170.08 ),
        },
    },
}

function GetFfaRifleMapById( mapId )
    mapId = tostring( mapId or '' )
    if mapId == '' then return nil end

    for _, mapDef in ipairs( FFA_RIFLE_MAPS or {} ) do
        if tostring( mapDef.id or '' ) == mapId or tostring( mapDef.key or '' ) == mapId then
            return mapDef
        end
    end

    return nil
end

function GetFfaRifleRotationMapByIndex( index )
    index = tonumber( index ) or 1

    local mapId = FFA_RIFLE_ROTATION_MAP_KEYS and FFA_RIFLE_ROTATION_MAP_KEYS[ index ] or nil
    return GetFfaRifleMapById( mapId )
end

local function getFfaRifleRotationClockSeconds()
    if os and os.time then
        return os.time()
    end

    return math.floor( GetGameTimer() / 1000 )
end

function GetFfaRifleMapRotationSlot( timestamp )
    local interval = FFA_RIFLE_MAP_ROTATION_INTERVAL_SECONDS or 900
    if interval <= 0 then interval = 900 end

    return math.floor( ( timestamp or getFfaRifleRotationClockSeconds() ) / interval )
end

function GetFfaRifleMapRotationIndex( timestamp )
    local mapCount = FFA_RIFLE_ROTATION_MAP_KEYS and #FFA_RIFLE_ROTATION_MAP_KEYS or 0
    if mapCount <= 0 then return nil end

    return ( GetFfaRifleMapRotationSlot( timestamp ) % mapCount ) + 1
end

function GetFfaRifleCurrentRotationMap()
    local index = GetFfaRifleMapRotationIndex()
    return ( index and GetFfaRifleRotationMapByIndex( index ) ) or FFA_RIFLE_MAPS[ 1 ]
end

function GetFfaRifleSecondsUntilNextMapRotation()
    local interval = FFA_RIFLE_MAP_ROTATION_INTERVAL_SECONDS or 900
    if interval <= 0 then interval = 900 end

    local now = getFfaRifleRotationClockSeconds()
    local remaining = interval - ( now % interval )

    if remaining <= 0 then
        remaining = interval
    end

    return remaining
end

function GetFfaRifleWeapon()
    local competitiveRifle = GetCompetitiveWeaponById and GetCompetitiveWeaponById( 'rifle' ) or nil
    local source = competitiveRifle or ffaRifleWeaponFallback

    return {
        id       = source.id or ffaRifleWeaponFallback.id,
        key      = source.key or source.id or ffaRifleWeaponFallback.key,
        name     = source.name or ffaRifleWeaponFallback.name,
        weapon   = source.weapon or ffaRifleWeaponFallback.weapon,
        hud      = source.hud or source.name or ffaRifleWeaponFallback.hud,
        killfeed = source.killfeed or ffaRifleWeaponFallback.killfeed,
        image    = source.hudImage or source.image or ffaRifleWeaponFallback.image,
        ammo     = source.ammo or ffaRifleWeaponFallback.ammo,
        slotItem = source.slotItem or ffaRifleWeaponFallback.slotItem,
    }
end

function GetFfaRifleDefaultMap()
    return GetFfaRifleCurrentRotationMap()
end

function GetFfaRifleSpawnpoints()
    local mapDef = GetFfaRifleDefaultMap()
    return mapDef and mapDef.spawns or {}
end
