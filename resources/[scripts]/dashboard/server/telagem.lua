local inTelagem = {}

RegisterCommand('telagem', function(source, args)
    local passport = vRP.Passport(source)
    if passport and vRP.HasGroup(passport, 'Admin') then
        local target = tonumber(args[1])
        local tSrc = vRP.Source(target)
        if tSrc then
            inTelagem[target] = true
            FreezeEntityPosition(GetPlayerPed(tSrc), true)
            TriggerClientEvent('Notify', tSrc, 'vermelho', '<b>[TELAGEM]</b> Você foi puxado para telagem. Não deslogue sob pena de banimento permanente!', 60000)
            TriggerClientEvent('Notify', source, 'verde', 'Jogador ID ' .. target .. ' congelado para telagem.', 5000)
        end
    end
end)

RegisterCommand('destelagem', function(source, args)
    local passport = vRP.Passport(source)
    if passport and vRP.HasGroup(passport, 'Admin') then
        local target = tonumber(args[1])
        local tSrc = vRP.Source(target)
        if tSrc then
            inTelagem[target] = nil
            FreezeEntityPosition(GetPlayerPed(tSrc), false)
            TriggerClientEvent('Notify', tSrc, 'verde', 'Telagem concluída. Bom jogo!', 10000)
            TriggerClientEvent('Notify', source, 'verde', 'Jogador ID ' .. target .. ' liberado.', 5000)
        end
    end
end)
