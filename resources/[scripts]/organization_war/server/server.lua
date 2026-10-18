-----------------------------------------------------------------------------------------------------------------------------------------
-- ORGANIZATION WAR (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

Server = {}
Tunnel.bindInterface("organization_war", Server)
Client = Tunnel.getInterface("organization_war")

local activeWars = {}

function Server._CreateEvent(map, eventType, playersQuantity, rounds, bet)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end
    print(("[ORG WAR] Event created by %s: %s | Mode: %s"):format(Passport, map, eventType))
end

function Server.GetOrganizations()
    return {}
end

function Server._SelectRival(data)
end

function Server.GetOrganizationMembers()
    return {}
end

function Server._SelectPlayers(time)
end

RegisterNetEvent("organization_war:KillEvent", function(killerId, victimId, weapon)
    print(("[ORG WAR] Kill event: %s killed %s with %s"):format(killerId, victimId, weapon))
end)
