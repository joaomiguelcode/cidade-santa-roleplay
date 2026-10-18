SkinshopClothingRulesPreview = SkinshopClothingRulesPreview or {}
SkinshopClothingVisual = SkinshopClothingVisual or {}

local SNAPSHOT_TTL = 15000

local gRulesSnapshot = {}
local gLastSnapshotAt = 0
local gSnapshotLoaded = false

---@param response any
---@return table?
---@return string?
local function parseSnapshotResponse(response)
    if type(response) ~= "table" then
        return nil, _t("skinshopClothingRulesInternalError")
    end

    if response.ok ~= nil then
        if not response.ok then
            return nil, response.message or _t("skinshopClothingRulesInternalError")
        end

        return type(response.data) == "table" and response.data or {}, nil
    end

    return response, nil
end

---@param ped number?
---@return string?
local function getPedModelName(ped)
    local model = GetEntityModel(ped or PlayerPedId())

    if model == GetHashKey("mp_m_freemode_01") then
        return "mp_m_freemode_01"
    end

    if model == GetHashKey("mp_f_freemode_01") then
        return "mp_f_freemode_01"
    end

    return nil
end

---@param rule table
---@param category string
---@param item number
---@param texture number?
---@param model string?
---@return boolean
local function matchesRule(rule, category, item, texture, model)
    if rule.category ~= category or tonumber(rule.item) ~= item then
        return false
    end

    if not SkinshopClothingRuleTypes.matchesTexture(rule.textures, texture) then
        return false
    end

    if rule.model ~= nil and rule.model ~= model then
        return false
    end

    return true
end

---@param category string
---@param item number
---@param texture number?
---@param model string?
---@return boolean
local function getSnapshotDecision(category, item, texture, model)
    local hasBlockedRule = false

    for _, rule in ipairs(gRulesSnapshot) do
        if matchesRule(rule, category, item, texture, model) then
            if rule.canUse then
                return true
            end

            hasBlockedRule = true
        end
    end

    if hasBlockedRule then
        return false
    end

    return true
end

---@param force boolean?
---@return boolean
function SkinshopClothingRulesPreview.Refresh(force)
    local now = GetGameTimer()

    if not force and gSnapshotLoaded and now - gLastSnapshotAt < SNAPSHOT_TTL then
        return true
    end

    local status, response = pcall(function()
        return lib.callback.await("skinshop:clothingRules:snapshot", false)
    end)

    if not status then
        sx.logger:warn(("[skinshop] Falha ao carregar snapshot visual de clothing rules. error=%s"):format(
            tostring(response)
        ))
        return false
    end

    local snapshot, message = parseSnapshotResponse(response)

    if not snapshot then
        sx.logger:warn(("[skinshop] Snapshot visual de clothing rules invalido. message=%s"):format(
            tostring(message)
        ))
        return false
    end

    gRulesSnapshot = snapshot
    gLastSnapshotAt = now
    gSnapshotLoaded = true

    return true
end

---@param category any
---@param item any
---@param texture any
---@param options table?
---@return boolean
function SkinshopClothingRulesPreview.CanUsePart(category, item, texture, options)
    options = options or {}

    local normalizedCategory = SkinshopClothingRuleTypes.normalizeCategory(category)
    local itemNumber = SkinshopClothingRuleTypes.toInteger(item)

    if not normalizedCategory or itemNumber == nil then
        return true
    end

    SkinshopClothingRulesPreview.Refresh(false)

    local textureNumber = SkinshopClothingRuleTypes.toOptionalInteger(texture) or 0
    local model = options.model or getPedModelName(options.ped)
    local canUse = getSnapshotDecision(normalizedCategory, itemNumber, textureNumber, model)

    if canUse then
        return true
    end

    if SkinshopClothingRulesPreview.Refresh(true) then
        return getSnapshotDecision(normalizedCategory, itemNumber, textureNumber, model)
    end

    return false
end

---@param dataset table
---@param options table?
---@return table
function SkinshopClothingRulesPreview.FilterDataset(dataset, options)
    options = options or {}

    local filteredDataset = {}

    if type(dataset) ~= "table" then
        return filteredDataset
    end

    for category, part in pairs(dataset) do
        local normalizedCategory = SkinshopClothingRuleTypes.normalizeCategory(category)

        if normalizedCategory and type(part) == "table" then
            local item = SkinshopClothingRuleTypes.toInteger(part.item)
            local texture = SkinshopClothingRuleTypes.toOptionalInteger(part.texture) or 0
            local canUse = true

            if not options.canUseBlockedClothing then
                canUse = SkinshopClothingRulesPreview.CanUsePart(normalizedCategory, item, texture, {
                    model = options.model,
                    ped = options.ped,
                })
            end

            if canUse then
                filteredDataset[normalizedCategory] = { item = item or 0, texture = texture }
            end
        end
    end

    return filteredDataset
end

---@param ped number
---@param category any
---@param item any
---@param texture any
---@param paletteId number?
---@return boolean
function SkinshopClothingVisual.ApplyCategory(ped, category, item, texture, paletteId)
    local normalizedCategory = SkinshopClothingRuleTypes.normalizeCategory(category)
    local clothingData = normalizedCategory and SharedClothingData[normalizedCategory]

    if not clothingData then
        sx.logger:warn(("[skinshop] Categoria visual invalida. category=%s"):format(tostring(category)))
        return false
    end

    local itemNumber = SkinshopClothingRuleTypes.toInteger(item) or 0
    local textureNumber = SkinshopClothingRuleTypes.toOptionalInteger(texture) or 0
    local palette = paletteId or 1

    if clothingData.mode == "variation" then
        SetPedComponentVariation(ped, clothingData.id, itemNumber, textureNumber, palette)
        return true
    end

    if clothingData.mode == "prop" then
        if itemNumber ~= -1 and itemNumber ~= 0 then
            SetPedPropIndex(ped, clothingData.id, itemNumber, textureNumber, palette)
        else
            ClearPedProp(ped, clothingData.id)
        end

        return true
    end

    return false
end
