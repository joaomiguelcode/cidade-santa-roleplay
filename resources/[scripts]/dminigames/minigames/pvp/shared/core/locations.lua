PVP_NPC_COORDS = vector4(38.41, -901.97, 29.98, 340.57)
PVP_NPC_SECONDARY_COORDS = vector4(36.06, -666.1, 31.76, 340.16)

PVP_KNG_FFA_GUARD_PED_MODEL = 'GuardaBritanica'
PVP_KNG_FFA_GUARD_COORDS = {
    vector4(193.18, -1002.55, 30.55, 158.75),
    vector4(196.16, -1003.81, 30.55, 150.24),
}

PVP_COMPETITIVE_TEAM_RETURN_COORDS = {
    TeamA = PVP_NPC_COORDS,
    TeamB = PVP_NPC_SECONDARY_COORDS,
}

local function normalizePvpCityName( value )
    return tostring( value or '' ):lower():gsub( '%s+', '' )
end

local function getPvpCityName()
    if CURRENT_CITY_NAME ~= nil and tostring( CURRENT_CITY_NAME ) ~= '' then
        return CURRENT_CITY_NAME
    end

    if cityName ~= nil and tostring( cityName ) ~= '' then
        return cityName
    end

    return GetConvar( 'cityName', GetConvar( 'city_name', '' ) )
end

function PvpIsKngCity()
    local city = normalizePvpCityName( getPvpCityName() )
    return city == 'kng' or city == 'kingdom'
end
