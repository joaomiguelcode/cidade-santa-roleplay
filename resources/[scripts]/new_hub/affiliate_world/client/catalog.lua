RegisterNUICallback("afiliadoCatalog.getVisibleCategories", function(_, callback)
    local categories = GetAffiliateWorldVisibleCategoryIds()
    categories[#categories + 1] = "vips"
    categories[#categories + 1] = "bundles"

    callback({
        categories = categories,
    })
end)

RegisterNUICallback("afiliadoCatalog.getBundles", function(_, callback)
    callback(vSERVER.GetAffiliateWorldBundles() or { items = {} })
end)

RegisterNUICallback("afiliadoCatalog.getPreferences", function(_, callback)
    local response = vSERVER.GetAffiliateWorldCatalogPreferences()
    callback(response or { success = false })
end)

RegisterNUICallback("afiliadoCatalog.watchPopularity", function(data, callback)
    local enabled = type(data) == "table" and data.enabled or false
    callback(vSERVER.WatchAffiliateWorldPopularity(enabled) or { success = false })
end)

RegisterNetEvent("new_hub:affiliatePopularity", function(snapshot)
    SendNUIMessage({ action = "afiliadoPopularityUpdated", data = snapshot })
end)

RegisterNUICallback("afiliadoCatalog.setFavorite", function(data, callback)
    if type(data) ~= "table" then callback({ success = false }) return end
    local response = vSERVER.SetAffiliateWorldFavorite(data.favoriteId, data.productId, data.reference, data.selected)
    callback(response or { success = false })
end)

RegisterNUICallback("afiliadoCatalog.getWeaponSkinSpawns", function(_, callback)
    callback({
        weaponSkinSpawns = AFFILIATE_WORLD_CONFIG.WEAPONS_SKINS,
    })
end)

RegisterNUICallback("afiliadoTestProduct", function(data, callback)
    local productId = type(data) == "table" and data.productId or nil
    local reference = type(data) == "table" and data.reference or nil
    local state = type(data) == "table" and data.state or nil
    local includedId = type(data) == "table" and data.includedId or nil
    local response = vSERVER.RequestAffiliateWorldProduct(productId, reference, state, includedId)

    callback(response or { success = false, message = _t("affiliate_world_action_failed") })
end)

RegisterNUICallback("afiliadoPurchaseIntent", function(data, callback)
    local productId = type(data) == "table" and data.productId or nil
    local response = vSERVER.RegisterAffiliateWorldPurchaseIntent(productId)

    callback(response or { success = false })
end)

RegisterNUICallback("afiliadoBuyProduct", function(data, callback)
    local response = vSERVER.BuyAffiliateWorldProduct(data.id)

    callback(response or { success = false, message = _t("affiliate_world_purchase_failed") })
end)

RegisterNUICallback("afiliadoCallAffiliate", function(_, callback)
    local resp = RequestAffiliateWorldStaffCall(false)

    if gAffiliateWorldClientState.callModalOpen then
        CloseAffiliateWorldPresentation()
    end

    callback(resp)
end)

RegisterNUICallback("afiliadoInvitePlayer", function(data, callback)
    local playerId = type(data) == "table" and tonumber(data.playerId) or nil
    local response = vSERVER.InviteAffiliateWorldPlayer(playerId)

    callback(response or { success = false, message = _t("affiliate_world_invite_unavailable") })
end)

RegisterNUICallback("afiliadoCancelCall", function(_, callback)
    local response = vSERVER.CancelAffiliateWorldStaffCall()

    if not response or response.success ~= true then
        NotifyAffiliateWorldClient(response and response.message or _t("affiliate_world_action_failed"), "Warning")
    end

    if gAffiliateWorldClientState.callModalOpen then
        CloseAffiliateWorldPresentation()
    end

    callback(response or { success = false, message = _t("affiliate_world_action_failed") })
end)

RegisterNUICallback("closeAfiliadoCatalog", function(_, callback)
    if gAffiliateWorldClientState.callModalOpen then
        CloseAffiliateWorldPresentation()
    else
        SetNuiFocus(false, false)
    end

    callback({})
end)

RegisterNUICallback("afiliadoOnboardingDone", function(_, callback)
    FinishAffiliateWorldOnboarding()
    callback({})
end)
