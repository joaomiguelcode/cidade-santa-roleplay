-- character-creator main server-side
local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')

lib.callback.register('character-creator:collectsPlayerData', function(source)
    return true
end)

lib.callback.register('character-creator:createCharacter', function(source, data)
    return true
end)

lib.callback.register('character-creator:saveCustomization', function(source, customization, flag, model, characterData, ramo)
    local license = vRP.Identities(source)
    local passport = vRP.Passport(source)

    if not passport or passport <= 0 then
        local name = (characterData and characterData.nome and characterData.nome ~= "") and characterData.nome or "Individuo"
        local name2 = (characterData and characterData.nome2) or ""
        local sex = (model == 'mp_f_freemode_01' or (characterData and characterData.sexo == 'f')) and 'F' or 'M'
        local age = (characterData and tonumber(characterData.idade)) or 25
        local skin = model or (sex == 'F' and 'mp_f_freemode_01' or 'mp_m_freemode_01')
        local phone = vRP.GeneratePhone and vRP.GeneratePhone() or tostring(math.random(100000, 999999))
        local blood = math.random(1, 4)

        if license then
            local account = MySQL.single.await('SELECT id FROM accounts WHERE license = ?', { license })
            if not account then
                MySQL.insert.await('INSERT INTO accounts (license) VALUES (?)', { license })
            end
        end

        local insertId = MySQL.insert.await([[
            INSERT INTO characters (license, name, name2, sex, age, skin, phone, blood)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        ]], { license, name, name2, sex, age, skin, phone, blood })

        if insertId and insertId > 0 then
            passport = insertId
            if license then
                MySQL.update.await([[
                    UPDATE accounts SET name = ?, sex = ? WHERE license = ?
                ]], { name .. " " .. name2, sex == 'M' and 'masculino' or 'feminino', license })
            end
            vRP.CharacterChosen(source, passport, model or skin or (sex == 'M' and 'mp_m_freemode_01' or 'mp_f_freemode_01'))
        else
            return false, false
        end
    end

    if customization then
        CreatorRepository.saveCustomization(passport, customization)
        local encodedCustomization = json.encode(customization)
        pcall(function()
            if vRP.SetUserData then
                vRP.SetUserData(passport, "Barbershop", encodedCustomization)
            elseif vRP.setUserData then
                vRP.setUserData(passport, "Barbershop", encodedCustomization)
            end
        end)
        MySQL.query([[
            REPLACE INTO playerdata (Passport, dkey, dvalue) VALUES (?, 'Barbershop', ?)
        ]], { passport, encodedCustomization })
    end

    if model then
        MySQL.update.await('UPDATE characters SET skin = ? WHERE id = ?', { model, passport })
    end

    if ramo and ramo ~= '' then
        pcall(function()
            vRP.setPermission(passport, ramo, 'Membro')
        end)
    end

    EndCreatorSession(source)
    return true, false
end)

lib.callback.register('character-creator:selectRamo', function(source, ramo, spawnAtFactionFocus)
    local passport = vRP.Passport(source)
    if not passport then return false end
    
    if ramo and ramo ~= '' then
        pcall(function()
            vRP.setPermission(passport, ramo, 'Membro')
        end)
    end
    
    EndCreatorSession(source)
    return true
end)

RegisterNetEvent('character-creator:finishCreation', function(data, ramo)
    local source = source
    local passport = vRP.Passport(source)
    if not passport then return end
    
    if data then
        CreatorRepository.saveCustomization(passport, data)
        local encodedData = json.encode(data)
        pcall(function()
            if vRP.SetUserData then
                vRP.SetUserData(passport, "Barbershop", encodedData)
            elseif vRP.setUserData then
                vRP.setUserData(passport, "Barbershop", encodedData)
            end
        end)
        MySQL.query([[
            REPLACE INTO playerdata (Passport, dkey, dvalue) VALUES (?, 'Barbershop', ?)
        ]], { passport, encodedData })
    end
    
    if ramo and ramo ~= '' then
        pcall(function()
            vRP.setPermission(passport, ramo, 'Membro')
        end)
    end
    
    EndCreatorSession(source)
    TriggerClientEvent('Notify', source, 'sucesso', 'Personagem criado com sucesso!')
end)
