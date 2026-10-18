CreateThread(function()
    local CustomZones = CustomWeather[cityName]
    if CustomZones then
        local Zones = {}
        for i=1,#CustomZones do
            local Info = CustomZones[i]
            local Options = {
                name = "CustomWeatherZone"..i,
                debugPoly = false,
            }
            if Info.Height then
                Options.minZ = Info.Height.min
                Options.maxZ = Info.Height.max
            end
            local Zone = PolyZone:Create(Info.Zone, Options)
            Zones[i] = {Zone = Zone, Weather = Info.Weather, Time = Info.Time}
        end
        local InsideZone = false
        while true do
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
    
            for i=1,#Zones do
                local Info = Zones[i]
                local Zone = Info.Zone
                local Time = Info.Time
                local Weather = Info.Weather
                local IsInside = Zone:isPointInside(Coords)
                if IsInside then
                    exports["worldstate"]:SetWeatherOverride(Weather)
                    exports["worldstate"]:SetWorldClockOverride(Time)
                    InsideZone = i
                elseif InsideZone == i and not IsInside then
                    TriggerEvent('hud:syncConfig')
                    InsideZone = nil
                end
            end
            Wait(1500)
        end
    end
end)