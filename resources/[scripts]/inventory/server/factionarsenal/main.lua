-----------------------------------------------------------------------------------------------------------------------------------------
-- FACTION ARSENAL (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Creative = {}
Tunnel.bindInterface("inventory/factionarsenal", Creative)

local arsenalPositions = {}

function Creative.Withdraw()
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    -- Give weapon kit/consumables based on faction job
    TriggerClientEvent("Notify2", source, "#arsenalPegou")
end

function Creative.OpenLegalMenu()
    return { ok = true, roles = {} }
end

function Creative.RequestConfig()
    return { ok = true, roles = {} }
end

function Creative.SetPosition()
    local source = source
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    return { ok = true, sync = { showPoint = true, coords = coords } }
end

function Creative.SetRoleEnabled(roleId, enabled)
    return { ok = true }
end

function Creative.RequestKitItems(roleId, currentKitItems)
    return { items = {} }
end

function Creative.AddRoleKitItem(roleId, item)
    return { ok = true }
end

function Creative.SaveRoleConfig(roleId, enabled, cooldownMinutes, withdrawLimit, kitItems)
    return { ok = true }
end

function Creative.DisableAllRoles()
    return { ok = true }
end

function Creative.ClearPosition()
    return { ok = true, sync = { showPoint = false, coords = nil } }
end

RegisterNetEvent("factionarsenal:requestSync", function()
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    -- Send sync payload
    TriggerClientEvent("factionarsenal:sync", source, {
        isPolice = false,
        showPoint = false,
        coords = nil
    })
end)
