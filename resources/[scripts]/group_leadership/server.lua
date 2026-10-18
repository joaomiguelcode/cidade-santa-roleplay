-- group_leadership server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('group_leadership', server)

function server.getLeadershipData(data)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return { ok = false, error = 'unauthenticated' } end
    
    local group = vRP.UserGroupByType(passport, 'Job') or vRP.UserGroupByType(passport, 'Org')
    return {
        ok = true,
        passport = passport,
        group = group,
        cityName = GetConvar('cityName', 'Maresia'):lower()
    }
end

function server.validateLeadership(data)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return { ok = false, error = 'unauthenticated' } end
    
    local targetPassport = parseInt(data.targetPassport or data.passport or 0)
    if targetPassport <= 0 or targetPassport == passport then
        return { ok = false, error = 'invalid_target' }
    end
    
    local targetSource = vRP.Source(targetPassport)
    if not targetSource then
        return { ok = false, error = 'target_offline' }
    end
    
    return { ok = true, targetPassport = targetPassport }
end

function server.confirmLeadership(data)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return { ok = false, error = 'unauthenticated' } end
    
    local targetPassport = parseInt(data.targetPassport or data.passport or 0)
    if targetPassport <= 0 then return { ok = false, error = 'invalid_target' } end
    
    local group = data.group or vRP.UserGroupByType(passport, 'Job')
    if not group then return { ok = false, error = 'no_group' } end
    
    -- Verify sender is leader
    if not vRP.hasPermission(passport, group .. '.Lider') and not vRP.hasPermission(passport, 'Admin') then
        return { ok = false, error = 'not_leader' }
    end
    
    vRP.setPermission(passport, group, 'Membro')
    vRP.setPermission(targetPassport, group, 'Lider')
    
    TriggerClientEvent('Notify', source, 'sucesso', 'Liderança transferida com sucesso!')
    local targetSource = vRP.Source(targetPassport)
    if targetSource then
        TriggerClientEvent('Notify', targetSource, 'sucesso', 'Você agora é o novo líder de ' .. group .. '!')
    end
    
    return { ok = true }
end
