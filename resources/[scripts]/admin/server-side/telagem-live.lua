-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: telagem-live
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("telagemLive:answer", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

