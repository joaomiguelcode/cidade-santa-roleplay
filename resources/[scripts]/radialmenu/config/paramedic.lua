game.menuEntries["paramedic"] = {
    {
        id = "Treatment",
        icon = 'heartbeat',
        label = _t("treatment"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:Treatment", source)
            return true
        end,
        isEnabled = function( pEntity ) 
            return GetEntityHealth(PlayerPedId()) > 100 and GetEntityHealth(pEntity) > 100
        end
    },
    {
        id = "Bandage",
        icon = 'handcuffs',
        label = _t("apply_bandages"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:Bandage", source)
            return true
        end,
        isEnabled = function( pEntity ) 
            return GetEntityHealth(PlayerPedId()) > 100 and GetEntityHealth(pEntity) > 100
        end
    },
    {
        id = "extractBlood",
        icon = 'plus-square',
        label = _t("extract_blood"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:extractBlood", source)
            return true
        end,
        isEnabled = function( pEntity ) 
            return GetEntityHealth(PlayerPedId()) > 100 and GetEntityHealth(pEntity) > 100
        end
    },
    {
        id = "Medic",
        icon = 'plus-square',
        label = _t("apply_plastic_surgery"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("barbershop:Medic", source)
            return true
        end,
        isEnabled = function( pEntity ) 
            return GetEntityHealth(PlayerPedId()) > 100 and GetEntityHealth(pEntity) > 100
        end
    },
    
    {
        id = "Revive",
        label = _t("revive"),
        icon = 'medkit',
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:Revive", source)
            return true
        end,
        isEnabled = function( pEntity ) 
            local ped = PlayerPedId()
            local isPlayingAnim = IsEntityPlayingAnim(ped,"mini@cpr@char_a@cpr_str","cpr_pumpchest",3)
            return GetEntityHealth(ped) > 100 and GetEntityHealth( pEntity ) <= 100 and not isPlayingAnim
        end
    },
    
    {
        id = "Diagnostic",
        label = _t("diagnostic"),
        icon = 'plus-square',
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("paramedic:Diagnostic", source)
            return true
        end,
    },
}
