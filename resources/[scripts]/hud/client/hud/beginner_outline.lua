local OUTLINE_RADIUS = 50.0
local OUTLINE_RADIUS_SQ = OUTLINE_RADIUS * OUTLINE_RADIUS
local OUTLINE_UPDATE_INTERVAL_MS = 250

local gOutlinedPeds = {}
local gTickAbort
local gNextUpdateAt = 0

---@param entityId number
---@param enabled boolean
local function SetBeginnerOutline( entityId, enabled )

    if not DoesEntityExist( entityId ) then
        return
    end

    SetEntityDrawOutline( entityId, enabled )

    if enabled then
        SetEntityDrawOutlineColor( 124, 58, 237, 255 )
        SetEntityDrawOutlineShader( 1 )
        Citizen.InvokeNative( 1759507165, 'waterreflection' )
    end
end

---@param pedId number
local function ClearOutlinedPed( pedId )

    if not gOutlinedPeds[ pedId ] then
        return
    end

    SetBeginnerOutline( pedId, false )
    gOutlinedPeds[ pedId ] = nil
end

local function ClearAllOutlinedPeds()

    for pedId in pairs( gOutlinedPeds ) do
        ClearOutlinedPed( pedId )
    end
end

---@return boolean
local function CanSeeBeginnerOutlines()

    local groups = vRP.GetPlayerGroups() or {}

    if groups[ 'WallStreet' ] ~= nil or groups[ 'Orgs' ] ~= nil then
        return true
    end

    for group, level in pairs( groups ) do
        local config = Groups[ group ]
        local rank = tonumber( level )

        if config and config.Type == 'Job'
            and group ~= 'Iniciante'
            and group ~= 'Desempregado'
            and rank ~= nil
            and rank <= 3 then
            return true
        end
    end

    return false
end

---@param localPedId number
---@param pedId number
---@param localCoords vector3
---@return boolean
local function ShouldOutlinePed( localPedId, pedId, localCoords )

    if pedId == localPedId
        or not DoesEntityExist( pedId )
        or Entity( pedId ).state.Iniciante ~= true
        or not IsEntityOnScreen( pedId )
    then
        return false
    end

    local pedModel = GetEntityModel( pedId )

    -- Outros modelos de ped causam crash ao aplicar o outline.
    if pedModel ~= `mp_f_freemode_01` and pedModel ~= `mp_m_freemode_01` then
        return false
    end

    local pedCoords = GetEntityCoords( pedId )
    local dx = pedCoords.x - localCoords.x
    local dy = pedCoords.y - localCoords.y
    local dz = pedCoords.z - localCoords.z

    return dx * dx + dy * dy + dz * dz <= OUTLINE_RADIUS_SQ
end

local function UpdateBeginnerOutlines()

    local now = GetGameTimer()

    if now < gNextUpdateAt then
        return
    end

    gNextUpdateAt = now + OUTLINE_UPDATE_INTERVAL_MS

    if not CanSeeBeginnerOutlines()
        or LocalPlayer.state[ 'minigame:active' ] then
        ClearAllOutlinedPeds()
        return
    end

    local localPedId = PlayerPedId()

    if not DoesEntityExist( localPedId ) then
        ClearAllOutlinedPeds()
        return
    end

    local localCoords = GetEntityCoords( localPedId )
    local visiblePeds = {}

    for _, playerId in ipairs( GetActivePlayers() ) do
        local pedId = GetPlayerPed( playerId )

        if ShouldOutlinePed( localPedId, pedId, localCoords ) then
            visiblePeds[ pedId ] = true

            if not gOutlinedPeds[ pedId ] then
                SetBeginnerOutline( pedId, true )
                gOutlinedPeds[ pedId ] = true
            end
        end
    end

    for pedId in pairs( gOutlinedPeds ) do
        if not visiblePeds[ pedId ] then
            ClearOutlinedPed( pedId )
        end
    end
end

CreateThread(
    function()
        Wait( 3500 )
        while not (sx and sx.script and sx.script.setTick) do
            Wait( 500 )
        end
        gTickAbort = sx.script.setTick( UpdateBeginnerOutlines )
    end
)

AddEventHandler( 'onResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    ClearAllOutlinedPeds()

    if gTickAbort then
        gTickAbort()
        gTickAbort = nil
    end
end )
