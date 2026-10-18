-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: car_magnet
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("admin:CarMagnetSetSignal", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
    -- Player(source).state:set("carMagnet", ..., true)
end)

