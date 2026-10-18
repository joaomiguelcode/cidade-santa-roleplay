local WORLD_CLOCK_TIME_SCALE = 48.0 -- 1 dia são 30 minutos na vida real

--[[
    86400 / 48.0 = 1800 segundos
    1800 / 60    = 30 minutos
--]]

---@type WorldClock
local gWorldClock = { syncedHours = 0, syncedMinutes = 0, syncedAt = 0 }

---@type number | nil
local gWorldClockHourOverride = nil

---@param buffer any[]
function SerializeWorldClock( buffer )

    local serialized = ( gWorldClock.syncedMinutes << 0 ) | ( gWorldClock.syncedHours << 8 )

    table.insert( buffer, serialized               )
    table.insert( buffer, GetWorldClock().syncedAt )
end

---@param buffer any[]
function DeserializeWorldClock( buffer )

    local serialized = table.remove( buffer, 1 )
    local syncedAt   = table.remove( buffer, 1 )

    local minute = ( serialized >> 0 ) & 0xFF
    local hour   = ( serialized >> 8 ) & 0xFF

    -- print( 'DeserializeWorldClock :: hour='  , hour   )
    -- print( 'DeserializeWorldClock :: minute=', minute )

    SetWorldClockInternal( hour, minute, syncedAt )
end

---@return WorldClock
function GetWorldClock()

    return gWorldClock
end
exports("GetWorldClock",GetWorldClock)

---@param hours?   number
---@param minutes? number
---@param syncedAt number
---@return boolean
function SetWorldClockInternal( hours, minutes, syncedAt )

    if not hours and not minutes then
        return false
    end

    if hours then

        assert( hours >= 0 and hours <= 23, 'Expected hours to be in range [0, 23], got ' .. hours )

        gWorldClock.syncedHours = hours
    end

    if minutes then

        assert( minutes >= 0 and minutes <= 59 )

        gWorldClock.syncedMinutes = minutes
    end

    if syncedAt then

        gWorldClock.syncedAt = syncedAt
    end

    return true
end

---@return number | nil
function GetWorldClockOverride()
    return gWorldClockHourOverride
end

---@param hour number
function SetWorldClockOverride( hour )
    gWorldClockHourOverride = hour
end
exports("SetWorldClockOverride",SetWorldClockOverride)

function ClearWorldClockOverride()
    gWorldClockHourOverride = nil
end

GetServerTime =
    GetGameName() == 'fxserver'
        and GetGameTimer
        or  GetNetworkTimeAccurate

function GetWorldClockHoursAndMinutes()

    local ts = ( WORLD_CLOCK_TIME_SCALE * 1 ) - 1

    local millisecondsSinceSync           = GetServerTime() - gWorldClock.syncedAt
    local millisecondsSinceSyncTimeScaled = math.floor( millisecondsSinceSync * ts )

    local worldClockAsMilliseconds = 0

    worldClockAsMilliseconds += gWorldClock.syncedHours   * 60 * 60 * 1000
    worldClockAsMilliseconds += gWorldClock.syncedMinutes * 60 * 1000

    worldClockAsMilliseconds += millisecondsSinceSyncTimeScaled

    local seconds = math.floor( worldClockAsMilliseconds / 1000 ) % 60
    local minutes = math.floor( worldClockAsMilliseconds / ( 60 * 1000 ) ) % 60
    local hours   = math.floor( worldClockAsMilliseconds / ( 60 * 60 * 1000 ) ) % 24

    return hours, minutes
end