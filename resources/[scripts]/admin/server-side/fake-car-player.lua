-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: fake-car-player
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("net.admin.cancelEscapeCloneRequest", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("net.admin.createEscapeClone", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("net.admin.escapeCloneConfigured", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("net.admin.escapeCloneConfigurationFailed", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

