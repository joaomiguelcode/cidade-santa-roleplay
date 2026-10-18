---@param distance number
---@param coords vector3
---@return vector3
function GetCoordsFromCam( distance, coords )
    local rotation = GetFinalRenderedCamRot()
    local adjusted = vec3( ( math.pi / 180 ) * rotation.x, ( math.pi / 180 ) * rotation.y, ( math.pi / 180 ) * rotation.z )
    local direction = vec3( -math.sin( adjusted.z ) * math.abs( math.cos( adjusted.x ) ), math.cos( adjusted.z ) * math.abs( math.cos( adjusted.x ) ), math.sin( adjusted.x ) )

    return vec3( coords.x + direction.x * distance, coords.y + direction.y * distance, coords.z + direction.z * distance )
end

---@return boolean
---@return vector3
---@return number
function RayCastGamePlayCamera()
    local ped = PlayerPedId()
    local cam = GetFinalRenderedCamCoord()
    local cam2 = GetCoordsFromCam( 200.0, cam )
    local handle = StartExpensiveSynchronousShapeTestLosProbe( cam, cam2, -1, ped, 4 )
    local a, hit, coords, b, entity = GetShapeTestResult( handle )

    return hit, coords, entity
end

---@param playerSource Source
---@return string
function GetProfilePicture( playerSource )
    
    --[[
        WARNING: POR ALGUM MOTIVO TEM QUE FAZER ESTA MERDA
        POIS, TEM CHANCE DE EU ESTAR ESPECTANDO X JOGADOR
        E FICAR ALTERANDO DE 1 PARA OUTRO RAPIDAMENTE, DESSA
        FORMA NÃO DA TEMPO DE CARREGAR O PED DO JOGADOR
    
        - @TkzDev
    ]]

    local playerId = GetPlayerFromServerId( playerSource )

    repeat 
        playerId = GetPlayerFromServerId( playerSource )
        Wait( 100 )
    until playerId ~= -1

    sx.logger:debug( 'GetProfilePicture -> playerId: %s', playerId )

    local playerPed = GetPlayerPed( playerId )

    sx.logger:debug( 'GetProfilePicture -> playerPed: %s', playerPed )

    local handle = RegisterPedheadshot( playerPed )

    sx.logger:debug( 'GetProfilePicture -> handle: %s', handle )

    while not IsPedheadshotReady( handle ) do

        Wait( 100 )
        
    end

    local headshot = GetPedheadshotTxdString( handle )
    sx.logger:debug( 'GetProfilePicture -> headshot: %s', headshot )

    Wait( 100 )

    return headshot
end

---@param playerSource Source
---@return string
function GetPlayerMetricStatus( playerSource )

    local playerId = GetPlayerFromServerId( playerSource )

    local pedId = GetPlayerPed( playerId )

    local playerIdx = NetworkGetPlayerIndexFromPed( pedId )

    local playerId = GetPlayerServerId( playerIdx )

    local inMetricsSystem = Player( playerId ).state.m

    local metricStatus = 'low'
    ---@diagnostic disable-next-line: undefined-field
    if inMetricsSystem and inMetricsSystem > 0 then

        local value = math.floor( inMetricsSystem * 10 )
        if value >= 80 then
            metricStatus = 'high'
        elseif value >= 30 then
            metricStatus = 'medium'
        end
        
    end

    return metricStatus
end