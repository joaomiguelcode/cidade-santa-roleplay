RegisterCommand('addxp', function(source, args)
    local passport = vRP.Passport(source)
    if passport and (vRP.HasGroup(passport, 'Admin') or source == 0) then
        local target = tonumber(args[1]) or passport
        local amount = tonumber(args[2]) or 100
        RankingAPI.AddXP(target, amount, 'admin_cmd')
        if source > 0 then
            TriggerClientEvent('Notify', source, 'verde', ('Adicionado %d XP para ID %d'):format(amount, target), 5000)
        end
    end
end)

RegisterCommand('updatepodium', function(source)
    local passport = vRP.Passport(source)
    if passport and (vRP.HasGroup(passport, 'Admin') or source == 0) then
        RankingPodium.Update()
        if source > 0 then TriggerClientEvent('Notify', source, 'verde', 'Podium atualizado.', 5000) end
    end
end)
