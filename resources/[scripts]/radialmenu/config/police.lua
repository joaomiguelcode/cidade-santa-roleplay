game.menuEntries["police"] = {
    {
        id = "apreender",
        label = _t("seize_items"),
        icon = 'handcuffs',
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            local Selected = { source, pEntity }
            TriggerServerEvent("police:Apreender", Selected)
            return true
        end,
        tunnel = "police",
    },
    {
        id = "AddLicense",
        label = _t("add_weapon_license"),
        icon = 'id-card',
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            local Selected = { source, pEntity }
            TriggerServerEvent("police:AddLicense", Selected)
            return true
        end,
        tunnel = "police",
    },
    {
        id = "RemLicense",
        label = _t("remove_weapon_license"),
        icon = 'id-card',
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            local Selected = { source, pEntity }
            TriggerServerEvent("police:RemLicense", Selected)
            return true
        end,
        tunnel = "police",
    },
    {
        id = "CheckLicense",
        label = _t("check_weapon_license"),
        icon = 'id-card',
        onSelect = function( currentMenu, itemIndex, pEntity )
            -- print(urrentMenu, itemIndex, pEntity)
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            local Selected = { source, pEntity }
            -- print(json.encode(Selected))
            TriggerServerEvent("police:CheckLicense", Selected)
            return true
        end,
        tunnel = "police",
    },
    -- {
    --     id = "Revive",
    --     label = _t("revive"),
    --     icon = 'medkit',
    --     tunnel = "paramedic",
    --     onSelect = function( currentMenu, itemIndex, pEntity )
    --         local index = NetworkGetPlayerIndexFromPed(pEntity)
    --         local source = GetPlayerServerId(index)
    --         TriggerServerEvent("paramedic:Revive", source)
    --         return true
    --     end,
    --     isEnabled = function( pEntity ) 
    --         local isPlayingAnim = IsEntityPlayingAnim(ped,"mini@cpr@char_a@cpr_str","cpr_pumpchest",3)
    --         return GetEntityHealth( pEntity ) <= 100 and not isPlayingAnim
    --     end
    -- },
    {
        id = "Cv",
        label = "Colocar no Veículo",
        icon = 'car-side',
        onSelect = function( currentMenu, itemIndex, pEntity )
            TriggerEvent("net.vehicles.req_force_player_into")
            return true
        end,
        tunnel = "police",
    },
}
