-- used when muted
local disableUpdates = false
local isListenerEnabled = false
local plyCoords = GetEntityCoords(PlayerPedId())

function orig_addProximityCheck(ply)
	local tgtPed = GetPlayerPed(ply)
	local voiceModeData = Cfg.voiceModes[mode]
	local distance = GetConvar('voice_useNativeAudio', 'false') == 'true' and voiceModeData[1] * 3 or voiceModeData[1]

	return #(plyCoords - GetEntityCoords(tgtPed)) < distance
end
local addProximityCheck = orig_addProximityCheck

---@type pma.eProximityCheckChangeKind
eProximityCheckChangeKind =
{
	OVERRIDE = 1,
	RESET 	 = 2,
}

local PROXIMITY_CHECK_CHANGE_HISTORY_MAX_SIZE = 256

---@type pma.eProximityCheckChangeKind[]
local gProximityCheckChangeHistory = { }

---@param kind pma.eProximityCheckChangeKind
local function PushProximityCheckChange( kind )

	print( ('PushProximityCheckChange: %s'):format( kind ) )

	if #gProximityCheckChangeHistory > PROXIMITY_CHECK_CHANGE_HISTORY_MAX_SIZE then

		print( ('PushProximityCheckChange: too many changes. kind=%s'):format( kind ) )

		return
	end

	table.insert( gProximityCheckChangeHistory, kind )
end

exports("overrideProximityCheck", function(fn)
	addProximityCheck = fn

	PushProximityCheckChange( eProximityCheckChangeKind.OVERRIDE )
end)

exports("resetProximityCheck", function()
	addProximityCheck = orig_addProximityCheck

	PushProximityCheckChange( eProximityCheckChangeKind.RESET )
end)

function addNearbyPlayers()
    if gToxicityMuted then
        MumbleClearVoiceTarget(voiceTarget)
        return
    end
	if disableUpdates then return end

	plyCoords = GetEntityCoords(PlayerPedId())

	MumbleClearVoiceTargetChannels(voiceTarget)
	local players = GetActivePlayers()
	local playerCount = #players
    local useExperimentalCheck = false
    if playerCount > 50 then
        useExperimentalCheck = true
    end 

    -- print('^1Using experimental proximity check: %d^7', tostring(useExperimentalCheck))

	for i = 1, playerCount do
		local ply = players[i]
		local serverId = GetPlayerServerId(ply)
		
		if useExperimentalCheck then
			local tgtPed = GetPlayerPed(ply)
			local distance = #(plyCoords - GetEntityCoords(tgtPed))
			if distance > 50.0 then goto skip_loop end
		end

		if addProximityCheck(ply) then
			if isTarget then goto skip_loop end

			logger.verbose('Added %s as a voice target', serverId)
			MumbleAddVoiceTargetChannel(voiceTarget, serverId)
		end

		::skip_loop::
	end
end

function setSpectatorMode(enabled)
	logger.info('Setting spectate mode to %s', enabled)
	isListenerEnabled = enabled
	local players = GetActivePlayers()
	if isListenerEnabled then
		for i = 1, #players do
			local ply = players[i]
			local serverId = GetPlayerServerId(ply)
			if serverId == playerServerId then goto skip_loop end
			logger.verbose("Adding %s to listen table", serverId)
			MumbleAddVoiceChannelListen(serverId)
			::skip_loop::
		end
	else
		for i = 1, #players do
			local ply = players[i]
			local serverId = GetPlayerServerId(ply)
			if serverId == playerServerId then goto skip_loop end
			logger.verbose("Removing %s from listen table", serverId)
			MumbleRemoveVoiceChannelListen(serverId)
			::skip_loop::
		end
	end
end

RegisterNetEvent('onPlayerJoining', function(serverId)
	if isListenerEnabled then
		MumbleAddVoiceChannelListen(serverId)
		logger.verbose("Adding %s to listen table", serverId)
	end
end)

RegisterNetEvent('onPlayerDropped', function(serverId)
	if isListenerEnabled then
		MumbleRemoveVoiceChannelListen(serverId)
		logger.verbose("Removing %s from listen table", serverId)
	end
end)

-- cache talking status so we only send a nui message when its not the same as what it was before
local lastTalkingStatus = false
local lastRadioStatus = false
local voiceState = "proximity"
CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/muteply', 'Mutes the player with the specified id', {
		{ name = "player id", help = "the player to toggle mute" },
		{ name = "duration", help = "(opt) the duration the mute in seconds (default: 900)" }
	})
	while true do

		while not MumbleIsConnected() do
			Wait(100)
		end

		if GetConvarInt('voice_enableUi', 1) == 1 then
			local curTalkingStatus = MumbleIsPlayerTalking(PlayerId()) == 1
			if lastRadioStatus ~= radioPressed or lastTalkingStatus ~= curTalkingStatus then
				lastRadioStatus = radioPressed
				lastTalkingStatus = curTalkingStatus
				sendUIMessage({
					usingRadio = lastRadioStatus,
					talking = lastTalkingStatus
				})
			end
		end

		if voiceState == "proximity" then
			addNearbyPlayers()
			local isSpectating = NetworkIsInSpectatorMode()
			if isSpectating and not isListenerEnabled then
				setSpectatorMode(true)
			elseif not isSpectating and isListenerEnabled then
				setSpectatorMode(false)
			end
		end

		Wait(GetConvarInt('voice_refreshRate', 200))
	end
end)

exports("setVoiceState", function(_voiceState, channel)
	if _voiceState ~= "proximity" and _voiceState ~= "channel" then
		logger.error("Didn't get a proper voice state, expected proximity or channel, got %s", _voiceState)
	end
	voiceState = _voiceState
	if voiceState == "channel" then
		type_check({channel, "number"})
		-- 65535 is the highest a client id can go, so we add that to the base channel so we don't manage to get onto a players channel
		channel = channel + 65535
		MumbleSetVoiceChannel(channel)
		while MumbleGetVoiceChannelFromServerId(playerServerId) ~= channel do
			Wait(250)
		end
        if not gToxicityMuted then MumbleAddVoiceTargetChannel(voiceTarget, channel) end
	elseif voiceState == "proximity" then
		handleInitialState()
	end
end)

-- Event handler for proximity history requests
RegisterNetEvent('pma-voice:requestProximityHistory', function(requesterId)
    TriggerServerEvent('pma-voice:sendProximityHistory', gProximityCheckChangeHistory, requesterId)
end)

AddEventHandler("onClientResourceStop", function(resource)
	if type(addProximityCheck) == "table" then
		local proximityCheckRef = addProximityCheck.__cfx_functionReference
		if proximityCheckRef then
			local isResource = string.match(proximityCheckRef, resource)
			if isResource then
				addProximityCheck = orig_addProximityCheck
				logger.warn('Reset proximity check to default, the original resource [%s] which provided the function restarted', resource)
			end
		end
	end
end)
