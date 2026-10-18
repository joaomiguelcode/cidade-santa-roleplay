-- smartphone contacts manager
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

Contacts = {}

function GetPlayerPhone(passport)
    local query = exports.oxmysql:executeSync('SELECT phone FROM characters WHERE id = ?', { passport })
    if query and query[1] and query[1].phone then
        return query[1].phone
    end
    return ('%05d'):format(passport)
end

function GetPlayerContacts(passport)
    local rows = exports.oxmysql:executeSync('SELECT * FROM smartphone_contacts WHERE passport = ?', { passport })
    return rows or {}
end

function AddPlayerContact(passport, name, number)
    exports.oxmysql:executeSync('INSERT INTO smartphone_contacts (passport, name, number) VALUES (?, ?, ?)', { passport, name, number })
end

function DeletePlayerContact(passport, id)
    exports.oxmysql:executeSync('DELETE FROM smartphone_contacts WHERE passport = ? AND id = ?', { passport, id })
end
