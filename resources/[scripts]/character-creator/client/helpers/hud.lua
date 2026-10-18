Hud = {}

---@param visible boolean
function Hud.setVisible(visible)
    TriggerEvent("hud:setHudStatus", visible)
    TriggerEvent("hud:Active",visible)
end