-- penthouse server events & vSERVER interface
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

vSERVER = {}
Tunnel.bindInterface('penthouse', vSERVER)

function vSERVER.getMyHouses(buildingId, locationId)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return {} end
    local rows = exports.oxmysql:executeSync('SELECT * FROM penthouses WHERE owner_passport = ?', { passport })
    return rows or {}
end

function vSERVER.getNeighbors(buildingId, locationId)
    local rows = exports.oxmysql:executeSync('SELECT property_id, house_name, owner_passport FROM penthouses WHERE building_id = ?', { buildingId })
    return rows or {}
end

function vSERVER.buyHouse(propertyId)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return { success = false } end
    local rows = exports.oxmysql:executeSync('SELECT * FROM penthouses WHERE property_id = ?', { propertyId })
    if rows and rows[1] then
        local price = rows[1].monthly_price or 50000
        if vRP.PaymentFull(passport, price) then
            local expires = os.time() + (30 * 86400)
            exports.oxmysql:executeSync('UPDATE penthouses SET owner_passport = ?, expires_at = ? WHERE property_id = ?', { passport, expires, propertyId })
            return { success = true }
        end
    end
    return { success = false, message = 'Saldo insuficiente.' }
end

function vSERVER.renewProperty(propertyId, targetLevel)
    local src = source
    local passport = vRP.Passport(src)
    if not passport then return { success = false } end
    local expires = os.time() + (30 * 86400)
    exports.oxmysql:executeSync('UPDATE penthouses SET expires_at = ? WHERE property_id = ? AND owner_passport = ?', { expires, propertyId, passport })
    return { success = true }
end

function vSERVER.ringDoorbell(data)
    local src = source
    return true
end

function vSERVER.updateHouseName(data)
    local src = source
    local passport = vRP.Passport(src)
    if passport and data.propertyId and data.name then
        exports.oxmysql:executeSync('UPDATE penthouses SET house_name = ? WHERE property_id = ? AND owner_passport = ?', { data.name, data.propertyId, passport })
        return true
    end
    return false
end

function vSERVER.callHelp(data)
    return true
end

function vSERVER.banUser(data)
    return true
end

function vSERVER.unbanUser(data)
    return true
end

function vSERVER.kickVisitor(data)
    return true
end

function vSERVER.updateAccessType(data)
    return true
end

function vSERVER.updateMaxVisitors(data)
    return true
end

RegisterNetEvent('penthouse.server:givePenthouse', function(data)
    local src = source
    local passport = vRP.Passport(src)
    if passport and vRP.HasGroup(passport, 'Admin') then
        exports.oxmysql:executeSync('UPDATE penthouses SET owner_passport = ? WHERE property_id = ?', { data.targetPassport, data.propertyId })
    end
end)

RegisterNetEvent('penthouse.server:savePenthouseSettings', function(data)
    local src = source
    local passport = vRP.Passport(src)
    if passport and data.propertyId then
        exports.oxmysql:executeSync('UPDATE penthouses SET settings = ? WHERE property_id = ? AND owner_passport = ?', { json.encode(data), data.propertyId, passport })
    end
end)
