-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: fake-control-player
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("net.admin.togglePlayerControl", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
    -- Player(source).state:set("whitelistsourceBypass", ..., true)
end)

RegisterNetEvent("net.admin.stopPlayerControl", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
    -- Player(source).state:set("whitelistsourceBypass", ..., true)
end)

