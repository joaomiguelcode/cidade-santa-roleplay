---@alias EmoteId string

---@class PairedEmote
---@field id 			  EmoteId
---@field verb 			  string
---@field onStartedServer function( source: Source, pairedSource: Source )

---@type PairedEmote[]
PAIRED_EMOTES =
{
    -- TODO: Futuramente seguir essa estrutura abaixo
    -- ao invés de ter o "onStartedServer" de forma estranha
	-- {
	-- 	id = 'casal',

	-- 	slots =
	-- 	{
	-- 		{ dict = "lovers_couple_pack@anim", anim = "back_rejection_atc" },
	-- 		{ dict = "lovers_couple_pack@anim", anim = "back_rejection_vic" },
	-- 	}
	-- },

	{
		id = 'abracar1',

        verb = 'Beijar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,0.8)
			TriggerClientEvent("abracarr1",source)
			TriggerClientEvent("abracarr2",pairedSource)
		end,
	},
	{
		id = 'casal',

        verb = 'Beijar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.4)
			TriggerClientEvent("casal",source)
			TriggerClientEvent("casal1",pairedSource)
		end,
	},
	{
		id = 'casal2',

        verb = 'Beijar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,0.63)
			TriggerClientEvent("casal2",source)
			TriggerClientEvent("casall2",pairedSource)
		end
	},
	{
		id = 'casal3',

        verb = 'Beijar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.77)
			TriggerClientEvent("casal3",source)
			TriggerClientEvent("casall3",pairedSource)
		end
	},
	{
		id = 'casal4',

        verb = 'Beijar igual cinema',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.37)
			TriggerClientEvent("casal4",source)
			TriggerClientEvent("casall4",pairedSource)
		end
	},
	{
		id = 'casal5',

        verb = 'Beijar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.2)
			TriggerClientEvent("casal5",source)
			TriggerClientEvent("casall5",pairedSource)
		end
	},
	{
		id = 'casal6',

        verb = 'Beijar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.4)
			TriggerClientEvent("casal6",source)
			TriggerClientEvent("casall6",pairedSource)
		end
	},
	{
		id = 'casal7',

        verb = 'Abraçar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.4)
			TriggerClientEvent("casal7",source)
			TriggerClientEvent("casall7",pairedSource)
		end
	},
	{
		id = 'casal8',

        verb = 'Dançar junto com',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,0.3)
			TriggerClientEvent("casal8",source)
			TriggerClientEvent("casall8",pairedSource)
		end
	},
	{
		id = 'casal9',

        verb = 'Dançar junto com',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,0.63)
			TriggerClientEvent("casal9",source)
			TriggerClientEvent("casall9",pairedSource)
		end
	},
	{
		id = 'lutar1',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.5)
			TriggerClientEvent("lutar1",source)
			TriggerClientEvent("lutarr1",pairedSource)
		end
	},
	{
		id = 'lutar2',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar2",source)
			TriggerClientEvent("lutarr2",pairedSource)
		end
	},
	{
		id = 'lutar3',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar3",source)
			TriggerClientEvent("lutarr3",pairedSource)
		end
	},
	{
		id = 'lutar4',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar4",source)
			TriggerClientEvent("lutarr4",pairedSource)
		end
	},
	{
		id = 'lutar5',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar5",source)
			TriggerClientEvent("lutarr5",pairedSource)
		end
	},
	{
		id = 'lutar6',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar6",source)
			TriggerClientEvent("lutarr6",pairedSource)
		end
	},
	{
		id = 'lutar7',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar7",source)
			TriggerClientEvent("lutarr7",pairedSource)
		end
	},
	{
		id = 'lutar8',

        verb = 'Lutar',

		onStartedServer = function( source, pairedSource )

			TriggerClientEvent("syncanim",source,1.7)
			TriggerClientEvent("lutar8",source)
			TriggerClientEvent("lutarr8",pairedSource)
		end
	},
}

---@type table<string, PairedEmote>
PAIRED_EMOTE_BY_ID = { }

do
	for _, pairedEmote in ipairs( PAIRED_EMOTES ) do

		PAIRED_EMOTE_BY_ID[ pairedEmote.id ] = pairedEmote
	end
end

---@param playerState table | nil
---@return boolean
local function IsPlayerInScriptedPvpAnimationBlock( playerState )
	return playerState and (
		( playerState[ 'minigame:active' ] and playerState[ 'minigame:active' ] ~= 'neighbor' ) or
		playerState[ 'snowball:match' ] or
		playerState.PVP or
		playerState.FFA or
		playerState.WorldPVP or
		playerState.Arena or
		playerState[ '1x1' ] or
		playerState.GunGame or
		playerState.WarSystem or
		playerState.WarSystemSpec or
		playerState.WarMode or
		playerState.Domination
	) and true or false
end

---@param pedId number
---@return boolean
function IsPedInScriptedPvpAnimationBlock( pedId )
	if pedId == 0 then
		return false
	end

	if LocalPlayer and pedId == PlayerPedId() and IsPlayerInScriptedPvpAnimationBlock( LocalPlayer.state ) then
		return true
	end

	if IsPlayerInScriptedPvpAnimationBlock( Entity( pedId ).state ) then
		return true
	end

	if IsDuplicityVersion() then
		local player = Player( NetworkGetEntityOwner( pedId ) )
		return player and IsPlayerInScriptedPvpAnimationBlock( player.state ) or false
	end

	return false
end

---@param pedId number
---@return boolean
function IsPedDrivingVehicle( pedId )
	local vehicle = GetVehiclePedIsIn( pedId, false )
	return vehicle ~= 0 and GetPedInVehicleSeat( vehicle, -1 ) == pedId
end

---@param pedId number
---@return boolean
function CanPedPlayEmotes( pedId )

    -- O jogador está morto?
    if GetEntityHealth( pedId ) < 100 then
        return false
    end

	if IsPedInScriptedPvpAnimationBlock( pedId ) then
		return false
	end

    -- O jogador está em um veículo?
    if GetVehiclePedIsIn( pedId, false ) ~= 0 then
        return false
    end

	if IsPedRagdoll( pedId ) then
		return false
	end

    return true
end
