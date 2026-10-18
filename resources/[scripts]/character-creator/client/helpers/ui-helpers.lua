local KEY_COLOR = "%s:COLOR"
local KEY_OPACITY = "%s:OPACITY"

---@param entry table<string,number>
---@return table<string[]>
local function GetKeysCustomization(entry)
    local output = {}

    for key, value in pairs(entry) do
        output[value] = key
    end

    return output
end

local COMPONENT_VARIATIONS_KEYS = GetKeysCustomization(eCharacterCreatorComponentVariations)
local FACE_FEATURES_KEYS = GetKeysCustomization(eCharacterCreatorFaceFeatures)
local OVERLAYS_KEYS = GetKeysCustomization(eCharacterCreatorOverlays)

---@param customization character-creator.CustomizationData
function SendCustomizationToUI(customization)
    local blend                   = customization.HEAD_BLEND_DATA or {}
    local hairColor               = customization.HAIR_COLOR or {}
    local data                    = {}

    data["shapeFirstID"]      = blend.shapeFirstID or 0
    data["shapeSecondID"]     = blend.shapeSecondID or 0
    data["shapeThirdID"]      = blend.shapeThirdID or 0
    data["skinFirstID"]       = blend.skinFirstID or 0
    data["skinSecondID"]      = blend.skinSecondID or 0
    data["skinThirdID"]       = blend.skinThirdID or 0
    data["shapeMix"]        = blend.shapeMix or 0.0
    data["skinMix"]         = blend.skinMix or 0.0
    data["thirdMix"]        = blend.thirdMix or 0.0
    data["isParent"]        = blend.isParent or false

    data[KEY_COLOR:format("EYE")] = customization.EYE_COLOR or 0

    for id, value in pairs(customization.COMPONENT_VARIATIONS or {}) do
        local name = COMPONENT_VARIATIONS_KEYS[id]
        if name then
            data[name] = value.drawableId
            data[KEY_COLOR:format(name)] = value.textureId or 0
        end
    end

    for featureId, scale in pairs(customization.FACE_FEATURES or {}) do
        local featureName = FACE_FEATURES_KEYS[featureId]
        if featureName then
            data[featureName] = scale
        end
    end

    data[KEY_COLOR:format("HAIR")] = hairColor.colorId or 0
    data["HAIR_SECONDARY"] = hairColor.highlightColorId or 0

    for overlayId, overlayData in pairs(customization.OVERLAYS or {}) do
        local overlayName = OVERLAYS_KEYS[overlayId]

        if overlayName then
            data[overlayName] = overlayData.index
            data[KEY_OPACITY:format(overlayName)] = overlayData.opacity
        end
    end

    for overlayId, colorData in pairs(customization.OVERLAY_COLORS or {}) do
        local overlayName = OVERLAYS_KEYS[overlayId]

        if overlayName then
            data[KEY_COLOR:format(overlayName)] = colorData.colorId
        end
    end

    data["GENDER"] = GetEntityModel(PlayerPedId()) == GetHashKey('mp_f_freemode_01') and 'F' or 'M'
    SendNUIMessage({ action = "character:update", data = data })
end

---@return string?
function GetCreationStateFlagName()
    assert(next(gCreationState), "gCreationState is not defined")

    local flags = gCreationState.flag

    for name, current in pairs(eCharacterCreatorCreationState) do
        if (flags & current) ~= 0 then
            return name
        end
    end
end