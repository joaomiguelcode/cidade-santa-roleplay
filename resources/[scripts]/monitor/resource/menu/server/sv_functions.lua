-- txAdmin sv_functions.lua
function IsSourceAdmin(src)
    if IsPlayerAceAllowed(src, 'txadmin.menu') or IsPlayerAceAllowed(src, 'command') then return true end
    if vRP then
        local p = vRP.Passport and vRP.Passport(src) or vRP.getUserId(src)
        return p and (vRP.HasGroup(p, 'Admin') or vRP.HasPermission(p, 'admin.permissao'))
    end
    return false
end
