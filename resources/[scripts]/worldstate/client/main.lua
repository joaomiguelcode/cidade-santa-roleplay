---Evento usado por outros script para forçar um horário estático no jogo
---#WARNING: Não usar em scripts novos!
---@param e 'Day' | 'Night'
AddEventHandler('timeSet', function ( e )

    if     e == 'Day'   then

        SetWorldClockOverride( 12 )

    elseif e == 'Night' then

        ClearWorldClockOverride()
    end
end)

exports( 'getTime', function()

    local worldClockHours, worldClockMinutes = GetWorldClockHoursAndMinutes()

    return worldClockHours, worldClockMinutes
end)