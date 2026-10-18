BattlePass = {}

function CheckExperience(passport)
    local info = vRP.Query('battlepass/GetPlayerInfo', { passport = passport })
    if info and info[1] then
        return info[1]
    else
        vRP.Query('battlepass/InsertPlayer', {
            passport = passport,
            experience = 0,
            level = 1,
            hasPremium = 0,
            premium = json.encode({}),
            free = json.encode({})
        })
        return { passport = passport, experience = 0, level = 1, hasPremium = 0 }
    end
end

RegisterNetEvent('battlepass:claimReward', function(level, isPremium)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return end
    TriggerClientEvent('Notify', src, 'verde', 'Recompensa do passe resgatada!', 5000)
end)
