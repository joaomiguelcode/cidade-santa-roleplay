cityName = GetConvar("cityName", "")
RegisterNetEvent("balloons:Start")
AddEventHandler("balloons:Start",function(title,message,duration,Pass)
    if not duration then
        duration = 8
    end
    -- if Pass then
    SendNUIMessage({ Action = "open", title = title, message = message, duration = duration, pass = true })
    -- else
    --     SendNUIMessage({ Action = "open", title = title, message = message, duration = duration, vip = Config.vip, video = Config.video, benefits = Config.benefits, pass = Pass })
    --     SetNuiFocus(true,true)
    -- end
end)


RegisterCommand("balloons",function(source,args)
    --TriggerEvent("balloons:Start","aaaaaaaaaa","aaaaaaaaaa2",15)
    local Vehicle = "Blimp"
    local Image = "https://santaimagens.roleplayrp.com/img/imagens_variadas/passe/ws8ol.png"
    TriggerEvent("balloons:Start","Parabéns",'<p>Você recebeu '..Vehicle..' </p> <img src="'..Image..'" alt="Character">',15)
end)

RegisterNUICallback("close",function(Data,Callback)
	SetNuiFocus(false,false)
end)

RegisterNUICallback("whatsapp",function(Data,Callback)
  print(Data)
  SetNuiFocus(false,false)
  TriggerEvent("player:OpenURL",Data["type"])
end)

Config = {
    ["vip"] = "",
    ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
    ["benefits"] = {
        {
            title = "Benefício 1",
            description = "Acesso a Promoções Exclusivas;"
        },
        {
            title = "Benefício 2",
            description = "Cupons de Descontos;"
        },
        {
            title = "Benefício 3",
            description = "Receber novidades antecipadas;"
        },
        {
            title = "Benefício 4",
            description = "Sorteios apenas para quem estiver no grupo;"
        },
        {
            title = "Benefício 5",
            description = "Produtos exclusivos pra quem esta no grupo;"
        },
    }
}
if cityName == "CidadeNobre" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Acesso a Promoções Exclusivas;"
            },
            {
                title = "Benefício 2",
                description = "Cupons de Descontos;"
            },
            {
                title = "Benefício 3",
                description = "Receber novidades antecipadas;"
            },
            {
                title = "Benefício 4",
                description = "Sorteios apenas para quem estiver no grupo;"
            },
            {
                title = "Benefício 5",
                description = "Produtos exclusivos pra quem esta no grupo;"
            },
        }
    }
elseif cityName == "Boomerang" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Acesso a Promoções Exclusivas;"
            },
            {
                title = "Benefício 2",
                description = "Cupons de Descontos;"
            },
            {
                title = "Benefício 3",
                description = "Receber novidades antecipadas;"
            },
            {
                title = "Benefício 4",
                description = "Sorteios apenas para quem estiver no grupo;"
            },
            {
                title = "Benefício 5",
                description = "Produtos exclusivos pra quem esta no grupo;"
            },
        }
    }
elseif cityName == "Malta" then
        Config = {
            ["vip"] = GlobalState["CityGroupsPromo"],
            ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
            ["benefits"] = {
                {
                    title = "Benefício 1",
                    description = "Acesso a Promoções Exclusivas;"
                },
                {
                    title = "Benefício 2",
                    description = "Cupons de Descontos;"
                },
                {
                    title = "Benefício 3",
                    description = "Receber novidades antecipadas;"
                },
                {
                    title = "Benefício 4",
                    description = "Sorteios apenas para quem estiver no grupo;"
                },
                {
                    title = "Benefício 5",
                    description = "Produtos exclusivos pra quem esta no grupo;"
                },
            }
        }
elseif cityName == "Kingdom" then
        Config = {
            ["vip"] = GlobalState["CityGroupsPromo"],
            ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
            ["benefits"] = {
                {
                    title = "Benefício 1",
                    description = "Access to Exclusive Promotions;"
                },
                {
                    title = "Benefício 2",
                    description = "Discount Coupons;"
                },
                {
                    title = "Benefício 3",
                    description = "Receive news in advance;"
                },
                {
                    title = "Benefício 4",
                    description = "Raffles exclusively for group members;"
                },
                {
                    title = "Benefício 5",
                    description = "Exclusive products for group members;"
                },
            }
        }
elseif cityName == "Imperium" then
        Config = {
            ["vip"] = GlobalState["CityGroupsPromo"],
            ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
            ["benefits"] = {
                {
                    title = "Benefício 1",
                    description = "Access to Exclusive Promotions;"
                },
                {
                    title = "Benefício 2",
                    description = "Discount Coupons;"
                },
                {
                    title = "Benefício 3",
                    description = "Receive news in advance;"
                },
                {
                    title = "Benefício 4",
                    description = "Raffles exclusively for group members;"
                },
                {
                    title = "Benefício 5",
                    description = "Exclusive products for group members;"
                },
            }
        }
elseif cityName == "GoatRP" then
        Config = {
            ["vip"] = GlobalState["CityGroupsPromo"],
            ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
            ["benefits"] = {
                {
                    title = "Benefício 1",
                    description = "Access to Exclusive Promotions;"
                },
                {
                    title = "Benefício 2",
                    description = "Discount Coupons;"
                },
                {
                    title = "Benefício 3",
                    description = "Receive news in advance;"
                },
                {
                    title = "Benefício 4",
                    description = "Raffles exclusively for group members;"
                },
                {
                    title = "Benefício 5",
                    description = "Exclusive products for group members;"
                },
            }
        }
elseif cityName == "District99" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Krown" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Orizon" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Liberty99" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Royal" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Real" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Prime" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Access to Exclusive Promotions;"
            },
            {
                title = "Benefício 2",
                description = "Discount Coupons;"
            },
            {
                title = "Benefício 3",
                description = "Receive news in advance;"
            },
            {
                title = "Benefício 4",
                description = "Raffles exclusively for group members;"
            },
            {
                title = "Benefício 5",
                description = "Exclusive products for group members;"
            },
        }
    }
elseif cityName == "Santa" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Acesso a Promoções Exclusivas;"
            },
            {
                title = "Benefício 2",
                description = "Cupons de Descontos;"
            },
            {
                title = "Benefício 3",
                description = "Receber novidades antecipadas;"
            },
            {
                title = "Benefício 4",
                description = "Sorteios apenas para quem estiver no grupo;"
            },
            {
                title = "Benefício 5",
                description = "Produtos exclusivos pra quem esta no grupo;"
            },
        }
    }
elseif cityName == "Maresia" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Acesso a Promoções Exclusivas;"
            },
            {
                title = "Benefício 2",
                description = "Cupons de Descontos;"
            },
            {
                title = "Benefício 3",
                description = "Receber novidades antecipadas;"
            },
            {
                title = "Benefício 4",
                description = "Sorteios apenas para quem estiver no grupo;"
            },
            {
                title = "Benefício 5",
                description = "Produtos exclusivos pra quem esta no grupo;"
            },
        }
    }
elseif cityName == "Universo" then
    Config = {
        ["vip"] = GlobalState["CityGroupsPromo"],
        ["video"] = "https://www.youtube.com/watch?v=KCVuPg6Xf0M",
        ["benefits"] = {
            {
                title = "Benefício 1",
                description = "Acesso a Promoções Exclusivas;"
            },
            {
                title = "Benefício 2",
                description = "Cupons de Descontos;"
            },
            {
                title = "Benefício 3",
                description = "Receber novidades antecipadas;"
            },
            {
                title = "Benefício 4",
                description = "Sorteios apenas para quem estiver no grupo;"
            },
            {
                title = "Benefício 5",
                description = "Produtos exclusivos pra quem esta no grupo;"
            },
        }
    }
end
