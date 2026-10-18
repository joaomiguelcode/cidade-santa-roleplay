cityName = GetConvar("cityName", "")
local MONTHS =
{
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
}

---@class WorldClockUpdatedEvent
---@field hours      number
---@field minutes    number
---@field day        number
---@field month      string
---@field monthLabel string

---@param hours   number
---@param minutes number
function UpdateLocalWorldClock(hours, minutes)
    local overridenGameClock = GetWorldClockOverride() or hours
    local worldClockOverride, networkMinutes = GetWorldClockOverride(), minutes

    if not worldClockOverride then
        if cityName == "Kingdom" then
            -- Define the hour sequence
            local hourSequence = {17, 18, 19, 20, 21, 22, 23, 0, 5, 6, 7, 12}
            
            -- Find the closest hour in the sequence
            local closestHour = hourSequence[1]
            local minDifference = math.abs(hours - closestHour)

            for _, hour in ipairs(hourSequence) do
                local difference = math.abs(hours - hour)
                if difference < minDifference then
                    closestHour = hour
                    minDifference = difference
                end
            end

            overridenGameClock = closestHour
        end
    else 
        networkMinutes = 0
    end
        

    NetworkOverrideClockTime(overridenGameClock, networkMinutes, 0)

    local tm = gm_time(GetServerTime())

    local monthLabel = MONTHS[tm.tm_mon]

    ---@type WorldClockUpdatedEvent
    local event = {
        hours = hours,
        minutes = minutes,
        day = tm.tm_mday,
        month = tm.tm_mo,
        monthLabel = monthLabel,
    }

    TriggerEvent('worldstate:clock_updated', event)

    -- print(('UpdateLocalWorldClock :: hours=%d minutes=%d'):format(hours, minutes))
end



CreateThread(function ()

    local prevWorldClockHours, prevWorldClockMinutes = GetWorldClockHoursAndMinutes()

    while true do

        Wait( 0 )

        local worldClock = GetWorldClock()

        if worldClock.syncedAt ~= 0 and GetServerTime() >= worldClock.syncedAt then

            local worldClockHours, worldClockMinutes = GetWorldClockHoursAndMinutes()

            if worldClockHours ~= prevWorldClockHours or worldClockMinutes ~= prevWorldClockMinutes then

                UpdateLocalWorldClock( worldClockHours, worldClockMinutes )

                prevWorldClockHours   = worldClockHours
                prevWorldClockMinutes = worldClockMinutes
            end
        end
    end
end)