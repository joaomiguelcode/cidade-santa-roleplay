RegisterNetEvent("register:openplayerdata",function()
    local influencers = vSERVER.GetRegisterInfluencers()

    local order = (recommendationOrder and (recommendationOrder[cityName] or recommendationOrder["Santa"])) or {
        Recommendation = { "Lista do FiveM", "Influencer", "Indicação de amigo", "Redes sociais", "Outros" },
        SocialMedia = { "Instagram", "Tiktok", "YouTube" }
    }
    local recKeys = {}
    if type(getRecommendationTranslationKeys) == "function" then
        pcall(function() recKeys = getRecommendationTranslationKeys(cityName) end)
    end

    SendNUIMessage({
        action = 'openPlayerData',
        data = {
            recommendations = order["Recommendation"] or {},
            recommendationKeys = recKeys or {},
            socialMedia = order["SocialMedia"] or {},
            influencers = influencers or {},
        }
    })
    SetNuiFocus(true, true)
end)

---@param str string
---@return string?
local function capString(str)
    return str:gsub("(%w)([%w']*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

RegisterNUICallback("updatePlayerData",function(data,cb)
    local name = data["name"]
    local surname = data["surname"]
    local fullName = name .. " " .. surname
    local email = data["email"]
    local age = data["age"]
    local gender = data["gender"]
    local recommendation = data["recommendation"]
    local whatsapp = data["whatsapp"]
    local cupom = data["cupom"]

    local influencerId = data.influencer_id
    
    local Data = {
        ["nome"] = name,
        ["nome2"] = surname,
        ["sexo"] = string.lower(data["gender"]),
        ["idade"] = data["age"],
    }
    SendNUIMessage({ 
        action = "close",
        data = false 
    })
    TriggerEvent("spawn:NameInfo",Data)
    TriggerServerEvent( 'register:updatePlayerData',
        fullName,
        email,
        age,
        gender,
        recommendation,
        whatsapp,
        cupom,
        influencerId
    )
    cb(true)
end)

RegisterNUICallback("getCurrentCountryCode",function(Data,CallBack)
    local countryCode = vSERVER.GetPlayerCountryCode()
    print("getCurrentCountryCode",countryCode)
    CallBack(countryCode)
end)
