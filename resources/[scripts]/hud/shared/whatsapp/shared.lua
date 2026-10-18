local lang = GetConvar("language", "pt-br") or "pt-br"

WhatsappText = {
    ["en-us"] = {
        ["title"] = "Boas-vindas",
        ["rewardText"] = "🏎️ 1x Veículo<br><br>🔫 1x Fuzil e 100 Munições<br>🔫 2x Pistola e 150 Munições<br>💵 25 mil em dinheiro do game<br><br>✂️ Acesso ao comando /barbearia<br>🎵 Acesso ao Santafy (/som) da cidade<br>🎒 Espaço da Mochila Aumentado em 120Kg",
        ["cities"] = {
            ["numbers"] = {
                ["Universo"] = "5511936183412",
                ["Santa"] = "5511936185549",
            }
        }
    },
    ["pt-br"] = {
        ["title"] = "Boas-vindas",
        ["rewardText"] = "🏎️ 1x Veículo<br><br>🔫 1x Fuzil e 100 Munições<br>🔫 2x Pistola e 150 Munições<br>💵 25 mil em dinheiro do game<br><br>✂️ Acesso ao comando /barbearia<br>🎵 Acesso ao Santafy (/som) da cidade<br>🎒 Espaço da Mochila Aumentado em 120Kg",
        ["cities"] = {
            ["numbers"] = {
                ["Universo"] = "5511936183412",
                ["Santa"] = "5511936185549",
            }
        }
    },
    ["pt-pt"] = {
        ["title"] = "Boas-vindas",
        ["rewardText"] = "🏎️ 1x Veículo<br><br>🔫 1x Fuzil e 100 Munições<br>🔫 2x Pistola e 150 Munições<br>💵 25 mil em dinheiro do game<br><br>✂️ Acesso ao comando /barbearia<br>🎵 Acesso ao Santafy (/som) da cidade<br>🎒 Espaço da Mochila Aumentado em 120Kg",
        ["cities"] = {
            ["numbers"] = {
                ["Universo"] = "5511936183412",
                ["Santa"] = "5511936185549",
            }
        }
    },
}


function GetWhatsAppConfig()
    return WhatsappText[lang]
end