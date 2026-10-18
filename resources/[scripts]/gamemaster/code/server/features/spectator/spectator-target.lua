gamemaster.server.spectatorTarget = {}

function gamemaster.server.spectatorTarget.resolve(targetSource)
    local ped = GetPlayerPed(targetSource)
    local passport = vRP.Passport(targetSource)
    return {
        source = targetSource,
        passport = passport,
        name = GetPlayerName(targetSource),
        health = GetEntityHealth(ped),
        armour = GetPedArmour(ped),
        coords = GetEntityCoords(ped)
    }
end
