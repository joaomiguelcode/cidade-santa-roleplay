local messages = {
    [1] = 'user_wants_to_visit',
    [2] = 'user_refused_visit',
    [3] = 'user_accepted_visit',
    [4] = 'owner_rejected_user_visit',
    [5] = 'user_is_banned'
}

local addedSettings = {}
local penthouseInteractions = {}

local function validatePenthouseData(penthouse)
    return penthouse and penthouse.id
end

local function validateInteriorData(interior)
    return interior and interior.chests
end

local function coordToVec3(coord)
    return vec3(coord.x, coord.y, coord.z)
end

local function initializePenthouseInteractions(penthouseId)
    if not penthouseInteractions[penthouseId] then
        penthouseInteractions[penthouseId] = {
            cloakrooms = {},
            barber = {},
            tattoo = {},
            drinks = {},
            chests = {}
        }
    end
    return penthouseInteractions[penthouseId]
end

local function setupPenthouseShops(penthouse, interior)
    local penthouseId = penthouse.id
    local interactions = initializePenthouseInteractions(penthouseId)

    -- Cloakrooms
    if interior.cloakrooms then
        for index, coord in pairs(interior.cloakrooms) do
            if not interactions.cloakrooms[index] then
                local shopId = exports['skinshop']:AddSkinshop(
                    ('penthouse:%s:%s'):format(penthouseId, index),
                    coordToVec3(coord)
                )
                interactions.cloakrooms[index] = shopId
            end
        end
    end

    -- Barber
    if interior.barber then
        for index, coord in pairs(interior.barber) do
            if not interactions.barber[index] then
                local shopId = exports['character-creator']:AddBarbershop(
                    ('penthouse:%s:%s'):format(penthouseId, index),
                    coordToVec3(coord)
                )
                interactions.barber[index] = shopId
            end
        end
    end

    -- Tattoo
    if interior.tattoo then
        for index, coord in pairs(interior.tattoo) do
            if not interactions.tattoo[index] then
                exports['tattooshop']:AddTattooShop(
                    ('penthouse:%s:%s'):format(penthouseId, index),
                    coordToVec3(coord)
                )
                interactions.tattoo[index] = true
            end
        end
    end

    -- Drinks
    if interior.drinks then
        for index, coord in pairs(interior.drinks) do
            if not interactions.drinks[index] then
                exports['inventory']:AddShop('Bebidas', index, coordToVec3(coord))
                interactions.drinks[index] = true
            end
        end
    end
end

local function setupPenthouseChests(penthouse, interior)
    local penthouseId = penthouse.id
    local interactions = initializePenthouseInteractions(penthouseId)

    for key, chest in pairs(interior.chests) do
        if not interactions.chests[key] then
            local chestName = ('penthouse:%s:chest:%s'):format(penthouseId, key)
            local chestData = {
                ["Name"]   = chestName,
                ["Coords"] = tD(chest.coords.x) .. "," .. tD(chest.coords.y) .. "," .. tD(chest.coords.z),
                ["Weight"] = chest.weight,
                ["Mode"]   = "Penthouses",
                ["Owner"]  = penthouse.ownerId,
            }
            TriggerEvent('chest:Add', chestData)
            interactions.chests[key] = chestName
        end
    end
end

local function showSettingsTip()
    TriggerEvent('Notify', 'Attention',
        (translations[language]['tip_settings_command']):format(translations[language]['settings_command']), 5000)
end

local function setupOwnerFeatures(penthouse, interior)
    if penthouse.chestsCreated then return end
    if not interior.chests then return end

    setupPenthouseShops(penthouse, interior)
    setupPenthouseChests(penthouse, interior)
end

local function cleanupPenthouseInteractions(penthouseId)
    if not penthouseInteractions[penthouseId] then return end

    local interactions = penthouseInteractions[penthouseId]

    -- Remove Cloakrooms
    if interactions.cloakrooms then
        for _, shopId in pairs(interactions.cloakrooms) do
            exports['skinshop']:RemoveSkinshop(shopId)
        end
    end

    -- Remove Barber
    if interactions.barber then
        for _, shopId in pairs(interactions.barber) do
            exports['character-creator']:RemoveBarbershop(shopId)
        end
    end

    -- Remove Tattoo
    if interactions.tattoo then
        for index, _ in pairs(interactions.tattoo) do
            exports['tattooshop']:RemoveTattooShop(('penthouse:%s:%s'):format(penthouseId, index))
        end
    end

    -- Remove Drinks
    if interactions.drinks then
        for index in pairs(interactions.drinks) do
            exports['inventory']:RemoveShop('Bebidas', index)
        end
    end

    -- Remove Chests
    if interactions.chests then
        for _, chestName in pairs(interactions.chests) do
            exports['inventory']:RemoveChest(chestName)
        end
    end

    penthouseInteractions[penthouseId] = nil
end

RegisterNetEvent('penthouse.client:ringDoorbell', function(type, penthouse)
    TriggerEvent('Notify', 'Warning', translations[language]['ring_doorbell'][messages[type]], 5000)
end)

RegisterNetEvent('penthouse.client:enterPenthouse', function(penthouse, is_owner)
    if not validatePenthouseData(penthouse) then return end

    penthouse.isOwner = is_owner

    PenthouseManager:setInsidePenthouse(penthouse)

    if not is_owner then return end

    local interior = config.interiors[penthouse.interior]
    if not validateInteriorData(interior) then return end

    showSettingsTip()
    setupOwnerFeatures(penthouse, interior)
end)

---@param disableRestorePosition boolean
RegisterNetEvent('penthouse.client:leavePenthouse', function(disableRestorePosition)
    if PenthouseManager:isInsidePenthouse() then
        local penthouseId = PenthouseManager:getCurrentPenthouseId()
        if penthouseId then
            cleanupPenthouseInteractions(penthouseId)
        end
    end

    if not PenthouseManager or not PenthouseManager.insideHouseData then return end

    local insideHouseData = PenthouseManager.insideHouseData
    local ped = PlayerPedId()
    local oldCoords = insideHouseData.oldCoords

    if not oldCoords then return end

    local x, y, z = oldCoords.x, oldCoords.y, oldCoords.z
    DoScreenFadeOut(500)
    Wait(500)

    if not disableRestorePosition then
        SetEntityCoords(ped, x, y, z)
    end

    if insideHouseData.interior then
        insideHouseData.interior:unload()
    end

    PenthouseManager.insideHouseData = {}

    Wait(500)
    DoScreenFadeIn(500)
end)

RegisterNetEvent('penthouse.client:callHelpAccepted', function(name, passport)
    SendNUIMessage({
        action = "PENTHOUSE_CALLHELPINFOS",
        data = {
            step = 3,
            helper_info = {
                name = name,
                passport = passport
            }
        }
    })
end)

RegisterNetEvent('penthouse.client:useWallpaperItem', function(color)
    local penthouse = PenthouseManager:getCurrentPenthouse()

    if not penthouse then return end
    if not color then return end

    vSERVER.updatePenthouseColor({
        houseId  = penthouse.id,
        interior = penthouse.interior,
        tier     = 1,
        color    = color
    })
end)

RegisterNetEvent('penthouse.client:applyWallpaperColor', function(interior, tier, color)
    local interior = interiors(interior, tier)
    interior:setColor(color)
end)

RegisterNetEvent('penthouse.client:kickedVisitor', function()
    TriggerEvent('Notify', 'Warning', translations[language]['kicked_visitor'], 5000)
end)

RegisterNetEvent('penthouse.client:bannedUser', function()
    TriggerEvent('Notify', 'Warning', translations[language]['you_have_been_banned'], 5000)
end)
