local Proxy = module("vrp","lib/Proxy")
local Tunnel = module("vrp","lib/Tunnel")
local vRP = Proxy.getInterface("vRP")

local function IsFactionPilotCity()
    if GetResourceState("inventory") ~= "started" then
        return false
    end
    return exports["inventory"]:IsFactionPilotCity() == true
end

game.menuEntries["general"] = {
    {
        icon = 'eye',
        id = 'affiliates_create_direct_ticket',
        label = _t('tickets.create_commercial_direct_ticket' ),
        onSelect = function( currentMenu, itemIndex, pEntity )

            local playerIdx = NetworkGetPlayerIndexFromPed(pEntity)
            local playerSource = GetPlayerServerId(playerIdx)

            local passport = Player( playerSource ).state['Passport']

            exports.dashboard:CreateCommercialDirectTicket({
                customerProfilePassport = tostring( passport )
            })

            return true
        end,
        isEnabled = function ( pEntity )
            return HasPermission("Afiliado")
        end
    },
    {
        icon = 'eye',
        id = 'wall_01',
        label = _t("start_wall_street"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("wallstreet:Start", { source, pEntity })
            return true
        end,
        isEnabled = function ( pEntity ) 
            return HasPermission("WallStreet")
        end
    },
    {
        icon = 'handcuffs',
        id = 'steal_shoes',
        label = _t("steal_shoes"),
        -- onEvent = 'player:checkShoes',
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("player:checkShoes", pEntity, source)
            return true
        end,
        isEnabled = function( pEntity )
            if not pEntity then return false end
            return IsEntityPlayingAnim( pEntity,"random@mugging3","handsup_standing_base", 3 )
        end
    },
    {
        -- icon = 'handcuffs',
        id = 'revive',
        label = _t("revive"),
        onEvent = "target:SetLife",
        isEnabled = function( pEntity )
            if not pEntity then return false end
            return GlobalState["AllRevive"]
                    and GetEntityHealth( pEntity ) <= 100
                    and LocalPlayer["state"]["Route"] == 1
                    and IsEntityPlayingAnim( pEntity,"misstrevor3_beatup","guard_beatup_exit_dockworker",3)
        end
    },
    {
        icon = 'search-plus',
        id = 'frisk',
        label = _t("frisk"),
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            local Selected = { source, pEntity }
            TriggerServerEvent("police:runInspect", Selected)
            return true
        end,
        isEnabled = function( pEntity )
            if not pEntity then return false end
            return not LocalPlayer["state"]["Newbie"] and not LocalPlayer["state"]["GreenMode"] and not LocalPlayer["state"]["InSafeZone"] and not LocalPlayer["state"]["PVP"]
        end
    },
    {
        id = 'cv',
        label = _t("put_in_vehicle_label"),
        icon = 'car-side',
        onEvent = 'net.vehicles.req_force_player_into',
        isEnabled = function( pEntity )
            return true
        end
    },
    {
        id = 'police_menu',
        label = _t("officer_menu"),
        menu = "police",
        icon = 'handcuffs',
        isEnabled = function( pEntity )
            return HasPermission("Policia")
        end
    },

    {
        id = 'paramedic_menu',
        label = _t("paramedic_menu"),
        menu = "paramedic",
        icon = 'user-md',
        isEnabled = function( pEntity )
            if GetEntityHealth(PlayerPedId()) <= 100 then
                return false
            end

            if HasPermission("Bombeiros") then

                -- Bombeiros possuem permissão 'Paramedic', mas não queremos que eles
                -- tenham acesso a essa opçao do menu!

                return false
            end

            return HasPermission("Paramedic")
        end
    },
    {
        icon = 'fire-extinguisher',
        id = 'bombeiros_menu',
        label = _t("bombeiros_menu"),
        menu = "bombeiros",
        isEnabled = function( pEntity )
            if GetEntityHealth(PlayerPedId()) <= 100 then
                return false
            end

            return HasPermission("Bombeiros")
        end
    },
    {
        icon = 'thumbs-up',
        id = 'like',
        label = _t("like"),
        isEnabled = function( pEntity )
            return true
        end,
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("player:MaisReputacao", source)
            return true
        end,
    },
    {
        icon = 'handshake',
        id = 'negociar',
        label = _t("negociar"),
        isEnabled = function( pEntity )
            if not IsFactionPilotCity() or HasPermission("Policia") then
                return false
            end
            return LocalPlayer["state"]["Active"] and not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"]
        end,
        onSelect = function( currentMenu, itemIndex, pEntity )
            if HasPermission("Policia") then
                return true
            end

            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local targetSource = GetPlayerServerId(index)
            local passport = Player(targetSource).state["Passport"]
            if not passport then
                return true
            end
            TriggerServerEvent("factiontrade:invite", tonumber(passport))
            return true
        end,
    },
    {
        icon = 'star',
        id = 'evaluate_player',
        label = _t("evaluate_player"),
        isEnabled = function( pEntity )
            return true
        end,
        onSelect = function( currentMenu, itemIndex, pEntity )
            local index = NetworkGetPlayerIndexFromPed(pEntity)
            local source = GetPlayerServerId(index)
            TriggerServerEvent("promoter_score:EvaluatePayer", source)
            return true
        end,
    },
    {
        icon = 'address-book',
        id = 'my_perfil',
        label = _t("open_perfil"),
        isEnabled = function( pEntity )
            return true
        end,
        onSelect = function( currentMenu, itemIndex, pEntity )
            openProfile(PlayerPedId(), true)
            return true
        end,
    },
    {
        icon = 'smile',
        id = 'open_animations',
        label = _t("open_animations"),
        menu = "animations",
        isEnabled = function( pEntity )
            return true
        end
    },
}
