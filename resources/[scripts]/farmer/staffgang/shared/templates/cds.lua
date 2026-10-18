local CDS_REWARDS = {
    { item = 'cereais', amount = 12 },
}

local CDS_TEMPLATE_ID = 'cds'
local ACTIVE_CDS_TEMPLATE_ID = StaffgangBuildModeTemplateId(CDS_TEMPLATE_ID, 'active')
local AFK_CDS_TEMPLATE_ID = StaffgangBuildModeTemplateId(CDS_TEMPLATE_ID, 'afk')

---@class StaffgangCdsTemplateData
---@field templateId StaffgangTemplateId
---@field mode StaffgangFarmMode
---@field isHidden boolean
---@field flags number

---@param data StaffgangCdsTemplateData
local function defineCdsTemplate(data)
    DEFINE_STAFFGANG_TEMPLATE(data.templateId) {

        label = _t('staffgang.template.cds'),

        icon = 'map-pin',

        farmType = 'cds',

        isHidden = data.isHidden,

        mode = data.mode,

        activeTemplateId = ACTIVE_CDS_TEMPLATE_ID,

        afkTemplateId = AFK_CDS_TEMPLATE_ID,

        pointType = 'sphere',

        minigame =
        {
            displayName = _t('staffgang.template.cds'),

            duration = 30,

            distance = 7.0,

            flags = data.flags,

            scriptedInteractionName = 'generic_collecting_from_ground',
        },

        rewards = CDS_REWARDS,
    }
end

defineCdsTemplate({
    templateId = ACTIVE_CDS_TEMPLATE_ID,
    mode = 'active',
    isHidden = false,
    flags = eMinigameDefFlags.MDF__BEFORE_START__REQUIRE_TASK,
})

defineCdsTemplate({
    templateId = AFK_CDS_TEMPLATE_ID,
    mode = 'afk',
    isHidden = true,
    flags = eMinigameDefFlags.MDF_NONE,
})
