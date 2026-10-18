-- Register server module: playerdata.lua

RegisterServerEvent('register:updatePlayerData')
AddEventHandler('register:updatePlayerData', function(fullName, email, age, gender, recommendation, whatsapp, cupom, influencerId)
    local source = source
    local license = vRP.Identities(source)
    if not license then return end
    
    local cName = cityName or GetConvar("cityName", "Santa")
    local recVal = (recommendationConfig and (recommendationConfig[cName] or recommendationConfig["Santa"]) and (recommendationConfig[cName] or recommendationConfig["Santa"])[recommendation]) or recommendation or "Outros"
    local birthday = "2000-01-01"
    if age and tonumber(age) then
        local birthYear = 2026 - tonumber(age)
        birthday = string.format("%d-01-01", birthYear)
    end
    
    vRP.Query("accounts/updateAccountInfo", {
        Name = fullName or "Individuo",
        Email = email or "none@email.com",
        Sex = gender or "masculino",
        Recommendation = recVal,
        Birthday = birthday,
        License = license,
        Number = whatsapp or "00000000000"
    })
    
    TriggerClientEvent("register:Close", source)
    TriggerClientEvent("spawn:FirsLogin", source)
end)

function Server.GetPlayerCountryCode()
    return "BR"
end
