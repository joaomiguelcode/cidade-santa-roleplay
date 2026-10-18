local BLIPS_STORAGE = { }

---@param crownData CrownData
local function RegisterCrownInBlips( crownData )

    crownData.Coords = toVector3( crownData[ 3 ] )
	BLIPS_STORAGE[ crownData[ 1 ] ] = AddBlipForCoord( crownData.Coords )

	SetBlipSprite( BLIPS_STORAGE[ crownData[ 1 ] ], crownData[ 5 ] )

	SetBlipDisplay( BLIPS_STORAGE[ crownData[ 1 ] ], 4 )

	SetBlipAsShortRange( BLIPS_STORAGE[ crownData[ 1 ] ], true )

	SetBlipColour( BLIPS_STORAGE[ crownData[ 1 ] ], crownData[ 4 ] )

	SetBlipScale( BLIPS_STORAGE[ crownData[ 1 ] ], 1.0 )

	BeginTextCommandSetBlipName( "STRING" )
	AddTextComponentString( crownData[ 2 ] )
	EndTextCommandSetBlipName( BLIPS_STORAGE[ crownData[ 1 ] ] )

end

---@param serial string
local function RemoveCrownFromBlips( serial )

	if not ( BLIPS_STORAGE[ serial ] and DoesBlipExist( BLIPS_STORAGE[ serial ] ) ) then

		sx.logger:debug( ('Crown blip not found: Serial %s'):format( serial ) )

		return
	end

	RemoveBlip( BLIPS_STORAGE[ serial ] )
	BLIPS_STORAGE[ serial ] = nil
end

---@param serial string
---@param crownData table
local function AddCrownFromStorage( serial, crownData )

    if not ( crownData and serial ) then

		sx.logger:debug( ('Crown data or serial not found: Serial %s'):format( serial ) )

		return 
	end 
	
	RegisterCrownInBlips( crownData )
end


---@param serial string	
local function RemoveCrownFromStorage( serial )

	if not ( serial ) then

		sx.logger:debug( ('Serial not found: Serial %s'):format( serial ) )

		return
	end

    RemoveCrownFromBlips( serial )
end

local previousCrowns = { }
AddStateBagChangeHandler( 'crowns', 'global', function( _, _, value )

	local oldCrowns = previousCrowns
	local newCrowns = value or { }
	
	for serial, crown in pairs( oldCrowns ) do

		if not newCrowns[ serial ] then

			RemoveCrownFromStorage( serial )

		end

	end

	for serial, crown in pairs( newCrowns ) do

		if not oldCrowns[ serial ] then

			AddCrownFromStorage( serial, crown )
			
		end
		
	end

	previousCrowns = newCrowns
end)

RegisterNUICallback( "getCityName", function( _, callback )

    cityName = string.lower( GetConvar( "cityName", "" ) )

    callback( cityName )
end)

CreateThread( 
	function()
		
		Wait( 250 )

		local currentCrowns = GlobalState.crowns or { }
		
		for serial, crown in pairs( currentCrowns ) do
			
			AddCrownFromStorage( serial, crown )
			
		end

		previousCrowns = currentCrowns

	end
)