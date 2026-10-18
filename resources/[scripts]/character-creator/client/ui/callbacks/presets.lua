---Aplica a skinshop baseado no contexto (criação ou edição)
---@param currentModel number Modelo atual do personagem
---@param applyAppearance boolean?
local function ApplySkinshop(currentModel, applyAppearance)
    local customization = GetCustomizationPreset(currentModel) or {}
    local skinshop = customization.skinshop

    -- Se for criação, sempre aplica a skinshop padrão
    if (gCreationState.flag & eCharacterCreatorCreationState.CREATING) ~= 0 then
        if skinshop then
            TriggerEvent('skinshop:Apply', skinshop)

            Wait(100)

            Customizator.RemoveShoes()
            Customizator.RemoveComponents()
        end
        return
    end

    -- Se for edição
    -- Se o modelo atual é igual ao original, volta com a roupa antiga
    -- Se mudou de modelo, aplica a skinshop padrão
    if currentModel == gCreationState.userModelHash then
        if next(gCreationState.clothes) then
            TriggerEvent('skinshop:Apply', gCreationState.clothes)
        end

        if applyAppearance then
            Customizator.ApplyFromData(gCreationState.appearance)
        end
    else
        if skinshop then
            TriggerEvent('skinshop:Apply', skinshop)
        end
    end

    Wait(100)

    Customizator.RemoveShoes()
    Customizator.RemoveComponents()
end

RegisterNUICallback('presets:list', function(data, callback)
    local presets = GetAppearancePresets()[GetGenderModel(data.gender)] or {}
    local list = {}

    for id, preset in ipairs(presets) do
        table.insert(list, { id = id, image = preset.image })
    end

    callback({ presets = list })
end)

---@param data {gender: 'F' | 'M', id: number}
RegisterNUICallback('preset:select', function(data, callback)
    local customizations = GetAppearancePresets()[GetGenderModel(data.gender)]

    if not customizations then
        return callback(false)
    end

    ---@type character-creator.PresetAppearance
    local customization = customizations[data.id]

    if not customization then
        return callback(false)
    end

    local model = GetGenderModel(data.gender)

    Customizator.ChangeGender(model)
    Customizator.ApplyFromData(ImportLegacyAppearance(customization.preset))

    ApplySkinshop(model)
    ResetPlayerPosition()

    SendCustomizationToUI(gCustomization)
    gLastPresetData = data
    SuspectSystem.addPresetSelectScore()
    callback(true)
end)

RegisterNUICallback('preset:randomize', function(data, callback)
    local gender = GetGenderModel(data.gender)
    local customization = Customizator.RandomizeFromPresets(gender)

    Customizator.ApplyFromData(customization)
    SendCustomizationToUI(gCustomization)

    SuspectSystem.addPresetRandomizeScore()
    callback(true)
end)


---@param data {value: 'F' | 'M'}
RegisterNUICallback('changeGender', function(data, callback)
    local gender = GetGenderModel(data.value)
    local customization = (GetCustomizationPreset(gender) or {})

    Customizator.ChangeGender(gender)

    if gLastPresetData and gLastPresetData.gender == data.value then
        local customizations = GetAppearancePresets()[gender]
        if customizations then
            local customizationData = customizations[gLastPresetData.id]
            if customizationData then
                Customizator.ApplyFromData(ImportLegacyAppearance(customizationData.preset))
            end
        end
    elseif customization.barbershop then
        Customizator.ApplyFromData(ImportLegacyAppearance(customization.barbershop))
    end
    
    ApplySkinshop(gender, true)
    ResetPlayerPosition()
    SendCustomizationToUI(gCustomization)
    
    Customizator.RemoveShoes()
    Customizator.RemoveComponents()

    SuspectSystem.addChangeGenderScore()
    callback(true)
end)

RegisterNUICallback('appearance:importCode', function(data, callback)
    local status, code = pcall(json.decode, data.code)

    if not status then
        return callback(false)
    end

    local model = code.model
    local appearance = code.customization

    Customizator.ChangeGender(model)
    Customizator.ApplyFromData(ImportLegacyAppearance(appearance))

    ApplySkinshop(model)
    SendCustomizationToUI(gCustomization)
    ResetPlayerPosition()

    Customizator.RemoveShoes()
    Customizator.RemoveComponents()

    if not gCreationState.hasAlreadyImportedAppearance then
        SuspectSystem.addImportCodeScore()
    end

    gCreationState.hasAlreadyImportedAppearance = true
    callback(true)
end)
