-- fireworks server-side
local nextSlot = 1

local function LaunchFirework(coords, particleType, particleName)
    local slot = nextSlot
    nextSlot = (nextSlot % FireworksConfig.MaxFireworks) + 1
    
    particleName = particleName or FireworksConfig.Particles[math.random(#FireworksConfig.Particles)]
    particleType = particleType or 'firework_common'
    
    local stateKey = ('fireworks:%d'):format(slot)
    GlobalState[stateKey] = {
        particleName = particleName,
        particleType = particleType,
        x = coords.x,
        y = coords.y,
        z = coords.z
    }
    
    SetTimeout(FireworksConfig.Duration or 10000, function()
        GlobalState[stateKey] = nil
    end)
end

exports('startFirework', LaunchFirework)

RegisterCommand('firework', function(source, args)
    local passport = vRP.Passport(source)
    if not vRP.hasPermission(passport, 'Admin') then return end
    
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    LaunchFirework(coords, args[1] or 'firework_special', args[2])
end)
