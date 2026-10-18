-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: spikes
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("admin:createSpikes", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

