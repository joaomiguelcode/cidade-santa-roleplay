-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRPS = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("dynamic")
SafeMode = GetConvar("SafeMode", "")
cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local menuOpen = false

---@param reason string
local function NotifyCollectibleStateChangeFailure( reason )

    local descriptionKey = ('collectibles.failure.%s'):format( reason )
    TriggerEvent( 'Notify', 'negado', _t( descriptionKey ), 5000, _t( 'collectibles.failure.title' ) )
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
exports("AddButton", function(title, description, trigger, par, id, server, link)
	SendNUIMessage({ addbutton = true, title = title, description = description, trigger = trigger, par = par, id = id, server = server, link = link })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SUBMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("SubMenu", function(title, description, id)
	SendNUIMessage({ addmenu = true, title = title, description = description, menuid = id })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENMENU
-----------------------------------------------------------------------------------------------------------------------------------------
exports("openMenu", function()
	SendNUIMessage({ show = true })
	SetNuiFocus(true, true)
	menuOpen = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENURL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("OpenUrl", function(link)
	if type(link) ~= "string" or link == "" then
		return
	end

	SendNUIMessage({ openUrl = link })
end)

RegisterNetEvent("dynamic:OpenUrl")
AddEventHandler("dynamic:OpenUrl", function(link)
	exports["dynamic"]:OpenUrl(link)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLICKED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("clicked", function(Data, Callback)
	if Data["trigger"] and Data["trigger"] ~= "" then
		if Data["server"] == "true" then
			TriggerServerEvent(Data["trigger"], Data["param"])
		else
			TriggerEvent(Data["trigger"], Data["param"])
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close", function(Data, Callback)
	SetNuiFocus(false, false)
	menuOpen = false

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DYNAMIC:CLOSESYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("dynamic:closeSystem")
AddEventHandler("dynamic:closeSystem", function()
	if menuOpen then
		SendNUIMessage({ close = true })
		SetNuiFocus(false, false)
		menuOpen = false
	end
end)

RegisterNetEvent( 'scripted_interactions:client:stateChangeFailed', function( reason )

    NotifyCollectibleStateChangeFailure( reason )
end )

RegisterNetEvent( 'dynamic:changeCollectibleState', function( params )

    if type( params ) ~= 'table' then
        NotifyCollectibleStateChangeFailure( 'invalid_request' )
        return
    end

    TriggerServerEvent( 'scripted_interactions:server:changeScriptedInteractionState', params.slot, params.stateName )
end )

---@param interactionName string
---@param translationKey string | nil
---@param fallback string
---@return string
local function GetCollectibleStateTranslation( interactionName, translationKey, fallback )

    if translationKey and interactionName:find( '^collectible_pet_' ) then
        local petTranslation = exports.scripted_interactions:GetPetTranslation( translationKey )

        if petTranslation then
            return petTranslation
        end
    end

    return translationKey and _t( translationKey ) or fallback
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("globalFunctions", function()
    if (LocalPlayer.state.Racing) then
        return
    end

    local minigame = LocalPlayer["state"]["minigame:active"]

    if minigame and minigame ~= "Domination" then
        return
    end


    if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and LocalPlayer["state"]["Route"] < 900000 and not IsPauseMenuActive() then
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)

        -- Fetch the current language from the Convar
        local lang = GetConvar("language", "pt-br") or "pt-br"

        -- Add buttons and submenu with translation support
        exports["dynamic"]:AddButton(_t("mansion_alarm"), _t("toggle_alarm"), "mansion_alarm:ToggleAlarm", false, "others", true)

        if SafeMode == "true" then
            if LocalPlayer["state"]["Route"] == 7 then
                exports["dynamic"]:AddButton(_t("safe_world"), _t("exit_safe_world"), "SafeWorld:Enter", false, "others", true)
            else
                exports["dynamic"]:AddButton(_t("safe_world"), _t("enter_safe_world"), "SafeWorld:Enter", false, "others", true)
            end
            if GlobalState["WarModeBucket"] then
                if not Entity(Ped)["state"]["WarMode"] and not LocalPlayer["state"]["InSafeZone"] then
                    if not LocalPlayer["state"]["Newbie"] then
                        exports["dynamic"]:AddButton(_t("war_mode"), _t("enter_war_mode"), "WarMode:Enter", false, "others", true)
                    end
                end
            else
                if not Entity(Ped)["state"]["WarMode"] and not LocalPlayer["state"]["InSafeZone"] then
                    if not LocalPlayer["state"]["Newbie"] then
                        exports["dynamic"]:AddButton(_t("war_mode"), _t("enter_war_mode"), "WarMode:Enter", false, "others", true)
                    end
                end
            end
        end

        if GetEntityHealth(Ped) > 100 then
            -- Add more buttons using translation
            if not LocalPlayer["state"]["Plaster"] then
                exports["dynamic"]:AddButton("<yellow>" .. _t("wardrobe") .. "</yellow>", "<yellow>" .. _t("save_use_outfits") .. "</yellow>.", "dynamic:Clothes", "", "clothes", false)
                exports["dynamic"]:AddButton(_t("hat"), _t("hat"), "player:Outfit", "2", "clothes", true)
                exports["dynamic"]:AddButton(_t("mask"), _t("mask"), "player:Outfit", "1", "clothes", true)
                exports["dynamic"]:AddButton(_t("glasses"), _t("glasses"), "player:Outfit", "3", "clothes", true)
                exports["dynamic"]:AddButton(_t("wear_outfit"), _t("wear_outfit"), "player:Outfit", "aplicar", "clothes", true)
                exports["dynamic"]:AddButton(_t("save_outfit"), _t("save_outfit"), "player:Outfit", "salvar", "clothes", true)
            end

            exports["dynamic"]:AddButton(_t("mark_properties"), _t("mark_properties"), "propertys:Blips", "", "others", false)
            exports["dynamic"]:AddButton(_t("injury_check"), _t("injury_check"), "paramedic:Injuries", "", "others", false)
            if not GlobalState["WarMode"] and SafeMode == "true" then
                exports["dynamic"]:AddButton(_t("safemode"), _t("toggle_safemode"), "safezone:updateNewbie", "", "others", false)
            end
            exports["dynamic"]:AddButton(_t("reload_character"), _t("reload_character"), "player:Debug", "", "others", true)

            local switchableInteractions = exports["scripted_interactions"]:getSwitchableScriptedInteractions()

            if #switchableInteractions > 0 then
                for _, interaction in ipairs( switchableInteractions ) do
                    for _, state in ipairs( interaction.states ) do
                        local stateTitle = GetCollectibleStateTranslation( interaction.interactionName, state.title, state.name )
                        local title = stateTitle
                        local description = GetCollectibleStateTranslation( interaction.interactionName, state.description, stateTitle )

                        exports["dynamic"]:AddButton( title, description, "dynamic:changeCollectibleState", {
                            slot = interaction.slot,
                            stateName = state.name,
                        }, "collectibles", false )
                    end
                end

                exports["dynamic"]:SubMenu( _t( "collectibles.submenu.title" ), _t( "collectibles.submenu.description" ), "collectibles" )
            end

            local Vehicle = vRP.ClosestVehicle(7)
            if IsEntityAVehicle(Vehicle) then
                if not IsPedInAnyVehicle(Ped) then
                    exports["dynamic"]:AddButton(_t("tow_vehicle"), _t("tow_vehicle"), "towdriver:invokeTow", "", "vehicle", false)

                    if vRP.ClosestPed(3) then
                        exports["dynamic"]:AddButton(_t("player_into_vehicle"), _t("player_into_vehicle"), "net.vehicles.req_force_player_into", "", "closestpeds", false)

                        exports["dynamic"]:SubMenu(_t("player"), _t("player"), "closestpeds")
                    end
                else
                    exports["dynamic"]:AddButton(_t("sit_driver"), _t("sit_driver"), "player:seatPlayer", "0", "vehicle", false)
                    exports["dynamic"]:AddButton(_t("sit_passenger"), _t("sit_passenger"), "player:seatPlayer", "1", "vehicle", false)
                    exports["dynamic"]:AddButton(_t("sit_other"), _t("sit_other"), "player:seatPlayer", "2", "vehicle", false)
                    exports["dynamic"]:AddButton(_t("status_vehicle_window"), _t("status_vehicle_window"), "player.prepare_set_vehicle_window_state_request", "", "vehicle", false)
                    exports["dynamic"]:AddButton(_t("driver_door"), _t("driver_door"), "player.prepare_set_vehicle_door_shut_state_request", "0", "doors", false)
                    exports["dynamic"]:AddButton(_t("passenger_door"), _t("passenger_door"), "player.prepare_set_vehicle_door_shut_state_request", "1", "doors", false)
                    exports["dynamic"]:AddButton(_t("rear_left_door"), _t("rear_left_door"), "player.prepare_set_vehicle_door_shut_state_request", "2", "doors", false)
                    exports["dynamic"]:AddButton(_t("rear_right_door"), _t("rear_right_door"), "player.prepare_set_vehicle_door_shut_state_request", "3", "doors", false)
                    exports["dynamic"]:AddButton(_t("trunk"), _t("trunk"), "player.prepare_set_vehicle_door_shut_state_request", "5", "doors", false)
                    exports["dynamic"]:AddButton(_t("hood"), _t("hood"), "player.prepare_set_vehicle_door_shut_state_request", "4", "doors", false)
                end

                exports["dynamic"]:SubMenu(_t("vehicle"), _t("vehicle"), "vehicle")
                exports["dynamic"]:SubMenu(_t("doors"), _t("doors"), "doors")
            end

            exports["dynamic"]:SubMenu(_t("player"), _t("player"), "player")
            exports["dynamic"]:SubMenu(_t("clothes_menu"), _t("clothes_menu"), "clothes")
            exports["dynamic"]:SubMenu(_t("others"), _t("others"), "others")

            exports["dynamic"]:openMenu()
        end
    end
end)

local TIME_TO_CHANGE_WEAR = 5000

---@param customization table
function ChangeWearByCustomization(customization)
    TriggerEvent("vrp:removeObjects")

    if not customization then
        return TriggerEvent("Notify", 'Warning', _t('wear.error.not.configurable.yet.description'), 5000, _t('wear.error.not.configurable.yet.title'))
    end

    vRP.playAnim(false, {"move_m@_idles@shake_off", "shakeoff_1"}, false)
    Wait(TIME_TO_CHANGE_WEAR)
    vRP.stopAnim(false)
    TriggerEvent("skinshop:Apply", customization, nil, nil, true)
    TriggerEvent("Notify", 'Confirmed', _t('wear.success.description'), 5000, _t('wear.success.title'))
end

exports('wearUniform', ChangeWearByCustomization)

AddEventHandler('dynamic.skinshop.apply.uniform', function()
    TriggerEvent("dynamic:closeSystem")
    ChangeWearByCustomization(exports["painel"]:GetWearUniform())
end)

---@param group string
---@return boolean
local function HasGroup(group)
    local groups = vRP.GetPlayerGroups() or {}
    local groupsParent = Groups[group] and Groups[group]["Parent"]

    if groups[group] then
        return true
    end

    if groupsParent then
        for parentGroup, _ in pairs(groupsParent) do
            if groups[parentGroup] then
                return true
            end
        end
    end

    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCYFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("emergencyFunctions", function()
    if (LocalPlayer["state"]["minigame:active"]) then
        return
    end

    if exports.dashboard:BlockIfInRestrictWorld() then
        return
    end

    if LocalPlayer["state"]["PVP"] then
        TriggerEvent("matchmaking:Leave")
        return
    end

    local isPolice = HasGroup("Policia")
    local isParamedic = HasGroup("Paramedic")
    local isBombeiros = HasGroup("Bombeiros")
    local isMechanic = HasGroup("Mechanic")

	if (isPolice or isParamedic or isBombeiros or isMechanic) and not IsPauseMenuActive() then
		if not LocalPlayer["state"]["Commands"] and not LocalPlayer["state"]["Handcuff"] and not menuOpen and LocalPlayer["state"]["Route"] < 900000 then
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) > 100 then
                -- exports["dynamic"]:SubMenu(_t('wear.uniform.submenu.title'),_t('wear.uniform.submenu.description'), "wear-uniform")
                -- exports["dynamic"]:AddButton(_t('wear.uniform.button.title'), _t('wear.uniform.button.description'), "dynamic.skinshop.apply.uniform", "", "wear-uniform", false)

                if not IsPedInAnyVehicle(Ped) then
                    exports["dynamic"]:AddButton(_t("carry_person"), _t("carry_person"), "player.carry.request_to_carry_the_nearest_player", "", "player", false)
                    exports["dynamic"]:AddButton(_t("player_into_vehicle"), _t("player_into_vehicle"), "net.vehicles.req_force_player_into", "", "player", false)
                    exports["dynamic"]:SubMenu(_t("player"), _t("player"), "player")
                end

				if isPolice then
                    if cityName == "Santa" then
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 4", "Fardamento tatico 4.", "player:Preset", "tatico 4", "preTatico", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 4", "Fardamento pm 4.", "player:Preset", "pm 4", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 5", "Fardamento pm 5.", "player:Preset", "pm 5", "prePM", true)
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 4", "Fardamento civil 4.", "player:Preset", "civil 4", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:AddButton("PRF 1", "Fardamento PRF 1.", "player:Preset", "prf 1", "prePrf", true)
                        -- exports["dynamic"]:AddButton("PRF 2", "Fardamento PRF 2.", "player:Preset", "prf 2", "prePrf", true)

                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                        -- exports["dynamic"]:SubMenu("Fardamento PRF", "Todos os fardamentos PRF.", "prePrf")
                    elseif cityName == "Maresia" then
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    elseif cityName == "CidadeNobre" then
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 4", "Fardamento civil 4.", "player:Preset", "civil 4", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 5", "Fardamento civil 5.", "player:Preset", "civil 5", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PRN 1", "Fardamento PRN 1.", "player:Preset", "prn 1", "prePrf", true)
                        -- exports["dynamic"]:AddButton("PRN 2", "Fardamento PRN 2.", "player:Preset", "prn 2", "prePrf", true)
                        -- exports["dynamic"]:AddButton("PRN 3", "Fardamento PRN 3.", "player:Preset", "prn 3", "prePrf", true)
                        -- exports["dynamic"]:AddButton("PRN 4", "Fardamento PRN 4.", "player:Preset", "prn 4", "prePrf", true)
                        -- exports["dynamic"]:AddButton("PRN 5", "Fardamento PRN 5.", "player:Preset", "prn 5", "prePrf", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 4", "Fardamento pm 4.", "player:Preset", "pm 4", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 5", "Fardamento pm 5.", "player:Preset", "pm 5", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 4", "Fardamento tatico 4.", "player:Preset", "tatico 4", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 5", "Fardamento tatico 5.", "player:Preset", "tatico 5", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 4", "Fardamento exercito 4.", "player:Preset", "exercito 4", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 5", "Fardamento exercito 5.", "player:Preset", "exercito 5", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PRN", "Todos os fardamentos PRN.", "prePrf")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    elseif cityName == "Boomerang" then
                        -- exports["dynamic"]:AddButton("Investigative 1", "Investigative outfit 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Investigative 2", "Investigative outfit 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Investigative 3", "Investigative outfit 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 1", " Police outfit 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 2", " Police outfit 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 3", " Police outfit 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tactical 1", "Tactical outfit 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tactical 2", "Tactical outfit 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tactical 3", "Tactical outfit 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Army outfit 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Army outfit 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Army outfit 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Investigative Outfit", "All civil outfits.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Police Outfit", "All pm outfits.", "prePM")
                        -- exports["dynamic"]:SubMenu("Tactical Outfit", "All tactical outfits.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Army Outfit", "All army outfits.", "preExercito")
                    elseif cityName == "Grande" then
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    elseif cityName == "Malta" then
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos policia.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    elseif cityName == "Kingdom" then
                        -- exports["dynamic"]:AddButton("Police 1", "Civil outfit 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 2", "Civil outfit 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 3", "Civil outfit 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 1", "PM outfit 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 2", "PM outfit 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 3", "PM outfit 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 4", "PM outfit 4.", "player:Preset", "pm 4", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tactical 1", "Tactical outfit 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tactical 2", "Tactical outfit 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tactical 3", "Tactical outfit 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "BAEP outfit 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "BAEP outfit 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "BAEP outfit 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "ROTA outfit 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "ROTA outfit 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "ROTA outfit 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Army 1", "Army outfit 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Army 2", "Army outfit 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Army 3", "Army outfit 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Police 1", "All civil outfits.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Police 2", "All PM outfits.", "prePM")
                        -- exports["dynamic"]:SubMenu("Tactical Outfit", "All tactical outfits.", "preTatico")
                        -- exports["dynamic"]:SubMenu("BAEP Outfit", "All BAEP outfits.", "preBaep")
                        -- exports["dynamic"]:SubMenu("ROTA Outfit", "All ROTA outfits.", "preRota")
                        -- exports["dynamic"]:SubMenu("Army Outfit", "All army outfits.", "preExercito")
                    elseif cityName == "Royal" then
                        -- exports["dynamic"]:AddButton("Police 1", "Civil outfit 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 2", "Civil outfit 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 3", "Civil outfit 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Police 1", "PM outfit 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 2", "PM outfit 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 3", "PM outfit 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Police 4", "PM outfit 4.", "player:Preset", "pm 4", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tactical 1", "Tactical outfit 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tactical 2", "Tactical outfit 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tactical 3", "Tactical outfit 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "BAEP outfit 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "BAEP outfit 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "BAEP outfit 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "ROTA outfit 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "ROTA outfit 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "ROTA outfit 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Army 1", "Army outfit 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Army 2", "Army outfit 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Army 3", "Army outfit 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Police 1", "All civil outfits.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Police 2", "All PM outfits.", "prePM")
                        -- exports["dynamic"]:SubMenu("Tactical Outfit", "All tactical outfits.", "preTatico")
                        -- exports["dynamic"]:SubMenu("BAEP Outfit", "All BAEP outfits.", "preBaep")
                        -- exports["dynamic"]:SubMenu("ROTA Outfit", "All ROTA outfits.", "preRota")
                        -- exports["dynamic"]:SubMenu("Army Outfit", "All army outfits.", "preExercito")
                    elseif cityName == "Real" then
                        -- exports["dynamic"]:AddButton("Policía 1", "Guardia Civil.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Policía 2", "Guardia Civil.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Policía 3", "Guardia Civil.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Policía Nacional.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Policía Nacional.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Policía Nacional.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Policía Municipal.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Policía Municipal.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Policía Municipal.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Ejército.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Ejército.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Ejército.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Guardia Civil", "Ropa del Guardia Civil de Real.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Policía Municipal", "Ropa del Policía Nacional de Real.", "prePM")
                        -- exports["dynamic"]:SubMenu("Policía Municipal", "Ropa del Policía Municipal de Real.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Ejército de Real", "Ropa del Ejército de Real.", "preExercito")
                    elseif cityName == "Alexandria" then
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    elseif cityName == "Universo" then
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("PRF 1", "Fardamento PRF.", "player:Preset", "prf 1", "prePRF", true)
                        -- exports["dynamic"]:AddButton("PRF 2", "Fardamento PRF.", "player:Preset", "prf 2", "prePRF", true)
                        -- exports["dynamic"]:AddButton("PRF 3", "Fardamento PRF.", "player:Preset", "prf 3", "prePRF", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Juridico 1", "Fardamento Juridico.", "player:Preset", "juridico 1", "preJuridico", true)
                        -- exports["dynamic"]:AddButton("Juridico 2", "Fardamento Juridico.", "player:Preset", "juridico 2", "preJuridico", true)
                        -- exports["dynamic"]:AddButton("Juridico 3", "Fardamento Juridico.", "player:Preset", "juridico 3", "preJuridico", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento PRF", "Todos os fardamentos prf.", "prePRF")
                        -- exports["dynamic"]:SubMenu("Fardamento Juridico", "Todos os fardamentos juridico.", "preJuridico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    else
                        -- exports["dynamic"]:AddButton("Civil 1", "Fardamento civil 1.", "player:Preset", "civil 1", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 2", "Fardamento civil 2.", "player:Preset", "civil 2", "preCivil", true)
                        -- exports["dynamic"]:AddButton("Civil 3", "Fardamento civil 3.", "player:Preset", "civil 3", "preCivil", true)
                        -- exports["dynamic"]:AddButton("PM 1", "Fardamento pm 1.", "player:Preset", "pm 1", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 2", "Fardamento pm 2.", "player:Preset", "pm 2", "prePM", true)
                        -- exports["dynamic"]:AddButton("PM 3", "Fardamento pm 3.", "player:Preset", "pm 3", "prePM", true)
                        -- exports["dynamic"]:AddButton("Tático 1", "Fardamento tatico 1.", "player:Preset", "tatico 1", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 2", "Fardamento tatico 2.", "player:Preset", "tatico 2", "preTatico", true)
                        -- exports["dynamic"]:AddButton("Tático 3", "Fardamento tatico 3.", "player:Preset", "tatico 3", "preTatico", true)
                        -- exports["dynamic"]:AddButton("BAEP 1", "Fardamento BAEP 1.", "player:Preset", "baep 1", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 2", "Fardamento BAEP 2.", "player:Preset", "baep 2", "preBaep", true)
                        -- exports["dynamic"]:AddButton("BAEP 3", "Fardamento BAEP 3.", "player:Preset", "baep 3", "preBaep", true)
                        -- exports["dynamic"]:AddButton("ROTA 1", "Fardamento ROTA 1.", "player:Preset", "rota 1", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 2", "Fardamento ROTA 2.", "player:Preset", "rota 2", "preRota", true)
                        -- exports["dynamic"]:AddButton("ROTA 3", "Fardamento ROTA 3.", "player:Preset", "rota 3", "preRota", true)
                        -- exports["dynamic"]:AddButton("Exército 1", "Fardamento exercito 1.", "player:Preset", "exercito 1", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 2", "Fardamento exercito 2.", "player:Preset", "exercito 2", "preExercito", true)
                        -- exports["dynamic"]:AddButton("Exército 3", "Fardamento exercito 3.", "player:Preset", "exercito 3", "preExercito", true)
                        -- exports["dynamic"]:SubMenu("Fardamento Civil", "Todos os fardamentos civil.", "preCivil")
                        -- exports["dynamic"]:SubMenu("Fardamento PM", "Todos os fardamentos pm.", "prePM")
                        -- exports["dynamic"]:SubMenu("Fardamento Tático", "Todos os fardamentos tatico.", "preTatico")
                        -- exports["dynamic"]:SubMenu("Fardamento BAEP", "Todos os fardamentos BAEP.", "preBaep")
                        -- exports["dynamic"]:SubMenu("Fardamento ROTA", "Todos os fardamentos ROTA.", "preRota")
                        -- exports["dynamic"]:SubMenu("Fardamento Exército", "Todos os fardamentos exército.", "preExercito")
                    end
					exports["dynamic"]:AddButton(_t("remove_mask"), _t("remove_mask_desc"), "net.clothes.req_set_component_from_ped", "1", "player", false)
					exports["dynamic"]:AddButton(_t("remove_hat"), _t("remove_hat_desc"), "net.clothes.req_set_component_from_ped", "2", "player", false)
					exports["dynamic"]:AddButton(_t("remove_glasses"), _t("remove_glasses_desc"), "net.clothes.req_set_component_from_ped", "3", "player", false)
					exports["dynamic"]:AddButton(_t("computer"), _t("computer_desc"), "police:Mdt", "", false, false)
                elseif isBombeiros then
                        -- exports["dynamic"]:AddButton(_t("firefighter_1"), _t("firefighter_1_desc"), "player:Preset", "bombeiros 1", "prebombeiros", true)
                        -- exports["dynamic"]:AddButton(_t("firefighter_2"), _t("firefighter_2_desc"), "player:Preset", "bombeiros 2", "prebombeiros", true)
                        -- exports["dynamic"]:AddButton(_t("firefighter_3"), _t("firefighter_3_desc"), "player:Preset", "bombeiros 3", "prebombeiros", true)

					exports["dynamic"]:SubMenu(_t("firefighter_uniforms"), _t("firefighter_uniforms_desc"), "prebombeiros")
                    
				elseif isParamedic then
					-- exports["dynamic"]:AddButton(_t("intern_uniform"), _t("intern_uniform_desc"), "player:Preset", "estagiários", "preMedic", true)
					-- exports["dynamic"]:AddButton(_t("paramedic_1"), _t("paramedic_1_desc"), "player:Preset", "paramédico 1", "preMedic", true)
					-- exports["dynamic"]:AddButton(_t("paramedic_2"), _t("paramedic_2_desc"), "player:Preset", "paramédico 2", "preMedic", true)
					-- exports["dynamic"]:AddButton(_t("nurse"), _t("nurse_desc"), "player:Preset", "enfermeiros", "preMedic", true)
					-- exports["dynamic"]:AddButton(_t("doctor"), _t("doctor_desc"), "player:Preset", "médico", "preMedic", true)

					exports["dynamic"]:SubMenu(_t("medic_uniforms"), _t("medic_uniforms_desc"), "preMedic")

                
                    
				elseif isMechanic then
                    if cityName == "CidadeNobre" then
                        -- exports["dynamic"]:AddButton(_t("mechanic_member"), _t("mechanic_member_desc"), "player:Preset", "membro", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_advisor"), _t("mechanic_advisor_desc"), "player:Preset", "conselheiro", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_manager"), _t("mechanic_manager_desc"), "player:Preset", "gerente", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_subchief"), _t("mechanic_subchief_desc"), "player:Preset", "sub-chefe", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_chief"), _t("mechanic_chief_desc"), "player:Preset", "chefe", "preMechanic", true)
                    else
                        -- exports["dynamic"]:AddButton(_t("mechanic_member"), _t("mechanic_member_desc"), "player:Preset", "membro", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_advisor"), _t("mechanic_advisor_desc"), "player:Preset", "conselheiro", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_manager"), _t("mechanic_manager_desc"), "player:Preset", "gerente", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_subchief"), _t("mechanic_subchief_desc"), "player:Preset", "sub-chefe", "preMechanic", true)
                        -- exports["dynamic"]:AddButton(_t("mechanic_chief"), _t("mechanic_chief_desc"), "player:Preset", "chefe", "preMechanic", true)
                    end


					-- exports["dynamic"]:SubMenu(_t("mechanic_uniforms"), _t("mechanic_uniforms_desc"), "preMechanic")

                    -- Vehicles
					exports["dynamic"]:AddButton(_t("tow"), _t("tow_desc"), "tow", nil, "+")
					exports["dynamic"]:SubMenu(_t("vehicles"), _t("vehicles_desc"), "vehMechanic")
				end

                if not IsPauseMenuActive() then
                    exports["dynamic"]:openMenu()
                end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("globalFunctions", _t("globalFunctions"), "keyboard", "F9")
RegisterKeyMapping("emergencyFunctions", _t("emergencyFunctions"), "keyboard", "F10")

RegisterNUICallback("getCityName",function(Data,Callback)
    Callback(string.lower(cityName))
end)

RegisterNetEvent("dynamic:Clothes")
AddEventHandler("dynamic:Clothes",function()
    TriggerEvent("dynamic:closeSystem")
    Wait(100)
    local Slots = 3 + (vSERVER.ClothesSlots() or 0)
    exports["dynamic"]:SubMenu(_t("save"), _t("save_clothes"), "save-clothes")

    for Number = 1,Slots do
        exports["dynamic"]:AddButton(_t("clothes") .. " " .. Number, _t("save_clothes"), "clothes:Save", tostring(Number), "save-clothes", true)
    end

    exports["dynamic"]:SubMenu(_t("select"), _t("select_clothes"), "use-clothes")

    for Number = 1,Slots do
        exports["dynamic"]:AddButton(_t("clothes") .. " " .. Number, _t("select_clothes"), "clothes:Use", tostring(Number), "use-clothes", true)
    end

    exports["dynamic"]:openMenu()
end)
