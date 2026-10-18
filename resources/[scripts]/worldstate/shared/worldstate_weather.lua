cityName = GetConvar("cityName", "")
local WEATHER_TYPES =
{
    'EXTRASUNNY',
    'CLEAR',
    'CLOUDS',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'RAIN',
    'THUNDER',
    'CLEARING',
    'NEUTRAL',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
}

WEATHER_CITIES = 
{
    ['Santa'] = 'CLEAR',
    ['CidadeNobre'] = 'CLEAR',
    ['Boomerang'] = 'CLEAR',
    ['Grande'] = 'CLEAR',
    ['Fronteira'] = 'CLEAR',
    ['Malta'] = 'CLEAR',
    ['Universo'] = 'CLEAR',
    ['Maresia'] = 'CLEAR',
    ['Alexandria'] = 'CLEAR',
    ['Kingdom'] = 'OVERCAST',
    ['District99'] = 'OVERCAST',
    ['Krown'] = 'OVERCAST',
    ['Orizon'] = 'OVERCAST',
    ['Royal'] = 'OVERCAST',
    ['Real'] = 'CLEAR',
    ['Prime'] = 'CLEAR',
}

---@type WorldWeatherIndex
local gWorldWeatherIndex = 1
local gWorldWeatherOverride = nil

---@param weather string
---@return WorldWeatherIndex
local function GetWeatherTypeIndex( weather )

    weather = string.upper( weather )

    for i, v in ipairs( WEATHER_TYPES ) do

        if v == weather then

            return i
        end
    end

    return -1
end

---@param buffer any[]
function SerializeWorldWeather( buffer )

    table.insert( buffer, gWorldWeatherIndex )
end
exports("SerializeWorldWeather",SerializeWorldWeather)

---@param buffer any[]
function DeserializeWorldWeather( buffer )

    local weatherIndex = table.remove( buffer, 1 )

    -- print( 'DeserializeWorldWeather :: weatherIndex=', weatherIndex )

    local weatherType = WEATHER_TYPES[ weatherIndex ]

    assert( weatherType )

    SetWorldWeatherInternal( weatherType )
end

---@param weatherType string
function SetWeatherOverride(weatherType)
    gWorldWeatherOverride = weatherType
    UpdateLocalWorldWeather()
end
exports("SetWeatherOverride",SetWeatherOverride)

function ClearWeatherOverride()
    gWorldWeatherOverride = nil
end
exports("ClearWeatherOverride",ClearWeatherOverride)

---@return string
function GetWorldWeather()
    if gWorldWeatherOverride then
        return gWorldWeatherOverride
    end
    return WEATHER_TYPES[ gWorldWeatherIndex ]
end
exports("GetWorldWeather",GetWorldWeather)

---@param weatherType string
---@return boolean
function SetWorldWeatherInternal( weatherType )

    local index = GetWeatherTypeIndex( weatherType )

    assert( index ~= -1, ( 'Clima "%s" não é valido!' ):format( weatherType ) )

    gWorldWeatherIndex = index

    return true
end
