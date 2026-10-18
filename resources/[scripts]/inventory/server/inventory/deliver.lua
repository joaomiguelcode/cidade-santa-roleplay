-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER SYSTEM (SERVER)
-----------------------------------------------------------------------------------------------------------------------------------------
local deliverRewards = {
    ["BurgerShot"] = { item = "dollars", amount = { 350, 500 } },
    ["PizzaThis"] = { item = "dollars", amount = { 350, 500 } },
    ["UwuCoffee"] = { item = "dollars", amount = { 350, 500 } },
    ["BeanMachine"] = { item = "dollars", amount = { 350, 500 } },
    ["Lumberman"] = { item = "dollars", amount = { 600, 850 } },
    ["Drugsmansouth"] = { item = "dollars", amount = { 1200, 1800 } },
    ["Drugsmannorth"] = { item = "dollars", amount = { 1200, 1800 } }
}

vRPserver = Inventory or {}
function Inventory.DeliverNew(Locate)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport then return end

    local cfg = deliverRewards[Locate]
    if cfg then
        local reward = math.random(cfg.amount[1], cfg.amount[2])
        vRP.GiveItem(Passport, cfg.item, reward, true)
        TriggerClientEvent("Notify2", source, "#entregouSucesso")
        vCLIENT.Update(source)
    end
end
