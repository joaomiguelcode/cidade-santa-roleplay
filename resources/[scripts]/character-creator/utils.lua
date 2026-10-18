local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

CITY_NAME = GetConvar("cityName", "")
LANGUAGE = GetConvar("language", "pt-br") or "pt-br"
KEY_STATE_CUSTOMIZATION = 'Character'

---@param x number
---@param min number
---@param max number
---@return number
function math.clamp(x, min, max)
    -- Se x for NaN ou infinito, retorna min
    if x ~= x or x == math.huge or x == -math.huge then
        return min
    end
    return math.max(math.min(x, max), min)
end

---@param gender 'F' | 'M'
---@return number
function GetGenderModel(gender)
    return gender == 'F' and GetHashKey('mp_f_freemode_01') or GetHashKey('mp_m_freemode_01')
end

---@param hash number
function GetModelNameByHash(hash)
    return hash == GetHashKey('mp_f_freemode_01') and 'mp_f_freemode_01' or 'mp_m_freemode_01'
end

function string:split(delimiter)
    local result               = {}
    local from                 = 1
    local delim_from, delim_to = string.find(self, delimiter, from)
    while delim_from do
        table.insert(result, string.sub(self, from, delim_from - 1))
        from                 = delim_to + 1
        delim_from, delim_to = string.find(self, delimiter, from)
    end
    table.insert(result, string.sub(self, from))
    return result
end

local Fathers = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 42, 43, 44 }
local Mothers = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 45 }

local function FindParentIndex(gtaId, list)
    for k, v in pairs(list) do
        if v == gtaId then
            return k - 1 -- Retorna k-1 porque Barber usa índice base 0
        end
    end
    return 0
end

---Exporta a aparência atual para o formato legado (compatibilidade com sistemas antigos)
---@param customization character-creator.CustomizationData?
---@return table Array no formato antigo (índices 1-51+)
function ExportLegacyAppearance(customization)
    customization = customization or gCustomization
    local data = {}

    -- Helper para extrair valores com fallback
    local function get(table, key, default)
        return (table or {})[key] or default
    end

    -- Helper para extrair overlay
    local function getOverlay(overlayId, property, default)
        return get(get(customization.OVERLAYS, overlayId), property, default)
    end

    -- Helper para extrair cor de overlay
    local function getOverlayColor(overlayId, property, default)
        return get(get(customization.OVERLAY_COLORS, overlayId), property, default)
    end

    -- Helper para extrair face feature
    local function getFaceFeature(featureId, default)
        return get(customization.FACE_FEATURES, featureId, default or 0.0)
    end

    -- 🧬 HEAD BLEND DATA (Herança e Genética)
    local hbd = customization.HEAD_BLEND_DATA or {}
    data[eBarbershopAppearance.SHAPE_FIRST_ID] = FindParentIndex(hbd.shapeFirstID or 0, Fathers)   -- Father
    data[eBarbershopAppearance.SHAPE_SECOND_ID] = FindParentIndex(hbd.shapeSecondID or 0, Mothers) -- Mother
    data[eBarbershopAppearance.SHAPE_MIX] = hbd.shapeMix or 0.0
    data[eBarbershopAppearance.SKIN_FIRST_ID] = hbd.skinFirstID or 0.0

    --- novas features de rosto
    data[eBarbershopAppearance.SHAPE_THIRD_ID] = hbd.shapeThirdID or 0
    data[eBarbershopAppearance.SKIN_SECOND_ID] = hbd.skinSecondID or 0
    data[eBarbershopAppearance.SKIN_THIRD_ID] = hbd.skinThirdID or 0
    data[eBarbershopAppearance.SKIN_MIX] = hbd.skinMix or 0.0
    data[eBarbershopAppearance.THIRD_MIX] = hbd.thirdMix or 0.0
    data[eBarbershopAppearance.IS_PARENT] = hbd.isParent or false

    --[[
        infelizmente foi criado novos index para ser possivel ter dois pais ou duas mães, ou um pai e mãe.
        criado novos index para não bugar o sistema de pai & mãe hardcoded.

        NEW_FATHER
        NEW_MOTHER
    ]]

    data[eBarbershopAppearance.NEW_FATHER] = hbd.shapeFirstID or 0
    data[eBarbershopAppearance.NEW_MOTHER] = hbd.shapeSecondID or 0

    -- 👁️ EYE COLOR
    data[eBarbershopAppearance.EYE_COLOR] = customization.EYE_COLOR or 0

    -- 💇 HAIR
    local hairComp = get(customization.COMPONENT_VARIATIONS, eCharacterCreatorComponentVariations.HAIR)
    data[eBarbershopAppearance.HAIR_DRAWABLE_ID] = get(hairComp, 'drawableId', 0) -- Hair Style
    data[eBarbershopAppearance.HAIR_COLOR_ID] = get(customization.HAIR_COLOR, 'colorId', 0)
    data[eBarbershopAppearance.HAIR_HIGHLIGHT_COLOR_ID] = get(customization.HAIR_COLOR, 'highlightColorId', 0)

    -- 🎭 OVERLAYS (apenas índices sem opacidade)
    data[eBarbershopAppearance.COMPLEXION_INDEX] = getOverlay(eCharacterCreatorOverlays.COMPLEXION, 'index', 255)
    data[eBarbershopAppearance.BLEMISHES_INDEX] = getOverlay(eCharacterCreatorOverlays.BLEMISHES, 'index', 255)
    data[eBarbershopAppearance.MOLES_FRECKLES_INDEX] = getOverlay(eCharacterCreatorOverlays.MOLES_FRECKLES, 'index', 255)
    data[eBarbershopAppearance.AGEING_INDEX] = getOverlay(eCharacterCreatorOverlays.AGEING, 'index', 255)

    -- 💄 MAKEUP (index + opacity + color)
    data[eBarbershopAppearance.MAKEUP_INDEX] = getOverlay(eCharacterCreatorOverlays.MAKEUP, 'index', 255)
    data[eBarbershopAppearance.MAKEUP_OPACITY] = getOverlay(eCharacterCreatorOverlays.MAKEUP, 'opacity', 0.0)
    data[eBarbershopAppearance.MAKEUP_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.MAKEUP, 'colorId', 0)

    -- 💋 LIPSTICK (index + opacity + color)
    data[eBarbershopAppearance.LIPSTICK_INDEX] = getOverlay(eCharacterCreatorOverlays.LIPSTICK, 'index', 255)
    data[eBarbershopAppearance.LIPSTICK_OPACITY] = getOverlay(eCharacterCreatorOverlays.LIPSTICK, 'opacity', 0.0)
    data[eBarbershopAppearance.LIPSTICK_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.LIPSTICK, 'colorId', 0)

    -- 👁️ EYEBROWS (index + opacity + color)
    data[eBarbershopAppearance.EYEBROWS_INDEX] = getOverlay(eCharacterCreatorOverlays.EYEBROWS, 'index', 255)
    data[eBarbershopAppearance.EYEBROWS_OPACITY] = getOverlay(eCharacterCreatorOverlays.EYEBROWS, 'opacity', 0.0)
    data[eBarbershopAppearance.EYEBROWS_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.EYEBROWS, 'colorId', 0)

    -- 🧔 FACIAL HAIR (index + opacity + color)
    data[eBarbershopAppearance.FACIAL_HAIR_INDEX] = getOverlay(eCharacterCreatorOverlays.FACIAL_HAIR, 'index', 255)
    data[eBarbershopAppearance.FACIAL_HAIR_OPACITY] = getOverlay(eCharacterCreatorOverlays.FACIAL_HAIR, 'opacity', 0.0)
    data[eBarbershopAppearance.FACIAL_HAIR_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.FACIAL_HAIR, 'colorId',
        0)

    -- 😊 BLUSH (index + opacity + color)
    data[eBarbershopAppearance.BLUSH_INDEX] = getOverlay(eCharacterCreatorOverlays.BLUSH, 'index', 255)
    data[eBarbershopAppearance.BLUSH_OPACITY] = getOverlay(eCharacterCreatorOverlays.BLUSH, 'opacity', 0.0)
    data[eBarbershopAppearance.BLUSH_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.BLUSH, 'colorId', 0)

    -- 👃 FACE FEATURES (Nose)
    data[eBarbershopAppearance.NOSE_WIDTH] = getFaceFeature(eCharacterCreatorFaceFeatures.NOSE_WIDTH)
    data[eBarbershopAppearance.NOSE_PEAK] = getFaceFeature(eCharacterCreatorFaceFeatures.NOSE_PEAK)
    data[eBarbershopAppearance.NOSE_LENGTH] = getFaceFeature(eCharacterCreatorFaceFeatures.NOSE_LENGTH)
    data[eBarbershopAppearance.NOSE_BONE_CURVENESS] = getFaceFeature(eCharacterCreatorFaceFeatures.NOSE_BONE_CURVENESS)
    data[eBarbershopAppearance.NOSE_TIP] = getFaceFeature(eCharacterCreatorFaceFeatures.NOSE_TIP)
    data[eBarbershopAppearance.NOSE_BONE_TWIST] = getFaceFeature(eCharacterCreatorFaceFeatures.NOSE_BONE_TWIST)

    -- 👁️ FACE FEATURES (Eyes & Eyebrows)
    data[eBarbershopAppearance.EYEBROW_DEPTH] = getFaceFeature(eCharacterCreatorFaceFeatures.EYEBROW_DEPTH)
    data[eBarbershopAppearance.EYEBROW_HEIGHT] = getFaceFeature(eCharacterCreatorFaceFeatures.EYEBROW_HEIGHT)
    data[eBarbershopAppearance.EYE_OPENING] = getFaceFeature(eCharacterCreatorFaceFeatures.EYE_OPENING)

    -- 😊 FACE FEATURES (Cheeks)
    data[eBarbershopAppearance.CHEEK_BONES_HEIGHT] = getFaceFeature(eCharacterCreatorFaceFeatures.CHEEK_BONES_HEIGHT)
    data[eBarbershopAppearance.CHEEK_BONES_WIDTH] = getFaceFeature(eCharacterCreatorFaceFeatures.CHEEK_BONES_WIDTH)
    data[eBarbershopAppearance.CHEEK_WIDTH] = getFaceFeature(eCharacterCreatorFaceFeatures.CHEEK_WIDTH)

    -- 😬 FACE FEATURES (Jaw & Chin)
    data[eBarbershopAppearance.JAW_BONE_SHAPE] = getFaceFeature(eCharacterCreatorFaceFeatures.JAW_BONE_SHAPE)
    data[eBarbershopAppearance.CHIN_HEIGHT] = getFaceFeature(eCharacterCreatorFaceFeatures.CHIN_HEIGHT)
    data[eBarbershopAppearance.CHIN_SHAPE] = getFaceFeature(eCharacterCreatorFaceFeatures.CHIN_SHAPE)
    data[eBarbershopAppearance.CHIN_LENGTH] = getFaceFeature(eCharacterCreatorFaceFeatures.CHIN_LENGTH)
    data[eBarbershopAppearance.CHIN_HOLE] = getFaceFeature(eCharacterCreatorFaceFeatures.CHIN_HOLE)
    data[eBarbershopAppearance.JAW_BONE_WIDTH] = getFaceFeature(eCharacterCreatorFaceFeatures.JAW_BONE_WIDTH)

    -- 💋 FACE FEATURES (Mouth & Neck)
    data[eBarbershopAppearance.LIP_THICKNESS] = getFaceFeature(eCharacterCreatorFaceFeatures.LIP_THICKNESS)
    data[eBarbershopAppearance.NECK_THICKNESS] = getFaceFeature(eCharacterCreatorFaceFeatures.NECK_THICKNESS)

    -- 💪 CHEST HAIR (index + opacity + color + secondColor)
    data[eBarbershopAppearance.CHEST_HAIR_INDEX] = getOverlay(eCharacterCreatorOverlays.CHEST_HAIR, 'index', 255)
    data[eBarbershopAppearance.CHEST_HAIR_OPACITY] = getOverlay(eCharacterCreatorOverlays.CHEST_HAIR, 'opacity', 0.0)
    data[eBarbershopAppearance.CHEST_HAIR_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.CHEST_HAIR, 'colorId', 0)
    data[eBarbershopAppearance.CHEST_HAIR_SECOND_COLOR_ID] = getOverlayColor(eCharacterCreatorOverlays.CHEST_HAIR,
        'secondColorId', 0)

    return data
end

---Importa uma aparência do formato legado (Barber Array) para o Character Creator
---@param data table Array no formato antigo (índices 1-51+)
---@return character-creator.CustomizationData
function ImportLegacyAppearance(data)
    --- infelizmente o barbershop funcionava assim antigamente
    for number = 1, 50 do 
        if not data[number] then
            data[number] = 0
        end
    end


    local customization = {}

    -- Helper para converter índice de parent (1-based) para ID nativo (0-based)
    local function getParentId(parentTable, index)
        return parentTable[index + 1] or 0
    end

    -- 🧬 HEAD BLEND DATA (Herança e Genética)
    local fatherIndex = data[eBarbershopAppearance.SHAPE_FIRST_ID]
    local motherIndex = data[eBarbershopAppearance.SHAPE_SECOND_ID]

    local skinFirstID = data[eBarbershopAppearance.SKIN_FIRST_ID] or 0
    local skinSecondID = data[eBarbershopAppearance.SKIN_SECOND_ID] or 0

    -- novas customizações
    local shapeMix = data[eBarbershopAppearance.SHAPE_MIX] or 0.0
    local skinMix = data[eBarbershopAppearance.SKIN_MIX] or 0.0
    local thirdMix = data[eBarbershopAppearance.THIRD_MIX] or 0.0
    local isParent = data[eBarbershopAppearance.IS_PARENT] or false
    local shapeThirdID = data[eBarbershopAppearance.SHAPE_THIRD_ID] or 0
    local skinThirdID = data[eBarbershopAppearance.SKIN_THIRD_ID] or 0

    --[[
        infelizmente foi criado novos index para ser possivel ter dois pais ou duas mães, ou um pai e mãe.
        criado novos index para não bugar o sistema de pai & mãe hardcoded.

        NEW_FATHER
        NEW_MOTHER
    ]]

    customization.HEAD_BLEND_DATA = {
        shapeFirstID = data[eBarbershopAppearance.NEW_FATHER] or getParentId(Fathers, fatherIndex),
        shapeSecondID = data[eBarbershopAppearance.NEW_MOTHER] or getParentId(Mothers, motherIndex),
        shapeThirdID = shapeThirdID,
        skinFirstID = skinFirstID,
        skinSecondID = skinSecondID,
        skinThirdID = skinThirdID,
        shapeMix = shapeMix,
        skinMix = skinMix,
        thirdMix = thirdMix,
        isParent = isParent
    }

    -- 👁️ EYE COLOR
    customization.EYE_COLOR = data[eBarbershopAppearance.EYE_COLOR] or 0

    -- 💇 HAIR
    customization.COMPONENT_VARIATIONS = {
        [eCharacterCreatorComponentVariations.HAIR] = {
            drawableId = data[eBarbershopAppearance.HAIR_DRAWABLE_ID] or 0,
            textureId = 0,
            paletteId = 0
        }
    }

    customization.HAIR_COLOR = {
        colorId = data[eBarbershopAppearance.HAIR_COLOR_ID] or 0,
        highlightColorId = data[eBarbershopAppearance.HAIR_HIGHLIGHT_COLOR_ID] or 0
    }

    -- 🎭 OVERLAYS & OVERLAY COLORS
    customization.OVERLAYS = {}
    customization.OVERLAY_COLORS = {}

    -- Helper unificado para adicionar overlay (com ou sem opacidade/cor)
    local function addOverlay(overlayEnum, indexKey, opacityKey, colorKey, colorType)
        local index = data[indexKey]

        customization.OVERLAYS[overlayEnum] = {
            index = index,
            opacity = opacityKey and (data[opacityKey] or 1.0) or 1.0
        }

        if colorKey then
            customization.OVERLAY_COLORS[overlayEnum] = {
                colorType = colorType or 1,
                colorId = data[colorKey] or 0,
                secondColorId = 0
            }
        end
    end

    -- Overlays simples (sem opacidade variável, sem cor)
    addOverlay(eCharacterCreatorOverlays.COMPLEXION, eBarbershopAppearance.COMPLEXION_INDEX)
    addOverlay(eCharacterCreatorOverlays.BLEMISHES, eBarbershopAppearance.BLEMISHES_INDEX)
    addOverlay(eCharacterCreatorOverlays.MOLES_FRECKLES, eBarbershopAppearance.MOLES_FRECKLES_INDEX)
    addOverlay(eCharacterCreatorOverlays.AGEING, eBarbershopAppearance.AGEING_INDEX)

    -- Overlays com opacidade + cor (colorType 1 = Hair Colors)
    addOverlay(eCharacterCreatorOverlays.EYEBROWS,
        eBarbershopAppearance.EYEBROWS_INDEX,
        eBarbershopAppearance.EYEBROWS_OPACITY,
        eBarbershopAppearance.EYEBROWS_COLOR_ID,
        1
    )

    addOverlay(eCharacterCreatorOverlays.FACIAL_HAIR,
        eBarbershopAppearance.FACIAL_HAIR_INDEX,
        eBarbershopAppearance.FACIAL_HAIR_OPACITY,
        eBarbershopAppearance.FACIAL_HAIR_COLOR_ID,
        1
    )

    -- Overlays com opacidade + cor (colorType 1 = Hair Colors - barbershop usa tudo como 1)
    addOverlay(eCharacterCreatorOverlays.MAKEUP,
        eBarbershopAppearance.MAKEUP_INDEX,
        eBarbershopAppearance.MAKEUP_OPACITY,
        eBarbershopAppearance.MAKEUP_COLOR_ID,
        1 -- ⚠️ Barbershop usa colorType 1 para tudo
    )

    addOverlay(eCharacterCreatorOverlays.LIPSTICK,
        eBarbershopAppearance.LIPSTICK_INDEX,
        eBarbershopAppearance.LIPSTICK_OPACITY,
        eBarbershopAppearance.LIPSTICK_COLOR_ID,
        1 -- ✅ Correção: barbershop usa colorType 1
    )

    addOverlay(eCharacterCreatorOverlays.BLUSH,
        eBarbershopAppearance.BLUSH_INDEX,
        eBarbershopAppearance.BLUSH_OPACITY,
        eBarbershopAppearance.BLUSH_COLOR_ID,
        1 -- ⚠️ Barbershop usa colorType 1 para tudo
    )

    -- 💪 Chest Hair (caso especial: tem secondColorId)
    local chestHairIndex = data[eBarbershopAppearance.CHEST_HAIR_INDEX]

    customization.OVERLAYS[eCharacterCreatorOverlays.CHEST_HAIR] = {
        index = chestHairIndex or -1,
        opacity = data[eBarbershopAppearance.CHEST_HAIR_OPACITY] or 0.0
    }

    customization.OVERLAY_COLORS[eCharacterCreatorOverlays.CHEST_HAIR] = {
        colorType = 1,
        colorId = data[eBarbershopAppearance.CHEST_HAIR_COLOR_ID] or 0,
        secondColorId = data[eBarbershopAppearance.CHEST_HAIR_SECOND_COLOR_ID] or 0
    }

    -- 👃 FACE FEATURES
    customization.FACE_FEATURES = {
        -- Nose
        [eCharacterCreatorFaceFeatures.NOSE_WIDTH] = data[eBarbershopAppearance.NOSE_WIDTH] or 0.0,
        [eCharacterCreatorFaceFeatures.NOSE_PEAK] = data[eBarbershopAppearance.NOSE_PEAK] or 0.0,
        [eCharacterCreatorFaceFeatures.NOSE_LENGTH] = data[eBarbershopAppearance.NOSE_LENGTH] or 0.0,
        [eCharacterCreatorFaceFeatures.NOSE_BONE_CURVENESS] = data[eBarbershopAppearance.NOSE_BONE_CURVENESS] or 0.0,
        [eCharacterCreatorFaceFeatures.NOSE_TIP] = data[eBarbershopAppearance.NOSE_TIP] or 0.0,
        [eCharacterCreatorFaceFeatures.NOSE_BONE_TWIST] = data[eBarbershopAppearance.NOSE_BONE_TWIST] or 0.0,

        -- Eyes & Eyebrows
        [eCharacterCreatorFaceFeatures.EYEBROW_HEIGHT] = data[eBarbershopAppearance.EYEBROW_HEIGHT] or 0.0,
        [eCharacterCreatorFaceFeatures.EYEBROW_DEPTH] = data[eBarbershopAppearance.EYEBROW_DEPTH] or 0.0,
        [eCharacterCreatorFaceFeatures.EYE_OPENING] = data[eBarbershopAppearance.EYE_OPENING] or 0.0,

        -- Cheeks
        [eCharacterCreatorFaceFeatures.CHEEK_BONES_HEIGHT] = data[eBarbershopAppearance.CHEEK_BONES_HEIGHT] or 0.0,
        [eCharacterCreatorFaceFeatures.CHEEK_BONES_WIDTH] = data[eBarbershopAppearance.CHEEK_BONES_WIDTH] or 0.0,
        [eCharacterCreatorFaceFeatures.CHEEK_WIDTH] = data[eBarbershopAppearance.CHEEK_WIDTH] or 0.0,

        -- Jaw & Chin
        [eCharacterCreatorFaceFeatures.JAW_BONE_WIDTH] = data[eBarbershopAppearance.JAW_BONE_WIDTH] or 0.0,
        [eCharacterCreatorFaceFeatures.JAW_BONE_SHAPE] = data[eBarbershopAppearance.JAW_BONE_SHAPE] or 0.0,
        [eCharacterCreatorFaceFeatures.CHIN_HEIGHT] = data[eBarbershopAppearance.CHIN_HEIGHT] or 0.0,
        [eCharacterCreatorFaceFeatures.CHIN_LENGTH] = data[eBarbershopAppearance.CHIN_LENGTH] or 0.0,
        [eCharacterCreatorFaceFeatures.CHIN_SHAPE] = data[eBarbershopAppearance.CHIN_SHAPE] or 0.0,
        [eCharacterCreatorFaceFeatures.CHIN_HOLE] = data[eBarbershopAppearance.CHIN_HOLE] or 0.0,

        -- Mouth & Neck
        [eCharacterCreatorFaceFeatures.LIP_THICKNESS] = data[eBarbershopAppearance.LIP_THICKNESS] or 0.0,
        [eCharacterCreatorFaceFeatures.NECK_THICKNESS] = data[eBarbershopAppearance.NECK_THICKNESS] or 0.0
    }

    return customization
end

---@param source number?
---@return character-creator.EnumCreationState?
function GetPlayerCustomizationState(source)
    if not IsDuplicityVersion() then
        return LocalPlayer.state[KEY_STATE_CREATOR]
    end

    if not source then
        return
    end

    return Player(source)['state'][KEY_STATE_CREATOR]
end

---@param source number?
function GetPlayerAppearanceState(source)
    if not IsDuplicityVersion() then
        return LocalPlayer["state"][KEY_STATE_CUSTOMIZATION] or {}
    end

    if not source then
        return {}
    end

    return Player(source)["state"][KEY_STATE_CUSTOMIZATION] or {}
end

---@param appearance number[]
function SavePlayerAppearanceState(appearance)
    LocalPlayer["state"][KEY_STATE_CUSTOMIZATION] = appearance
end

---@param source number?
function ClearPlayerCreatorState(source)
    if IsDuplicityVersion() and source then
        Player(source)['state']:set(KEY_STATE_CREATOR, nil, true)
        return
    end
    LocalPlayer['state']:set(KEY_STATE_CREATOR, nil, true)
end

function GetPlayerTattoosState()
    return LocalPlayer["state"]["Tattoos"] or {}
end