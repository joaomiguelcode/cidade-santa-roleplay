DEFINE_MISSION 'lenda_criminal' {
    group = eMissionGroup.Criminal,
    order = 16,
    enabled = false,
    name = _t("mission.lenda_criminal.name"),
    description = _t("mission.lenda_criminal.description"),
    icon = "https://cdn.santagroup.gg/onboarding/band.svg",
    rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "1.500 farm"
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    rewards = {
        farm = 1500,
        skills = { crime = 500 },
        title = _t("mission.lenda_criminal.reward.title"),
    },
    metadata = {
        hook = "missions:hook:criminal_legend_completed",
        required_playtime_seconds = 48 * 3600,
        onBeforeComplete = function( passport, extraData )
            local playtime = vRP.GetTracking( passport ) or 0
            if playtime < ( 48 * 3600 ) then
                return false, ('Playtime insuficiente (%d/%d)'):format( playtime, 48 * 3600 )
            end

            local job = vRP.UserGroupByType( passport, 'Job' )
            if not job or job == '' then
                return false, _t("notify.no_organization")
            end

            return true
        end,
    },
}
