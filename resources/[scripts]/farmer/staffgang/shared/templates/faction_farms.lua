local FACTION_FARM_SOURCES = {
    { id = 'weapons', minigameName = 'farm_weapons', icon = 'crosshairs' },
    { id = 'weed', minigameName = 'farm_weed', icon = 'cannabis' },
    { id = 'methamphetamine', minigameName = 'farm_methamphetamine', icon = 'flask' },
    { id = 'cocaine', minigameName = 'farm_cocaine', icon = 'pills' },
    { id = 'ammo', minigameName = 'farm_ammo', icon = 'box' },
    { id = 'money_laundering', minigameName = 'farm_money-laundering', icon = 'money-bill-wave' },
}

local ACTIVE_FACTION_FARM_REWARD_MULTIPLIER = 2

---@class StaffgangFactionFarmSource
---@field id string
---@field minigameName string
---@field icon string

---@class StaffgangFactionFarmTemplateData
---@field source StaffgangFactionFarmSource
---@field templateId StaffgangTemplateId
---@field label string
---@field flags number
---@field isHidden boolean
---@field mode StaffgangFarmMode
---@field activeTemplateId StaffgangTemplateId
---@field afkTemplateId StaffgangTemplateId

---@param flags number?
---@return number
local function removeRequireTaskFlag(flags)
    flags = flags or eMinigameDefFlags.MDF_NONE

    local requireTaskFlag = eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK

    if (flags & requireTaskFlag) == 0 then
        return flags
    end

    return flags - requireTaskFlag
end

---@param rewards MinigameRewardLootTableDef[]
---@return MinigameRewardLootTableDef[]
local function CloneRewardsWithActiveMultiplier(rewards)

    local clonedRewardLootTables = {}

    for lootTableIndex, rewardLootTable in ipairs(rewards) do
        local clonedRewardLootTable = table.clone(rewardLootTable)
        local clonedItems = {}

        for itemIndex, item in ipairs(rewardLootTable.item or {}) do
            local clonedItem = table.clone(item)
            clonedItem.amount = clonedItem.amount * ACTIVE_FACTION_FARM_REWARD_MULTIPLIER
            clonedItems[itemIndex] = clonedItem
        end

        clonedRewardLootTable.item = clonedItems
        clonedRewardLootTables[lootTableIndex] = clonedRewardLootTable
    end

    return clonedRewardLootTables
end

---@param data StaffgangFactionFarmTemplateData
local function defineFactionFarmTemplate(data)
    local sourceDef = assert(
        MINIGAME_DEF_DATABASE_DEF_BY_NAME[data.source.minigameName],
        ('Minigame "%s" must be defined before staffgang faction templates!'):format(data.source.minigameName)
    )

    DEFINE_STAFFGANG_TEMPLATE(data.templateId) {

        label = data.label,

        icon = data.source.icon,

        farmType = 'active',

        requiresAllowedGroups = true,

        isHidden = data.isHidden,

        mode = data.mode,

        activeTemplateId = data.activeTemplateId,

        afkTemplateId = data.afkTemplateId,

        pointType = 'polygon',

        minigamePreset = sourceDef.minigamePreset,

        minigame =
        {
            displayName = sourceDef.displayName,

            duration = sourceDef.duration,

            distance = sourceDef.distance,

            flags = data.flags,

            allowsVipFarmBuff = sourceDef.allowsVipFarmBuff,

            scriptedInteractionName = sourceDef.scriptedInteractionName,
        },

        rewards = data.mode == 'active'
            and CloneRewardsWithActiveMultiplier(sourceDef.rewards)
            or sourceDef.rewards,

        hooks = sourceDef.hooks,
    }
end

for _, source in ipairs(FACTION_FARM_SOURCES) do
    local sourceDef = assert(
        MINIGAME_DEF_DATABASE_DEF_BY_NAME[source.minigameName],
        ('Minigame "%s" must be defined before staffgang faction templates!'):format(source.minigameName)
    )

    local activeTemplateId = StaffgangBuildModeTemplateId(source.id, 'active')
    local afkTemplateId = StaffgangBuildModeTemplateId(source.id, 'afk')

    defineFactionFarmTemplate({
        source = source,
        templateId = activeTemplateId,
        label = sourceDef.displayName,
        flags = sourceDef.flags,
        isHidden = false,
        mode = 'active',
        activeTemplateId = activeTemplateId,
        afkTemplateId = afkTemplateId,
    })

    defineFactionFarmTemplate({
        source = source,
        templateId = afkTemplateId,
        label = ('%s - %s'):format(_t('staffgang.template.afk'), sourceDef.displayName),
        flags = removeRequireTaskFlag(sourceDef.flags),
        isHidden = true,
        mode = 'afk',
        activeTemplateId = activeTemplateId,
        afkTemplateId = afkTemplateId,
    })
end
