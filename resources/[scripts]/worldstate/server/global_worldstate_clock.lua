-- worldstate clock server-side
WorldClock = {
    hour = 12,
    minute = 0,
    frozen = false
}

function SetWorldTime(hour, minute)
    WorldClock.hour = hour
    WorldClock.minute = minute
    GlobalState.worldClock = {
        syncedHours = WorldClock.hour,
        syncedMinutes = WorldClock.minute,
        syncedAt = GetGameTimer()
    }
end

CreateThread(function()
    while true do
        Wait(5000)
        if not WorldClock.frozen then
            WorldClock.minute = WorldClock.minute + 1
            if WorldClock.minute >= 60 then
                WorldClock.minute = 0
                WorldClock.hour = (WorldClock.hour + 1) % 24
            end
            GlobalState.worldClock = {
                syncedHours = WorldClock.hour,
                syncedMinutes = WorldClock.minute,
                syncedAt = GetGameTimer()
            }
        end
    end
end)
