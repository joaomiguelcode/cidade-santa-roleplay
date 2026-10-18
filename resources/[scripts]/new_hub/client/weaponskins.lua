-- ================================================================
-- WeaponSkins: gerenciamento de dados de skins e callbacks NUI
-- ================================================================

local groupSkins = {}

-- ── Sincronização de skins do jogador ───────────────────────────

RegisterNetEvent("skins:setPlayerSkins", function(playerSkins)
    for i = 1, #playerSkins do
        local info = playerSkins[i]
        for weapon, skins in pairs(weapons_skins) do
            for index, skin in pairs(skins) do
                if skin.component == info[1] then
                    weapons_skins[weapon][index].equipped = info[2] and true or false
                    weapons_skins[weapon][index].bought   = true
                end
            end
        end
    end
end)

RegisterNetEvent("skins:updatePlayerSkins", function(skinInfo)
    for weapon, skins in pairs(weapons_skins) do
        for index, skin in pairs(skins) do
            if skin.component == skinInfo[1] then
                skin.equipped = skinInfo[2]
                skin.bought   = true
            end
        end
    end
end)

-- ── Helpers de dados ────────────────────────────────────────────

function GetNonPrivateSkins()
    local nonPrivateSkins = {}
    for weapon, skins in pairs(weapons_skins) do
        if not nonPrivateSkins[weapon] then
            nonPrivateSkins[weapon] = {}
        end
        for index, skin in pairs(skins) do

            if not skin.private then
                table.insert(nonPrivateSkins[weapon], skin)
            end
        end
    end
    return nonPrivateSkins
end

-- ── NUI callbacks de dados/negócio ──────────────────────────────

RegisterNUICallback("getSkins", function(Data, Callback)
    Callback({
        categories = weapons_categories,
        skins      = GetNonPrivateSkins()
    })
end)

RegisterNUICallback("buySkin", function(Data, Callback)
    local link = weapons_links[cityName] and weapons_links[cityName][Data.component]

    if type(link) ~= "string" or link == "" then
        Callback(false)
        return
    end

    TriggerEvent("player:OpenURL", link)
    Callback(true)
end)

RegisterNUICallback("equipSkin", function(Data, Callback)
    TriggerServerEvent("skins:equipSkin", Data.weapon, Data.component)
    Callback(true)
end)

RegisterNUICallback("unequipSkin", function(Data, Callback)
    TriggerServerEvent("skins:unequipSkin", Data.weapon, Data.component)
    Callback(true)
end)

RegisterNUICallback("unequipAllSkins", function(Data, Callback)
    TriggerServerEvent("skins:unequipAllSkins", Data.weapon)
    Callback(true)
end)

-- ── Pré-carregamento de modelos de componentes ──────────────────

local function preloadAllComponents()
    local Ped    = PlayerPedId()
    local coords = GetEntityCoords(Ped)
    for Weapon, Info in pairs(weapons_skins) do
        for _, skin in pairs(Info) do

            if not skin.custom_weapon then
                local componentHash = GetHashKey(skin.component)
                local pickupObject  = CreateWeaponObject(Weapon, 0, coords.x, coords.y, coords.z - 500, true, 1.0, 0)
                RequestModel(componentHash)
                GiveWeaponComponentToWeaponObject(pickupObject, componentHash)
                Wait(250)
                DeleteEntity(pickupObject)
            end
        end
    end
end

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == GetCurrentResourceName() then
        preloadAllComponents()
    end
end)

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active", function()
    preloadAllComponents()
end)

-- ── Skins de grupo ──────────────────────────────────────────────

function GetGroupSkins(weapon)
    return groupSkins[weapon] or nil
end
exports("GetGroupSkins", GetGroupSkins)

RegisterNetEvent("skins:setGroupSkins", function(skins)
    local previous = groupSkins
    groupSkins = {}
    for i = 1, #skins do
        local info = skins[i]
        groupSkins[info[2]] = info[1]
    end
    local ped = PlayerPedId()
    for weapon, component in pairs(previous) do
        if groupSkins[weapon] ~= component then
            local owned = false
            for _, skin in pairs(weapons_skins[weapon] or {}) do
                if skin.component == component and skin.bought then owned = true break end
            end
            if not owned then RemoveWeaponComponentFromPed(ped, GetHashKey(weapon), GetHashKey(component)) end
        end
    end
end)
