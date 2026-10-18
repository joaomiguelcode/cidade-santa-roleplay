---@param templateId StaffgangTemplateId
---@return string
function StaffgangGetRuntimeMinigameName(templateId)
    return ('staffgang_template_%s'):format(templateId)
end

---@param template StaffgangTemplate
---@return MinigameHooksDef | nil hooks
local function BuildAfkTemplateHooks(template)
    if template.mode ~= 'afk' then
        return template.hooks
    end

    local hooks = { }

    for hookName, hook in pairs(template.hooks or { }) do
        hooks[hookName] = hook
    end

    local beforeComputeRewards = hooks.beforeComputeRewards

    if beforeComputeRewards == CommonBeforeComputeRewards then
        return hooks
    end

    hooks.beforeComputeRewards = function(event)
        CommonBeforeComputeRewards(event)

        if beforeComputeRewards then
            beforeComputeRewards(event)
        end
    end

    return hooks
end

StaffgangRegisterTemplateDefinedHandler(function(template)
    local defineRuntimeMinigame = DEFINE_MINIGAME(StaffgangGetRuntimeMinigameName(template.id))
    local flags = template.minigame.flags

    if template.mode == 'afk' then
        flags = flags | eMinigameDefFlags.MDF__ON_CREATE__SWITCH_TO_PRIVATE_ROUTING_BUCKET
        flags = flags | eMinigameDefFlags.MDF_REWARDS_IGNORE_INVENTORY_WEIGHT
    end

    defineRuntimeMinigame {

        displayName = template.minigame.displayName,

        minigamePreset = template.minigamePreset,

        flags = flags,

        allowsVipFarmBuff = template.minigame.allowsVipFarmBuff,

        duration = template.minigame.duration,

        protectionActivationDelay = template.minigame.protectionActivationDelay,

        distance = template.minigame.distance,

        scriptedInteractionName = template.minigame.scriptedInteractionName,

        rewards = template.rewards,

        hooks = BuildAfkTemplateHooks(template),
    }
end)
