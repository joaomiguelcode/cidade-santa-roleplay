-----------------------------------------------------------------------------------------------------------------------------------------
-- FACTION TRADE (CLIENT)
-----------------------------------------------------------------------------------------------------------------------------------------
local vSERVER = Tunnel.getInterface("inventory/factiontrade")
local TradeActive = false
local TradeRole = nil
local LatestRevision = -1
local LatestPayload = nil

local function ApplyTradePayload(Payload)
    if type(Payload) ~= "table" then
        return false
    end

    local Revision = tonumber(Payload.revision) or 0
    if Revision < LatestRevision then
        return false
    end

    LatestRevision = Revision
    LatestPayload = Payload
    SendNUIMessage({ action = "updateFactionTrade", data = Payload })
    return true
end

RegisterNetEvent("factiontrade:open", function(Role)
    if not IsFactionPilotCity() then
        return
    end
    TradeActive = true
    TradeRole = Role
    LatestRevision = -1
    LatestPayload = nil
    SendNUIMessage({ action = "setVisible", data = "trade/"..Role })
    SetNuiFocus(true, true)
    TriggerEvent("hud:Active", false)
end)

RegisterNetEvent("factiontrade:update", function(Payload)
    ApplyTradePayload(Payload)
end)

local function CloseTradeUi()
    TradeActive = false
    TradeRole = nil
    LatestRevision = -1
    LatestPayload = nil
    SendNUIMessage({ action = "setVisible", data = false })
    SetNuiFocus(false, false)
    TriggerEvent("hud:Active", true)
end
RegisterNetEvent("factiontrade:close", CloseTradeUi)

function IsFactionTradeActive()
    return TradeActive
end

function CancelFactionTradeFromEsc()
    if not TradeActive then return end
    if TradeRole == "buyer" then
        vSERVER.Reject()
    else
        vSERVER.Cancel()
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestFactionTrade", function(_, Callback)
    local Payload = vSERVER.RequestSession()
    if type(Payload) ~= "table" or not Payload.ok then
        Callback(Payload)
        return
    end

    local Revision = tonumber(Payload.revision) or 0
    if Revision < LatestRevision and LatestPayload then
        Callback(LatestPayload)
        return
    end

    LatestRevision = math.max(LatestRevision, Revision)
    LatestPayload = Payload
    Callback(Payload)
end)
RegisterNUICallback("factionTradeOfferItem", function(Data, Callback)
    Callback(vSERVER.OfferItem(Data["fromSlot"], Data["amount"], Data["targetSlot"]))
end)
RegisterNUICallback("factionTradeMoveOfferItem", function(Data, Callback)
    Callback(vSERVER.MoveOfferItem(Data["fromSlot"], Data["targetSlot"]))
end)
RegisterNUICallback("factionTradeReturnItemToChest", function(Data, Callback)
    Callback(vSERVER.ReturnItemToChest(Data["offerSlot"], Data["targetSlot"], Data["amount"]))
end)
RegisterNUICallback("factionTradeRemoveItem", function(Data, Callback)
    Callback(vSERVER.RemoveItem(Data["slot"]))
end)
RegisterNUICallback("factionTradeSetPrice", function(Data, Callback)
    Callback(vSERVER.SetPrice(Data["price"]))
end)
RegisterNUICallback("factionTradeSetPartnership", function(Data, Callback)
    Callback(vSERVER.SetPartnership(Data["hasPartnership"]))
end)
RegisterNUICallback("factionTradeSetBuyerValue", function(Data, Callback)
    Callback(vSERVER.SetBuyerValue(Data["buyerValue"]))
end)
RegisterNUICallback("factionTradeConfirm", function(_, Callback)
    Callback(vSERVER.Confirm())
end)
RegisterNUICallback("factionTradeCancel", function(_, Callback)
    Callback(vSERVER.Cancel())
end)
RegisterNUICallback("factionTradeReject", function(_, Callback)
    Callback(vSERVER.Reject())
end)
