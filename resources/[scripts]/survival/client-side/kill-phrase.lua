local KILL_PHRASE_DEFAULT_DURATION = {
	default = 10,
	pvp = 5,
}
local gKillPhraseDisplayEndsAt = 0
local gKillPhraseDrawAbortSignal = nil
local gKillPhraseHudHidden = false
local gKillPhraseCamera = nil
local gKillPhraseKillerSource = nil
local gKillPhraseDisplayId = 0
local gKillPhraseCinematicPresentationEnabled = false

---@return boolean
local function IsKillPhrasePvpActive( )

	local playerState = LocalPlayer.state

	return playerState and (
		playerState[ 'minigame:active' ] or
		playerState[ 'snowball:match' ] or
		playerState.PVP or
		playerState.FFA or
		playerState.WorldPVP or
		playerState.Arena or
		playerState.Event or
		playerState[ '1x1' ] or
		playerState.GunGame or
		playerState.WarSystem or
		playerState.WarSystemSpec or
		playerState.WarMode or
		playerState.Domination
	) and true or false
end

---@param translationKey string
---@param css string
local function NotifyKillPhrase( translationKey, css )
	TriggerEvent( "Notify", css, _t( translationKey ), 5000, _t( "killPhraseTitle" ) )
end

AddEventHandler( "survival:RestoreKillPhraseHud", function( )

	if not gKillPhraseHudHidden then
		return
	end

	exports[ "hud" ]:hideAllButLogoAndNotifications( false )
	gKillPhraseHudHidden = false
end)

local function StopKillPhraseDisplay( )

	if gKillPhraseDrawAbortSignal then
		gKillPhraseDrawAbortSignal( )
		gKillPhraseDrawAbortSignal = nil
	end

	if gKillPhraseCamera then
		RenderScriptCams( false, true, 200, true, true )
		DestroyCam( gKillPhraseCamera, false )
		gKillPhraseCamera = nil
	end

	StopScreenEffect("DeathFailMPDark")
	StopGameplayCamShaking()

	gKillPhraseKillerSource = nil
	gKillPhraseCinematicPresentationEnabled = false
	TriggerEvent( "survival:KillPhraseDisplayState", false )
	SendNUIMessage( { action = "killPhrase", data = { visible = false } } )
end

---@return number | nil
local function GetKillPhraseKillerPed( )

	if not gKillPhraseKillerSource then
		return
	end

	local player = GetPlayerFromServerId( gKillPhraseKillerSource )

	if player == -1 then
		return
	end

	local ped = GetPlayerPed( player )

	if not DoesEntityExist( ped ) then
		return
	end

	return ped
end

---@param killerPed number
local function StartKillPhraseCamera( killerPed )

	if gKillPhraseCamera then
		return
	end

	gKillPhraseCamera = CreateCam( "DEFAULT_SCRIPTED_CAMERA", true )
	SetCamCoord( gKillPhraseCamera, GetGameplayCamCoord( ) )
	SetCamFov( gKillPhraseCamera, GetGameplayCamFov( ) )
	PointCamAtEntity( gKillPhraseCamera, killerPed, 0.0, 0.0, 1.0, true )
	SetCamActive( gKillPhraseCamera, true )
	RenderScriptCams( true, true, 200, true, true )
end

local function UpdateKillPhraseDisplay( )

	if GetGameTimer( ) >= gKillPhraseDisplayEndsAt then
		local enableCinematicPresentation = gKillPhraseCinematicPresentationEnabled

		StopKillPhraseDisplay( )
		TriggerEvent( "survival:KillPhraseFinished", enableCinematicPresentation )
		return
	end

	if not gKillPhraseCinematicPresentationEnabled then
		return
	end

	local killerPed = GetKillPhraseKillerPed( )

	if not killerPed then
		return
	end

	StartKillPhraseCamera( killerPed )

	if gKillPhraseCamera then
		local killerCoords = GetEntityCoords( killerPed )
		PointCamAtCoord( gKillPhraseCamera, killerCoords.x, killerCoords.y, killerCoords.z + 1.0 )
	end
end

---@param config table
---@param killerSource Source
RegisterNetEvent( "net.survival.ShowKillPhrase", function( config, killerSource )

	StopKillPhraseDisplay( )

	local isPvpActive = IsKillPhrasePvpActive( )
	gKillPhraseCinematicPresentationEnabled = not isPvpActive

	if gKillPhraseCinematicPresentationEnabled then
		StartScreenEffect("DeathFailMPDark", 0, 0)
		ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)

		gKillPhraseKillerSource = killerSource
		exports[ "hud" ]:hideAllButLogoAndNotifications( true )
		TriggerEvent( "hud:Active", false )

		gKillPhraseHudHidden = true
		SendNUIMessage( { action = "setVisible", data = false } )
	end

	local durationSeconds = isPvpActive and KILL_PHRASE_DEFAULT_DURATION.pvp or KILL_PHRASE_DEFAULT_DURATION.default
	gKillPhraseDisplayEndsAt = GetGameTimer( ) + durationSeconds * 1000
	gKillPhraseDisplayId = gKillPhraseDisplayId + 1
	gKillPhraseDrawAbortSignal = sx.script.setTick( UpdateKillPhraseDisplay )

	TriggerEvent( "survival:KillPhraseDisplayState", true )

	SendNUIMessage( {
		action = "killPhrase",
		data = {
			visible = true,
			phrase = config.phrase,
			textColor = config.textColor,
			backgroundColor = config.backgroundColor,
			soundUrl = config.soundUrl,
			displayId = gKillPhraseDisplayId,
		}
	})
end)

---@param catalog table[]
---@return table[]
local function GetKillPhraseOptions( catalog )

	local options = {}

	for index, entry in ipairs( catalog ) do
		options[ index ] = { value = entry.id, label = entry.phrase }
	end

	return options
end

---@param soundIds string[]
---@return table[]
local function GetKillPhraseSoundOptions( soundIds )

	local options = {}

	for index, sound in ipairs( soundIds ) do
		options[ index ] = {
			value = sound.id,
			label = sound.label,
		}
	end

	return options
end

---@param catalog table[]
---@param selection table
---@param soundIds string[]
local function OpenKillPhraseSelection( catalog, selection, soundIds )

	if #catalog == 0 then
		NotifyKillPhrase( "killPhraseCatalogEmpty", "vermelho" )
		return
	end

	local result = lib.inputDialog( _t( "killPhraseTitle" ), {
		{
			type = "select",
			label = _t( "killPhraseLabel" ),
			default = selection.phraseId,
			options = GetKillPhraseOptions( catalog ),
			required = true,
		},
		{
			type = "select",
			label = _t( "killPhraseSound" ),
			default = selection.soundId,
			options = GetKillPhraseSoundOptions( soundIds ),
			required = true,
		},
	} )

	if not result then
		return
	end

	TriggerServerEvent( "survival:SaveKillPhraseSelection", {
		phraseId = result[ 1 ],
		soundId = result[ 2 ],
	} )

end

local function OpenKillPhraseSounds( soundIds )

	local options = {}

	for index, sound in ipairs( soundIds ) do
		options[ index ] = {
			label = sound.label,
			icon = "volume-high",
			args = { soundUrl = sound.audio },
			close = false,
		}
	end

	lib.registerMenu( {
		id = "survival:killPhraseSounds",
		title = _t( "killPhraseSound" ),
		options = options,
	}, function( _, _, args )

		SendNUIMessage( { action = "previewKillPhraseSound", data = args } )
	end )
	lib.showMenu( "survival:killPhraseSounds" )
end

local function OpenKillPhraseDialog( catalog, selection, soundIds )

	if #catalog == 0 then
		NotifyKillPhrase( "killPhraseCatalogEmpty", "vermelho" )
		return
	end

	lib.registerContext( {
		id = "survival:killPhrase",
		title = _t( "killPhraseTitle" ),
		options = {
			{
				title = _t( "killPhraseConfigure" ),
				icon = "sliders",
				onSelect = function( )
					OpenKillPhraseSelection( catalog, selection, soundIds )
				end,
			},
			{
				title = _t( "killPhraseSound" ),
				icon = "volume-high",
				onSelect = function( )
					OpenKillPhraseSounds( soundIds )
				end,
			},
		},
	} )
	lib.showContext( "survival:killPhrase" )
end

local OpenKillPhraseManager
local OpenPersonalizedKillPhraseManager
local OpenPersonalizedKillPhraseActions

---@param catalog table[]
---@param personalizedKillPhrases table[]
local function OpenKillPhraseCatalogManager( catalog, personalizedKillPhrases )

	local actionResult = lib.inputDialog( _t( "killPhraseManagerTitle" ), {
		{
			type = "select",
			label = _t( "killPhraseManagerAction" ),
			default = "create",
			options = {
				{ value = "create", label = _t( "killPhraseManagerCreate" ) },
				{ value = "edit", label = _t( "killPhraseManagerEdit" ) },
				{ value = "delete", label = _t( "killPhraseManagerDelete" ) },
			},
			required = true,
		},
	} )

	if not actionResult then
		OpenKillPhraseManager( catalog, personalizedKillPhrases )
		return
	end

	local action = actionResult[ 1 ]

	if action == "create" then
		local phraseResult = lib.inputDialog( _t( "killPhraseManagerCreate" ), {
			{
				type = "textarea",
				label = _t( "killPhraseLabel" ),
				description = _t( "killPhraseDescription" ),
				max = 80,
				required = true,
			},
			{
				type = "color",
				label = _t( "killPhraseTextColor" ),
				default = "#FFFFFF",
				format = "hex",
			},
			{
				type = "color",
				label = _t( "killPhraseBackgroundColor" ),
				default = "#000000",
				format = "hex",
			},
		} )

		if not phraseResult then
			return
		end

		TriggerServerEvent( "survival:ManageKillPhraseCatalog", action, nil, phraseResult[ 1 ], phraseResult[ 2 ], phraseResult[ 3 ] )
		NotifyKillPhrase( "killPhraseModerating", "amarelo" )
		return
	end

	if #catalog == 0 then
		NotifyKillPhrase( "killPhraseCatalogEmpty", "vermelho" )
		OpenKillPhraseManager( catalog, personalizedKillPhrases )
		return
	end

	local fields = {
		{
			type = "select",
			label = _t( "killPhraseManagerTarget" ),
			options = GetKillPhraseOptions( catalog ),
			required = true,
		},
	}

	if action == "edit" then
		table.insert( fields, {
			type = "textarea",
			label = _t( "killPhraseLabel" ),
			description = _t( "killPhraseDescription" ),
			max = 80,
			required = true,
		} )
		table.insert( fields, {
			type = "color",
			label = _t( "killPhraseTextColor" ),
			default = "#FFFFFF",
			format = "hex",
		} )
		table.insert( fields, {
			type = "color",
			label = _t( "killPhraseBackgroundColor" ),
			default = "#000000",
			format = "hex",
		} )
	end

	local titleKey = action == "edit" and "killPhraseManagerEdit" or "killPhraseManagerDelete"
	local phraseResult = lib.inputDialog( _t( titleKey ), fields )

	if not phraseResult then
		return
	end

	TriggerServerEvent( "survival:ManageKillPhraseCatalog", action, phraseResult[ 1 ], phraseResult[ 2 ], phraseResult[ 3 ], phraseResult[ 4 ] )

	if action == "edit" then
		NotifyKillPhrase( "killPhraseModerating", "amarelo" )
	end
end

---@param entry table | nil
---@return table | nil
local function GetPersonalizedKillPhraseInput( entry )

	entry = entry or {}

	local result = lib.inputDialog( entry.id and _t( "killPhraseManagerEdit" ) or _t( "killPhrasePersonalizedCreate" ), {
		{
			type = "number",
			label = _t( "killPhraseTargetPassport" ),
			description = _t( "killPhraseTargetPassportDescription" ),
			default = entry.targetPassport,
			min = 1,
			precision = 0,
			required = true,
		},
		{
			type = "textarea",
			label = _t( "killPhraseLabel" ),
			description = _t( "killPhraseDescription" ),
			default = entry.phrase,
			max = 80,
			required = true,
		},
		{
			type = "color",
			label = _t( "killPhraseTextColor" ),
			default = entry.textColor or "#FFFFFF",
			format = "hex",
		},
		{
			type = "color",
			label = _t( "killPhraseBackgroundColor" ),
			default = entry.backgroundColor or "#000000",
			format = "hex",
		},
	} )

	if not result then
		return
	end

	return {
		targetPassport = result[ 1 ],
		phrase = result[ 2 ],
		textColor = result[ 3 ],
		backgroundColor = result[ 4 ],
	}
end

---@param personalizedKillPhrases table[]
local function CreatePersonalizedKillPhrase( personalizedKillPhrases )

	local input = GetPersonalizedKillPhraseInput( )

	if not input then
		OpenPersonalizedKillPhraseManager( personalizedKillPhrases )
		return
	end

	TriggerServerEvent(
		"survival:ManagePersonalizedKillPhrase",
		"create",
		nil,
		input.targetPassport,
		input.phrase,
		input.textColor,
		input.backgroundColor
	)
	NotifyKillPhrase( "killPhraseModerating", "amarelo" )
end

---@param entry table
---@param personalizedKillPhrases table[]
local function EditPersonalizedKillPhrase( entry, personalizedKillPhrases )

	local input = GetPersonalizedKillPhraseInput( entry )

	if not input then
		OpenPersonalizedKillPhraseActions( entry, personalizedKillPhrases )
		return
	end

	TriggerServerEvent(
		"survival:ManagePersonalizedKillPhrase",
		"edit",
		entry.id,
		input.targetPassport,
		input.phrase,
		input.textColor,
		input.backgroundColor
	)
	NotifyKillPhrase( "killPhraseModerating", "amarelo" )
end

---@param entry table
---@param personalizedKillPhrases table[]
local function DeletePersonalizedKillPhrase( entry, personalizedKillPhrases )

	local result = lib.alertDialog( {
		header = _t( "killPhrasePersonalizedDeleteHeader" ),
		content = _t( "killPhrasePersonalizedDeleteContent" ):format( entry.phrase, entry.targetPassport ),
		centered = true,
		cancel = true,
	} )

	if result ~= "confirm" then
		OpenPersonalizedKillPhraseActions( entry, personalizedKillPhrases )
		return
	end

	TriggerServerEvent( "survival:ManagePersonalizedKillPhrase", "delete", entry.id )
end

---@param entry table
---@param personalizedKillPhrases table[]
OpenPersonalizedKillPhraseActions = function( entry, personalizedKillPhrases )

	lib.registerContext( {
		id = "survival:personalizedKillPhraseActions",
		title = entry.phrase,
		menu = "survival:personalizedKillPhrases",
		options = {
			{
				title = _t( "killPhraseManagerEdit" ),
				icon = "pencil",
				onSelect = function( )
					EditPersonalizedKillPhrase( entry, personalizedKillPhrases )
				end,
			},
			{
				title = _t( "killPhraseManagerDelete" ),
				icon = "trash",
				onSelect = function( )
					DeletePersonalizedKillPhrase( entry, personalizedKillPhrases )
				end,
			},
		},
	} )
	lib.showContext( "survival:personalizedKillPhraseActions" )
end

---@param personalizedKillPhrases table[]
OpenPersonalizedKillPhraseManager = function( personalizedKillPhrases )

	local options = {
		{
			title = _t( "killPhrasePersonalizedCreate" ),
			icon = "plus",
			onSelect = function( )
				CreatePersonalizedKillPhrase( personalizedKillPhrases )
			end,
		},
	}

	for _, entry in ipairs( personalizedKillPhrases ) do
		local personalizedEntry = entry

		options[ #options + 1 ] = {
			title = personalizedEntry.phrase,
			description = _t( "killPhrasePersonalizedTargetDescription" ):format(
				personalizedEntry.targetName or _t( "killPhraseTargetUnknown" ),
				personalizedEntry.targetPassport
			),
			icon = "quote-left",
			arrow = true,
			onSelect = function( )
				OpenPersonalizedKillPhraseActions( personalizedEntry, personalizedKillPhrases )
			end,
		}
	end

	if #personalizedKillPhrases == 0 then
		options[ #options + 1 ] = {
			title = _t( "killPhrasePersonalizedEmpty" ),
			icon = "inbox",
			disabled = true,
		}
	end

	lib.registerContext( {
		id = "survival:personalizedKillPhrases",
		title = _t( "killPhrasePersonalizedManagerTitle" ),
		menu = "survival:killPhraseManager",
		canShowTextFilter = true,
		options = options,
	} )
	lib.showContext( "survival:personalizedKillPhrases" )
end

---@param catalog table[]
---@param personalizedKillPhrases table[]
OpenKillPhraseManager = function( catalog, personalizedKillPhrases )
	personalizedKillPhrases = personalizedKillPhrases or {}

	lib.registerContext( {
		id = "survival:killPhraseManager",
		title = _t( "killPhraseManagerTitle" ),
		options = {
			{
				title = _t( "killPhraseCatalogManagerTitle" ),
				description = _t( "killPhraseCatalogManagerDescription" ),
				icon = "book-open",
				onSelect = function( )
					OpenKillPhraseCatalogManager( catalog, personalizedKillPhrases )
				end,
			},
			{
				title = _t( "killPhrasePersonalizedManagerTitle" ),
				description = _t( "killPhrasePersonalizedManagerDescription" ),
				icon = "user-tag",
				onSelect = function( )
					OpenPersonalizedKillPhraseManager( personalizedKillPhrases )
				end,
			},
		},
	} )
	lib.showContext( "survival:killPhraseManager" )
end

---@param status string
RegisterNetEvent( "net.survival.KillPhraseResult", function( status )

	local translationKey = ( "killPhrase%s" ):format( status:sub( 1, 1 ):upper( ) .. status:sub( 2 ) )
	local isSuccess = status == "catalogSaved"
		or status == "catalogDeleted"
		or status == "selectionSaved"
		or status == "selectionReset"
		or status == "personalizedSaved"
		or status == "personalizedDeleted"

	NotifyKillPhrase( translationKey, isSuccess and "verde" or "vermelho" )
end)

RegisterNetEvent( "net.survival.OpenKillPhraseDialog", OpenKillPhraseDialog )
RegisterNetEvent( "net.survival.OpenKillPhraseManager", OpenKillPhraseManager )
