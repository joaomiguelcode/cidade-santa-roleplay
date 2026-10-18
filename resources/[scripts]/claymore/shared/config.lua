config = {}


config.blockedAreas = { -- ÁREAS BLOQUEADAS PARA NÃO USAR A CLAYMORE
    {
        Coords = vec3(40.51,-292.79,47.7),
        Radius = 10.0
    }
}

config.claymoreProp = 'claymore_pru'

config.detection = {
    visibleDistance = 50.0,
    aggressivePollDistance = 12.0,
    range = 6.0,
    coneHalfAngle = 45.0,
    ownerSafeMs = 4000,
    deleteRadius = 5.0,
    laserLength = 4.5,
    laserLines = {
        { -0.05, -45.0 },
        { 0.05, 45.0 },
    },
}

return config