---@param buffer any[]
local function HandleWorldStateSync( buffer )

    -- print('EVENTNAME_WORLDSTATESYNC buffer=', json.encode( buffer ))

    ---@type eWorldStateSyncFlags
    local flags = table.remove( buffer, 1 )

    if flags & eWorldStateSyncFlags.CLOCK ~= 0 then

        DeserializeWorldClock( buffer )
    end

    if flags & eWorldStateSyncFlags.WEATHER ~= 0 then

        DeserializeWorldWeather( buffer )

        UpdateLocalWorldWeather()
    end
end

RegisterNetEvent( EVENTNAME_WORLDSTATESYNC, HandleWorldStateSync )