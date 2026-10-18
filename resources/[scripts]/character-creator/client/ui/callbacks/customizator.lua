RegisterNUICallback('genetic', function(data, callback)
    ---@diagnostic disable-next-line: missing-fields
    Customizator.SetHeadBlendData({ [data.key] = data.value })

    SuspectSystem.addGeneticScore(data.key)

    callback(true)
end)

RegisterNUICallback('overlays', function(data, callback)
    callback(true)

    local nameOverlay = data.key:split(':')[1]
    local overlayId = eCharacterCreatorOverlays[nameOverlay]
    local dataOverlay = (gCustomization.OVERLAYS or {})[overlayId] or {}

    
    if data.key:find('COLOR') then
        SuspectSystem.addOverlayScore(nameOverlay)
        return Customizator.SetOverlayColor(overlayId, 2, data.value, 0)
    end
    
    if data.key:find('OPACITY') then
        SuspectSystem.addOverlayScore(nameOverlay)
        return Customizator.SetOverlay(overlayId, dataOverlay.index or 255, data.value + 0.0)
    end

    local sendToUi = false

    if dataOverlay.index and (dataOverlay.index == -1 or dataOverlay.index == 0) and data.value >= 0 then
        dataOverlay.opacity = 1.0
        sendToUi = true
    end
    
    Customizator.SetOverlay(overlayId, data.value, dataOverlay.opacity or 1.0)
    SuspectSystem.addOverlayScore(nameOverlay)

    if sendToUi then
        SendCustomizationToUI(gCustomization)
    end
end)

RegisterNUICallback('eyeFeatures', function(data, callback)
    Customizator.SetPedEyeColor(data.value)
    SuspectSystem.addEyeColorScore()
    callback(true)
end)

RegisterNUICallback('faceFeatures', function(data, callback)
    local faceFeatureId = eCharacterCreatorFaceFeatures[data.key]

    Customizator.SetFaceFeatures(faceFeatureId, data.value + 0.0)
    SuspectSystem.addFaceFeatureScore(data.key)
    callback(true)
end)

RegisterNUICallback('componentVariations', function(data, callback)
    local nameComponent = data.key:split(':')[1]
    local componentId = eCharacterCreatorComponentVariations[nameComponent]

    if not (nameComponent and componentId) then
        return callback(false)
    end

    callback(true)

    local component = (gCustomization.COMPONENT_VARIATIONS or {})[componentId] or {}
    local drawableId = component.drawableId or 0
    local textureId = component.textureId or 0
    local paletteId = component.paletteId or 0

    if data.key:find('COLOR') then
        SuspectSystem.addComponentScore(nameComponent)
        return Customizator.SetComponentVariation(componentId, drawableId, data.value, paletteId)
    end

    Customizator.SetComponentVariation(componentId, data.value, textureId, paletteId)
    SuspectSystem.addComponentScore(nameComponent)
end)

RegisterNUICallback('changeHair', function(data, callback)
    callback(true)

    local hairColor = gCustomization.HAIR_COLOR or {}
    local currentColor = hairColor.colorId or 0
    local currentSecondaryColor = hairColor.highlightColorId or 0

    if data.key:find('COLOR') then
        SuspectSystem.addHairScore()
        return Customizator.SetPedHairTint({ colorId = data.value, highlightColorId = currentSecondaryColor })
    end

    if data.key:find('HAIR_SECONDARY') then
        SuspectSystem.addHairScore()
        return Customizator.SetPedHairTint({ colorId = currentColor, highlightColorId = data.value })
    end

    Customizator.SetComponentVariation(eCharacterCreatorComponentVariations.HAIR, data.value)
    SuspectSystem.addHairScore()
end)

RegisterNUICallback('appearance:getExportCode', function(data, callback)
    local customization = ExportLegacyAppearance(gCustomization)
    local model = GetEntityModel(PlayerPedId())

    callback(json.encode({ model = model, customization = customization }))
end)
