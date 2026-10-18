-- new_spawn server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

local server = {}
Tunnel.bindInterface('new_spawn', server)

function server.UsesCharacterCreatorRegister()
    return true
end

function server.GetPlayerInfo()
    local source = source
    local license = vRP.Identities(source)
    if not license then return {} end
    
    local chars = vRP.Query('characters/Characters', { license = license }) or {}
    local formatted = {}
    local maxSlots = 1
    local account = vRP.Account(license)
    if account and account.chars then
        maxSlots = tonumber(account.chars) or 1
    end
    
    for i, c in ipairs(chars) do
        local passport = c.id
        local barbershop = vRP.UserData(passport, "Barbershop") or {}
        local clothings = vRP.UserData(passport, "Clothings") or {}
        local tattooshop = vRP.UserData(passport, "Tattooshop") or {}
        
        formatted[#formatted + 1] = {
            id = passport,
            passport = passport,
            name = c.name or '',
            name2 = c.name2 or '',
            skin = (c.skin and c.skin ~= '') and c.skin or (c.sex == 'F' and 'mp_f_freemode_01' or 'mp_m_freemode_01'),
            sex = c.sex or 'M',
            age = c.age or 25,
            bank = c.bank or 0,
            fines = c.fines or 0,
            Barbershop = barbershop,
            Clothings = clothings,
            Tattooshop = tattooshop,
            lastPosition = false,
            firstLogin = false,
            slots = maxSlots
        }
    end
    
    return formatted
end

function server.ChooseCharacter(passport, spawnCoords)
    local source = source
    passport = parseInt(passport)
    if passport <= 0 then return false end
    
    if spawnCoords and (type(spawnCoords) == "table" or type(spawnCoords) == "vector3") then
        local x = type(spawnCoords) == "vector3" and spawnCoords.x or spawnCoords["x"]
        local y = type(spawnCoords) == "vector3" and spawnCoords.y or spawnCoords["y"]
        local z = type(spawnCoords) == "vector3" and spawnCoords.z or spawnCoords["z"]
        if x and y and z then
            local Datatable = vRP.Datatable(passport)
            if Datatable then
                Datatable["Pos"] = { x = x, y = y, z = z }
            end
        end
    end
    
    vRP.CharacterChosen(source, passport)
    TriggerClientEvent("spawn:ChooseCharacter", source, spawnCoords)
    return true
end

function server.NewCharacter(nome, nome2, sexo, idade)
    local source = source
    local license = vRP.Identities(source)
    if not license then return false end
    
    local id = vRP.Query('characters/newPerson', {
        license = license,
        name = nome,
        name2 = nome2,
        sex = sexo,
        age = idade
    })
    
    if id and id.insertId then
        local model = (sexo == 'F' or sexo == 'feminino') and 'mp_f_freemode_01' or 'mp_m_freemode_01'
        vRP.CharacterChosen(source, id.insertId, model)
        return true
    end
    
    return false
end

function server.OpenCreatedCharacter()
    local source = source
    return true
end

function server.SpawnGod()
    local source = source
    SetPlayerInvincible(GetPlayerPed(source), true)
    SetTimeout(10000, function()
        if DoesEntityExist(GetPlayerPed(source)) then
            SetPlayerInvincible(GetPlayerPed(source), false)
        end
    end)
    return true
end

function server.redeemInfluencerCode(code)
    local source = source
    return true
end

pcall(function()
    lib.callback.register('new_spawn:redeemInfluencerCode', function(source, code)
        return true
    end)
end)
