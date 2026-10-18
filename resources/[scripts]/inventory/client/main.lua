Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
cityName = GetConvar("cityName", "")
Open = false

CreativeChest = {}
Tunnel.bindInterface("inventory/chest", CreativeChest)

RegisterNUICallback("getCityName", function(Data, Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

---@param collectibleLookupKeys collectibles.CollectibleKey[]
---@param accountId number id da conta
RegisterNetEvent("net.inventory.give.collectible.item", function(collectibleLookupKeys, accountId)
    print('syncing collectible items', json.encode(collectibleLookupKeys, { indent = true }), accountId)
    SendNUIMessage({ action = 'updateCollectiblesCount', ids = collectibleLookupKeys, accountId = accountId })
end)

RegisterNUICallback("hideFrame", function(Data, Callback)
    if IsFactionTradeActive() then
        CancelFactionTradeFromEsc()
    elseif IsChestPermissionActive() then
        CancelChestPermissionFromEsc()
    elseif IsFactionArsenalActive and IsFactionArsenalActive() then
        CancelFactionArsenalFromEsc()
    end
    TriggerEvent("hud:Active", true)
    TriggerEvent("inventory:CloseAll")
    Callback("Ok")
end)

function toggleInventory(tag)
    local toggle = (tag ~= nil)

    if toggle and exports.new_hub:IsAffiliateWorldClientActive() then
        TriggerEvent("Notify", "Warning", _t("affiliate_world_inventory_blocked"), 5000, "Mundo Afiliado")
        return false
    end

    if (toggle) then
        Open = tag
        SetCursorLocation(0.5, 0.5)
    end
    SendNUIMessage({
        action = "setVisible",
        data = tag or false
    })
    SetNuiFocus(toggle, toggle)
    TriggerEvent("hud:Active", not toggle)

    return true
end

RegisterNetEvent("itensNotify")
AddEventHandler("itensNotify", function(status)
    SendNUIMessage({
        action = "addItemNotify",
        data = {
            mode = status[1],
            item = status[2],
            amount = status[3],
            name = status[4]
        }
    })
end)

local TUTORIAL_LOOKUP_TO_SEND_EVENT = {
    ['chest'] = 'tutorial.ui.chest',
    ['shop'] = 'tutorial.ui.store',
}

RegisterNUICallback("tutorialInventory:finished",function(data,callback)
    local tutorialId = TUTORIAL_LOOKUP_TO_SEND_EVENT[data.secondaryInventoryType]

    if not tutorialId then
        return callback(false)
    end

    exports.tutorial:SendFinishedUiTutorial(tutorialId)
    callback(true)
end)

exports('IsResourceFocusedUi', function()
    return IsNuiFocused()
end)


local WAIT_TIME_TO_LAUNCH_FIREWORK = 1000
local MAX_FIREWORKS_TO_LAUNCH = 3
local GROUND_OFFSET = 45.0

---@param rarity firework.rarity
RegisterNetEvent('net.inventory.firework.launch', function(rarity)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local forward = GetEntityForwardVector(ped)

    local launchCoords = {
        x = coords.x + forward.x * 50.0,
        y = coords.y + forward.y * 50.0,
        z = coords.z - GROUND_OFFSET,
    }
    
    for i = 1, MAX_FIREWORKS_TO_LAUNCH do
        TriggerServerEvent('net.fireworks.launch', {
            particleName = 'scr_indep_firework_trailburst',
            coords = launchCoords,
            rarity = rarity,
        })
        Wait(WAIT_TIME_TO_LAUNCH_FIREWORK)
    end
end)
