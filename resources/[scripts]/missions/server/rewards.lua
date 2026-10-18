-- missions rewards
function GiveMissionReward(source, passport, rewardDef)
    if not rewardDef then return end
    if rewardDef.money and rewardDef.money > 0 then
        vRP.giveBank(passport, rewardDef.money)
    end
    if rewardDef.items then
        for _, it in ipairs(rewardDef.items) do
            vRP.generateItem(passport, it.name, it.amount or 1, true)
        end
    end
    TriggerClientEvent('Notify', source, 'sucesso', 'Recompensa da missão resgatada!')
end
