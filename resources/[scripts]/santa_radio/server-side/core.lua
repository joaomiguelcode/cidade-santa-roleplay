-- santa_radio server core
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')
vRPC = Tunnel.getInterface('vRP')

Creative = {}
Tunnel.bindInterface('radio', Creative)
vKEYBOARD = Tunnel.getInterface('keyboard')

local Reserved = {
    [1] = 'Policia',
    [2] = 'Policia',
    [3] = 'Policia',
    [4] = 'Policia',
    [5] = 'Policia',
    [6] = 'Paramedico',
    [7] = 'Paramedico',
    [8] = 'Paramedico',
    [9] = 'Mecanico',
    [10] = 'Mecanico',
}

local Facs = {
    [150] = 'Barragem',
    [160] = 'Cartel',
    [170] = 'Sindicato',
    [180] = 'Vagos',
    [200] = 'Umbrella',
    [310] = 'Ballas',
    [380] = 'Groove',
    [410] = 'Bennys',
    [520] = 'Bloods',
    [580] = 'Mexico',
    [999] = 'Aliado'
}

function Creative.Frequency(Number)
    local source = source
    local Number = parseInt(Number)
    local Passport = vRP.Passport(source)
    if Passport then
        if Reserved[Number] then
            if vRP.HasGroup(Passport, Reserved[Number]) or vRP.HasGroup(Passport, 'Admin') then
                return true
            end
        elseif Facs[Number] then
            if vRP.HasGroup(Passport, Facs[Number]) or vRP.HasGroup(Passport, 'Admin') then
                return true
            end
        else
            return true
        end
    end
    return false
end

function Creative.CheckRadio()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local Consult = vRP.InventoryItemAmount(Passport, 'radio')
        if Consult[1] <= 0 then
            return true
        end
        return false
    end
end
