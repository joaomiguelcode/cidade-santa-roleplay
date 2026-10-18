DEFINE_MISSION 'parceiro_de_crime' {
    group = eMissionGroup.Criminal,
    order = 13,
    enabled = false,
    name = _t("mission.parceiro_de_crime.name"),
    description = _t("mission.parceiro_de_crime.description"),
	icon = "https://cdn.santagroup.gg/onboarding/band.svg",
	rewardIcon = {
        {
            icon = "https://cdn.santagroup.gg/onboarding/xpa.webp",
            tooltip = _t("reward.tooltip.xp_skills")
        },
        {
            icon = "https://cdn.santagroup.gg/onboarding/farm2.webp",
            tooltip = "500 farm"
        }
    },
    dependencies = {},
    flags = eMissionFlags.NONE,
    auto_activate = true,
    coords = {}, -- populated lazily after 'player' resource is ready
    rewards = {
        skills = { crime = 150, social = 150 },
        farm = 500,
    },
    metadata = {
        hook = "missions:hook:partner_crime_completed"
    },
}

CreateThread( function()
    while GetResourceState( 'player' ) ~= 'started' do Wait( 100 ) end

    local ok, coords = pcall( function()
        return exports.player:GetTypeRobberys( 'pequena' )
    end )

    if ok and type( coords ) == 'table' then
        local def = GetMissionDefinition( 'parceiro_de_crime' )
        if def then def.coords = coords end
    else
        sx.logger:warn( ( 'parceiro_de_crime: failed to populate coords (%s)' ):format( tostring( coords ) ) )
    end
end )
