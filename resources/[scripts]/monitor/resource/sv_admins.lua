-- txAdmin sv_admins.lua
RegisterNetEvent('txsv:checkIfAdmin', function()
    local src = source
    local isAdmin = false
    if IsPlayerAceAllowed(src, 'txadmin.menu') or IsPlayerAceAllowed(src, 'command') then
        isAdmin = true
    elseif vRP then
        local passport = vRP.Passport and vRP.Passport(src) or vRP.getUserId(src)
        if passport and (vRP.HasGroup(passport, 'Admin') or vRP.HasPermission(passport, 'admin.permissao')) then
            isAdmin = true
        end
    end
    TriggerClientEvent('txcl:setAdmin', src, isAdmin, {
        username = GetPlayerName(src),
        permissions = { 'all' }
    })
end)
