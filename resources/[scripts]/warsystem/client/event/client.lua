cityName = GetConvar("cityName", "")
nEvent = false
StartingEvent = false
EventSpawns = {
    ["Arena"] = {
        [1] = {
            vector4(-1895.64,5958.8,207.48,17.01),
        },
        [2] = {
            vector4(-1952.62,5927.41,207.48,119.06),
        }
    },
    ["Predio"] = {
        [1] = {
            vector4(-1543.85,5947.64,213.54,121.89),
        },
        [2] = {
            vector4(-1577.19,5928.45,213.54,300.48),
        }
    },
    ["Fazenda"] = {
        [1] = {
            vector4(-1815.79,5754.9,209.38,36.86),
        },
        [2] = {
            vector4(-1842.76,5803.05,209.38,215.44),
        }
    },
    ["Cayo"] = {
        [1] = {
            vector4(4974.47,-5785.33,20.88,343.0),
        },
        [2] = {
            vector4(5038.11,-5695.13,19.87,136.07),
        }
    },
    ["2x2"] = {
        [1] = {
            vector4(-1663.09,5864.77,211.36,34.02),
        },
        [2] = {
            vector4(-1675.43,5886.27,211.36,218.27),
        }
    },
    ["Navio"] = {
        [1] = {
            vector4(426.84,-2912.8,6.82,274.97),
        },
        [2] = {
            vector4(527.74,-2912.82,6.74,90.71),
        }
    },
    ["Favelinha"] = {
        [1] = {
            vector4(2123.33,2810.3,50.26,121.89),
        },
        [2] = {
            vector4(2012.31,2737.19,50.14,121.89),
        }
    },
    ["Aldeia"] = {
        [1] = {
            vector4(2007.31,3311.58,45.58,2.84),
        },
        [2] = {
            vector4(2002.74,3454.12,43.3,170.08),
        }
    },

    ["Obs"] = {
        [1] = {
            vector4(658.7,607.1,129.05,249.45),
        },
        [2] = {
            vector4(851.32,516.62,125.92,70.87),
        }
    },
    ["Pelados"] = {
        [1] = {
            vector4(-1166.25,4899.3,217.45,317.49),
        },
        [2] = {
            vector4(-1069.27,4954.32,212.36,136.073),
        }
    },
    ["Zancudo"] = {
        [1] = {
            vector4(-2383.67,3273.28,32.84,56.7),
        },
        [2] = {
            vector4(-2483.39,3319.79,32.82,240.95),
        }
    },
    ["Fabrica"] = {
        [1] = {
            vector4(-619.16,5261.17,73.08,308.98),
        },
        [2] = {
            vector4(-472.12,5367.06,80.78,136.07),
        }
    },
    ["Gang7"] = {
        [1] = {
            vector4(167.75,732.8,208.62,172.92),
        },
        [2] = {
            vector4(130.57,580.92,184.27,172.92),
        }
    },
    ["Quebradinha"] = {
        [1] = {
            vector4(-2770.66,2521.67,3.93,308.98),
        },
        [2] = {
            vector4(-2751.53,2257.9,21.67,348.67),
        }
    },
    ["Lavajato"] = {
        [1] = {
            vector4(-1494.1,256.34,62.13,218.27),
        },
        [2] = {
            vector4(-1577.19,439.18,108.43,172.92),
        }
    },
    ["Fazendinha"] = {
        [1] = {
            vector4(1474.4,1036.11,114.28,269.3),
        },
        [2] = {
            vector4(1450.78,1184.46,114.19,269.3 ),
        }
    },
    ["Gang9"] = {
        [1] = {
            vector4(1496.84,1567.35,111.02,266.46),
        },
        [2] = {
            vector4(1431.82,1369.67,108.53,266.46),
        }
    },
    ["Mansao"] = {
        [1] = {
            vector4(4972.19,-5771.55,20.88,323.15),
        },
        [2] = {
            vector4(5089.81,-5749.96,15.7,68.0),
        }
    },
    ["Praca"] = {
        [1] = {
            vector4(144.6,-1074.89,29.18,340.16),
        },
        [2] = {
            vector4(236.25,-784.28,30.62,155.91),
        }
    },
    ["Pier"] = {
        [1] = {
            vector4(-1537.29,-941.86,11.56,127.56),
        },
        [2] = {
            vector4(-1717.17,-1119.19,13.14,127.56),
        }
    },
}

if cityName == "CidadeNobre" then
    EventSpawns["Palacio"] = {
        [1] = {
            vector4(661.76,3852.37,44.5,272.13),
        },
        [2] = {
            vector4(698.1,3852.4,44.5,87.88),
        }
    }
elseif cityName == "Santa" then
    EventSpawns["Oni"] = {
        [1] = {
            vector4(-2289.2,-687.57,14.73,45.36),
        },
        [2] = {
            vector4(-2315.16,-661.72,14.73,226.78),
        }
    }
end

local circleZone = false
function SetSameTeam(TeamName)
    local Ped = PlayerPedId()
    AddRelationshipGroup(TeamName)
    local TeamHash = GetHashKey(TeamName)
    SetPedRelationshipGroupHash(Ped,TeamHash)
    SetEntityCanBeDamagedByRelationshipGroup(Ped,false,TeamHash)
end

RegisterNetEvent("event:pause")
AddEventHandler("event:pause",function()
    StartingEvent = false
    local Ped = PlayerPedId()
    FreezeEntityPosition(Ped,true)
end)

RegisterNetEvent("event:PreStart")
AddEventHandler("event:PreStart",function(Team,Table,TeamName,Type)
    local Ped = PlayerPedId()
    SetEntityCoords(Ped,EventSpawns[Type][Team][1]["x"],EventSpawns[Type][Team][1]["y"],EventSpawns[Type][Team][1]["z"],false,false,false,false)
    FreezeEntityPosition(Ped,true)
    TriggerEvent("Notify:Remkey",false)
end)


RegisterNetEvent("event:Start")
AddEventHandler("event:Start",function(Team,Table,TeamName,Type)
    local Ped = PlayerPedId()
    local Player = PlayerId()
    SetNuiFocus(false,false)
    TriggerEvent("admin:resetSpectate")
    SetEntityCoords(Ped,EventSpawns[Type][Team][1]["x"],EventSpawns[Type][Team][1]["y"],EventSpawns[Type][Team][1]["z"],false,false,false,false)
    SetSameTeam(TeamName)
    SetEntityCollision(Ped,true,true)
    -- Revive antes de freezar para evitar que o player morto fique freezado
    exports["survival"]:Revive(400)
    Wait(200)
    ClearPedTasks(Ped)
    FreezeEntityPosition(Ped,true)
    StartingEvent = true
    SetRunSprintMultiplierForPlayer(Player,1.10)
    if not InEvent then
        TriggerEvent("event:StartNui",Table)
        InEvent = true
        CreateThread(function()
            local Ped = PlayerPedId()
            while InEvent do
                local Health = parseInt(GetEntityHealth(Ped))
                SendNUIMessage({
                    action = 'UpdateHealth',
                    data = Health
                })
                Wait(250)
            end
        end)
        TriggerEvent("hud:Active",false)
        TriggerEvent("Notify:Remkey" ,true)
        TriggerEvent("safezone:remPromo",true)
    else
        TriggerEvent("event:NewRound",Table)
    end
    TriggerEvent("hud:Active",false)
    TriggerEvent("Notify:Remkey",true)
    Wait(5000)
    if StartingEvent then
        StartingEvent = false
        FreezeEntityPosition(Ped,false)
    end 
end)

RegisterNetEvent("event:Update")
AddEventHandler("event:Update",function(Table)
    SendNUIMessage({
        action = 'setVisible',
        data = "gameplay-events"
    })
     Wait(100)
    SendNUIMessage({
        action = 'UpdateGameStats',
        data = Table
    })
end)

AddEventHandler("event:NewRound",function(Table)
    local Ped = PlayerPedId()
    TriggerEvent("admin:resetSpectate")
    SetEntityCollision(Ped,true,true)
    SendNUIMessage({
        action = 'setVisible',
        data = "countdown"
    })
    Wait(5000)
    SendNUIMessage({
        action = 'setVisible',
        data = "gameplay-events"
    })
     Wait(100)
    SendNUIMessage({
        action = 'UpdateGameStats',
        data = Table
    })
end)

AddEventHandler("event:StartNui",function(Table)
    Wait(100)
    SendNUIMessage({
        action = 'setVisible',
        data = "countdown"
    })
    
    Wait(5000)

    SendNUIMessage({
        action = 'setVisible',
        data = "gameplay-events"
    })

    Wait(100)
    SendNUIMessage({
        action = 'UpdateGameStats',
        data = Table
    })
end)

CreateThread(function()
    local Ped = PlayerPedId()
    while true do
        local Idle = 2500
        if InEvent then
            Idle = 250
            local Health = parseInt(GetEntityHealth(Ped))
            SendNUIMessage({
                action = 'UpdateHealth',
                data = Health
            })
        end
        Wait(Idle)
    end
end)

AddEventHandler("gameEventTriggered",function(name,args)
    if name ~= "CEventNetworkEntityDamage" then
        return
    end
    local Victim = PlayerPedId()
    
    if args[1] ~= Victim then
        return
    end
    
    if not InEvent then
        return
    end

    local Attacker = tonumber(args[2])
    local VictimDied = GetEntityHealth(Victim) <= 100
    local Weapon = tostring(args[7])
    if VictimDied then
        if IsEntityAPed(Victim) then
            if IsPedAPlayer(Attacker) then
                local KillerServerId = GetPlayerServerId((NetworkGetPlayerIndexFromPed(Attacker)))
                local VictimServerId = GetPlayerServerId(PlayerId())
                local KillerCoordinate = GetEntityCoords(Attacker)
                vSERVER.killFeedEvent(KillerServerId,VictimServerId,Weapon)
            end
        end
    end
end)

local FinishSpawns = {
    vector3(-1537.45,-941.96,11.56),
    vector3(201.66,-804.51,31.05),
}
RegisterNetEvent("event:Finish")
AddEventHandler("event:Finish",function(Team)
    local Ped = PlayerPedId()
    local Player = PlayerId()
    exports["survival"]:Revive(400)
    Wait(100)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
    SetPedRelationshipGroupHash(Ped,`PLAYER`)
    TriggerEvent("Notify:Remkey",false)
    TriggerEvent("safezone:remPromo",false)
    TriggerEvent("hud:Active",true)
    local Coords = FinishSpawns[Team] or vector3(-1537.45,-941.96,11.56)
    SetEntityCoords(Ped,Coords)
    SetRunSprintMultiplierForPlayer(Player,1.10)
    ClearPedTasks(Ped)
    FreezeEntityPosition(Ped,false)
end)

RegisterNetEvent("event:KillFeed")
AddEventHandler("event:KillFeed",function(KillerName,VictimName,Weapon,Kills)
    SendNUIMessage({
        action = 'KillFeed',
        data = { 
            killerName = KillerName,
            victimName = VictimName,
            weapon = Weapon,
            duration = 2500,
        }
    })
    SendNUIMessage({
        action = 'UpdateKills',
        data = Kills
    })
end)