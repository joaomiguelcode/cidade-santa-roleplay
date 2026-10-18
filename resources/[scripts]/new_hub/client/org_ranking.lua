-- NUI bridge for the Ranking das Organizações: expose the player's LIVE Job (vRP group,
-- replicated on the player state bag) so the hub identifies the viewer's org when calling the
-- RankingAPI. The live Job is the membership truth — painel_members rows can lag behind it.

RegisterNUICallback( 'getMyOrgJob', function( _, callback )

    local job = LocalPlayer.state.Job
    if type( job ) ~= 'string' or job == '' then
        callback( { job = false } )
        return
    end

    callback( { job = job } )
end )
