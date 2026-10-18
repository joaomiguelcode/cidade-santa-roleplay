CouponCodes = {}

RegisterNetEvent('dashboard:redeemCode', function(code)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return end
    TriggerClientEvent('Notify', src, 'azul', 'Código validado com sucesso!', 5000)
end)
