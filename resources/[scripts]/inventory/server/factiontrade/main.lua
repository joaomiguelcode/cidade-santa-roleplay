-----------------------------------------------------------------------------------------------------------------------------------------
-- FACTION TRADE (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

local Creative = {}
Tunnel.bindInterface("inventory/factiontrade", Creative)

local activeTrades = {}

function Creative.RequestSession()
    return { ok = true, revision = 1, items = {} }
end

function Creative.OfferItem(fromSlot, amount, targetSlot)
    return { ok = true }
end

function Creative.MoveOfferItem(fromSlot, targetSlot)
    return { ok = true }
end

function Creative.ReturnItemToChest(offerSlot, targetSlot, amount)
    return { ok = true }
end

function Creative.RemoveItem(slot)
    return { ok = true }
end

function Creative.SetPrice(price)
    return { ok = true }
end

function Creative.SetPartnership(hasPartnership)
    return { ok = true }
end

function Creative.SetBuyerValue(buyerValue)
    return { ok = true }
end

function Creative.Confirm()
    return { ok = true }
end

function Creative.Cancel()
    return { ok = true }
end

function Creative.Reject()
    return { ok = true }
end
