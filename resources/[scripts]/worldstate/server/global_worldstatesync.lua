-- worldstate sync server-side
RegisterNetEvent('worldstate:requestSync', function()
    local source = source
    TriggerClientEvent(EVENTNAME_WORLDSTATESYNC or 'worldstate', source, eWorldStateSyncFlags.ALL, {
        clock = GlobalState.worldClock,
        weather = GlobalState.worldWeather
    })
end)
