-- Client entrypoint. Owns the whole lifecycle: startup wires the active modules, shutdown tears them
-- down. Each module exposes Init…/Teardown… functions (the logic touches that file's locals); main is
-- the single place that orchestrates them, like an app's main(). Loaded last so every module's
-- functions are defined by the time these run.

CreateThread( function()

    while not (sx and sx.logger) do
        Wait( 50 )
    end

    if IsSocialRankingCityEnabled() then
        InitSocialPodiumRenderer() -- peds.lua: render zone + seed + mount + draw/emote tick
    else
        sx.logger:info( "social ranking podium renderer disabled for this city" )
    end

    InitSocialRewardVisuals()  -- reward_visuals.lua: worn rank aura/nametag reconciler (data-derived, by source)
end )

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    TerminateSocialPodiumRenderer() -- peds.lua: despawn peds, stop the tick, drop the zone
    TerminateSocialRewardVisuals()  -- reward_visuals.lua: clear every worn aura/nametag from the sx host
    ClearPodiumCards()         -- cards.lua: drop cards + DUIs, stop the draw tick
end )
