-----------------------------------------------------------------------------------------------------------------------------------------
-- ADMIN MODULE: drughide
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterNetEvent("admin:drughide:setHidden", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("admin:drughide:createCrater", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

RegisterNetEvent("admin:drughide:clearCraters", function(...)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
end)

