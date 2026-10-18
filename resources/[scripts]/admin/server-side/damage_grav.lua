-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: damage_grav
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("admin:damageGravHitVehicle", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("admin:damageGravHitPlayer", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

