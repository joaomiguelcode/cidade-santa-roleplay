---@alias StaffgangTemplateId string
---@alias StaffgangFarmType 'cds' | 'fishing' | 'milking' | 'polyzone' | 'afk' | 'active'
---@alias StaffgangPointType 'sphere' | 'polygon'
---@alias StaffgangShopMode 'Buy' | 'Sell'
---@alias StaffgangFarmMode 'active' | 'afk'

---@class StaffgangScriptedInteractionOption
---@field label string
---@field value string

---@class StaffgangPolyzoneLimits
---@field minPoints number
---@field maxPoints number
---@field maxBounds number

---@class StaffgangTemplateRewardItemDef
---@field item string
---@field amount number

---@class StaffgangTemplateShopItemDef
---@field item string
---@field price number

---@class StaffgangTemplateShopDef
---@field mode? StaffgangShopMode
---@field items? StaffgangTemplateShopItemDef[]
---@field title? string
---@field description? string

---@class StaffgangTemplateShop
---@field mode StaffgangShopMode
---@field items StaffgangTemplateShopItemDef[]
---@field title? string
---@field description? string

---@class StaffgangTemplateMinigameDef
---@field displayName? string
---@field duration number
---@field distance? number
---@field flags? eMinigameDefFlags
---@field allowsVipFarmBuff? boolean
---@field scriptedInteractionName? string

---@class StaffgangTemplateMinigame
---@field displayName string
---@field duration number
---@field protectionActivationDelay number Delay in seconds from the minigame start
---@field distance number
---@field flags eMinigameDefFlags
---@field allowsVipFarmBuff boolean
---@field scriptedInteractionName? string

---@class StaffgangTemplateDef
---@field label string
---@field icon? string
---@field farmType StaffgangFarmType
---@field pointType StaffgangPointType
---@field minigamePreset? string
---@field isHidden? boolean
---@field requiresAllowedGroups? boolean
---@field mode? StaffgangFarmMode
---@field activeTemplateId? StaffgangTemplateId
---@field afkTemplateId? StaffgangTemplateId
---@field minigame StaffgangTemplateMinigameDef
---@field rewards StaffgangTemplateRewardItemDef[]|MinigameRewardLootTableDef|MinigameRewardLootTableDef[]
---@field hooks? table
---@field shop? StaffgangTemplateShopDef

---@class StaffgangTemplate
---@field id StaffgangTemplateId
---@field label string
---@field icon string
---@field farmType StaffgangFarmType
---@field pointType StaffgangPointType
---@field minigamePreset? string
---@field isHidden? boolean
---@field requiresAllowedGroups boolean
---@field mode? StaffgangFarmMode
---@field activeTemplateId? StaffgangTemplateId
---@field afkTemplateId? StaffgangTemplateId
---@field minigame StaffgangTemplateMinigame
---@field rewards MinigameRewardLootTableDef[]
---@field hooks? table
---@field shop? StaffgangTemplateShop

---@type StaffgangTemplateId[]
STAFFGANG_FARM_TEMPLATE_ORDER = {}

---@type table<StaffgangTemplateId, StaffgangTemplate>
STAFFGANG_FARM_TEMPLATES = {}

---@type StaffgangScriptedInteractionOption[]
STAFFGANG_SCRIPTED_INTERACTION_OPTIONS = {}

---@type table<string, boolean>
local registeredScriptedInteractionNames = {}

---@type fun(template: StaffgangTemplate)[]
local templateDefinedHandlers = {}

---@type eMinigameDefFlags
local gStaffgangMinigameProtectionFlags = eMinigameDefFlags.MDF_FLAG_PLAYER_INVINCIBLE
    | eMinigameDefFlags.MDF_FLAG_COLLISION_ENTITIES

---@type number
local STAFFGANG_MINIGAME_PROTECTION_ACTIVATION_DELAY_SECONDS = 5

---@type StaffgangPolyzoneLimits
STAFFGANG_POLYZONE_LIMITS = {
    minPoints = 3,
    maxPoints = 20,
    maxBounds = 350.0,
}

---@type number
STAFFGANG_AFK_MINIGAME_DURATION_SECONDS = 120

DEFAULT_STAFF_GANG_MULTIPLIER_FACTOR = 5 -- Multiplicação de tempo padrão para farms que não são os listados abaixo:

local DEFAULT_MULTIPLIES_BY_TEMPLATE_ID = {
    ['active_milking'] = 1,
    ['afk_milking'] = 1,
    ['active_fishing'] = 1,
    ['afk_fishing'] = 1
}

---@param templateBaseId string
---@param mode StaffgangFarmMode
---@return StaffgangTemplateId
function StaffgangBuildModeTemplateId(templateBaseId, mode)
    assert(type(templateBaseId) == 'string' and templateBaseId ~= '', 'templateBaseId is required!')
    assert(mode == 'active' or mode == 'afk', 'mode must be active or afk!')

    return ('%s_%s'):format(mode, templateBaseId)
end

---@param templateId string
local function GetMultiplierFactorById(templateId)
    return DEFAULT_MULTIPLIES_BY_TEMPLATE_ID[templateId] or DEFAULT_STAFF_GANG_MULTIPLIER_FACTOR
end

---@param templateId string
---@param mode StaffgangFarmMode | nil
---@param duration number
---@return number
function StaffgangGetMinigameDurationForMode(templateId, mode, duration)
    assert(duration, 'minigame.duration is required!')
    return duration * ( mode == 'afk' and GetMultiplierFactorById(templateId) or 1)
end

local function isSimpleRewardItem(value)
    return type(value) == 'table'
        and (type(value.item) == 'string' or type(value.id) == 'string')
end

---@param lootTable MinigameRewardLootTableDef
---@return MinigameRewardLootTableDef
local function cloneRewardLootTable(lootTable)
    local clonedLootTable = {}

    for key, value in pairs(lootTable) do
        if key ~= 'computedChanceWeightSum'
            and key ~= 'item'
            and key ~= 'currency'
        then
            clonedLootTable[key] = value
        end
    end

    clonedLootTable.item = table.clone(lootTable.item or {})
    clonedLootTable.currency = table.clone(lootTable.currency or {})

    return clonedLootTable
end

---@param rewards StaffgangTemplateRewardItemDef[]|MinigameRewardLootTableDef|MinigameRewardLootTableDef[]
---@return MinigameRewardLootTableDef[]
local function normalizeTemplateRewards(rewards)
    assert(type(rewards) == 'table', 'rewards is required!')

    if type(rewards.item) == 'table' then
        return { cloneRewardLootTable(rewards) }
    end

    if isSimpleRewardItem(rewards[1]) then
        local items = {}

        for _, reward in ipairs(rewards) do
            items[#items + 1] = { id = reward.item or reward.id, amount = reward.amount or 1 }
        end

        return { { item = items } }
    end

    local lootTables = {}

    for _, rewardLootTable in ipairs(rewards) do
        lootTables[#lootTables + 1] = cloneRewardLootTable(rewardLootTable)
    end

    return lootTables
end

---@param scriptedInteractionName? string
---@param label string
local function RegisterScriptedInteractionOption(scriptedInteractionName, label)
    if not scriptedInteractionName
        or scriptedInteractionName == ''
        or registeredScriptedInteractionNames[scriptedInteractionName]
    then
        return
    end

    registeredScriptedInteractionNames[scriptedInteractionName] = true

    STAFFGANG_SCRIPTED_INTERACTION_OPTIONS[#STAFFGANG_SCRIPTED_INTERACTION_OPTIONS + 1] = {
        label = label,
        value = scriptedInteractionName,
    }
end

---@param templateId StaffgangTemplateId
---@return fun(data: StaffgangTemplateDef)
function DEFINE_STAFFGANG_TEMPLATE(templateId)
    ---@param data StaffgangTemplateDef
    return function(data)
        assert(type(templateId) == 'string' and templateId ~= '', 'templateId is required!')
        assert(type(data) == 'table', 'template data is required!')
        assert(not STAFFGANG_FARM_TEMPLATES[templateId], ('staffgang template "%s" already defined!'):format(templateId))
        assert(data.label, 'label is required!')
        assert(data.farmType, 'farmType is required!')
        assert(data.pointType == 'sphere' or data.pointType == 'polygon', 'pointType must be "sphere" or "polygon"!')
        assert(data.minigame, 'minigame is required!')
        assert(data.rewards, 'rewards is required!')

        local minigame = data.minigame
        local shop = data.shop or {}

        local template = {
            id = templateId,
            label = data.label,
            icon = data.icon or (data.pointType == 'polygon' and 'pentagon' or 'map-pin'),
            farmType = data.farmType,
            pointType = data.pointType,
            minigamePreset = data.minigamePreset,
            isHidden = data.isHidden == true,
            requiresAllowedGroups = data.requiresAllowedGroups == true,
            mode = data.mode,
            activeTemplateId = data.activeTemplateId,
            afkTemplateId = data.afkTemplateId,
            minigame = {
                displayName = minigame.displayName or data.label,
                duration = StaffgangGetMinigameDurationForMode(templateId, data.mode, minigame.duration),
                protectionActivationDelay = STAFFGANG_MINIGAME_PROTECTION_ACTIVATION_DELAY_SECONDS,
                distance = minigame.distance or 7.0,
                scriptedInteractionName = minigame.scriptedInteractionName,
                flags = (minigame.flags or eMinigameDefFlags.MDF_NONE) | gStaffgangMinigameProtectionFlags,
                allowsVipFarmBuff = minigame.allowsVipFarmBuff,
            },
            rewards = normalizeTemplateRewards(data.rewards),
            hooks = data.hooks,
            shop = {
                mode = shop.mode or 'Sell',
                items = shop.items or {},
                title = shop.title,
                description = shop.description,
            },
        }

        STAFFGANG_FARM_TEMPLATES[templateId] = template
        STAFFGANG_FARM_TEMPLATE_ORDER[#STAFFGANG_FARM_TEMPLATE_ORDER + 1] = templateId

        RegisterScriptedInteractionOption(
            template.minigame.scriptedInteractionName,
            template.minigame.displayName
        )

        local registeredTemplate = StaffgangGetFarmTemplate(templateId)

        if not registeredTemplate then
            return
        end

        for _, handler in ipairs(templateDefinedHandlers) do
            handler(registeredTemplate)
        end
    end
end

---@return StaffgangScriptedInteractionOption[]
function StaffgangGetScriptedInteractionOptions()
    return STAFFGANG_SCRIPTED_INTERACTION_OPTIONS
end

---@param templateId StaffgangTemplateId
---@return StaffgangTemplate?
function StaffgangGetFarmTemplate(templateId)
    local data = STAFFGANG_FARM_TEMPLATES[templateId]

    if not data then
        return nil
    end

    local minigame = data.minigame or {}
    local shop = data.shop or {}

    return {
        id = templateId,
        label = data.label,
        icon = data.icon or (data.pointType == 'polygon' and 'pentagon' or 'map-pin'),
        farmType = data.farmType,
        pointType = data.pointType,
        minigamePreset = data.minigamePreset,
        isHidden = data.isHidden == true,
        requiresAllowedGroups = data.requiresAllowedGroups == true,
        mode = data.mode,
        activeTemplateId = data.activeTemplateId,
        afkTemplateId = data.afkTemplateId,
        minigame = {
            displayName = minigame.displayName,
            duration = minigame.duration,
            protectionActivationDelay = minigame.protectionActivationDelay,
            distance = minigame.distance,
            scriptedInteractionName = minigame.scriptedInteractionName,
            flags = minigame.flags or eMinigameDefFlags.MDF_NONE,
            allowsVipFarmBuff = minigame.allowsVipFarmBuff,
        },
        rewards = data.rewards or {},
        hooks = data.hooks,
        shop = {
            mode = shop.mode or 'Sell',
            items = shop.items or {},
            title = shop.title,
            description = shop.description,
        },
    }
end

---@param template StaffgangTemplate?
---@return boolean
function StaffgangTemplateHasShop(template)
    return template ~= nil
        and template.shop ~= nil
        and type(template.shop.items) == 'table'
        and #template.shop.items > 0
end

---@param template StaffgangTemplate?
---@return boolean
function StaffgangTemplateRequiresAllowedGroups(template)
    return template ~= nil and template.requiresAllowedGroups == true
end

---@param handler fun(template: StaffgangTemplate)
function StaffgangRegisterTemplateDefinedHandler(handler)
    assert(type(handler) == 'function', 'handler must be a function!')

    templateDefinedHandlers[#templateDefinedHandlers + 1] = handler

    for _, templateId in ipairs(STAFFGANG_FARM_TEMPLATE_ORDER) do
        local template = StaffgangGetFarmTemplate(templateId)

        if template then
            handler(template)
        end
    end
end
