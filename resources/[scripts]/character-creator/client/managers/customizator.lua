Customizator = {}

---@param data character-creator.HairColor
---@param ped number?
function Customizator.SetPedHairTint(data, ped)
    gCustomization.HAIR_COLOR = data

    SetPedHairColor(ped or PlayerPedId(), data.colorId, data.highlightColorId)
end

---@param index integer
---@param ped number?
function Customizator.SetPedEyeColor(index, ped)
    gCustomization.EYE_COLOR = index
    SetPedEyeColor(ped or PlayerPedId(), index)
end

---@param data character-creator.HeadBlendData
---@param ped number?
function Customizator.SetHeadBlendData(data, ped)
    gCustomization.HEAD_BLEND_DATA = gCustomization.HEAD_BLEND_DATA or {}

    gCustomization.HEAD_BLEND_DATA.shapeFirstID = data.shapeFirstID or gCustomization.HEAD_BLEND_DATA.shapeFirstID or 0
    gCustomization.HEAD_BLEND_DATA.shapeSecondID = data.shapeSecondID or gCustomization.HEAD_BLEND_DATA.shapeSecondID or
        0
    gCustomization.HEAD_BLEND_DATA.shapeThirdID = data.shapeThirdID or gCustomization.HEAD_BLEND_DATA.shapeThirdID or 0
    gCustomization.HEAD_BLEND_DATA.skinFirstID = data.skinFirstID or gCustomization.HEAD_BLEND_DATA.skinFirstID or 0
    gCustomization.HEAD_BLEND_DATA.skinSecondID = data.skinSecondID or gCustomization.HEAD_BLEND_DATA.skinSecondID or 0
    gCustomization.HEAD_BLEND_DATA.skinThirdID = data.skinThirdID or gCustomization.HEAD_BLEND_DATA.skinThirdID or 0
    gCustomization.HEAD_BLEND_DATA.isParent = data.isParent or gCustomization.HEAD_BLEND_DATA.isParent or false

    gCustomization.HEAD_BLEND_DATA.thirdMix = (data.thirdMix or gCustomization.HEAD_BLEND_DATA.thirdMix or 0.0) + 0.0
    gCustomization.HEAD_BLEND_DATA.skinMix = (data.skinMix or gCustomization.HEAD_BLEND_DATA.skinMix or 0.0) + 0.0
    gCustomization.HEAD_BLEND_DATA.shapeMix = (data.shapeMix or gCustomization.HEAD_BLEND_DATA.shapeMix or 0.0) + 0.0

    SetPedHeadBlendData(ped or PlayerPedId(),
        gCustomization.HEAD_BLEND_DATA.shapeFirstID,
        gCustomization.HEAD_BLEND_DATA.shapeSecondID,
        gCustomization.HEAD_BLEND_DATA.shapeThirdID,
        gCustomization.HEAD_BLEND_DATA.skinFirstID,
        gCustomization.HEAD_BLEND_DATA.skinSecondID,
        gCustomization.HEAD_BLEND_DATA.skinThirdID,
        gCustomization.HEAD_BLEND_DATA.shapeMix,
        gCustomization.HEAD_BLEND_DATA.skinMix,
        gCustomization.HEAD_BLEND_DATA.thirdMix,
        gCustomization.HEAD_BLEND_DATA.isParent
    )
end

---@param index character-creator.EnumFaceFeatures
---@param scale integer
---@param ped number?
function Customizator.SetFaceFeatures(index, scale, ped)
    gCustomization.FACE_FEATURES = gCustomization.FACE_FEATURES or {}
    gCustomization.FACE_FEATURES[index] = scale
    SetPedFaceFeature(ped or PlayerPedId(), index, scale)
end

---@param overlayId character-creator.EnumFaceFeatures
---@param index integer
---@param opacity number
---@param ped number?
function Customizator.SetOverlay(overlayId, index, opacity, ped)
    gCustomization.OVERLAYS = gCustomization.OVERLAYS or {}
    gCustomization.OVERLAYS[overlayId] = { index = index, opacity = opacity }

    SetPedHeadOverlay(ped or PlayerPedId(), overlayId, index, opacity)
end

---@param overlayId character-creator.EnumOverlays
---@param colorType integer
---@param colorId integer
---@param secondColorId integer
---@param ped number?
function Customizator.SetOverlayColor(overlayId, colorType, colorId, secondColorId, ped)
    secondColorId = colorId -- feito assim pois não usamos a cor secundária para overlay's e quando deixa as duas iguais fica melhor visualmente (mais forte a cor).

    gCustomization.OVERLAY_COLORS = gCustomization.OVERLAY_COLORS or {}
    gCustomization.OVERLAY_COLORS[overlayId] = { colorType = colorType, colorId = colorId, secondColorId = secondColorId }

    SetPedHeadOverlayColor(ped or PlayerPedId(), overlayId, DICT_COLORS_OVERLAYS[overlayId] or 0, colorId, secondColorId)
end

---@param componentId  character-creator.EnumComponentVariations
---@param drawableId integer
---@param textureId integer?
---@param paletteId integer?
---@param ped number?
function Customizator.SetComponentVariation(componentId, drawableId, textureId, paletteId, ped)
    gCustomization.COMPONENT_VARIATIONS = gCustomization.COMPONENT_VARIATIONS or {}
    gCustomization.COMPONENT_VARIATIONS[componentId] = {
        drawableId = drawableId,
        textureId = 0,
        paletteId = 0
    }
    SetPedComponentVariation(ped or PlayerPedId(), componentId, drawableId, 0, 0)
end

---Randomiza aparência misturando atributos de diferentes presets (igual ao barbershop)
---@param gender number Model do ped (`mp_m_freemode_01` ou `mp_f_freemode_01`)
---@return character-creator.CustomizationData
function Customizator.RandomizeFromPresets(gender)
    local presets = GetAppearancePresets()[gender]

    -- Helper para pegar atributo aleatório de um preset aleatório
    local function getRandomAttribute(attributeIndex)
        local randomPreset = presets[math.random(1, #presets)].preset
        return randomPreset[attributeIndex] or 0
    end

    -- 🎲 Mix and match de diferentes presets!
    local mixedBarber = {}

    -- Índices 1-27 (head blend, overlays, hair)
    for i = 1, 27 do
        mixedBarber[i] = getRandomAttribute(i)
    end

    -- Índices 28-47 (face features)
    for i = 28, 47 do
        mixedBarber[i] = getRandomAttribute(i)
    end

    -- Índices 48-51 (chest hair)
    for i = 48, 51 do
        mixedBarber[i] = getRandomAttribute(i)
    end

    -- Converte o array mixed para customization
    return ImportLegacyAppearance(mixedBarber)
end

---Aplica uma aparência ao personagem
---@param data character-creator.CustomizationData
---@param ped number?
function Customizator.ApplyFromData(data, ped)
    gCustomization = {}

    ped = ped or PlayerPedId()

    for i = 0, 12 do
        SetPedHeadOverlay(ped, i, 0, 255)
    end

    -- 🧬 Aplicar head blend primeiro
    if data.HEAD_BLEND_DATA then
        Customizator.SetHeadBlendData(data.HEAD_BLEND_DATA, ped)
    end

    -- 👁️ Aplicar cor dos olhos
    if data.EYE_COLOR then
        SetPedEyeColor(ped, data.EYE_COLOR)
    end

    for componentId, componentData in pairs(data.COMPONENT_VARIATIONS or {}) do
        Customizator.SetComponentVariation(componentId, componentData.drawableId, componentData.textureId,
            componentData.paletteId, ped)
    end

    if data.HAIR_COLOR then
        Customizator.SetPedHairTint(data.HAIR_COLOR, ped)
    end

    for overlayId, overlayData in pairs(data.OVERLAYS or {}) do
        Customizator.SetOverlay(overlayId, overlayData.index, overlayData.opacity, ped)
    end

    for overlayId, colorData in pairs(data.OVERLAY_COLORS or {}) do
        Customizator.SetOverlayColor(overlayId, colorData.colorType, colorData.colorId, colorData.secondColorId, ped)
    end

    for featureId, scale in pairs(data.FACE_FEATURES or {}) do
        Customizator.SetFaceFeatures(featureId, scale, ped)
    end
end

local function GetMaxHealth()
    local health = GetEntityHealth(PlayerPedId())

    if not next(gCreationState) then
        return health
    end

    if (gCreationState.flag & eCharacterCreatorCreationState.CREATING) ~= 0 then
        return CREATOR_CONFIG.MAX_HEALTH
    end

    return health
end

-- ponytail: debug temporário CTD DecibelSpawn (ver new_spawn/client/native_debug.lua); remover quando identificado
local nsdbgCity = GetConvar('cityName', '')
local nsdbg = (nsdbgCity == 'Fronteira' or nsdbgCity == 'Krown') and GetConvar('newspawn_debug', '1') ~= '0'

---@param model number
function Customizator.ChangeGender(model)
    local armour = GetPedArmour(PlayerPedId())
    local health = GetMaxHealth()

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(100)
    end

    if nsdbg then
        sx.logger:debug(('[nsdbg] ChangeGender SetPlayerModel model=%s pedBefore=%s'):format(model, PlayerPedId()))
    end
    SetPlayerModel(PlayerId(), model)
    if nsdbg then
        sx.logger:debug(('[nsdbg] ChangeGender SetPlayerModel done pedAfter=%s'):format(PlayerPedId()))
    end
    SetPedDefaultComponentVariation(PlayerPedId())

    SetPedArmour(PlayerPedId(), armour)
    SetEntityHealth(PlayerPedId(), health)

    if not next(gCreationState) then
        return
    end

    local tattoos = model == gCreationState.userModelHash and gCreationState.tattoos or {}
    exports["tattooshop"]:Apply(tattoos)
end

local REMOVE_MALE_SHOES = 34
local REMOVE_FEMALE_SHOES = 35

function Customizator.RemoveShoes()
    SetPedComponentVariation(PlayerPedId(), 6, GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") and REMOVE_MALE_SHOES or REMOVE_FEMALE_SHOES, 0, 0)
end

function Customizator.RemoveComponents()
    local ped = PlayerPedId()

    ClearPedProp(ped, 1)
    ClearPedProp(ped, 0)
end