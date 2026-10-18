-- gamemaster validations service
gamemaster.server.validations = {}

function gamemaster.server.validations.isAuthorized(source)
    local passport = vRP.Passport(source)
    if not passport then return false end
    return vRP.HasGroup(passport, 'Admin') or vRP.HasPermission(passport, 'admin.permissao') or IsPlayerAceAllowed(source, 'command')
end
