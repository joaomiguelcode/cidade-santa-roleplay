recommendationConfig = recommendationConfig or {}
recommendationConfig["Base"] = {
    ["Lista Fivem"] = "Lista 4",
    ["Youtube"] = "Lista 5",
    ["Season Passada"] = "Lista 1",
    ["Tiktok"] = "Lista 2",
    ["Outros"] = "Lista 3",
    ["Lista do FiveM"] = "Lista 4",
    ["Influencer"] = "Lista 5",
    ["Indicação de amigo"] = "Lista 1",
    ["Redes sociais"] = "Lista 2",
    ["Instagram"] = "Lista 2"
}
recommendationConfig["Santa"] = recommendationConfig["Base"]

infoLogin = infoLogin or {}
infoLogin["Base"] = {
    ["Cars"] = {            
        { name = "Yamaha XJ6", spawn = "xj6", link = "" },
        { name = "Golf GTI", spawn = "golfgti", link = "" },
        { name = "Range Rover", spawn = "rangerover", link = "" },
    },
    ["Recommendation"] = {
        "Lista do FiveM",
        "Influencer",
        "Indicação de amigo",
        "Redes sociais",
        "Outros"
    },
    ["SocialMedia"] = {
        "Instagram",
        "Tiktok",
        "YouTube"
    },
    ["Discord"] = "https://discord.gg",
}
infoLogin["Santa"] = infoLogin["Base"]
