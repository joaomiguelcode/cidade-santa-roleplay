local canReceiveMessages = true


local TRANSLATE_TAG_KEYS = {
    ["Policia"] = 'chat.tag.police',
    ["Paramedic"] = 'chat.tag.paramedic',
    ["Bombeiros"] = 'chat.tag.bombeiros',
    ["Mechanic"] = 'chat.tag.mechanic',
    ["Help"] = 'chat.tag.help',
    ["Global"] = 'chat.tag.global',
    ["Local"] = 'chat.tag.local',
}

---@type table<string, boolean>
local CHAT_BLOCK_BY_NAME = {
    ["arrivedNow"] = true,
    ["#arrivedNow"] = true,
    ["#consoleCommand"] = true,
    ["#playerAhiv"] = true,
}

local CHAT_SETTING_BY_NAME = {
    ["#applyBan"] = "chatModeration",
    ["#applyBan2"] = "chatModeration",
    ["#warningNoti"] = "chatModeration",
    ["remAdv"] = "chatModeration",
    ["#remAdv"] = "chatModeration",
    ["#admTicket"] = "chatModeration",
    ["#playerKStreak"] = "chatArenaCombat",
    ["#playerKStreakStop"] = "chatArenaCombat",
    ["#playerOneKStreak"] = "chatArenaCombat",
    ["#playerOneKStreakCall"] = "chatArenaCombat",
    ["#playerOneKStreakPuro"] = "chatArenaCombat",
    ["#playerOneKStreakTelem"] = "chatArenaCombat",
    ["#ffaMap1Min"] = "chatArenaCombat",
    ["#ffaMap3Min"] = "chatArenaCombat",
    ["#ffaMap5Min"] = "chatArenaCombat",
    ["#playerWinFfa"] = "chatArenaCombat",
    ["#statusWar"] = "chatWarDomination",
    ["#roundDraw"] = "chatWarDomination",
    ["#teamWinEvent"] = "chatWarDomination",
    ["#theDomi"] = "chatWarDomination",
    ["#cancelDomi"] = "chatWarDomination",
    ["#accumulatedDomi"] = "chatWarDomination",
    ["#domiCompleted"] = "chatWarDomination",
    ["#gotCard"] = "chatItems",
    ["#gotCard2"] = "chatItems",
    ["#slideCoin"] = "chatItems",
    ["#slideCoin2"] = "chatItems",
    ["#megaPhone"] = "chatItems",
    ["#policeServ"] = "chatOrganization",
    ["#contratOrg"] = "chatOrganization",
    ["#aliasOrgani"] = "chatOrganization",
    ["#boughtCar"] = "chatDealership",
}

local CHAT_SOCIAL_ALL = {
    ["#breakupNotice"] = true,
    ["#endRelationship"] = true,
    ["#newEndRelationship"] = true,
    ["#newStartEngaged"] = true,
    ["#newStartMarried"] = true,
    ["#startRelationship"] = true,
    ["#cheatingRelationship"] = true,
    ["#newCheatingRelationship"] = true,
    ["#tryCheatingRelationship"] = true,
    ["#flirtingAlert"] = true,
}

local CHAT_SOCIAL_DATING = {
    ["#startRelationship"] = true,
    ["#newStartEngaged"] = true,
    ["#newStartMarried"] = true,
}

local function hasGroup(group)
    local playerGroups = vRP.GetPlayerGroups()

    if not playerGroups then
        return false
    end

    return playerGroups[group] == true or playerGroups[group] ~= nil
end

local function isPlayerStaff()
    return hasGroup("Admin") or hasGroup("Developers")
end

local function canShowConfiguredChat(chatName)

    if not chatName then
        return true
    end

    if CHAT_BLOCK_BY_NAME[chatName] then
        return false
    end

    local settingKey = CHAT_SETTING_BY_NAME[chatName]
    if settingKey then
        if not isPlayerStaff() then
            return false
        end

        return hudConfiguration[settingKey] ~= false
    end

    if CHAT_SOCIAL_ALL[chatName] then
        if not isPlayerStaff() then
            return false
        end

        local socialSetting = hudConfiguration.chatSocial or "dating"

        if socialSetting == "none" then
            return false
        end

        if socialSetting == "dating" then
            return CHAT_SOCIAL_DATING[chatName] == true
        end
    end

    return true
end

local function translateTag(tag)
    local key = TRANSLATE_TAG_KEYS[tag]
    if key then
        return _t(key)
    end
    return tag
end

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
-- CHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("Chat",function()

    if LocalPlayer.state["minigame:active"] and LocalPlayer.state["minigame:active"] ~= "neighbor" then
        return
    end

    if not isNuiReady then
        return
    end

    if not LocalPlayer["state"]["Active"] then
        return
    end
    
	if not IsPauseMenuActive() then
		SetNuiFocus(true,true)

		local Tags = {}
		for Index,v in pairs(ClientState) do
			if LocalPlayer["state"][Index] or HasGroup(Index) then
                local Organization = GlobalState["AliasGroup"][Index] or Index
          
				Tags[#Tags + 1] = translateTag(Organization)
			end
		end
        -- if not GlobalState["ChatGlobal"] then
        --     Tags[#Tags + 1] = translateTag("Global")
        -- end
        if not GlobalState["ChatHelp"] then
            Tags[#Tags + 1] = translateTag("Help")
        end
        print(json.encode(Tags, {indent = true}))
		SendNUIMessage({ Action = "Chat", Data = Tags, Block = Block, Suggestions = Suggestions })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------

--[[ Evitar o servidor enviar dois eventos com as mesmas informações para o client! ]]
RegisterNetEvent( 'chat:ClientMessageWithShowMe', function( sentByServerId, title, message, mode, special, custom, tag )

    TriggerEvent( 'chat:ClientMessage', title, message, mode, special, custom, tag )

    TriggerEvent( "showme:pressMe", sentByServerId, message, 10 )
end)

RegisterNetEvent("chat:ClientMessage")
AddEventHandler("chat:ClientMessage",function(Author,Message,Mode,Special,Custom,Tag)
    -- if LocalPlayer["state"]["FirstLogin"] then
    --     return
    -- end
    if not canReceiveMessages then
        return
    end

    if LocalPlayer["state"]["Creating"] then
        return
    end

    local playtime = exports.new_hub:GetPlaytimeMinutes() or 0
    
    if playtime <= 30 and Tag ~= "Local" then
        return
    end

    -- sx.logger:debug( ('chat:ClientMessage Author=%s Message=%s Mode=%s Special=%s Custom=%s Tag=%s'):format( tostring(Author), tostring(Message), tostring(Mode), tostring(Special), tostring(Custom), tostring(Tag) ) )

    local Messages = Message:gsub("[<>]","")
    local Organization = GlobalState["AliasGroup"][Tag] or Tag
	SendNUIMessage({ Action = "Message", Author = Author, Message = Messages, Type = Mode, Special = Special, Custom = Custom, Vip = Organization or "" })
end)

RegisterNetEvent("chat:DisablePreview")
AddEventHandler("chat:DisablePreview",function(Boolean)
    SendNUIMessage({ action = "DisablePreview", data = { toggle = Boolean }})
    canReceiveMessages = not Boolean
end)

RegisterNetEvent("chat:ClientMessage2")
AddEventHandler("chat:ClientMessage2",function(chatName,Variables,Special,Custom,Tag)
    if not canShowConfiguredChat(chatName) then
        return
    end

    local Config = chatConfig[lang][chatName]
    if not canReceiveMessages then
        return
    end

    if LocalPlayer["state"]["Creating"] then
        return
    end
    if LocalPlayer.state["minigame:active"] and LocalPlayer.state["minigame:active"] ~= "neighbor" then
        return
    end

    local playtime = exports.new_hub:GetPlaytimeMinutes() or 0

    if playtime <= 30 and Tag ~= "Local" then
        return
    end

    if Config then
        -- Sanitiza os valores substituidos (msg1..msgN) removendo "<" e ">" para impedir
        -- injecao de HTML/XSS na NUI do chat, que renderiza o conteudo via
        -- dangerouslySetInnerHTML. O template em chatConfig e confiavel e mantem sua
        -- marcacao (ex.: <br>), pois so as variaveis sao tratadas. Mesmo padrao ja
        -- aplicado em chat:ClientMessage (Message:gsub("[<>]","")).
        if type(Variables) == "table" then
            for Key, Value in pairs(Variables) do
                if type(Value) == "string" then
                    Variables[Key] = Value:gsub("[<>]","")
                end
            end
        end

        local Author = parseString(Config["author"],Variables)
        local Message = parseString(Config["message"],Variables)
        local Mode = parseString(Config["mode"],Variables)
        SendNUIMessage({ Action = "Message", Author = Author, Message = Message, Type = Mode, Special = Special, Custom = Custom, Vip = Organization or "" })
    end
end)

-- RegisterNetEvent("chat:AddSuggestion")
-- AddEventHandler("chat:AddSuggestion",function(Name, Message, Params)
--     SendNUIMessage({ Action = "AddSuggestion", Name = Name, Message = Message, Params = Params })
--     print(Name, Message, Params)
--     print("Adicionando sugestões")
-- end)

-- TriggerEvent("chat:AddSuggestion", "godteste", "Chat global fora do personagem.", { "id", "ID do player" })
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:ClientDelete")
AddEventHandler("chat:ClientDelete",function(Message)
    -- if LocalPlayer["state"]["FirstLogin"] then
    --     return
    -- end
	SendNUIMessage({ Action = "Delete", Message = Message})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:CLIENTMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("chat:Toggle")
AddEventHandler("chat:Toggle",function(toggle)
    SendNUIMessage({ Action = "Toggle", toggle = toggle or false })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATDELETE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChatDelete",function(Data,Callback)
    TriggerServerEvent("chat:DeleteMessage",Data["message"])
    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSECHAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("CloseChat",function(Data,Callback)
    SetNuiFocus(false,false)
    Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHATSUBMIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ChatSubmit",function(Data,Callback)
	SetNuiFocus(false,false)
    if LocalPlayer.state["minigame:active"] and LocalPlayer.state["minigame:active"] ~= "neighbor" then
        Callback("Ok")
        return
    end


	if Data["message"] ~= "" then
        Data["message"] = Data["message"]:gsub("[<>]","")
		if Data["message"]:sub(1,1) == "/" then
			-- print("Command run through chat ("..Data["message"]:sub(2)..")", GetInvokingResource())
			ExecuteCommand(Data["message"]:sub(2))
		else
			local Ped = PlayerPedId()
			if GetEntityHealth(Ped) > 100 then
                if #Data["message"] > 255 then
                    --TriggerEvent("Notify","vermelho","Mensagem muito longa.",5000,"CHAT")
					TriggerEvent("Notify2","#msgLonga")
                    return
                else

                    local playerId = PlayerId()
                    local playerPedId  = PlayerPedId()
                    local playerPedPos = GetEntityCoords( playerPedId )
                
                    local routingPlayers = { } 
                
                    for _, remotePlayerId in ipairs( GetActivePlayers() ) do

                        if remotePlayerId ~= playerId then
                    
                            local remotePlayerPedId = GetPlayerPed( remotePlayerId )
                            local remotePlayerPedPos = GetEntityCoords( remotePlayerPedId )
                    
                            if #( remotePlayerPedPos - playerPedPos ) <= 10.0 then
                    
                                table.insert( routingPlayers, GetPlayerServerId( remotePlayerId ) )
                            end
                        end
                    end

                    if Data["tag"] and Data["tag"] == "ajuda" and GlobalState["ChatHelp"] then
                        return
                    end

                    TriggerServerEvent("chat:ServerMessage", Data["tag"], Data["message"], routingPlayers )
                end
			end
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
    TriggerEvent("missions:welcomeCityNotify:close")
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KEYMAPPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterKeyMapping("Chat", _t("OpenChat"), "keyboard", "T")

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

--[[
local BlockedModels = {}
local REPORTADO = false
local REPORTADO_2 = false
local REPORTADO_3 = false
CreateThread(function() 
    local search_pools = {'CObject'}
    local founded_sizes = {}
    while true do
        for i = 1, #search_pools do
            local selected_pool = search_pools[i]
            local pool = GetGamePool(selected_pool)
            for j = 1, #pool do
                local entity_handle = pool[j]
                if NetworkHasControlOfEntity(entity_handle) and NetworkGetEntityIsNetworked(entity_handle) then
                    local model = GetEntityModel(entity_handle)
					if BlockedModels[model] then
						-- print("^1 ModelHash: "..tostring(model).." | Name: "..tostring(GetEntityArchetypeName(entity_handle)))
						DeleteEntity(entity_handle)
					else
						local size = founded_sizes[model]
						if not size then
							local min, max = GetModelDimensions(model) 
							local size_vec = max - min
							size = size_vec.x + size_vec.y + size_vec.z
							founded_sizes[model] = size
						end
						if size > 40.0 then
							-- print("^1Detectamos uma atitude suspeita e forçamos a remoção de algumas entidades criadas por você.^7")
							-- print("^1Caso acredite que isso seja um erro, envie as seguintes informações para a staff^7")
							local name = tostring(GetEntityArchetypeName(entity_handle))
							-- print("^1 ModelHash: "..tostring(model).." | S_1: "..math.floor(size).." | Name: "..name)
                            if name == "v_res_d_paddedwall" then
                                return
                            end
							BlockedModels[model] = true
							if not REPORTADO_2 then
								REPORTADO_2 = true
								TriggerServerEvent("DNASUNDWDSA", {
									type = "SIZE",
									model = tostring(model),
									archetype = tostring(GetEntityArchetypeName(entity_handle)),
									pop_type = GetEntityPopulationType(entity_handle),
									script = GetEntityScript(entity_handle),
								})
							end
							DeleteEntity(entity_handle)
						else
							local coords = GetEntityCoords(entity_handle)
							local ply_coords = GetEntityCoords(PlayerPedId())
							local popType = GetEntityPopulationType(entity_handle)
							if #(coords - ply_coords) > 40 and (popType == 7 or popType == 0) then
								-- print("^1 ModelHash: "..tostring(model).." | S_2: "..math.floor(#(coords - ply_coords)).." | Name: "..tostring(GetEntityArchetypeName(entity_handle)))
                                if tostring(GetEntityArchetypeName(entity_handle)) == "v_res_d_paddedwall" then
                                    return
                                end
								DeleteEntity(entity_handle)
							end
						end
					end
                else
                    local model = GetEntityModel(entity_handle)
                    if BlockedModels[model] then
						DeleteEntity(entity_handle)
                    else
                        local size = founded_sizes[model]
                        if not size then
                            local min, max = GetModelDimensions(model) 
                            local size_vec = max - min
                            size = size_vec.x + size_vec.y + size_vec.z
                            founded_sizes[model] = size
                        end
                        if size > 40.0 then
                            local name = tostring(GetEntityArchetypeName(entity_handle))
                            -- print("^1 ModelHash: "..tostring(model).." | S_6: "..math.floor(size).." | Name: "..name)
                            -- print(NetworkGetEntityIsNetworked(entity_handle))
                            if name == "v_res_d_paddedwall" then
                                return
                            end
                            BlockedModels[model] = true
                            DeleteEntity(entity_handle)
                        end
                    end
                end
            end
        end
        Wait(1000)
    end
end)


CreateThread(function() 
	while true do
		local pool = GetGamePool('CVehicle')
		local vehicle_count = {}
		for i = 1,#pool do
			local entity_handle = pool[i]
			if NetworkHasControlOfEntity(entity_handle) and NetworkGetEntityIsNetworked(entity_handle) then
				local model = GetEntityModel(entity_handle)
				if not vehicle_count[model] then
					vehicle_count[model] = {entity_handle}
				else
					table.insert(vehicle_count[model], entity_handle)
				end
			end
		end

		for k,v in pairs(vehicle_count) do
			if #v > 5 then
				-- print("^1Detectamos um spam de veículos, por segurança estamos deletando.^7")
				-- print("^1Caso acredite que isso seja um erro, envie as seguintes informações para a staff^7")
				-- print("^1 ModelHash: "..tostring(k).." | S_2: "..math.floor(#v).." | Name: "..tostring(GetEntityArchetypeName(v[1])))
				if not REPORTADO_3 then
					REPORTADO_3 = true
					TriggerServerEvent("DNASUNDWDSA", {
						size = "VEH",
						model = tostring(k),
						count = #v
					})
				end
				for _,i in pairs(v) do
					DeleteEntity(i)
				end
				
			end
		end
		Wait(1000)
	end
end)
--]]

CreateThread(function()
	if LocalPlayer["state"]["Active"] then
			Wait(3000)
			SendNUIMessage({ Action = "Toggle", toggle = true })
	end
end)

CreateThread(function()
    Wait(5000)
    local Scale = GlobalState["ChatScale"] or 1.0
    if cityName == "Maresia" then
        Scale = 0.85
    end
    if Scale then
        -- print(Scale)
        SendNUIMessage({ Action = "ChatScale", scale = Scale })
    end
end)

RegisterCommand("testmessage",function()
    local Custom = {
        background = "rgba(6,57,112,.75)",
    }
    local Organization = "TPM"
    local Message = " 1  | Ismael tiro curto contratou 2 | Tilambo Cano para a organização."

    --TriggerEvent("chat:ClientMessage", Organization, Message, "🧲 Painel", false, Custom)
    TriggerEvent("chat:ClientMessage2","#contratOrg",{msg = Message},false, Custom)

    TriggerEvent("Notify2","#insufficientItems")

    TriggerEvent("Announce", "adminNew", "TEST ANNOUNCE", 15000, "AVISO POLICIA")
end)

local gDebugChatCustom = {
    background = "rgba(6,57,112,.75)",
}

local gDebugChatVariables = {
    msg = "[DEBUG] Mensagem de teste das configuracoes do chat.",
    msg1 = "[DEBUG]",
    msg2 = "Filtro",
    msg3 = "Chat",
    msg4 = "10",
    msg5 = "Teste de configuracao",
    msg6 = "Staff",
    msg7 = "Debug",
    msg8 = "12:00",
    msg9 = "999",
    msg10 = "HUD",
}

local gDebugChatCases = {
    -- { key = "#chatDefault", label = "livre / deve aparecer para todos" },
    -- { key = "#arrivedNow", label = "bloqueado antigo / nao deve aparecer" },
    -- { key = "#consoleCommand", label = "bloqueado antigo / nao deve aparecer" },
    -- { key = "#playerAhiv", label = "bloqueado antigo / nao deve aparecer" },
    { key = "#applyBan", label = "moderacao / staff + config chatModeration" },
    { key = "#applyBan2", label = "moderacao / staff + config chatModeration 2" },
    -- { key = "#playerKStreak", label = "arena combate / staff + config chatArenaCombat" },
    -- { key = "#statusWar", label = "guerra dominio / staff + config chatWarDomination" },
    -- { key = "#megaPhone", label = "itens / staff + config chatItems" },
    { key = "#startRelationship", label = "social namoro / staff + chatSocial dating ou all" },
    { key = "#newStartEngaged", label = "social namoro / staff + chatSocial dating ou all" },
    { key = "#newStartMarried", label = "social namoro / staff + chatSocial dating ou all" },
    -- { key = "#breakupNotice", label = "social geral / staff + chatSocial all" },
    -- { key = "#contratOrg", label = "organizacao / staff + config chatOrganization" },
    -- { key = "#boughtCar", label = "concessionaria / staff + config chatDealership" },
}

local function buildDebugChatVariables(chatCase)
    local variables = {}

    for key,value in pairs(gDebugChatVariables) do
        variables[key] = value
    end

    variables.msg = ("[DEBUG] %s - %s"):format(chatCase.key, chatCase.label)
    variables.msg1 = "[DEBUG]"
    variables.msg2 = chatCase.key
    variables.msg3 = chatCase.label

    return variables
end

local function debugChatSettingsCommand()
    -- sx.logger:info( ("Running debug chat settings command with %d cases"):format( #gDebugChatCases ) )

    CreateThread(function()
        for _,chatCase in ipairs(gDebugChatCases) do
            TriggerEvent("chat:ClientMessage2", chatCase.key, buildDebugChatVariables(chatCase), false, gDebugChatCustom, "Local")
            Wait(450)
        end
    end)
end

RegisterCommand("debugchatsettings", debugChatSettingsCommand)
