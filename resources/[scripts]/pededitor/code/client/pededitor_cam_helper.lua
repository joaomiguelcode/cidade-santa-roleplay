local PED_CAM_FOV = 48.0
local PED_CAM_MIN_DIMENSION = 0.5
local PED_CAM_MIN_DISTANCE = 2.25
local PED_CAM_MAX_DISTANCE = 25.0
local PED_CAM_VERTICAL_MARGIN = 1.2
local PED_CAM_WIDTH_DISTANCE_FACTOR = 0.75
local PED_CAM_DEPTH_CLEARANCE = 1.5
local PED_CAM_HEIGHT_OFFSET_FACTOR = 0.12

local cam = nil

---@param pedId number
---@return number targetHeight
---@return number cameraHeight
---@return number cameraDistance
local function CalculateCamFraming( pedId )

	local minDimensions, maxDimensions = GetModelDimensions( GetEntityModel( pedId ) )
	local modelHeight = math.max( maxDimensions.z - minDimensions.z, PED_CAM_MIN_DIMENSION )
	local modelWidth = math.max( maxDimensions.x - minDimensions.x, PED_CAM_MIN_DIMENSION )
	local modelDepth = math.max( maxDimensions.y - minDimensions.y, PED_CAM_MIN_DIMENSION )
	local targetHeight = ( minDimensions.z + maxDimensions.z ) * 0.5
	local cameraHeight = targetHeight + ( modelHeight * PED_CAM_HEIGHT_OFFSET_FACTOR )
	local halfFovRadians = math.rad( PED_CAM_FOV * 0.5 )
	local heightDistance = ( modelHeight * 0.5 * PED_CAM_VERTICAL_MARGIN ) / math.tan( halfFovRadians )
	local widthDistance = modelWidth * PED_CAM_WIDTH_DISTANCE_FACTOR
	local depthDistance = math.max( modelDepth * 0.5, maxDimensions.y, 0.0 ) + PED_CAM_DEPTH_CLEARANCE
	local cameraDistance = math.max( PED_CAM_MIN_DISTANCE, heightDistance, widthDistance, depthDistance )

	return targetHeight, cameraHeight, math.min( cameraDistance, PED_CAM_MAX_DISTANCE )
end

---@param pedId number
local function ApplyCamFraming( pedId )

	local targetHeight, cameraHeight, cameraDistance = CalculateCamFraming( pedId )
	local targetCoords = GetOffsetFromEntityInWorldCoords( pedId, 0.0, 0.0, targetHeight )
	local cameraCoords = GetOffsetFromEntityInWorldCoords( pedId, 0.0, cameraDistance, cameraHeight )

	SetCamCoord( cam, cameraCoords.x, cameraCoords.y, cameraCoords.z )
	PointCamAtCoord( cam, targetCoords.x, targetCoords.y, targetCoords.z )
end

function CreateCamMode( )

	assert( not cam, 'Cam already exists' )

	local pedId = PlayerPedId( )

	cam = CreateCam( 'DEFAULT_SCRIPTED_CAMERA', true )

	SetCamFov( cam, PED_CAM_FOV )
	SetEntityHeading( pedId, 282.02 )
	ApplyCamFraming( pedId )
	SetCamActive( cam, true )
	RenderScriptCams( true, false, 0, true, true )
end

function RefreshCamMode()

	assert( DoesCamExist( cam ), 'A câmera precisa existir antes de atualizar o alvo.' )

	ApplyCamFraming( PlayerPedId() )
end

function SuspendCamMode()

	assert( DoesCamExist( cam ), 'A câmera precisa existir antes de suspender o alvo.' )

	StopCamPointing( cam )
end

function DestroyCamMode( )

	if not DoesCamExist( cam ) then

		sx.logger:error( 'DestroyCamMode --> Cam does not exist' )

		return
	end

	RenderScriptCams( false, true, 250, 1, 0 )
	DestroyCam( cam, false )

	cam = nil
end
