game.menuEntries["bombeiros"] = {
    {
        id = "Revive",
        icon = 'heartbeat',
        label = _t("revive"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:Revive", source)
            return true
        end,
        tunnel = "paramedic",
        isEnabled = function( pEntity )
            local ped = PlayerPedId()
            local isPlayingAnim = IsEntityPlayingAnim(ped,"mini@cpr@char_a@cpr_str","cpr_pumpchest",3)
            return GetEntityHealth(ped) > 100 and GetEntityHealth( pEntity ) <= 100 and not isPlayingAnim
        end
    },
    {
        id = "treatment",
        icon = 'heartbeat',
        label = _t("treatment"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:Treatment", source)
            return true
        end,
        tunnel = "paramedic",
        isEnabled = function( pEntity ) 
            return GetEntityHealth(PlayerPedId()) > 100 and GetEntityHealth( pEntity ) > 100
        end
    }
}
