-- Server module: player/server/bprotection/main.lua
RegisterNetEvent("player:server:firstLogin", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
    -- Handle player:server:firstLogin
end)

RegisterNetEvent("net.player.show.welcome.message", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
    -- Handle net.player.show.welcome.message
end)

