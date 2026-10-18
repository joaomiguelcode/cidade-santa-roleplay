SkinshopClothingRulesMenu = SkinshopClothingRulesMenu or {}


local CONTEXT_HOME = "skinshop_clothing_rules:home"
local CONTEXT_LIST = "skinshop_clothing_rules:list"
local CONTEXT_RULE_ACTIONS = "skinshop_clothing_rules:rule_actions"

local CALLBACK_OPEN_MENU = "skinshop:clothingRules:openMenu"
local CALLBACK_LIST_RULES = "skinshop:clothingRules:list"
local CALLBACK_CREATE_RULE = "skinshop:clothingRules:create"
local CALLBACK_UPDATE_RULE = "skinshop:clothingRules:update"
local CALLBACK_DISABLE_RULE = "skinshop:clothingRules:disable"

local MODEL_OPTIONS = {
    { label = _t("skinshopClothingRulesModelAll"), value = "" },
    { label = _t("skinshopClothingRulesModelMale"), value = "mp_m_freemode_01" },
    { label = _t("skinshopClothingRulesModelFemale"), value = "mp_f_freemode_01" },
}

local function showHomeAfterContextClose()
    SetTimeout(0, function()
        SkinshopClothingRulesMenu.showHome()
    end)
end

local function categoryOptions()
    local options = {}

    for _, category in ipairs(SkinshopClothingRuleTypes.CATEGORY_ORDER) do
        options[#options + 1] = {
            label = SkinshopClothingRuleTypes.getCategoryLabel(category),
            value = category,
        }
    end

    return options
end

---@param category any
---@return table?
local function getCurrentClothingPart(category)
    local normalizedCategory = SkinshopClothingRuleTypes.normalizeCategory(category)
    local clothingData = normalizedCategory and SharedClothingData[normalizedCategory] or nil

    if not clothingData then
        return nil
    end

    local ped = PlayerPedId()

    if clothingData.mode == "variation" then
        return {
            item = GetPedDrawableVariation(ped, clothingData.id),
            texture = GetPedTextureVariation(ped, clothingData.id),
        }
    end

    if clothingData.mode == "prop" then
        local item = GetPedPropIndex(ped, clothingData.id)

        return {
            item = item,
            texture = item == -1 and 0 or GetPedPropTextureIndex(ped, clothingData.id),
        }
    end

    return nil
end

---@param response table?
---@return boolean
local function notifyResult(response)
    if not response then
        lib.notify({
            title = _t("skinshopTitle"),
            description = _t("skinshopNoServerResponse"),
            type = "error",
        })
        return false
    end

    lib.notify({
        title = _t("skinshopTitle"),
        description = response.message or (response.ok and _t("skinshopOperationSuccess") or _t("skinshopOperationError")),
        type = response.ok and "success" or "error",
    })

    return not not response.ok
end

---@param title string
---@param initial table?
---@return table?
local function inputRule(title, initial)
    initial = initial or {}

    local input = lib.inputDialog(title, {
        {
            type = "select",
            label = _t("skinshopClothingRulesPartLabel"),
            required = true,
            options = categoryOptions(),
            default = initial.category or "torso",
        },
        {
            type = "number",
            label = _t("skinshopClothingRulesItemLabel"),
            required = true,
            default = initial.item,
        },
        {
            type = "input",
            label = _t("skinshopClothingRulesTextureLabel"),
            required = false,
            default = initial.texturesText or "",
        },
        {
            type = "select",
            label = _t("skinshopClothingRulesModelLabel"),
            required = false,
            options = MODEL_OPTIONS,
            default = initial.model or "",
        },
        {
            type = "input",
            label = _t("skinshopClothingRulesReasonLabel"),
            required = false,
            default = initial.reason or _t("skinshopClothingRulesDefaultReason"),
        },
        {
            type = "input",
            label = _t("skinshopClothingRulesAllowedGroupsLabel"),
            required = false,
            default = initial.allowedGroupsText or "",
        },
        {
            type = "input",
            label = _t("skinshopClothingRulesAllowedPassportsLabel"),
            required = false,
            default = initial.allowedPassportsText or "",
        },
        {
            type = "input",
            label = _t("skinshopClothingRulesAllowedItemsLabel"),
            required = false,
            default = initial.allowedItemsText or "",
        },
    })

    if not input then
        return nil
    end

    return {
        category = input[1],
        item = input[2],
        textures = input[3],
        model = input[4],
        reason = input[5],
        allowedGroups = input[6],
        allowedPassports = input[7],
        allowedItems = input[8],
    }
end

function SkinshopClothingRulesMenu.showHome()
    lib.registerContext({
        id = CONTEXT_HOME,
        title = _t("skinshopClothingRulesHomeTitle"),
        options = {
            {
                title = _t("skinshopClothingRulesAddManualTitle"),
                description = _t("skinshopClothingRulesAddManualDescription"),
                icon = "plus",
                onSelect = function()
                    SkinshopClothingRulesMenu.createManualRule()
                end,
            },
            {
                title = _t("skinshopClothingRulesAddCurrentTitle"),
                description = _t("skinshopClothingRulesAddCurrentDescription"),
                icon = "shirt",
                onSelect = function()
                    SkinshopClothingRulesMenu.createRuleFromCurrentClothes()
                end,
            },
            {
                title = _t("skinshopClothingRulesListTitle"),
                description = _t("skinshopClothingRulesListDescription"),
                icon = "list",
                onSelect = function()
                    SkinshopClothingRulesMenu.showRuleList()
                end,
            },
        },
    })

    lib.showContext(CONTEXT_HOME)
end

function SkinshopClothingRulesMenu.createManualRule()
    local payload = inputRule(_t("skinshopClothingRulesAddDialogTitle"))

    if not payload then
        return SkinshopClothingRulesMenu.showHome()
    end

    local response = lib.callback.await(CALLBACK_CREATE_RULE, false, payload)

    if notifyResult(response) then
        return SkinshopClothingRulesMenu.showHome()
    end

    SkinshopClothingRulesMenu.createManualRule()
end

function SkinshopClothingRulesMenu.createRuleFromCurrentClothes()
    local input = lib.inputDialog(_t("skinshopClothingRulesUseCurrentDialogTitle"), {
        {
            type = "select",
            label = _t("skinshopClothingRulesPartLabel"),
            required = true,
            options = categoryOptions(),
            default = "torso",
        },
    })

    if not input then
        return SkinshopClothingRulesMenu.showHome()
    end

    local category = SkinshopClothingRuleTypes.normalizeCategory(input[1])
    local current = getCurrentClothingPart(category)

    if not current then
        lib.notify({
            title = _t("skinshopTitle"),
            description = _t("skinshopClothingRulesCategoryNotFound"),
            type = "error",
        })
        return SkinshopClothingRulesMenu.showHome()
    end

    local payload = inputRule(_t("skinshopClothingRulesAddDialogTitle"), {
        category = category,
        item = current.item,
        texturesText = tostring(current.texture or 0),
    })

    if not payload then
        return SkinshopClothingRulesMenu.showHome()
    end

    local response = lib.callback.await(CALLBACK_CREATE_RULE, false, payload)

    if notifyResult(response) then
        return SkinshopClothingRulesMenu.showHome()
    end

    SkinshopClothingRulesMenu.createRuleFromCurrentClothes()
end

function SkinshopClothingRulesMenu.showRuleList()
    local response = lib.callback.await(CALLBACK_LIST_RULES, false, {})

    if not response or not response.ok then
        notifyResult(response)
        return SkinshopClothingRulesMenu.showHome()
    end

    local options = {}

    for _, rule in ipairs(response.data or {}) do
        options[#options + 1] = {
            title = ("#%s %s %s"):format(rule.id, rule.categoryLabel or rule.category, rule.item),
            description = _t("skinshopClothingRulesRuleDescription"):format(
                rule.texturesText or _t("skinshopClothingRulesAnyTexture"),
                rule.modelLabel or _t("skinshopClothingRulesGenderAll"),
                rule.reason or "",
                rule.createdByName or _t("skinshopClothingRulesCharacterIdFallback"):format(tostring(rule.createdByCharacterId or "")),
                tostring(rule.createdByCharacterId or "")
            ),
            icon = "lock",
            arrow = true,
            onSelect = function()
                SkinshopClothingRulesMenu.showRuleActions(rule)
            end,
        }
    end

    lib.registerContext({
        id = CONTEXT_LIST,
        title = _t("skinshopClothingRulesActiveTitle"),
        canShowTextFilter = true,
        onExit = showHomeAfterContextClose,
        options = options,
    })

    lib.showContext(CONTEXT_LIST)
end

---@param rule table
function SkinshopClothingRulesMenu.showRuleActions(rule)
    lib.registerContext({
        id = CONTEXT_RULE_ACTIONS,
        title = _t("skinshopClothingRulesActionsTitle"):format(rule.id),
        menu = CONTEXT_LIST,
        options = {
            {
                title = _t("skinshopClothingRulesEditTitle"),
                description = _t("skinshopClothingRulesEditDescription"),
                icon = "pencil",
                onSelect = function()
                    SkinshopClothingRulesMenu.editRule(rule)
                end,
            },
            {
                title = _t("skinshopClothingRulesDisableTitle"),
                description = _t("skinshopClothingRulesDisableDescription"),
                icon = "trash",
                onSelect = function()
                    SkinshopClothingRulesMenu.confirmDisableRule(rule)
                end,
            },
        },
    })

    lib.showContext(CONTEXT_RULE_ACTIONS)
end

---@param rule table
function SkinshopClothingRulesMenu.editRule(rule)
    local payload = inputRule(_t("skinshopClothingRulesEditDialogTitle"):format(rule.id), rule)

    if not payload then
        return SkinshopClothingRulesMenu.showRuleActions(rule)
    end

    local response = lib.callback.await(CALLBACK_UPDATE_RULE, false, rule.id, payload)

    if notifyResult(response) then
        return SkinshopClothingRulesMenu.showRuleList()
    end

    SkinshopClothingRulesMenu.editRule(rule)
end

---@param rule table
function SkinshopClothingRulesMenu.confirmDisableRule(rule)
    local result = lib.alertDialog({
        header = _t("skinshopClothingRulesDisableDialogHeader"),
        content = _t("skinshopClothingRulesDisableDialogContent"):format(rule.id, rule.categoryLabel or rule.category, rule.item),
        centered = true,
        cancel = true,
    })

    if result ~= "confirm" then
        return SkinshopClothingRulesMenu.showRuleActions(rule)
    end

    local response = lib.callback.await(CALLBACK_DISABLE_RULE, false, rule.id)

    if notifyResult(response) then
        return SkinshopClothingRulesMenu.showRuleList()
    end

    SkinshopClothingRulesMenu.showRuleActions(rule)
end

lib.callback.register(CALLBACK_OPEN_MENU, function()
    SkinshopClothingRulesMenu.showHome()
end)
