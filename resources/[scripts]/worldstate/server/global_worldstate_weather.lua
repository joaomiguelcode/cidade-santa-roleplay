-- worldstate weather server-side
WorldWeather = {
    current = 'CLEAR',
    frozen = false
}

function SetWorldWeather(weather)
    WorldWeather.current = string.upper(weather)
    GlobalState.worldWeather = WorldWeather.current
end
