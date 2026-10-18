SkinshopClothingRuleTypes = SkinshopClothingRuleTypes or {}


SkinshopClothingRuleTypes.CATEGORY_ORDER = {
    "torso",
    "pants",
    "shoes",
    "tshirt",
    "arms",
    "hat",
    "glass",
    "accessory",
    "backpack",
    "mask",
    "vest",
    "decals",
    "ear",
    "bracelet",
    "watch",
}

SkinshopClothingRuleTypes.CATEGORY_LABELS = {
    pants = "Calcas",
    arms = "Maos",
    tshirt = "Blusa",
    torso = "Jaqueta",
    vest = "Colete",
    shoes = "Sapatos",
    mask = "Mascara",
    backpack = "Mochila",
    hat = "Chapeu",
    glass = "Oculos",
    ear = "Orelha",
    watch = "Relogio",
    bracelet = "Pulseira",
    accessory = "Acessorios",
    decals = "Decals",
}

SkinshopClothingRuleTypes.CATEGORY_TRANSLATION_KEYS = {
    pants = "skinshopClothingCategoryPants",
    arms = "skinshopClothingCategoryArms",
    tshirt = "skinshopClothingCategoryTshirt",
    torso = "skinshopClothingCategoryTorso",
    vest = "skinshopClothingCategoryVest",
    shoes = "skinshopClothingCategoryShoes",
    mask = "skinshopClothingCategoryMask",
    backpack = "skinshopClothingCategoryBackpack",
    hat = "skinshopClothingCategoryHat",
    glass = "skinshopClothingCategoryGlass",
    ear = "skinshopClothingCategoryEar",
    watch = "skinshopClothingCategoryWatch",
    bracelet = "skinshopClothingCategoryBracelet",
    accessory = "skinshopClothingCategoryAccessory",
    decals = "skinshopClothingCategoryDecals",
}

local CATEGORY_ALIASES = {
    calca = "pants",
    calcas = "pants",
    hands = "arms",
    maos = "arms",
    shirt = "tshirt",
    blusa = "tshirt",
    jacket = "torso",
    jaqueta = "torso",
    colete = "vest",
    sapato = "shoes",
    sapatos = "shoes",
    mascara = "mask",
    mochila = "backpack",
    chapeu = "hat",
    hat = "hat",
    glasses = "glass",
    oculos = "glass",
    acessorio = "accessory",
    acessorios = "accessory",
}

local VALID_MODELS = {
    ["mp_m_freemode_01"] = true,
    ["mp_f_freemode_01"] = true,
}

local MODEL_GENDER_TRANSLATION_KEYS = {
    ["mp_m_freemode_01"] = "skinshopClothingRulesGenderMale",
    ["mp_f_freemode_01"] = "skinshopClothingRulesGenderFemale",
}

SkinshopClothingRuleTypes.CATEGORY_SET = {}

for _, category in ipairs(SkinshopClothingRuleTypes.CATEGORY_ORDER) do
    SkinshopClothingRuleTypes.CATEGORY_SET[category] = true
end

---@param value any
---@return string
function SkinshopClothingRuleTypes.trim(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

---@param category any
---@return string?
function SkinshopClothingRuleTypes.normalizeCategory(category)
    local normalized = SkinshopClothingRuleTypes.trim(category):lower()
    normalized = CATEGORY_ALIASES[normalized] or normalized

    if SkinshopClothingRuleTypes.CATEGORY_SET[normalized] then
        return normalized
    end

    return nil
end

---@param category any
---@return string
function SkinshopClothingRuleTypes.getCategoryLabel(category)
    local normalizedCategory = SkinshopClothingRuleTypes.normalizeCategory(category)

    if not normalizedCategory then
        return tostring(category or "")
    end

    local translationKey = SkinshopClothingRuleTypes.CATEGORY_TRANSLATION_KEYS[normalizedCategory]

    if translationKey then
        return _t(translationKey)
    end

    return SkinshopClothingRuleTypes.CATEGORY_LABELS[normalizedCategory] or normalizedCategory
end

---@param model any
---@return string
function SkinshopClothingRuleTypes.getModelGenderLabel(model)
    local normalizedModel = SkinshopClothingRuleTypes.normalizeModel(model)

    if not normalizedModel then
        return _t("skinshopClothingRulesGenderAll")
    end

    local translationKey = MODEL_GENDER_TRANSLATION_KEYS[normalizedModel]

    if translationKey then
        return _t(translationKey)
    end

    return normalizedModel
end

---@param value any
---@return number?
function SkinshopClothingRuleTypes.toInteger(value)
    local number = tonumber(value)

    if not number or number ~= math.floor(number) then
        return nil
    end

    return number
end

---@param value any
---@return number?
function SkinshopClothingRuleTypes.toOptionalInteger(value)
    local text = SkinshopClothingRuleTypes.trim(value)

    if text == "" then
        return nil
    end

    return SkinshopClothingRuleTypes.toInteger(text)
end

---@param rawValue any
---@return number[]?
---@return string?
function SkinshopClothingRuleTypes.parseTextures(rawValue)
    if type(rawValue) ~= "table" and SkinshopClothingRuleTypes.trim(rawValue) == "" then
        return nil, nil
    end

    local textures = {}
    local seen = {}

    for _, rawTexture in ipairs(SkinshopClothingRuleTypes.parseCsv(rawValue)) do
        local texture = SkinshopClothingRuleTypes.toInteger(rawTexture)

        if not texture or texture < 0 then
            return nil, _t("skinshopClothingRulesInvalidTexture")
        end

        if not seen[texture] then
            seen[texture] = true
            textures[#textures + 1] = texture
        end
    end

    if #textures == 0 then
        return nil, nil
    end

    table.sort(textures)

    return textures, nil
end

---@param textures number[]?
---@return string?
function SkinshopClothingRuleTypes.encodeTextures(textures)
    if type(textures) ~= "table" or #textures == 0 then
        return nil
    end

    return json.encode(textures, { empty_table_as_array = true })
end

---@param rawJson any
---@return number[]?
function SkinshopClothingRuleTypes.decodeTextures(rawJson)
    local text = SkinshopClothingRuleTypes.trim(rawJson)

    if text == "" then
        return nil
    end

    local status, decoded = pcall(json.decode, text)

    if not status or type(decoded) ~= "table" then
        return nil
    end

    local textures, texturesError = SkinshopClothingRuleTypes.parseTextures(decoded)

    if texturesError then
        return nil
    end

    return textures
end

---@param textures number[]?
---@param texture any
---@return boolean
function SkinshopClothingRuleTypes.matchesTexture(textures, texture)
    if type(textures) ~= "table" or #textures == 0 then
        return true
    end

    local textureNumber = SkinshopClothingRuleTypes.toOptionalInteger(texture) or 0

    for _, allowedTexture in ipairs(textures) do
        if tonumber(allowedTexture) == textureNumber then
            return true
        end
    end

    return false
end

---@param value any
---@return string?
function SkinshopClothingRuleTypes.normalizeModel(value)
    local text = SkinshopClothingRuleTypes.trim(value)

    if text == "" then
        return nil
    end

    local lowered = text:lower()

    if VALID_MODELS[lowered] then
        return lowered
    end

    return nil
end

---@param text any
---@return string[]
function SkinshopClothingRuleTypes.parseCsv(text)
    if type(text) == "table" then
        local values = {}

        for _, value in ipairs(text) do
            local item = SkinshopClothingRuleTypes.trim(value)

            if item ~= "" then
                values[#values + 1] = item
            end
        end

        return values
    end

    local values = {}
    local rawText = SkinshopClothingRuleTypes.trim(text)

    if rawText == "" then
        return values
    end

    for value in rawText:gmatch("[^,]+") do
        local item = SkinshopClothingRuleTypes.trim(value)

        if item ~= "" then
            values[#values + 1] = item
        end
    end

    return values
end

---@param rawGroups any
---@return table[]?
---@return string?
function SkinshopClothingRuleTypes.parseGroupList(rawGroups)
    local groups = {}
    local seen = {}

    for _, rawGroup in ipairs(SkinshopClothingRuleTypes.parseCsv(rawGroups)) do
        local groupName = rawGroup
        local levelText = nil
        local parsedGroup, parsedLevel = rawGroup:match("^([^:=]+)[:=](%d+)$")

        if parsedGroup then
            groupName = SkinshopClothingRuleTypes.trim(parsedGroup)
            levelText = parsedLevel
        end

        if #groupName > 64 then
            return nil, _t("skinshopClothingRulesGroupTooLong"):format(groupName)
        end

        local level = SkinshopClothingRuleTypes.toInteger(levelText or 1)

        if not level or level < 1 then
            return nil, _t("skinshopClothingRulesGroupLevelInvalid"):format(groupName)
        end

        if not seen[groupName] then
            seen[groupName] = true
            groups[#groups + 1] = {
                group = groupName,
                level = level,
            }
        end
    end

    return groups, nil
end

---@param rawPassports any
---@return number[]?
---@return string?
function SkinshopClothingRuleTypes.parsePassportList(rawPassports)
    local characterIds = {}
    local seen = {}

    for _, rawPassport in ipairs(SkinshopClothingRuleTypes.parseCsv(rawPassports)) do
        local characterId = SkinshopClothingRuleTypes.toInteger(rawPassport)

        if not characterId or characterId < 1 then
            return nil, _t("skinshopClothingRulesInvalidPassport"):format(rawPassport)
        end

        if not seen[characterId] then
            seen[characterId] = true
            characterIds[#characterIds + 1] = characterId
        end
    end

    return characterIds, nil
end

---@param rawItems any
---@return string[]
function SkinshopClothingRuleTypes.parseItemList(rawItems)
    local items = {}
    local seen = {}

    for _, rawItem in ipairs(SkinshopClothingRuleTypes.parseCsv(rawItems)) do
        if not seen[rawItem] then
            seen[rawItem] = true
            items[#items + 1] = rawItem
        end
    end

    return items
end

---@param groups table[]?
---@return string
function SkinshopClothingRuleTypes.formatGroups(groups)
    local values = {}

    for _, group in ipairs(groups or {}) do
        if type(group) == "table" then
            values[#values + 1] = ("%s:%s"):format(tostring(group.group), tostring(group.level or 1))
        else
            values[#values + 1] = tostring(group)
        end
    end

    return table.concat(values, ", ")
end

---@param values table?
---@return string
function SkinshopClothingRuleTypes.formatCsv(values)
    local formatted = {}

    for _, value in ipairs(values or {}) do
        formatted[#formatted + 1] = tostring(value)
    end

    return table.concat(formatted, ", ")
end

---@param textures number[]?
---@return string
function SkinshopClothingRuleTypes.formatTextures(textures)
    if type(textures) ~= "table" or #textures == 0 then
        return _t("skinshopClothingRulesAnyTexture")
    end

    return SkinshopClothingRuleTypes.formatCsv(textures)
end

---@param payload table
---@return table?
---@return string?
function SkinshopClothingRuleTypes.normalizeRulePayload(payload)
    if type(payload) ~= "table" then
        return nil, _t("skinshopClothingRulesInvalidPayload")
    end

    local category = SkinshopClothingRuleTypes.normalizeCategory(payload.category)

    if not category then
        return nil, _t("skinshopClothingRulesInvalidCategory")
    end

    local item = SkinshopClothingRuleTypes.toInteger(payload.item)

    if not item or item < -1 then
        return nil, _t("skinshopClothingRulesInvalidItem")
    end

    local textures, texturesError = SkinshopClothingRuleTypes.parseTextures(payload.textures)

    if texturesError then
        return nil, texturesError
    end

    local model = SkinshopClothingRuleTypes.normalizeModel(payload.model)
    local modelText = SkinshopClothingRuleTypes.trim(payload.model)

    if modelText ~= "" and not model then
        return nil, _t("skinshopClothingRulesInvalidModel")
    end

    local allowedGroups, groupsError = SkinshopClothingRuleTypes.parseGroupList(payload.allowedGroups)

    if groupsError then
        return nil, groupsError
    end

    local allowedPassports, passportsError = SkinshopClothingRuleTypes.parsePassportList(payload.allowedPassports)

    if passportsError then
        return nil, passportsError
    end

    local reason = SkinshopClothingRuleTypes.trim(payload.reason)

    if reason == "" then
        reason = _t("skinshopClothingRulesDefaultReason")
    end

    if #reason > 160 then
        return nil, _t("skinshopClothingRulesReasonTooLong")
    end

    return {
        category = category,
        item = item,
        textures = textures,
        model = model,
        reason = reason,
        allowedGroups = allowedGroups,
        allowedPassports = allowedPassports,
        allowedItems = SkinshopClothingRuleTypes.parseItemList(payload.allowedItems),
    }, nil
end
