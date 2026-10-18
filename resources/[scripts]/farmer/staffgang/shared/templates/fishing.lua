local FISHING_TEMPLATE_ID = 'fishing'
local ACTIVE_FISHING_TEMPLATE_ID = StaffgangBuildModeTemplateId(FISHING_TEMPLATE_ID, 'active')
local AFK_FISHING_TEMPLATE_ID = StaffgangBuildModeTemplateId(FISHING_TEMPLATE_ID, 'afk')
local FISHING_SOURCE_DEF = assert(
    MINIGAME_DEF_DATABASE_DEF_BY_NAME[FISHING_TEMPLATE_ID],
    'Minigame "fishing" must be defined before staffgang fishing template!'
)

local FISHING_SHOP = {
    mode = 'Sell',
    items = {
        { item = 'octopus', price = 5875 },
        { item = 'shrimp', price = 6020 },
        { item = 'carp', price = 7000 },
        { item = 'horsefish', price = 3000 },
        { item = 'tilapia', price = 5500 },
        { item = 'codfish', price = 6100 },
        { item = 'catfish', price = 6320 },
        { item = 'goldenfish', price = 6201 },
        { item = 'pirarucu', price = 5700 },
        { item = 'pacu', price = 5500 },
        { item = 'tambaqui', price = 5900 },
    },
}

---@class StaffgangFishingTemplateData
---@field templateId StaffgangTemplateId
---@field mode StaffgangFarmMode
---@field isHidden boolean
---@field flags number

---@param data StaffgangFishingTemplateData
local function defineFishingTemplate(data)
    DEFINE_STAFFGANG_TEMPLATE(data.templateId) {

        label = _t('staffgang.template.fishing'),

        icon = 'fish',

        farmType = 'fishing',

        isHidden = data.isHidden,

        mode = data.mode,

        activeTemplateId = ACTIVE_FISHING_TEMPLATE_ID,

        afkTemplateId = AFK_FISHING_TEMPLATE_ID,

        pointType = 'polygon',

        minigamePreset = 'fishing',

        minigame =
        {
            displayName = _t('staffgang.template.fishing'),

            duration = FISHING_SOURCE_DEF.duration,

            distance = FISHING_SOURCE_DEF.distance,

            flags = data.flags,

            scriptedInteractionName = FISHING_SOURCE_DEF.scriptedInteractionName,
        },

        rewards = FISHING_SOURCE_DEF.rewards,

        shop = FISHING_SHOP,
    }
end

defineFishingTemplate({
    templateId = ACTIVE_FISHING_TEMPLATE_ID,
    mode = 'active',
    isHidden = false,
    flags = FISHING_SOURCE_DEF.flags | eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK,
})

defineFishingTemplate({
    templateId = AFK_FISHING_TEMPLATE_ID,
    mode = 'afk',
    isHidden = true,
    flags = FISHING_SOURCE_DEF.flags,
})
