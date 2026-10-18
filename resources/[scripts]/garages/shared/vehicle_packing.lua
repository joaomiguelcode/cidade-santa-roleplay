function Rgb2Int(r, g, b)

	-- print('Rgb2Int -> r', r)
	-- print('Rgb2Int -> g', g)
	-- print('Rgb2Int -> b', b)

	local bR = ( r << 16 )
	local bG = ( g << 8  )
	local bB = b

	local int = bR | bG | bB

	-- print('Rgb2Int -> int', int)

	return int
end

function Int2rgb(int)
	-- print('Int2rgb -> int', int)

	local r = (int >> 16) & 0xFF
	local g = (int >> 8 ) & 0xFF
	local b = int & 0xFF --simplification of  (bitPackedData >> 0)

	-- print('Int2rgb -> r', r)
	-- print('Int2rgb -> g', g)
	-- print('Int2rgb -> b', b)

	return r, g, b
end

eVehicleCustomizationPart =
{
	NeonLightsFlag = 1,
	NeonLightsColor = 2,
	Colors = 3,
	ExtraColors = 4,
	DashboardColour = 5,
	InteriorColour = 6,
	Tint = 7,
	WheelType = 8,
	-- PlateStyle = 9, --[[ Não é usado ]]
	Mods = 10,
	ModsVariations = 11,
	TyreSmokeColor = 12,
	XenonColor = 13,
	Livery = 14,
	ExtrasFlag = 15,
	NumberPlateTextIndex = 16,

	ModWheelsVariation = 17,
	ModRearWheelsVariation = 18,
}

GARAGE_VEHICLE_IS_CREATING_STATEBAG_KEY = 'isCreating'

while not (sx and sx.packethandler) do
    Wait( 50 )
end

VehicleAppearanceDataPacket = sx.packethandler.register(
    ---@class VehicleAppearanceDataPacketData
	---@field hasMaxEngineHealth 	boolean
    ---@field engineHealth 		 	number
	---@field hasMaxBodyHealth 		boolean
    ---@field bodyHealth			number
    ---@field customize 			table
    ---@field brokenWindowsFlag		number 
    ---@field burstTyresFlag		number 
    ---@field degrade 				table 
    ---@field color					number | nil
	function( s, data )

		s( data.hasMaxEngineHealth )

		if not data.hasMaxEngineHealth then

			s( data.engineHealth )
		end

		s( data.hasMaxBodyHealth )

		if not data.hasMaxBodyHealth then

			s( data.bodyHealth )
		end

		s( data.customize )
		s( data.brokenWindowsFlag )
		s( data.burstTyresFlag )
		s( data.degrade )
		s( data.color )
	end
	, false )