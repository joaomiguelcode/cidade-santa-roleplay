---Configuracao compartilhada do apostado no competitivo.

PVP_COMPETITIVE_BET_MIN_AMOUNT = 100000
PVP_COMPETITIVE_BET_FORFEIT_CHARGE_ROUND = 3

---Cidades onde o apostado fica indisponivel.
---Use o valor normalizado do convar cityName/city_name em minusculo.
PVP_COMPETITIVE_BET_DISABLED_CITIES = {
}

local function normalizeCityName( value )
    return tostring( value or '' ):lower():gsub( '^%s+', '' ):gsub( '%s+$', '' )
end

function PvpGetCurrentCityName()
    return normalizeCityName( CURRENT_CITY_NAME or cityName or GetConvar( 'cityName', GetConvar( 'city_name', '' ) ) )
end

function PvpIsCompetitiveBetEnabled()
    local city = PvpGetCurrentCityName()
    return PVP_COMPETITIVE_BET_DISABLED_CITIES[ city ] ~= true
end
