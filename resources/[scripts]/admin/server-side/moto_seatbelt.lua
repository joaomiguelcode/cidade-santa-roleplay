-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: moto_seatbelt
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("net.admin.motoSeatbelt:set", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

