local gAffiliateWorldShortcutsVisible = false

local gAffiliateWorldShortcuts = {
    { key = "J", labelKey = "afiliado.shortcuts.catalog" },
    { key = "U", labelKey = "afiliado.shortcuts.call" },
    { key = "O", labelKey = "afiliado.shortcuts.exit" },
}

---@param visible boolean
local function SetAffiliateWorldShortcutsVisible(visible)
    gAffiliateWorldShortcutsVisible = visible == true

    SendNUIMessage({
        action = gAffiliateWorldShortcutsVisible and "openAfiliadoShortcuts" or "closeAfiliadoShortcuts",
        shortcuts = gAffiliateWorldShortcutsVisible and gAffiliateWorldShortcuts or nil,
    })

    TriggerEvent("hud:AffiliateWorldShortcutsVisibilityChanged", gAffiliateWorldShortcutsVisible)
end

exports("SetAffiliateWorldShortcutsVisible", SetAffiliateWorldShortcutsVisible)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() or not gAffiliateWorldShortcutsVisible then
        return
    end

    SetAffiliateWorldShortcutsVisible(false)
end)
