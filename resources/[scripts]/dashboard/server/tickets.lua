Tickets = {}

RegisterNetEvent('dashboard:tickets:open', function(subject, message)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return end
    vRP.Query('dashboard/InsertTicket', { passport = passport, subject = subject, message = message })
    TriggerClientEvent('Notify', src, 'verde', 'Ticket aberto com sucesso!', 5000)
end)

RegisterNetEvent('dashboard:tickets:close', function(ticketId)
    local src = source
    local passport = vRP.Passport(src)
    if passport and vRP.HasGroup(passport, 'Admin') then
        vRP.Query('dashboard/CloseTicket', { id = ticketId, staff_passport = passport })
        TriggerClientEvent('Notify', src, 'verde', 'Ticket finalizado.', 5000)
    end
end)
