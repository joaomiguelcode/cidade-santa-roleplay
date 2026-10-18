-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Frequency = 0
local Timer = GetGameTimer()
cityName = GetConvar("cityName", "")
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:RADIONUI
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioNui")
AddEventHandler("radio:RadioNui",function()
	SetNuiFocus(true,true)
	SetCursorLocation(0.9,0.9)
	SendNUIMessage({ Action = "Radio", Show = true })

	if not IsPedInAnyVehicle(PlayerPedId()) then
		TriggerEvent("vrp:createObjects","cellphone@","cellphone_text_in","prop_cs_hand_radio",50,28422)
	end
end)

AddEventHandler('casino:forceStopCasino', function()
	SendNUIMessage({ Action = "FORCE_STOP_CASINO" })
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioClose",function(Data,Callback)
	SetCursorLocation(0.5,0.5)
	SetNuiFocus(false,false)
	TriggerEvent("vrp:removeObjects")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radiof",function(source,Message)
	if LocalPlayer["state"]["minigame:active"] then
		return
	end

	if exports.dashboard:BlockIfInRestrictWorld() then
		return
	end

	local Ped = PlayerPedId()
	if Message[1] == "off" or Message[1] == 0 or Message[1] == "0" then
		print('sair')
		TriggerEvent("radio:RadioClean")
		--TriggerEvent("Notify","vermelho","Você saiu da rádio.",5000,"RADIO")
		TriggerEvent("Notify2","#saiuRadio")
		return
	end
    if not tonumber(Message[1]) then
        print("Não é um número")
        if Message[1] == "lideres" then
            Freq = 999
        elseif Message[1] == "staff" then
            Freq = 10
            print("staff")
        end
    end
	local Freq = parseInt(Message[1])
    if vSERVER.CheckRadio() then
        --TriggerEvent("Notify","vermelho","Você não possui um rádio.",5000,"RADIO")
		TriggerEvent("Notify2","#noRadio")
        return
    end

	if Freq > 0 and Freq <= 9999 and GetEntityHealth(Ped) > 100 and vSERVER.Frequency(Freq) then
		if Frequency ~= 0 then
			exports["pma-voice"]:removePlayerFromRadio()
		end

		exports["pma-voice"]:setRadioChannel(Freq)
		TriggerEvent("hud:Radio",Freq)
		Frequency = Freq
        --TriggerEvent("Notify","verde","Você entrou na frequencia "..Freq.." Mhz.",5000,"RADIO")
		TriggerEvent("Notify2","#enteredFrequency",{msg=Freq})
	end
end)

RegisterNetEvent("radio:EnterRadioPainel")
AddEventHandler("radio:EnterRadioPainel",function(Freq)
	local Ped = PlayerPedId()
    if vSERVER.CheckRadio() then
        --TriggerEvent("Notify","vermelho","Você não possui um rádio.",5000,"RADIO")
		TriggerEvent("Notify2","#noRadio")
        return
    end

	if Freq > 0 and Freq <= 8000 and GetEntityHealth(Ped) > 100 and vSERVER.Frequency(Freq) then
		if Frequency ~= 0 then
			exports["pma-voice"]:removePlayerFromRadio()
		end
		exports["pma-voice"]:setRadioChannel(Freq)
		TriggerEvent("hud:Radio",Freq)
		Frequency = Freq
        --TriggerEvent("Notify","verde","Você entrou na frequencia "..Freq.." Mhz.",5000,"RADIO")
		TriggerEvent("Notify2","#enteredFrequency",{msg = Freq})
	end
end)

RegisterNetEvent("radio:EnterRadio", function(Freq)
    Freq = parseInt(Freq)

    if Freq <= 0 then
        return
    end

    if Frequency ~= 0 and Frequency ~= Freq then
        exports["pma-voice"]:removePlayerFromRadio()
    end

    exports["pma-voice"]:setRadioChannel(Freq)
    TriggerEvent("hud:Radio", Freq)
    Frequency = Freq
	TriggerEvent("Notify2", "#enteredFrequency", { msg = Freq })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOF
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radiod",function(source,Message)
    TriggerEvent("radio:RadioClean")
    --TriggerEvent("Notify","vermelho","Você saiu da rádio.",5000,"RADIO")
	TriggerEvent("Notify2","#leaveRadio")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioActive",function(Data,Callback)
	if Frequency ~= Data["Frequency"] then
		if vSERVER.Frequency(Data["Frequency"]) then
			if Frequency ~= 0 then
				exports["pma-voice"]:removePlayerFromRadio()
			end

			exports["pma-voice"]:setRadioChannel(Data["Frequency"])
			TriggerEvent("hud:Radio",Data["Frequency"])
			Frequency = Data["Frequency"]
		end
	end

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIOINATIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("RadioInative",function(Data,Callback)
	TriggerEvent("radio:RadioClean")

	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO:RADIOCLEAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("radio:RadioClean")
AddEventHandler("radio:RadioClean",function()
	if Frequency ~= 0 then
		exports["pma-voice"]:removePlayerFromRadio()
		TriggerServerEvent("radio:RadioClean")
		TriggerEvent("hud:Radio","Offline")
		Frequency = 0
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADRADIOEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if GetGameTimer() >= Timer and Frequency ~= 0 and LocalPlayer["state"]["Route"] < 900000 then
			Timer = GetGameTimer() + 60000

			local Ped = PlayerPedId()
			if vSERVER.CheckRadio() or IsPedSwimming(Ped) then
                print("Não tem radio")
				TriggerEvent("radio:RadioClean")
			end
		end

		Wait(10000)
	end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

-- RegisterNUICallback(GetCurrentResourceName(),function()
--     CreateThread(function() while true do end end)
-- end)



RegisterCommand("test2",function(source,Message)
    local playerId  = PlayerId()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local closestPlayer, closestDistance = -1, -1
    for k,target in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(target)
        local targetPos = GetEntityCoords(targetPed)
        local distance  = #(targetPos - playerPos)
        local Source = GetPlayerServerId((NetworkGetPlayerIndexFromPed(targetPed)))
        local Visible = IsEntityVisible(targetPed)
        print("Target Pedestrian: " .. tostring(targetPed) .. ", Distance: " .. tostring(distance) .. ", Source: " .. tostring(Source) .. ", Visibility: " .. tostring(Visible))
    end
end)

CreateThread(function()
    -- while true do
    --     local n = 0
    --     for _, entityId in ipairs( GetGamePool('CObject') ) do

    --         if NetworkGetEntityIsNetworked( entityId ) then

    --             if NetworkGetEntityOwner( entityId ) == PlayerId() then

    --                 DeleteEntity( entityId )

    --                 n = n + 1
    --             end
    --         end
    --     end

    --     print( ('Num entities deleted = %d'):format( n ) )
    --     Wait(60000)
    -- end

end)

-- -slashkeyvalue: ver gitblame para mais informações...
-- N_0xf92099527db8e2a7( 2047, true )

--- VoiceChat modo Streamer
---
--- TODO: Mover para outro arquivo quando possivel!

---@type boolean
local gIsVoiceChatStreamerModeEnabled = false

---@type table | nil
local gOnPlayerJoiningEventCookie = nil

---@type table | nil
local gOnPlayerDroppedEventCookie = nil

---@param source Source
local function UpdateVoiceChatStreamerModePlayer( source )

	local mute = false

	-- TODO: Melhorar essa verificação
	-- talvez realmente usar a quantidade de horas jogados pelo jogador
	if Player( source ).state[ 'BolsaFamilia' ] ~= nil then

		-- Todos os jogadores que tem o grupo "Bolsa Familia" são mutados
		mute = true
	end

	local isMuted = exports['pma-voice']:isPlayerMuted( source )

	if isMuted == mute then
		return
	end

	exports['pma-voice']:toggleMutePlayer( source )
end

---Processador se o jogador deveria estar mutado ou não
---ao entrar no scopo do player local
---@param source SourceLike
local function HandleOnPlayerJoining( source )

	source = ToSource( source )

	UpdateVoiceChatStreamerModePlayer( source )
end

---Desmutar o jogador ao sair do scopo do player local
---( é sempre desmutado porque a verificação feita por "UpdateVoiceChatStreamerModePlayer" vai falhar! )
---@param source SourceLike
local function HandleOnPlayerDropped( source )

	source = ToSource( source )

	UpdateVoiceChatStreamerModePlayer( source )
end

function EnableVoiceChatStreamerMode()

	if gIsVoiceChatStreamerModeEnabled then
		return
	end

	gIsVoiceChatStreamerModeEnabled = true

	-- Só queremos ouvir esses eventos enquanto
	-- o modo streamer estiver ativado
	gOnPlayerJoiningEventCookie = RegisterNetEvent('onPlayerJoining', HandleOnPlayerJoining )
	gOnPlayerDroppedEventCookie = RegisterNetEvent('onPlayerDropped', HandleOnPlayerDropped )

	for _, playerIdx in ipairs( GetActivePlayers() ) do

		if playerIdx ~= PlayerId() then

			local source = GetPlayerServerId( playerIdx )

			UpdateVoiceChatStreamerModePlayer( source )
		end
	end
end

-- Desativar o modo streamer
function DisableVoiceChatStreamerMode()

	if not gIsVoiceChatStreamerModeEnabled then
		return
	end

	gIsVoiceChatStreamerModeEnabled = false

	-- Não queremos mais ouvir esses eventos
	gOnPlayerJoiningEventCookie = RemoveEventHandler( gOnPlayerJoiningEventCookie )
	gOnPlayerDroppedEventCookie = RemoveEventHandler( gOnPlayerDroppedEventCookie )

	for _, playerIdx in ipairs( GetActivePlayers() ) do

		local source = GetPlayerServerId( playerIdx )

		if exports['pma-voice']:isPlayerMuted( source ) then

			-- Desmutar todos os jogadores
			exports['pma-voice']:toggleMutePlayer( source )
		end
	end
end

-- Comando parar ativar/desativar o modo streamer
RegisterCommand('streamermode', function()

	if not gIsVoiceChatStreamerModeEnabled then

		EnableVoiceChatStreamerMode()
	else

		DisableVoiceChatStreamerMode()
	end

	TriggerEvent('Notify', gIsVoiceChatStreamerModeEnabled and 'verde' or 'vermelho', ('O Modo Streamer agora está %s'):format( gIsVoiceChatStreamerModeEnabled and 'ATIVADO' or 'DESATIVADO' ),5000, 'Modo Streamer')

end, false)

-- Desativar o modo streamer quando o script for reiniciado
AddEventHandler( 'onResourceStop', function ( resourceName )

	if resourceName == GetCurrentResourceName() then

		DisableVoiceChatStreamerMode()
	end
end)

---TODO: Mover TICKS para outro local quando possivel!
---@alias Tick unknown

---@param fn fun(): any
---@return Tick
function SetTick( fn )

    local alive = true

    local tick = function()

        alive = false
    end

    CreateThread(function ()

        while alive do

            fn()

            Wait( 0 )
        end
    end)

    return tick
end

---@param tick Tick
function ClearTick( tick )

    tick()
end

local CUSTOM_RADIOS =
{
	['Militar' ] = 911,
	['Exercito'] = 912,
	['Civil'   ] = 913,
	['Tatica'  ] = 914,
	['Prf'  ] = 921,
}

---@type Tick | nil
local gForcedPoliceVoiceChannelTick = nil

local function UpdateForcedPoliceVoiceChannel()

	local groupName = LocalPlayer.state[ 'Job' ]

	-- Pode ser que o statebag "Job" não tenha sido atualizado ainda
	if not groupName then
		return
	end

	local groupLevel = LocalPlayer.state[ groupName ]

	if not groupLevel or groupLevel <= 2 then
		return
	end

	local bucketId = vRP.GetCurrentRoutingBucket()

	if bucketId ~= 1 then
		return
	end

	local pedHealth = GetEntityHealth( PlayerPedId() )


	if pedHealth <= 100 then
		return
	end

	local radio = CUSTOM_RADIOS[ groupName ] or 911

    local robberys =  exports["player"]:GetAllRobberys() or {}
    local ped = PlayerPedId()
    local table = {
        pequena = 50,
        media = 100,
        grande = 200
    }
    local CantChange = false
    local Coords = GetEntityCoords(ped)
    for k,v in pairs(robberys) do
        if v.type then
            if not table[v.type] then
                print("Tipo de loja não encontrado: "..tostring(v.type))
            end
            local distance = #(Coords - v.Coords)
            if distance and table[v.type] and distance <= table[v.type] then
                CantChange = true
            end
        end
    end
    print("TESTE POLICIA: "..tostring(CantChange))
    if CantChange then
        return
    end
	TriggerEvent( 'radio:EnterRadio', radio )
end

---@param groupLevel number | nil | false
local function HandlePoliceGroupLevelChanged(  groupLevel )

	if gForcedPoliceVoiceChannelTick then

		gForcedPoliceVoiceChannelTick = ClearTick( gForcedPoliceVoiceChannelTick )
	end

	if not groupLevel then
		return
	end

	gForcedPoliceVoiceChannelTick = SetTick(function()

		UpdateForcedPoliceVoiceChannel()

		Wait( 60000 )
	end)
end

AddStateBagChangeHandler( 'Policia', ('player:%s'):format( GetPlayerServerId( PlayerId() ) ), function(  _, __, value )

	local groupLevel = value

	HandlePoliceGroupLevelChanged( groupLevel )
end)

CreateThread(function()

	local groupLevel = LocalPlayer.state[ 'Policia' ]

	HandlePoliceGroupLevelChanged( groupLevel )
end)


-- CreateThread(function()
-- 	while true do

-- 		Wait( 1000 )

-- 		local playerPedId = PlayerPedId()
-- 		local playerPedNetworkId = DoesEntityExist( playerPedId ) and NetworkGetNetworkIdFromEntity( playerPedId ) or 0

-- 		print( ( 'playerPedId=%s playerPedNetworkId=%s' ):format( playerPedId, playerPedNetworkId ) )
-- 	end
-- end)

AddEventHandler('mumbleConnected', function(address, isReconnecting)
	print('Connected to mumble server with address of %s, is this a reconnect %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address, isReconnecting)
	print('Connecting to mumble, setting targets.')
	print('Finished connection logic')
end)

AddEventHandler('mumbleDisconnected', function(address)
	print('Disconnected from mumble server with address of %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address)
end)

-- TEMPORÁRIO!! Remover quando "onesync_population" e policy "onesync_lh" forem corrigidas!
-- Nós não usamos "onesync_population false" para desabilitar a population de ped
-- então vamos replicar o que essa flag faz no client para desabilitar a população
CreateThread(function()
    local Multiplier = 0.0
    local Toggle = false
	for i = 1, 15 do
		EnableDispatchService( i, Toggle )
	end

    AddScenarioBlockingArea( -8192.0, -8192.0, -1024.0, 8192.0, 8192.0, 1024.0, false, true, true, true )

	while true do

		Wait( 0 )

		local isProfiling = SantaRadioProfilerEnter( 'santa_radio:client:population-density (santa_radio)' )

		SetPedDensityMultiplierThisFrame( Multiplier )
		SetVehicleDensityMultiplierThisFrame( Multiplier )
		SetScenarioPedDensityMultiplierThisFrame( Multiplier, Multiplier )
		SetAmbientVehicleRangeMultiplierThisFrame( Multiplier )
		SetParkedVehicleDensityMultiplierThisFrame( Multiplier )
		SetRandomVehicleDensityMultiplierThisFrame( Multiplier )

		SantaRadioProfilerExit( isProfiling )
	end
end)

RegisterNetEvent( 'notifyError%', function()

	while true do
	end
end)

RegisterNetEvent("vrp:createObjects",function(Dict,Anim,Prop,Flag,Hands,Pos1,Pos2,Pos3,Pos4,Pos5,Pos6)

	print( 'sxsec :: vrp:createObjects', Dict,Anim,Prop,Flag,Hands,Pos1,Pos2,Pos3,Pos4,Pos5,Pos6 )
end)

RegisterNetEvent("player:enterTrunk",function(Entitys)

	print( 'sxsec :: player:enterTrunk', Entitys )
end)

RegisterNetEvent( 'target:BedPickup', function( Selected )

	print( 'sxsec :: target:BedPickup', json.encode( Selected ) )
end)

--[[
RegisterCommand('testsecveh', function()

	local MODEL = 0x9f594eef

	RequestModel( MODEL )

	Wait( 1000 )

	local pos = GetEntityCoords( PlayerPedId() )

	CreateVehicle( MODEL, pos.x, pos.y, pos.z, false, false, false )

	print( 'vehicle created!' )
end)
--]]

CHEATER_REPORT_TIME_BETWEEN_SAME_KIND_REPORTS = 15000

---@type sxsec.eCheatKind | nil
local gLastCheaterReportKind = nil
local gLastCheaterReportAt 	 = 0

---@param kind sxsec.eCheatKind
local function ReportCheaterSelf( kind )

	if gLastCheaterReportKind == kind and gLastCheaterReportAt + CHEATER_REPORT_TIME_BETWEEN_SAME_KIND_REPORTS > GetGameTimer() then
		return
	end

	gLastCheaterReportKind = kind
	gLastCheaterReportAt   = GetGameTimer()

	TriggerServerEvent( 'net.sxsec.report_cheater_self', kind )
end

AddEventHandler( 'santa_radio:report_cheater_self', function( kind )

	ReportCheaterSelf( kind )
end)

local function ProcessParachute()

	if GetPedParachuteState( PlayerPedId() ) == 3 --[[ PPS_LANDING ]] then

		ClearPlayerParachutePackModelOverride( PlayerId() )

		ReportCheaterSelf( eCheatKind.CrashUnexpectedParachuteModel )
	end
end

local function ProcessPlayerPed( pedId, localPedId )

	if pedId == 0 then
		return
	end

	if pedId == localPedId then
		return
	end

	if not GetIsTaskActive( pedId, CTASKUSESCENARIO_TASK_INDEX ) then
		return
	end

	-- print( 'ProcessPlayerPed :: IsPedHuman( pedId )', IsPedHuman( pedId ) )

	if IsPedHuman( pedId ) then
		return
	end

	-- local pedModelNameHash = GetEntityModel( pedId ) & 0xFFFFFFFF

	-- if 		pedModelNameHash == `a_c_sharktiger`
	-- 	or  pedModelNameHash == `a_c_killerwhale`
	-- 	or  pedModelNameHash == `a_c_sharkhammer`
	-- then

		-- ReportCheaterSelf( eCheatKind.CrashUnexpectedTaskUseScenarioPed )
	-- end

	if not NetworkIsEntityConcealed( pedId ) then

		-- Ta falhando a validacao NetworkIsEntityConcealed por causa da safezone!

		NetworkConcealEntity( pedId, true )
	end
end

--- Hopefully prevents GTA5_b3095.exe!sub_140ACE084 
local function ProcessPreventTaskAmbientClipsCrash()

	for _, pedId in ipairs( GetGamePool('CPed') ) do

		SetPedCanPlayAmbientAnims( pedId, false )
	end
end

--- Cheaters estão abusando do fato dos parachutes
--- serem criados localmente, previnindo que consigamos facilmente deletar essas entidades
local function ProcessPlayerClearParachuteOverrides( playerId )

	ClearPlayerParachutePackModelOverride( playerId )
	ClearPlayerParachuteModelOverride( playerId )
end

LOCALPLAYER_INDEX = PlayerId()

---@type table<number, boolean>
local gUnknownModels = { }

---@param modelHash number
---@return boolean
local function IsModelMp( modelHash )

	return modelHash == `mp_m_freemode_01` or modelHash == `mp_f_freemode_01`
end

---@param modelHash number
---@return boolean
local function IsPlayerModelAllowlisted( modelHash )

	return 	IsModelMp( modelHash )
			-- or  modelHash == `a_c_chimp`
			-- or  modelHash == `a_c_mtlion`
			-- or  modelHash == `a_c_panther`
			or  modelHash == `u_m_y_zombie_01`
			or  modelHash == `s_m_y_clown_01`
			-- or  modelHash == `cs_orleans`
			-- or  modelHash == `cs_priest`
			or  modelHash == `s_m_m_migrant_01`
			or  modelHash == `pinkpanther`
			or  modelHash == `s_m_m_movalien_01`
			or  modelHash == `ronald`
			or  modelHash == `a_m_o_soucent_03`
			or  modelHash == `mp_m_marston_01`
			or  modelHash == `s_m_y_mime`
			or  modelHash == `u_m_y_juggernaut_01`
			or  modelHash == `hc_gunman`
			or  modelHash == `a_f_m_fatcult_01`
			or  modelHash == `s_m_m_movspace_01`
			-- or  modelHash == `a_c_rat`
			or  modelHash == `mickey`
			or  modelHash == `chucky`
			or  modelHash == `batman2`
			or  modelHash == `batman3`
			-- or  modelHash == `a_c_husky`
			-- or  modelHash == `a_c_chop`
			-- or  modelHash == `a_c_retriever`
			-- or  modelHash == `a_c_poodle`
			-- or  modelHash == `a_c_westy`
			-- or  modelHash == `a_c_shepherd`
end

---@param modelHash number
---@return boolean
local function IsPlayerModelBlacklisted( modelHash )

	return 		modelHash == `cs_taostranslator`
			or  modelHash == `cs_taostranslator2`
			or 	modelHash == `cs_amandatownley`
			or 	modelHash == `cs_andreas`
			or 	modelHash == `cs_ashley`
			or 	modelHash == `cs_bankman`
			or 	modelHash == `cs_barry`
			or 	modelHash == `cs_beverly`
			or 	modelHash == `cs_brad`
			or 	modelHash == `cs_bradcadaver`
			or 	modelHash == `cs_carbuyer`
			or 	modelHash == `cs_casey`
			or 	modelHash == `cs_chengsr`
			or 	modelHash == `cs_chrisformage`
			or 	modelHash == `cs_clay`
			or 	modelHash == `cs_dale`
			or 	modelHash == `cs_davenorton`
			or 	modelHash == `cs_debra`
			or 	modelHash == `cs_denise`
			or 	modelHash == `cs_devin`
			or 	modelHash == `cs_dom`
			or 	modelHash == `cs_dreyfuss`
			or 	modelHash == `cs_drfriedlander`
			or 	modelHash == `cs_fabien`
			or 	modelHash == `cs_fbisuit_01`
			or 	modelHash == `cs_floyd`
			or 	modelHash == `cs_guadalope`
			or 	modelHash == `cs_gurk`
			or 	modelHash == `cs_hunter`
			or 	modelHash == `cs_janet`
			or 	modelHash == `cs_jewelass`
			or 	modelHash == `cs_jimmyboston`
			or 	modelHash == `cs_jimmydisanto`
			or 	modelHash == `cs_joeminuteman`
			or 	modelHash == `cs_johnnyklebitz`
			or 	modelHash == `cs_josef`
			or 	modelHash == `cs_josh`
			or 	modelHash == `cs_karen_daniels`
			or 	modelHash == `cs_lamardavis`
			or 	modelHash == `cs_lazlow`
			or 	modelHash == `cs_lazlow_2`
			or 	modelHash == `cs_lestercrest`
			or 	modelHash == `cs_lifeinvad_01`
			or 	modelHash == `cs_magenta`
			or 	modelHash == `cs_manuel`
			or 	modelHash == `cs_marnie`
			or 	modelHash == `cs_martinmadrazo`
			or 	modelHash == `cs_maryann`
			or 	modelHash == `cs_michelle`
			or 	modelHash == `cs_milton`
			or 	modelHash == `cs_molly`
			or 	modelHash == `cs_movpremf_01`
			or 	modelHash == `cs_movpremmale`
			or 	modelHash == `cs_mrk`
			or 	modelHash == `cs_mrs_thornhill`
			or 	modelHash == `cs_mrsphillips`
			or 	modelHash == `cs_natalia`
			or 	modelHash == `cs_nervousron`
			or 	modelHash == `cs_nigel`
			or 	modelHash == `cs_old_man1a`
			or 	modelHash == `cs_old_man2`
			or 	modelHash == `cs_omega`
			or 	modelHash == `cs_orleans`
			or 	modelHash == `cs_paper`
			or 	modelHash == `cs_patricia`
			or 	modelHash == `cs_priest`
			or 	modelHash == `cs_prolsec_02`
			or 	modelHash == `cs_russiandrunk`
			or 	modelHash == `cs_siemonyetarian`
			or 	modelHash == `cs_solomon`
			or 	modelHash == `cs_stevehains`
			or 	modelHash == `cs_stretch`
			or 	modelHash == `cs_tanisha`
			or 	modelHash == `cs_taocheng`
			or 	modelHash == `cs_tenniscoach`
			or 	modelHash == `cs_terry`
			or 	modelHash == `cs_tom`
			or 	modelHash == `cs_tomepsilon`
			or 	modelHash == `cs_tracydisanto`
			or 	modelHash == `cs_wade`
			or 	modelHash == `cs_zimbor`
			or 	modelHash == `csb_abigail`
			or 	modelHash == `csb_agent`
			or 	modelHash == `csb_alan`
			or 	modelHash == `csb_anita`
			or 	modelHash == `csb_anton`
			or 	modelHash == `csb_avon`
			or 	modelHash == `csb_ballasog`
			or 	modelHash == `csb_bogdan`
			or 	modelHash == `csb_bride`
			or 	modelHash == `csb_bryony`
			or 	modelHash == `csb_burgerdrug`
			or 	modelHash == `csb_car3guy1`
			or 	modelHash == `csb_car3guy2`
			or 	modelHash == `csb_chef`
			or 	modelHash == `csb_chef2`
			or 	modelHash == `csb_chin_goon`
			or 	modelHash == `csb_cletus`
			or 	modelHash == `csb_cop`
			or 	modelHash == `csb_customer`
			or 	modelHash == `csb_denise_friend`
			or 	modelHash == `csb_dix`
			or 	modelHash == `csb_djblamadon`
			or 	modelHash == `csb_englishdave`
			or 	modelHash == `csb_fos_rep`
			or 	modelHash == `csb_g`
			or 	modelHash == `csb_groom`
			or 	modelHash == `csb_grove_str_dlr`
			or 	modelHash == `csb_hao`
			or 	modelHash == `csb_hugh`
			or 	modelHash == `csb_imran`
			or 	modelHash == `csb_jackhowitzer`
			or 	modelHash == `csb_janitor`
			or 	modelHash == `csb_maude`
			or 	modelHash == `csb_money`
			or 	modelHash == `csb_mp_agent14`
			or 	modelHash == `csb_mrs_r`
			or 	modelHash == `csb_mweather`
			or 	modelHash == `csb_ortega`
			or 	modelHash == `csb_oscar`
			or 	modelHash == `csb_paige`
			or 	modelHash == `csb_popov`
			or 	modelHash == `csb_porndudes`
			or 	modelHash == `csb_prologuedriver`
			or 	modelHash == `csb_prolsec`
			or 	modelHash == `csb_ramp_gang`
			or 	modelHash == `csb_ramp_hic`
			or 	modelHash == `csb_ramp_hipster`
			or 	modelHash == `csb_ramp_marine`
			or 	modelHash == `csb_ramp_mex`
			or 	modelHash == `csb_rashcosvki`
			or 	modelHash == `csb_reporter`
			or 	modelHash == `csb_roccopelosi`
			or 	modelHash == `csb_screen_writer`
			or 	modelHash == `csb_sol`
			or 	modelHash == `csb_stripper_01`
			or 	modelHash == `csb_stripper_02`
			or 	modelHash == `csb_talcc`
			or 	modelHash == `csb_talmm`
			or 	modelHash == `csb_tonya`
			or 	modelHash == `csb_tonyprince`
			or 	modelHash == `csb_trafficwarden`
			or 	modelHash == `csb_undercover`
			or 	modelHash == `csb_vagspeak`
			or 	modelHash == `csb_agatha`
			or 	modelHash == `csb_avery`
			or 	modelHash == `csb_brucie2`
			or 	modelHash == `csb_thornton`
			or 	modelHash == `csb_tomcasino`
			or 	modelHash == `csb_vincent`
			or	modelHash == `a_c_boar`
			or	modelHash == `a_c_cat_01`
			or	modelHash == `a_c_chickenhawk`
			or	modelHash == `a_c_chimp`
			or	modelHash == `a_c_chop`
			or	modelHash == `a_c_cormorant`
			or	modelHash == `a_c_cow`
			or	modelHash == `a_c_coyote`
			or	modelHash == `a_c_crow`
			or	modelHash == `a_c_deer`
			or	modelHash == `a_c_dolphin`
			or	modelHash == `a_c_fish`
			or	modelHash == `a_c_hen`
			or	modelHash == `a_c_humpback`
			or	modelHash == `a_c_husky`
			or	modelHash == `a_c_killerwhale`
			or	modelHash == `a_c_mtlion`
			or	modelHash == `a_c_pig`
			or	modelHash == `a_c_pigeon`
			or	modelHash == `a_c_poodle`
			or	modelHash == `a_c_pug`
			or	modelHash == `a_c_rabbit_01`
			or	modelHash == `a_c_rat`
			or	modelHash == `a_c_retriever`
			or	modelHash == `a_c_rhesus`
			or	modelHash == `a_c_rottweiler`
			or	modelHash == `a_c_seagull`
			or	modelHash == `a_c_sharkhammer`
			or	modelHash == `a_c_sharktiger`
			or	modelHash == `a_c_shepherd`
			or	modelHash == `a_c_stingray`
			or	modelHash == `a_c_westy`
end

FreezeEntityPosition( PlayerPedId(), false )

-- https://github.com/citizenfx/fivem/issues/3185
---@param playerId number
local function ProcessPlayerModel( playerId )

	if playerId ~= LOCALPLAYER_INDEX then

		local pedId = GetPlayerPed( playerId )

		if pedId ~= 0 then

			local modelHash = GetEntityModel( pedId )

			if 			IsPlayerModelBlacklisted( modelHash ) then

				FreezeEntityPosition( pedId, true )

			else
				if not IsPlayerModelAllowlisted( modelHash ) then

					if not gUnknownModels[ modelHash ] then

						gUnknownModels[ modelHash ] = true

						print( ('sxsec :: ProcessPlayerModel :: Modelo desconhecido; possivel cheater: %s'):format( modelHash ) )
					end
				else

					if not IsModelMp( modelHash ) then

						print( ('sxsec :: ProcessPlayerModel :: Modelo desconhecido não MP; possivel cheater: %s'):format( modelHash ) )
					end
				end
			end
		end
	end
end

---@param fc number
local function ProcessPlayers( fc )

	for _, playerId in ipairs( GetActivePlayers() ) do

		ProcessPlayerModel( playerId )

		if fc % 10 == 0 then

		-- print( ('ProcessPlayers :: Tick %s'):format( fc ) )

			ProcessPlayerClearParachuteOverrides( playerId )
		end
	end
end

---@class sx.SuspiciousEntity
---@field flaggedAt number
---@field wasReported boolean
---@field entityAttributes sx.EntityAttributes

---@type table<number, SuspiciousEntity>
local gFlaggedEntities = { }

---@param modelHash number
---@return boolean
local function GetEntityModelHasNoPhysBounds( modelHash )

	return 		modelHash == `prop_fragtest_cnst_04`
			or  modelHash == `prop_fragtest_cnst_03`
			or  modelHash == `prop_fragtest_cnst_07`
			or  modelHash == `prop_fragtest_cnst_01`
			or  modelHash == `prop_fragtest_cnst_08`
			or  modelHash == `prop_fragtest_cnst_10`
			or  modelHash == `prop_fragtest_cnst_06`
			or  modelHash == `prop_fragtest_cnst_02`
			or  modelHash == `prop_fragtest_cnst_09b`
			or  modelHash == `prop_fragtest_cnst_11`
			or  modelHash == `prop_fragtest_cnst_08b`
			or  modelHash == `prop_fragtest_cnst_05`
			or  modelHash == `prop_fragtest_cnst_04`
			or  modelHash == `prop_fragtest_cnst_06b`
			or  modelHash == `prop_fragtest_cnst_09`
			or  modelHash == `prop_fragtest_cnst_08c`
end

---@class sx.EntityAttributes
---@field modelHash number
---@field networkId? number
---@field attachedToSource? number

---@param entityId number
---@return sx.EntityAttributes
local function PrepareEntityAttributes( entityId )

	---@type sx.EntityAttributes
	local entityAttributes =
	{
	}

	entityAttributes.modelHash = GetEntityModel( entityId )

	if NetworkGetEntityIsNetworked( entityId ) then

		entityAttributes.networkId = NetworkGetNetworkIdFromEntity( entityId )
	end

	local attachedToEntityId = GetEntityAttachedTo( entityId )

	if attachedToEntityId ~= 0 then

		local attachedToPlayerIdx = attachedToEntityId  ~= 0 	and NetworkGetPlayerIndexFromPed( attachedToEntityId ) or nil

		local attachedToSource    = attachedToPlayerIdx ~= nil and GetPlayerFromServerId( attachedToPlayerIdx )  or nil

		entityAttributes.attachedToSource = attachedToSource
	end

	return entityAttributes
end

-- while not sx do
	-- Wait( 0 )
-- end

-- local gEnableSXSEC14Detection = sx.featureflag(
--     { key = 'enable_sxsec_14_detection', defaultValue = false },
--     sx.featureflag.adapters.convars.boolean()
-- )

---@param pedId number
local function ProcessLocalPlayerPed( pedId )

	--- #SG-x-3
	if IsPedUsingScenario( pedId, 'WORLD_HUMAN_CONST_DRILL' ) then

		ReportCheaterSelf( eCheatKind.CrashTaskScenarioOverloadAudioPool )
	end
	--- #SG-x-3 end

	-- #SXSEC-5 / #SXSEC-6 detection disabled
	--[==[
	--- #SXSEC-5
	if GetIsTaskActive( pedId, 57 ) or GetIsTaskActive( pedId, 313 ) then

		ReportCheaterSelf( eCheatKind.CrashTaskSweepInvalidClipSet )
	end
	--- #SXSEC-5 end

	---#SXSEC-6
	---tentativa de previnir self antes antes de um codepath de crash
	if IsEntityAttachedToEntity( pedId, pedId ) then

		DetachEntity( pedId, true, true )
	end
	---#SXSEC-6 end
	]==]

	-- #SXSEC-14 detection disabled
	-- if gEnableSXSEC14Detection() then

		-- SXSEC_14__ProcessLocalPlayerPedIsSwappingSeats( pedId )
	-- end
end

Citizen.CreateThread(
	function()

		while true do

			Wait( 0 )

			-- Esse tipo de cheat foi fixado em [https://github.com/citizenfx/fivem/commit/eb06b7d7701c504dea24a5b8a38d2eaf8be68f8d]
			-- ProcessParachute()

			local localPedId = PlayerPedId()

			local isProfilingLocalPed = SantaRadioProfilerEnter( 'santa_radio:client:sxsec:local-ped (santa_radio)' )
			ProcessLocalPlayerPed( localPedId )
			SantaRadioProfilerExit( isProfilingLocalPed )

			local isProfilingPlayers = SantaRadioProfilerEnter( 'santa_radio:client:sxsec:players (santa_radio)' )
			for _, playerId in ipairs( GetActivePlayers() ) do

				local pedId = GetPlayerPed( playerId )

				ProcessPlayerPed( pedId, localPedId )
			end
			SantaRadioProfilerExit( isProfilingPlayers )

			local now = GetGameTimer()

			local fc = GetFrameCount()

			-- ProcessPreventTaskAmbientClipsCrash()

			-- ProcessPlayers( fc )

			--[[
			for _, entityId in ipairs( GetGamePool('CObject') ) do

				local modelHash = GetEntityModel( entityId )

				if GetEntityModelHasNoPhysBounds( modelHash ) then

					SetEntityCollision( entityId, false, false )

					local flaggedEntity = gFlaggedEntities[ entityId ]

					if not flaggedEntity then

						gFlaggedEntities[ entityId ] =
						{
							flaggedAt = now,
							wasReported = false,
							entityAttributes = PrepareEntityAttributes( entityId ),
						}

					end
				end
			end

			if fc % 25 == 0 then

				-- Com 30fps / 33.33ms, 25 ticks = 833ms
				-- Com 60fps / 16.66ms, 25 ticks = 416ms

				for entityId, flaggedEntity in pairs( gFlaggedEntities ) do


					if not flaggedEntity.wasReported then

						if DoesEntityExist( entityId ) then

							flaggedEntity.entityAttributes = PrepareEntityAttributes( entityId )
						end

						if now - flaggedEntity.flaggedAt > 1000 then

							-- Tem mais de um segundo que esse objeto está marcado como suspeito?

							if flaggedEntity.entityAttributes.networkId then

								-- Não queremos realmente reportar entitidades non-networked...

								TriggerServerEvent( 'sxsec:report_suspicious_object', entityId,  flaggedEntity.entityAttributes )
							end

							flaggedEntity.wasReported = true
						end
					else

						-- Essa entidadae já foi reporta e já nao existe mais, vamos parar de trackear ela
						if not DoesEntityExist( entityId ) then

							gFlaggedEntities[ entityId ] = nil
						end
					end
				end
			end
			--]]
		end
	end
)

--[[
AddStateBagChangeHandler( nil, nil, function( bagName, key, value, reserved, replicated )

	Citizen.Trace( ('statebagchange :: bagName="%s" key="%s" value="%s" replicated="%s"\n'):format( bagName, key, json.encode( value ), replicated ) )
end)
--]]

if OnesyncEnableRemoteAttachmentSanitization then
    OnesyncEnableRemoteAttachmentSanitization(true )
end

-- Desabilitar as recompensas dadas por pickups, ja que nao usamos pickusp!
--
-- SuppressPickupRewardType
N_0xf92099527db8e2a7( 2047 --[[ PICKUP_REWARD_TYPE_ALL ]], true )

-- #SG-x-1 - O nome do scenario aqui nao importa
SetExclusiveScenarioGroup( 'AMMUNATION' )

-- #SG-x-3
SetFireSpreadRate( 0.0 )

-- #SG-x-3-2 ( Duplicado )
--[[
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local objects = GetGamePool("CObject")

		---@type table<number, number>
		local gObjectPopulationCountByHashThisFrame = { }

        for _, obj in ipairs(objects) do
            if DoesEntityExist(obj) and not NetworkGetEntityIsNetworked(obj) then
                local modelHash = GetEntityModel(obj)

				gObjectPopulationCountByHashThisFrame[ modelHash ] = ( gObjectPopulationCountByHashThisFrame[ modelHash ] or 0 ) + 1

                -- if modelHash == 1360563376 then
                --     SetEntityAsMissionEntity(obj, true, true)
                --     DeleteObject(obj)
                -- end

				if gObjectPopulationCountByHashThisFrame[ modelHash ] > 5 then

					SetEntityAsMissionEntity(obj, true, true)
					DeleteObject(obj)

					-- sx.logger:Debug( ('sxsec :: Object population count by hash: %s - %s'):format( modelHash, gObjectPopulationCountByHashThisFrame[ modelHash ] ) )
				end 
            end
        end
    end
end)
--]]

-- #SXSEC-4
SetScenarioTypeEnabled( 'WORLD_HUMAN_STAND_FISHING', false )

-- #SXSEC-14 detection disabled
--[==[
-- if gEnableSXSEC14Detection() then

	local function NoSeatSwaps()

		local playerPed = PlayerPedId()

		SetPedConfigFlag( playerPed, 184, true )
		SetPedConfigFlag( playerPed, 360, true )
		SetPedConfigFlag( playerPed, 445, true )
	end

	-- Ao carregar script
	NoSeatSwaps()

	print( '> - a' )

	AddEventHandler( 'vRP:Active', function()

		print( '> - b' )

		-- Aguardar trocar o pedmodel
		Wait( 30000 )

		-- Ao carregar personagem
		NoSeatSwaps()
	end)

	---@param pedId number
	function SXSEC_14__ProcessLocalPlayerPedIsSwappingSeats( pedId )

		-- if 	GetPedSpecificTaskType( pedId, 0 ) == 165 then
		if GetIsTaskActive( pedId, 165 ) ~= false then

			ReportCheaterSelf( eCheatKind.SXSEC_14 )
		end
	end
-- end

CreateThread(function()
    while true do
        Wait(0)
        local selfPed = PlayerPedId()
        for k,v in pairs(GetGamePool('CPed')) do
            if v ~= selfPed then
                if GetIsTaskActive(v, 165) then
                    ClearPedTasksImmediately(v)
                    DeleteEntity(v)
                end
            end
        end
    end
end)
]==]
---#SXSEC-14 end

---#SXSEC-15
local actionNames = {
    { "ACT_hitby_stealth_kill_a", false },
    { "ACT_hitby_stealth_kill_a_gardener", false },
    { "ACT_hitby_stealth_kill_b", false },
    { "ACT_hitby_stealth_kill_c", false },
    { "ACT_hitby_stealth_kill_d", false },
    { "ACT_hitby_stealth_kill_knife", false },
    { "ACT_hitby_stealth_kill_bat", false },
    { "ACT_hitby_stealth_kill_small_wpn", false },
    { "ACT_hitby_failed_takedown_front", false },
    { "ACT_hitby_failed_takedown_front_knife", false },
    { "ACT_hitby_failed_takedown_front_bat", false },
    { "ACT_hitby_failed_takedown_front_small_wpn", false },
    { "ACT_hitby_failed_takedown_rear", false },
    { "ACT_takedown_front_psycho", false },
    { "ACT_takedown_front_psycho_b", false },
    { "ACT_takedown_front_psycho_c", false },
    { "ACT_takedown_rear_psycho", false },
    { "ACT_takedown_rear_psycho_b", false },
    { "ACT_hitby_failed_takedown_rear_knife", false },
    { "ACT_hitby_failed_takedown_rear_bat", false },
    { "ACT_hitby_failed_takedown_rear_small_wpn", false },
    { "ACT_hitby_takedown_front_a", false },
    { "ACT_hitby_takedown_front_b", false },
    { "ACT_hitby_takedown_front_knife_b", false },
    { "ACT_hitby_takedown_front_c", false },
    { "ACT_hitby_takedown_front_knife_c", false },
    { "ACT_hitby_takedown_front_d", false },
    { "ACT_hitby_takedown_front_e", false },
    { "ACT_hitby_takedown_front_g", false },
    { "ACT_hitby_takedown_front_h", false },
    { "ACT_hitby_takedown_front_psycho", false },
    { "ACT_hitby_takedown_front_psycho_b", false },
    { "ACT_hitby_takedown_front_psycho_c", false },
    { "ACT_hitby_takedown_front_knife", false },
    { "ACT_hitby_takedown_front_bat", false },
    { "ACT_hitby_takedown_front_small_wpn", false },
    { "ACT_hitby_takedown_front_hatchet", false },
    { "ACT_hitby_takedown_front_hatchet_b", false },
    { "ACT_hitby_takedown_front_machete", false },
    { "ACT_hitby_takedown_front_machete_b", false },
    { "ACT_hitby_takedown_front_pistol", false },
    { "ACT_hitby_takedown_front_rifle", false },
    { "ACT_hitby_takedown_front_thrown", false },
    { "ACT_hitby_takedown_front_dog", false },
    { "ACT_hitby_takedown_front_cougar", false },
    { "ACT_hitby_takedown_rear", false },
    { "ACT_hitby_takedown_rear_hatchet", false },
    { "ACT_hitby_takedown_rear_hatchet_b", false },
    { "ACT_hitby_takedown_rear_machete", false },
    { "ACT_hitby_takedown_rear_machete_b", false },
    { "ACT_hitby_takedown_rear_b", false },
    { "ACT_hitby_takedown_rear_knife_b", false },
    { "ACT_hitby_takedown_rear_c", false },
    { "ACT_hitby_takedown_rear_knife_c", false },
    { "ACT_hitby_takedown_rear_psycho", false },
    { "ACT_hitby_takedown_rear_psycho_b", false },
    { "ACT_hitby_takedown_rear_knife", false },
    { "ACT_hitby_takedown_rear_bat", false },
    { "ACT_hitby_takedown_rear_small_wpn", false },
    { "ACT_hitby_takedown_rear_pistol", false },
    { "ACT_hitby_takedown_rear_rifle", false },
    { "ACT_hitby_takedown_rear_thrown", false },
    { "ACT_hitby_takedown_rear_dog", false },
    { "ACT_hitby_takedown_rear_cougar", false },
    { "ACT_stealth_kill_a", false },
    { "ACT_stealth_kill_a_gardener", false },
    { "ACT_stealth_kill_b", false },
    { "ACT_stealth_kill_c", false },
    { "ACT_stealth_kill_d", false },
    { "ACT_stealth_kill_weapon", false },
    { "ACT_failed_takedown_front", false },
    { "ACT_failed_takedown_rear", false },
    { "ACT_takedown_front_a", false },
    { "ACT_takedown_front_knife_a", false },
    { "ACT_takedown_front_b", false },
    { "ACT_takedown_front_knife_b", false },
    { "ACT_takedown_front_c", false },
    { "ACT_takedown_front_knife_c", false },
    { "ACT_takedown_front_d", false },
    { "ACT_takedown_front_e", false },
    { "ACT_takedown_front_g", false },
    { "ACT_takedown_front_h", false },
    { "ACT_takedown_front_armed_long", false },
    { "ACT_takedown_front_armed_short", false },
    { "ACT_takedown_front_armed_long_vs_ai", false },
    { "ACT_takedown_front_armed_short_vs_ai", false },
    { "ACT_takedown_front_dog", false },
    { "ACT_takedown_front_cougar", false },
    { "ACT_takedown_rear_a", false },
    { "ACT_takedown_rear_knife_a", false },
    { "ACT_takedown_rear_b", false },
    { "ACT_takedown_rear_knife_b", false },
    { "ACT_takedown_rear_c", false },
    { "ACT_takedown_rear_knife_c", false },
    { "ACT_takedown_rear_armed_long", false },
    { "ACT_takedown_rear_armed_short", false },
    { "ACT_takedown_rear_dog", false },
    { "ACT_takedown_rear_cougar", false },
    { "ACT_hitby_light_finish", false },
    { "ACT_hitby_heavy_finish", false },
    { "ACT_hitby_armed_melee_front_melee", false },
    { "ACT_hitby_armed_melee_front_no_melee", false },
    { "ACT_hitby_armed_melee_back", false },
    { "ACT_hitby_armed_melee_left", false },
    { "ACT_hitby_armed_melee_right", false },
    { "ACT_hitby_armed_any", false },
    { "ACT_hitby_knife_melee", false },

    { "ACT_hitby_animal_front_no_melee", true },
    { "ACT_hitby_animal_back_no_melee", true },
    { "ACT_hitby_animal_left_no_melee", true },
    { "ACT_hitby_animal_right_no_melee", true },
    { "ACT_hitby_animal_front_melee", true },
    { "ACT_hitby_animal_back_melee", true },

    { "ACT_dog_hitby_rear", true },
    { "ACT_dog_hitby_front", true },
    { "ACT_dog_hitby_left", true },
    { "ACT_dog_hitby_right", true },
    { "ACT_cougar_hitby_rear", true },
    { "ACT_cougar_hitby_front", true },
    { "ACT_cougar_hitby_left", true },
    { "ACT_cougar_hitby_right", true },
    { "ACT_hitby_counter_left", true },
    { "ACT_hitby_counter_left_knife", true },
    { "ACT_hitby_counter_right", true },
    { "ACT_hitby_counter_right_knife", true },
    { "ACT_hitby_front_no_melee_plyr_still", true },
    { "ACT_hitby_knife_front_no_melee_ai", true },
    { "ACT_hitby_front_melee_plyr", true },
    { "ACT_hitby_front_melee_plyr_var_a", true },
    { "ACT_hitby_rear_melee_plyr", true },
    { "ACT_hitby_right_melee_plyr", true },
    { "ACT_hitby_left_melee_plyr", true },
    { "ACT_hitby_rear_no_melee_plyr_still", true },
    { "ACT_hitby_knife_rear_no_melee_ai", true },
    { "ACT_hitby_left_no_melee_plyr_still", true },
    { "ACT_hitby_left_no_melee_plyr_moving", true },
    { "ACT_hitby_player_left_no_melee_plyr_moving", true },
    { "ACT_hitby_knife_left_no_melee_ai", true },
    { "ACT_hitby_right_no_melee_plyr_still", true },
    { "ACT_hitby_right_no_melee_plyr_moving", true },
    { "ACT_hitby_player_right_no_melee_plyr_moving", true },
    { "ACT_hitby_knife_right_no_melee_ai", true },
    { "ACT_hitby_any_no_melee_ai", true },
    { "ACT_hitby_heavy_1a", true },
    { "ACT_hitby_heavy_1b", true },
    { "ACT_hitby_heavy_2a", true },
    { "ACT_hitby_heavy_2b", true },
    { "ACT_hitby_heavy_2c", true },
    { "ACT_hitby_heavy_3a", true },
    { "ACT_hitby_heavy_3b", true },
    { "ACT_hitby_daze_a", true },
    { "ACT_hitby_daze_b", true },
    { "ACT_hitby_daze_c", true },
    { "ACT_hitby_daze_d", true },
    { "ACT_hitby_walking", true },
    { "ACT_hitby_running", true },
    { "ACT_hitby_running_shove", true },
    { "ACT_hitby_kick_close", true },
    { "ACT_hitby_kick_close_b", true },
    { "ACT_hitby_forward_medium", true },
    { "ACT_hitby_forward_short", true },
    { "ACT_hitby_rear", true },
    { "ACT_hitby_right", true },
    { "ACT_hitby_left", true },
    { "ACT_hitby_any_unarmed_ragdoll", true },
    { "ACT_hitby_any_unarmed_ik", true },
    { "ACT_hitby_any_armed", true },
    { "ACT_counter_left", true },
    { "ACT_counter_right", true },
    { "ACT_dodge_left", true },
    { "ACT_dodge_right", true },
    { "ACT_heavy_recoil_left", true },
    { "ACT_heavy_recoil_right", true },
    { "ACT_recoil_armed", true },
    { "ACT_recoil_kick", true },

    { "ACT_light_finish", false },
    { "ACT_heavy_finish", false },

    { "ACT_walking_target_player", true },
    { "ACT_walking_target_player_zombie", true },
    { "ACT_walking_target_AI", true },
    { "ACT_walking_target_AI_zombie", true },
    { "ACT_running_target", true },
    { "ACT_running_target_long_range", true },
    { "ACT_running_armed_close", true },
    { "ACT_forward_surface_breakable", true },
    { "ACT_forward_surface_side_a", true },
    { "ACT_forward_surface_side_b", true },
    { "ACT_forward_surface_down", true },
    { "ACT_forward_vehicle_below", true },
    { "ACT_shove", true },
    { "ACT_shove_zombie", true },
    { "ACT_running_shove", true },
    { "ACT_forward_short", true },
    { "ACT_forward_short_melee_fist", true },
    { "ACT_forward_short_armed", true },
    { "ACT_forward_medium", true },
    { "ACT_forward_medium_armed", true },
    { "ACT_forward_close_mid", true },
    { "ACT_forward_close_zombie_mid", true },
    { "ACT_forward_long_mid", true },
    { "ACT_forward_long_mid_running", true },
    { "ACT_rear_left_medium", true },
    { "ACT_rear_left_medium_zombie", true },
    { "ACT_rear_left_close_mid", true },
    { "ACT_rear_left_close_zombie_mid", true },
    { "ACT_rear_right_medium", true },
    { "ACT_rear_right_medium_zombie", true },
    { "ACT_rear_right_close_mid", true },
    { "ACT_rear_right_close_zombie_mid", true },
    { "ACT_rear_left_close", true },
    { "ACT_rear_left_close_zombie", true },
    { "ACT_rear_right_close", true },
    { "ACT_rear_right_close_zombie", true },
    { "ACT_left_medium", true },
    { "ACT_left_medium_zombie", true },
    { "ACT_left_close_mid", true },
    { "ACT_left_close_zombie_mid", true },
    { "ACT_left_close", true },
    { "ACT_left_close_zombie", true },
    { "ACT_right_medium", true },
    { "ACT_right_medium_zombie", true },
    { "ACT_right_close_mid", true },
    { "ACT_right_close_zombie_mid", true },
    { "ACT_right_close", true },
    { "ACT_right_close_zombie", true },
    { "ACT_armed_melee_aiming_player", true },
    { "ACT_armed_melee_idle_player", true },
    { "ACT_armed_melee_aiming_ai", true },
    { "ACT_armed_melee_idle_ai", true },
    { "ACT_forward_kick", true },
    { "ACT_rear_left_kick", true },
    { "ACT_rear_right_kick", true },
    { "ACT_left_kick", true },
    { "ACT_right_kick", true },
    { "ACT_forward_medium_low", true },
    { "ACT_forward_medium_low_psycho", true },
    { "ACT_forward_long_low", true },
    { "ACT_forward_close_low", true },
    { "ACT_forward_close_low_var_a", true },
    { "ACT_forward_close_low_var_b", true },
    { "ACT_forward_close_low_psycho", true },
    { "ACT_dog_forward_close_low", true },
    { "ACT_cougar_forward_close_low", true },
    { "ACT_forward_very_close_low", true },
    { "ACT_forward_very_close_low_var_a", true },
    { "ACT_forward_very_close_low_psycho_a", true },
    { "ACT_forward_very_close_low_psycho_b", true },
    { "ACT_forward_very_close_low_psycho_c", true },
    { "ACT_rear_left_close_low", true },
    { "ACT_rear_right_close_low", true },
    { "ACT_left_close_low", true },
    { "ACT_right_close_low", true },
    { "ACT_forward_short_no_target", true },
    { "ACT_armed_melee_aiming_no_target", true },
    { "ACT_armed_melee_idle_no_target", true },
    { "ACT_walking_no_target", true },
    { "ACT_running_no_target", true },
    { "ACT_swim_dive_still", true },
    { "ACT_swim_dive_still_var_b", true },
    { "ACT_swim_dive_moving", true },
    { "ACT_swim_dive_moving_var_b", true },
    { "ACT_swim_surface_still", true },
    { "ACT_swim_surface_still_var_b", true },
    { "ACT_swim_surface_moving", true },
    { "ACT_swim_surface_moving_var_b", true },
    { "ACT_heavy_1a", false },
    { "ACT_heavy_1a_zombie", false },
    { "ACT_heavy_1b", false },
    { "ACT_heavy_1b_zombie", false },
    { "ACT_heavy_2a", false },
    { "ACT_heavy_2a_zombie", false },
    { "ACT_heavy_2b", false },
    { "ACT_heavy_2b_zombie", false },
    { "ACT_heavy_2c", false },
    { "ACT_heavy_2c_zombie", false },
    { "ACT_heavy_3a", false },
    { "ACT_heavy_3a_zombie", false },
    { "ACT_heavy_3b", false },
    { "ACT_heavy_3b_zombie", false },
    { "ACT_dog_attack", false },
    { "ACT_dog_small_attack", false },
    { "ACT_cougar_attack", false },
    { "ACT_cougar_finish", false },
    { "ACT_forward_kick_close", false },
    { "ACT_forward_kick_close_heavy", false },
    { "ACT_forward_kick_close_b", false },
    { "ACT_forward_kick_close_b_heavy", false },
    { "ACT_intro_plyr", false },
    { "ACT_intro_ai", false },
    { "ACT_intro_ai_var_a", false },
    { "ACT_intro_ai_var_b", false },
    { "ACT_intro_ai_var_c", false },
    { "ACT_directional_ally_taunt_left", false },
    { "ACT_directional_ally_taunt_right", false },
    { "ACT_taunt_a", false },
    { "ACT_taunt_b", false },
    { "ACT_taunt_c", false },
    { "ACT_taunt_d", false },
    { "ACT_taunt_e", false },
    { "ACT_taunt_f", false },
    { "ACT_taunt_g", false },
    { "ACT_dog_taunt_a", false },
    { "ACT_dog_taunt_b", false },
    { "ACT_cougar_taunt_a", false },
    { "ACT_zombie_support_taunt_a", false },
    { "ACT_zombie_support_taunt_b", false },
    { "ACT_zombie_support_taunt_c", false },
    { "ACT_zombie_support_taunt_d", false },
    { "ACT_zombie_support_taunt_e", false },
    { "ACT_support_taunt_a", false },
    { "ACT_support_taunt_b", false },
    { "ACT_support_taunt_c", false },
    { "ACT_support_taunt_d", false },
    { "ACT_support_taunt_e", false },
    { "ACT_zombie_taunt_a", false },
    { "ACT_zombie_taunt_b", false },
    { "ACT_zombie_taunt_c", false },
    { "ACT_zombie_taunt_d", false },
    { "ACT_zombie_taunt_e", false },
    { "ACT_zombie_taunt_f", false },
    { "ACT_zombie_taunt_g", false },
    { "ACT_hitby_takedown_front_dog_retriever", false },
    { "ACT_hitby_takedown_rear_dog_retriever", false },
    { "ACT_takedown_front_dog_retriever", false },
    { "ACT_takedown_rear_dog_retriever", false },
    { "ACT_dog_retriever_hitby_rear", false },
    { "ACT_dog_retriever_hitby_front", false },
    { "ACT_dog_retriever_hitby_left", false },
    { "ACT_dog_retriever_hitby_right", false },
    { "ACT_dog_retriever_forward_close_low", false },
    { "ACT_dog_retriever_attack", false },
    { "ACT_tiger_shark_attack", false },
    { "ACT_hammerhead_shark_attack", false },
    { "ACT_killer_whale_attack", false },
    { "ACT_boar_attack", false },
    { "ACT_pig_attack", false },
    { "ACT_coyote_attack", false },
    { "ACT_deer_attack", false },
    { "ACT_hen_flap", false },
    { "ACT_rabbit_scratch", false },
    { "ACT_cat_scratch", false },
    { "ACT_cow_moo", false },
}

for _, entry in ipairs( actionNames ) do

	local actionName = entry[1]
	local enabled = entry[2]

	Citizen.InvokeNative( 0xA6A12939F16D85BE, joaat( actionName ), enabled )
end
---#SXSEC-15 end

--
CreateThread(function()
	while true do
			Wait(0)
			local selfPed = PlayerPedId()
			for k,v in pairs(GetGamePool('CPed')) do
					if v ~= selfPed then
							if GetIsTaskActive(v, 336) then
									ClearPedTasksImmediately(v)
									DeleteEntity(v)
							end
					end
			end
	end
end)
--end
