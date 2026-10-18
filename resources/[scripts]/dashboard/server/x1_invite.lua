X1Invite = {}

RegisterNetEvent('dashboard:x1:invite', function(targetPassport)
    local src = source
    local myPassport = vRP.Passport(src)
    local targetSrc = vRP.Source(targetPassport)
    if targetSrc then
        TriggerClientEvent('dashboard:x1:receiveInvite', targetSrc, myPassport, src)
    end
end)
