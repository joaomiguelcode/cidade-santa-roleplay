local gPlayerAccessToken = nil
local gPlayerAccessTokenExpiresAt = nil
local gPlayerGeneration = 0
local gPlayerAuthUser = nil

local function SetPlayerSession(info)
    gPlayerAccessToken = info and info.accessToken or nil
    gPlayerAccessTokenExpiresAt = info and info.expiresAt or nil
    gPlayerGeneration = info and info.generation or 0
    gPlayerAuthUser = info and info.user or nil

    local publicSession = info and {
        accessToken = gPlayerAccessToken,
        expiresAt = gPlayerAccessTokenExpiresAt,
        generation = gPlayerGeneration,
        user = gPlayerAuthUser,
    } or nil
    TriggerEvent( 'sx:playerSessionUpdated', publicSession )
end

RegisterNetEvent( 'net.sx.setPlayerSession', SetPlayerSession )
RegisterNetEvent( 'net.sx.clearPlayerSession', function()
    SetPlayerSession( nil )
end )

exports( 'GetPlayerAuthTokenInfo', function()
    if not gPlayerAccessToken then return nil end

    return {
        accessToken = gPlayerAccessToken,
        expiresAt = gPlayerAccessTokenExpiresAt,
        generation = gPlayerGeneration,
        user = gPlayerAuthUser,
    }
end)

RegisterNUICallback('getPlayerAuthUser', function(data, cb)

    -- sx.logger:info( ('getPlayerAuthUser --> %s'):format( json.encode(gPlayerAuthUser, { indent = true }) ))

    cb( gPlayerAuthUser )
end)
