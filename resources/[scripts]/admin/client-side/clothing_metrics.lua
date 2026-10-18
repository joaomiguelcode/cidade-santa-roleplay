local KVP_KEY = 'clothing_metrics'
local CHANGE_CHECK_INTERVAL = 10 * 60 * 1000

local lastFingerprint = nil
local kvpCache = nil
local currentWeekStart = nil

---@return table[]|nil clothingData, string|nil fingerprint
local function scanPedClothing()
    local ped = PlayerPedId()

    if not DoesEntityExist( ped ) or IsEntityDead( ped ) then
        return nil, nil
    end

    local data = {}
    local parts = {}

    for componentId = 0, 11 do
        local drawableId = GetPedDrawableVariation( ped, componentId )
        
        if drawableId > 0 then
            local variationId = GetPedTextureVariation( ped, componentId )
            local collectionName = GetPedCollectionNameFromDrawable( ped, componentId, drawableId )
            local collectionLocalIndex = GetPedCollectionLocalIndexFromDrawable( ped, componentId, drawableId ) or 0

            if type( collectionName ) ~= 'string' then
                collectionName = tostring( collectionName or '' )
            end

            data[#data + 1] = {
                c = componentId,
                d = drawableId,
                v = variationId,
                n = collectionName,
                i = collectionLocalIndex,
            }

            -- sx.logger:debug( ('%d:%d:%d:%s:%d'):format( componentId, drawableId, variationId, collectionName, collectionLocalIndex ) )

            parts[#parts + 1] = ('%d:%d:%d:%s:%d'):format( componentId, drawableId, variationId, collectionName, collectionLocalIndex )
        end
    end

    if #data == 0 then
        return nil, nil
    end

    local fingerprint = tostring( GetHashKey( table.concat( parts, '|' ) ) )

    return data, fingerprint
end

local function loadKvpCache()
    if kvpCache then
        return kvpCache
    end

    local raw = GetResourceKvpString( KVP_KEY )
    kvpCache = raw and json.decode( raw ) or nil

    return kvpCache
end

---@param fingerprint string
---@return boolean
local function isAlreadySentThisWeek( fingerprint )
    local cache = loadKvpCache()

    if not cache or cache.w ~= currentWeekStart then
        return false
    end

    return cache.s and cache.s[fingerprint] == true
end

---@param fingerprint string
local function markAsSent( fingerprint )
    local cache = loadKvpCache()

    if not cache or cache.w ~= currentWeekStart then
        cache = { w = currentWeekStart, s = {} }
    end

    cache.s[fingerprint] = true
    kvpCache = cache
    SetResourceKvp( KVP_KEY, json.encode( cache ) )
end

local function collectAndSend()
    if not currentWeekStart then
        return
    end

    local data, fingerprint = scanPedClothing()

    if not data or not fingerprint then
        return
    end

    lastFingerprint = fingerprint

    if isAlreadySentThisWeek( fingerprint ) then
        return
    end

    markAsSent( fingerprint )
    TriggerServerEvent( 'net.clothingMetrics.collect', data )
end

RegisterNetEvent( 'net.clothingMetrics.scan', function( weekStart )
    if type( weekStart ) == 'string' then
        currentWeekStart = weekStart
    end

    collectAndSend()
end)

CreateThread( function()
    while true do
        Wait( CHANGE_CHECK_INTERVAL )

        local ped = PlayerPedId()

        if DoesEntityExist( ped ) and not IsEntityDead( ped ) then
            local _, fingerprint = scanPedClothing()

            if fingerprint and fingerprint ~= lastFingerprint then
                collectAndSend()
            end
        end
    end
end)