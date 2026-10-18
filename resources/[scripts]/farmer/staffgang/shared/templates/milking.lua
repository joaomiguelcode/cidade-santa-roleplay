local MILKING_REWARDS = {
    { item = 'milkbottle', amount = 1 },
}

local MILKING_TEMPLATE_ID = 'milking'
local MILKING_NO_TASK_TEMPLATE_ID = 'milking_no_task'
local ACTIVE_MILKING_TEMPLATE_ID = StaffgangBuildModeTemplateId(MILKING_TEMPLATE_ID, 'active')
local AFK_MILKING_TEMPLATE_ID = StaffgangBuildModeTemplateId(MILKING_TEMPLATE_ID, 'afk')
local MILKING_SOURCE_DEF_BY_MODE = {
    active = assert(
        MINIGAME_DEF_DATABASE_DEF_BY_NAME[MILKING_TEMPLATE_ID],
        'Minigame "milking" must be defined before staffgang milking template!'
    ),
    afk = assert(
        MINIGAME_DEF_DATABASE_DEF_BY_NAME[MILKING_NO_TASK_TEMPLATE_ID],
        'Minigame "milking_no_task" must be defined before staffgang milking template!'
    ),
}

local MILKING_SHOP = {
    mode = 'Sell',
    items = { { item = 'milkbottle', price = 2000 } },
}

local MILKING_FLAGS = eMinigameDefFlags.MDF_FLAG_PLAYER_INVINCIBLE | eMinigameDefFlags.MDF_FLAG_COLLISION_ENTITIES

---@class StaffgangMilkingTemplateData
---@field templateId StaffgangTemplateId
---@field mode StaffgangFarmMode
---@field isHidden boolean
---@field flags number

---@param data StaffgangMilkingTemplateData
local function defineMilkingTemplate(data)
    local sourceDef = assert(
        MILKING_SOURCE_DEF_BY_MODE[data.mode],
        ('Invalid staffgang milking mode "%s"!'):format(data.mode)
    )

    DEFINE_STAFFGANG_TEMPLATE(data.templateId) {

        label = _t('staffgang.template.milkingNoTask'),

        icon = 'cow',

        farmType = 'milking',

        isHidden = data.isHidden,

        mode = data.mode,

        activeTemplateId = ACTIVE_MILKING_TEMPLATE_ID,

        afkTemplateId = AFK_MILKING_TEMPLATE_ID,

        pointType = 'polygon',

        minigamePreset = 'milking_no_task',

        minigame =
        {
            displayName = _t('staffgang.template.milkingNoTask'),

            duration = sourceDef.duration,

            distance = sourceDef.distance,

            flags = data.flags,

            scriptedInteractionName = sourceDef.scriptedInteractionName,
        },

        rewards = MILKING_REWARDS,

        shop = MILKING_SHOP,
    }
end

defineMilkingTemplate({
    templateId = ACTIVE_MILKING_TEMPLATE_ID,
    mode = 'active',
    isHidden = false,
    flags = MILKING_FLAGS | eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK,
})

defineMilkingTemplate({
    templateId = AFK_MILKING_TEMPLATE_ID,
    mode = 'afk',
    isHidden = true,
    flags = MILKING_FLAGS,
})
