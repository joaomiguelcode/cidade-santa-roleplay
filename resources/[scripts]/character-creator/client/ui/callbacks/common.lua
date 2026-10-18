---@type character-creator.CustomizationData
gCustomization = {}

RegisterNUICallback("getCityName", function(data, callback)
    callback(string.lower(CITY_NAME))
end)

RegisterNUICallback('get-game-parents', function(data, callback)
    callback(GAME_PARENTS_CHARACTER_CREATOR)
end)

RegisterNUICallback('colors', function(data, callback)
    callback({ colors = PALETTE_COLORS[data.type] })
end)

RegisterNUICallback("rotate", function(orientation, callback)
    if Camera.isLerpingTransition() then
        return callback(false)
    end

    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)

    if orientation < 0 then
        heading = heading - 4.0
    else
        heading = heading + 4.0
    end

    SetEntityHeading(ped, heading)
    callback(true)
end)

---@param location string
RegisterNUICallback("getInputLimits", function(location, callback)
    local ped = PlayerPedId()
    local overlayId = eCharacterCreatorOverlays[location]
    local componentId = eCharacterCreatorComponentVariations[location]

    if not (componentId or overlayId) then
        return callback({ -1, -1 })
    end

    if overlayId then
        return callback({ -1, GetNumHeadOverlayValues(overlayId) })
    end

    return callback({ -1, GetNumberOfPedDrawableVariations(ped, componentId) - 1 })
end)

---@param data {gender: 'female' | 'male'}
RegisterNUICallback('getParents', function(data, callback)
    callback(GAME_PARENTS_CHARACTER_CREATOR)
end)

RegisterNUICallback('colors', function(data, callback)
    callback({ colors = PALETTE_COLORS[data.type] })
end)

RegisterNUICallback('creator:loadConfig', function(data, callback)
    local ramoTitle = nil
    local ramoDescription = nil
    local ramoSelect = nil
    local ramoConfirmDesc = nil
    local ramoYes = nil
    local ramoNo = nil
    if CREATOR_CONFIG.RAMO_TITLE[CITY_NAME] then
        ramoTitle = CREATOR_CONFIG.RAMO_TITLE[CITY_NAME].title
        ramoDescription = CREATOR_CONFIG.RAMO_TITLE[CITY_NAME].description
        ramoSelect = CREATOR_CONFIG.RAMO_TITLE[CITY_NAME].select
        ramoConfirmDesc = CREATOR_CONFIG.RAMO_TITLE[CITY_NAME].confirmDescription
        ramoYes = CREATOR_CONFIG.RAMO_TITLE[CITY_NAME].yes
        ramoNo = CREATOR_CONFIG.RAMO_TITLE[CITY_NAME].no
    end
    local recommendations = gCollectPlayerData and exports.register:getRecommendation(CITY_NAME) or nil
    local recommendationKeys = gCollectPlayerData and exports.register:getRecommendationTranslationKeys(CITY_NAME) or nil
    local socialMedia = gCollectPlayerData and exports.register:getSocialMedia(CITY_NAME) or nil

    local config = {
        flags = CreatorFeatures[gCreationState.flag],
        type = GetCreationStateFlagName(),
        ramos = CREATOR_CONFIG.CITIES_RAMO[CITY_NAME],
        oldBoy = CREATOR_CONFIG.OLD_BOY[CITY_NAME],
        ramoTitle = ramoTitle,
        ramoDesc = ramoDescription,
        ramoSelect = ramoSelect,
        ramoConfirmDesc = ramoConfirmDesc,
        ramoYes = ramoYes,
        ramoNo = ramoNo,
        isFirst = gIsFirst,
        showRamoInline = false,
        recommendationOptions = recommendations,
        recommendationKeys = recommendationKeys,
        socialMediaOptions = socialMedia,
        showRegister = gCollectPlayerData,
    }

    print('config', json.encode(config))

    callback(config)
end)

RegisterNUICallback('appearance:copyCode', function(text, callback)
    lib.setClipboard(text)
    callback(true)
end)
