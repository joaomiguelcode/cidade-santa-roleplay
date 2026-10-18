-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: fake-change-driver
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("net.admin.toggleDriverControl", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("net.admin.stopVehicleControl", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

