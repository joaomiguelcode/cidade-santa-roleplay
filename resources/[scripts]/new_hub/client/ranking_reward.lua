local CONFIRM_EVENT_BY_RANKING = {
    social        = "social_ranking:confirmDailyVipReward",
    organizations = "social_ranking:confirmOrgVehicleReward",
}
local gOpenRankingReward = nil

RegisterNetEvent( "new_hub:openRankingReward", function( ranking )

    if not CONFIRM_EVENT_BY_RANKING[ ranking ] then
        sx.logger:warn( ("ranking reward rejected invalid ranking=%s"):format( tostring( ranking ) ) )
        return
    end

    gOpenRankingReward = ranking
    SetNuiFocus( true, true )
    SendNUIMessage( {
        action = "openRankingReward",
        data = { ranking = ranking },
    } )
end )

RegisterNUICallback( "closeRankingReward", function( _, callback )

    local ranking = gOpenRankingReward
    gOpenRankingReward = nil
    SetNuiFocus( false, false )

    local confirmEvent = ranking and CONFIRM_EVENT_BY_RANKING[ ranking ]
    if confirmEvent then
        TriggerServerEvent( confirmEvent )
    end

    callback( {} )
end )

RegisterCommand( "testrankingreward", function( _, args )
    
    local ranking = args[1]
    if not ranking then
        sx.logger:warn( "Usage: /testrankingreward <ranking>" )
        return
    end

    TriggerEvent( "new_hub:openRankingReward", ranking )
end )
