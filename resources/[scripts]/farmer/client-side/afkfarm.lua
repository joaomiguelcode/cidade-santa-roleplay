local InZone = false
local Hacking = false
local LapTop = false
local AfkFarmHoverfyHidden = false
cityName = GetConvar("cityName", "")
local KeySwitch = "E"
local KeySwitchNumber = 38

if cityName == "Santa" then
    KeySwitch = "Q"
    KeySwitchNumber = 44
end

local Zones = {
    PolyZone:Create({
        vector2(1497.73, 6405.30),
        vector2(1467.80, 6368.94),
        vector2(1401.52, 6389.02),
        vector2(1384.47, 6275.76),
        vector2(1546.97, 6281.82),
        vector2(1581.44, 6344.70)
    }, {
        name="HackZone",
        minZ=15,
        maxZ=30
    }),
    PolyZone:Create({
        vector2(5417.4, -5253.21),
        vector2(5389.6, -5293.75),
        vector2(5335.14, -5251.97),
        vector2(5367.91, -5213.78)
    }, {
        name="CayoPerico",
        -- minZ=15,
        -- maxZ=30
    }),
}

local StartCoords = {
    vector3(1531.98,6327.61,24.28),
    vector3(1431.53,6345.75,23.98),
    vector3(1472.44,6359.79,23.67),
    vector3(5377.56,-5253.87,33.82),
}

if cityName == "Santa" then


elseif cityName == "CidadeNobre" then
    -- QG_166 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(555.38,709.35),
        vector2(559.92,713.49),
        vector2(554.89,719.18),
        vector2(549.17,714.65)
    }, {
        name="QG_166",
        --minZ=0,
        --maxZ=800
    })
    -- QG_15 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-1780.00,421.62),
        vector2(-1788.13,421.73),
        vector2(-1788.02,427.66),
        vector2(-1779.90,427.82)
    }, {
        name="QG_15",
        --minZ=0,
        --maxZ=800
    })
    -- QG_218
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3274.19,569.08),
        vector2(-3279.49,565.97),
        vector2(-3282.27,571.15),
        vector2(-3276.92,574.09)
    }, {
        name="QG_218",
        --minZ=0,
        --maxZ=800
    })
    -- QG_75 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(2533.38,3631.43),
        vector2(2553.13,3643.155),
        vector2(2559.12,3632.79),
        vector2(2539.11,3621.79)
    }, {
        name="QG_75",
        --minZ=0,
        --maxZ=800
    })
    -- QG_173 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3803.1,247.97),
        vector2(-3809.53,247.86),
        vector2(-3809.53,251.62),
        vector2(-3803.36,251.71)
    }, {
        name="QG_173",
        --minZ=0,
        --maxZ=800
    })
elseif cityName == "Boomerang" then
    
elseif cityName == "Grande" then

elseif cityName == "Universo" then

    --Gang4 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-440.78,1603.57),
        vector2(-448.82,1579.36),
        vector2(-410.29,1565.52),
        vector2(-407.11,1575.33)
    }, {
    name="Gang4",
    --minZ=0,
    --maxZ=800
    })
    -- QG_171
    Zones[#Zones+1] = PolyZone:Create({
        vector2(991.75,3666.24),
        vector2(1003.98,3665.49),
        vector2(1003.38,3654.24),
        vector2(991.73,3654.41)
    }, {
    name="QG_171",
    --minZ=0,
    --maxZ=800
    })
    --QG_62 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(1552.99,1435.89),
        vector2(1549.44,1449.63),
        vector2(1538.72,1446.35),
        vector2(1543.71,1432.74)
    }, {
    name="QG_62",
    --minZ=0,
    --maxZ=800
    })
    -- QG_104 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(2497.15,3594.52),
        vector2(2471.78,3633.72),
        vector2(2486.91,3644.7),
        vector2(2515.52,3607.1)
    }, {
    name="QG_104",
    --minZ=0,
    --maxZ=800
    })
    -- QG_52
    Zones[#Zones+1] = PolyZone:Create({
        vector2(485.54,-1524.8),
        vector2(478.41,-1518.38),
        vector2(467.27,-1525.5),
        vector2(477.01,-1532.7)
    }, {
    name="QG_52",
    --minZ=0,
    --maxZ=800
    })
    -- QG_172
    Zones[#Zones+1] = PolyZone:Create({
        vector2(2728.79,1893.0),
        vector2(2757.63,1891.01),
        vector2(2758.52,1872.3),
        vector2(2738.97,1873.79)
    }, {
    name="QG_172",
    --minZ=0,
    --maxZ=800
    })

    --FarmAFKSindicato 
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-2296.47,242.25),
        vector2(-2325.7,223.5),
        vector2(-2298.5,162.53),
        vector2(-2267.86,172.58)
    }, {
    name="FarmAFKSindicato ",
    --minZ=0,
    --maxZ=800
    })
    StartCoords[#StartCoords+1] = vector3(-432.93,1585.69,360.32)
elseif cityName == "Maresia" then



elseif cityName == "Malta" then   

elseif cityName == "Kingdom" then 
    -- QG_54
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-43.06,947.94),
        vector2(-44.04,936.28),
        vector2(-55.84,938.33),
        vector2(-53.41,948.84)
    }, {
    name="QG_54",
    --minZ=0,
    --maxZ=800
    })
    -- QG_367
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3501.19, 1303.10),
        vector2(-3494.88, 1300.46),
        vector2(-3497.11, 1294.19),
        vector2(-3502.15, 1296.41)
    }, {
    name="QG_367",
    --minZ=0,
    --maxZ=800
    })
    -- QG_43
    Zones[#Zones+1] = PolyZone:Create({
        vector2(84.56, -1985.32),
        vector2(82.16, -1982.51),
        vector2(85.10, -1978.29),
        vector2(88.94, -1981.49)
    }, {
    name="QG_43",
    --minZ=0,
    --maxZ=800
    })
    -- Mansao94
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-437.34, 4393.5),
        vector2(-431.65, 4398.49),
        vector2(-432.1, 4392.91)
    }, {
    name="Mansao94",
    --minZ=0,
    --maxZ=800
    })
    -- QG_89
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-2342.9, 257.53),
        vector2(-2340.38, 252.48),
        vector2(-2329.63, 257.08),
        vector2(-2330.62, 263.0)
    }, {
    name="QG_89",
    --minZ=0,
    --maxZ=800
    })
    -- QG_44
    Zones[#Zones+1] = PolyZone:Create({
        vector2(909.83,23.9),
        vector2(902.06,52.59),
        vector2(898.48,43.32),
        vector2(901.88,32.42)
    }, {
    name="QG_44",
    --minZ=0,
    --maxZ=800
    })
    -- mansao180
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-125.94,1273.22),
        vector2(-129.54,1269.41),
        vector2(-134.38,1274.11),
        vector2(-130.41,1278.08)
    }, {
    name="Mansao180",
    --minZ=0,
    --maxZ=800
    })
    -- -- QG_265
    -- Zones[#Zones+1] = PolyZone:Create({
    --     vector2(2033.44,-1556.32),
    --     vector2(2027.4,-1554.87),
    --     vector2(2025.62,-1560.0),
    --     vector2(2031.38,-1562.55),
    -- }, {
    -- name="QG_265",
    -- --minZ=0,
    -- --maxZ=800
    -- })
    -- QG_51
    Zones[#Zones+1] = PolyZone:Create({
        vector2(636.84,-2718.71),
        vector2(640.11,-2722.97),
        vector2(635.23,-2726.61),
        vector2(631.43,-2719.02)
    }, {
    name="QG_51",
    --minZ=0,
    --maxZ=800
    })
    -- QG_117
    Zones[#Zones+1] = PolyZone:Create({
        vector2(1418.15,-722.92),
        vector2(1418.48,-731.7),
        vector2(1423.4,-731.8),
        vector2(1423.4,-722.55)
    }, {
    name="QG_117",
    --minZ=0,
    --maxZ=800
    })
    -- QG_127
    Zones[#Zones+1] = PolyZone:Create({
        vector2(1987.3,4335.53),
        vector2(1992.08,4337.08),
        vector2(1995.12,4328.15),
        vector2(1990.21,4327.36)
    }, {
    name="QG_127",
    --minZ=0,
    --maxZ=800
    })
    -- QG_227
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-142.18,869.08),
        vector2(-138.58,874.34),
        vector2(-130.02,868.66),
        vector2(-133.47,863.44)
    }, {
    name="QG_227",
    --minZ=0,
    --maxZ=800
    })
    -- QG_79
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3427.29,514.84),
        vector2(-3419.34,498.61),
        vector2(-3398.9,507.91),
        vector2(-3404.09,528.3)
    }, {
    name="QG_79",
    --minZ=0,
    --maxZ=800
    })
    -- Mansao13
    Zones[#Zones+1] = PolyZone:Create({
        vector2(2010.44,3408.49),
        vector2(2015.44,3408.18),
        vector2(2014.09,3394.34),
        vector2(2007.37,3395.37)
    }, {
    name="Mansao13",
    --minZ=0,
    --maxZ=800
    })
    -- QG_86
    Zones[#Zones+1] = PolyZone:Create({
        vector2(580.07,683.86),
        vector2(560.39,703.52),
        vector2(566.23,708.78),
        vector2(585.68,688.92)
    }, {
    name="QG_86",
    --minZ=0,
    --maxZ=800
    })

elseif cityName == "District99" then 
    -- QG_54
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-43.06,947.94),
        vector2(-44.04,936.28),
        vector2(-55.84,938.33),
        vector2(-53.41,948.84)
    }, {
    name="QG_54",
    --minZ=0,
    --maxZ=800
    })
elseif cityName == "Krown" then 

elseif cityName == "Orizon" then 
    
elseif cityName == "Liberty99" then 
    -- QG_54
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-43.06,947.94),
        vector2(-44.04,936.28),
        vector2(-55.84,938.33),
        vector2(-53.41,948.84)
    }, {
    name="QG_54",
    --minZ=0,
    --maxZ=800
    })
    -- QG_87
    Zones[#Zones+1] = PolyZone:Create({
        vector2(724.69, 3426.3),
        vector2(727.5, 3432.12),
        vector2(717.24, 3439.69),
        vector2(712.83, 3433.26)
    }, {
    name="QG_87",
    --minZ=0,
    --maxZ=800
    })
    -- QG_182
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3126.47, 1483.67),
        vector2(-3138.92, 1481.27),
        vector2(-3138.46, 1476.93),
        vector2(-3125.69, 1479.13)
    }, {
    name="QG_182",
    --minZ=0,
    --maxZ=800
    })
    -- QG_53
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-1480.32, 825.35),
        vector2(-1485.54, 839.62),
        vector2(-1490.51, 837.72),
        vector2(-1485.25, 822.45)
    }, {
    name="QG_53",
    --minZ=0,
    --maxZ=800
    })
    -- QG_183
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3273.47,820.16),
        vector2(-3264.66,816.89),
        vector2(-3262.44,827.30),
        vector2(-3270.78,828.80)
    }, {
    name="QG_183",
    --minZ=0,
    --maxZ=800
    })
elseif cityName == "GoatRP" then 
    -- QG_54
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-43.06,947.94),
        vector2(-44.04,936.28),
        vector2(-55.84,938.33),
        vector2(-53.41,948.84)
    }, {
    name="QG_54",
    --minZ=0,
    --maxZ=800
    })
    -- -- QG_183
    -- Zones[#Zones+1] = PolyZone:Create({
    --     vector2(-3273.95,820.33),
    --     vector2(-3263.54,817.47),
    --     vector2(-3262.06,827.03),
    --     vector2(-3271.02,828.81)
    -- }, {
    -- name="QG_183",
    -- --minZ=0,
    -- --maxZ=800
    -- })
    -- QG_53
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-1485.24, 822.99),
        vector2(-1490.86, 837.21),
        vector2(-1486.65, 839.10),
        vector2(-1481.23, 824.67)
    }, {
    name="QG_53",
    --minZ=0,
    --maxZ=800
    })
    -- QG_300
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-501.91, 506.00),
        vector2(-503.55, 504.67),
        vector2(-495.38, 496.61),
        vector2(-494.15, 497.80)
    }, {
    name="QG_300",
    --minZ=0,
    --maxZ=800
    })
    -- QG_15
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-1761.25,432.31),
        vector2(-1758.81,432.81),
        vector2(-1757.64,449.46),
        vector2(-1760.29,449.04)
    }, {
    name="QG_15",
    --minZ=0,
    --maxZ=800
    })
    -- QG_19
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-973.02,306.03),
        vector2(-979.27,321.24),
        vector2(-991.52,313.02),
        vector2(-984.9,302.55)
    }, {
    name="QG_19",
    --minZ=0,
    --maxZ=800
    })
    -- QG_127
    Zones[#Zones+1] = PolyZone:Create({
        vector2(1987.3,4335.53),
        vector2(1992.08,4337.08),
        vector2(1995.12,4328.15),
        vector2(1990.21,4327.36)
    }, {
    name="QG_127",
    --minZ=0,
    --maxZ=800
    })
    -- QG_227
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-142.18,869.08),
        vector2(-138.58,874.34),
        vector2(-130.02,868.66),
        vector2(-133.47,863.44)
    }, {
    name="QG_227",
    --minZ=0,
    --maxZ=800
    })
    -- QG_79
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3427.29,514.84),
        vector2(-3419.34,498.61),
        vector2(-3398.9,507.91),
        vector2(-3404.09,528.3)
    }, {
    name="QG_79",
    --minZ=0,
    --maxZ=800
    })
    -- QG_130
    Zones[#Zones+1] = PolyZone:Create({
        vector2(2010.44,3408.49),
        vector2(2015.44,3408.18),
        vector2(2014.09,3394.34),
        vector2(2007.37,3395.37)
    }, {
    name="QG_130",
    --minZ=0,
    --maxZ=800
    })
    -- QG_16
    Zones[#Zones+1] = PolyZone:Create({
        vector2(1439.6,1076.05),
        vector2(1439.17,1056.32),
        vector2(1457.39,1057.15),
        vector2(1458.78,1076.43)
    }, {
    name="QG_16",
    --minZ=0,
    --maxZ=800
    })
    -- QG_86
    Zones[#Zones+1] = PolyZone:Create({
        vector2(580.07,683.86),
        vector2(560.39,703.52),
        vector2(566.23,708.78),
        vector2(585.68,688.92)
    }, {
    name="QG_86",
    --minZ=0,
    --maxZ=800
    })
elseif cityName == "Royal" then 

elseif cityName == "Real" then 
    -- Mansao99
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3602.74,1239.81), 
        vector2(-3605.61,1243.05), 
        vector2(-3601.74,1252.74), 
        vector2(-3597.12,1252.93), 
        vector2(-3518.98,1222.52), 
        vector2(-3507.31,1216.73), 
        vector2(-3495.64,1206.95), 
        vector2(-3511.09,1207.39), 
        vector2(-3526.07,1211.52)
    }, {
    name="Mansao99",
    --minZ=0,
    --maxZ=800
    })
    -- QG_22
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-296.49,183.79),
        vector2(-296.54,173.72),
        vector2(-285.05,174.04),
        vector2(-285.05,184.01)
    }, {
    name="QG_22",
    --minZ=0,
    --maxZ=800
    })
    -- QG_44
    Zones[#Zones+1] = PolyZone:Create({
        vector2(848.53,-24.72),
        vector2(840.99,-36.02),
        vector2(846.38,-39.54),
        vector2(853.86,-27.88)
    }, {
    name="QG_44",
    --minZ=0,
    --maxZ=800
    })
    -- QG_148
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-1389.93,-653.72),
        vector2(-1393.08,-649.15),
        vector2(-1398.91,-653.14),
        vector2(-1395.18,-658.00)
    }, {
    name="QG_148",
    --minZ=0,
    --maxZ=800
    })
    
elseif cityName == "Prime" then
    -- QG_76
    Zones[#Zones+1] = PolyZone:Create({
        vector2(-3391.77,553.64),
        vector2(-3387.85,546.70),
        vector2(-3398.23,540.75),
        vector2(-3401.12,546.80)
    }, {
    name="QG_76",
    --minZ=0,
    --maxZ=800
    })
elseif cityName == "Alexandria" then
elseif cityName == "Fronteira" then
    

end

local TIME_START_GODMODE_AFTER_SECONDS =  2 * 60
local startAt = 0

---@return boolean
local function IsAffiliateWorldActive()
    return GetResourceState("new_hub") == "started" and exports["new_hub"]:IsAffiliateWorldClientActive()
end

local function OnStopGodMode()
    LocalPlayer["state"]["Invincible"] = false
    SetEntityInvincible(PlayerPedId(),false)
end

local function OnPushGodMode()
    local startCoords = GetEntityCoords(PlayerPedId())
    startAt = GetGameTimer()

    CreateThread(function()
        while ((GetGameTimer() - startAt) / 1000) < TIME_START_GODMODE_AFTER_SECONDS and Hacking do
            Wait(1000)
        end
        
        if not Hacking then 
            return
        end

        LocalPlayer["state"]["Invincible"] = true
        SetEntityInvincible(PlayerPedId(),true)

        while Hacking do
            local playerPed = PlayerPedId()
            local currentCoords = GetEntityCoords(playerPed)

            if #(currentCoords - startCoords) > 5.0 then
                OnStopGodMode()
                break
            end

            DisablePlayerFiring(playerPed,true)
            Wait(1)
        end
    end)
end

CreateThread(function()
    LocalPlayer["state"]["Invincible"] = false -- rever isso depois
    LocalPlayer["state"]:set("Buttons",false,true)
    while true do
        local Idle = 2500

        if IsAffiliateWorldActive() then
            InZone = false
        else
            local Ped = PlayerPedId()
            local Coords = GetEntityCoords(Ped)
            local Inside = false
            for i=1, #Zones do
                if Zones[i]:isPointInside(Coords) then
                    if not InZone then
                        InZone = true
                    end
                    Inside = true
                end
            end
            if not Inside then
                InZone = false
            end
        end
        Wait(Idle)
    end
end)

-- ENG-3863: ghost do farm (`minigame/client/farm_ghost.lua`). Exige `InZone` porque `Hacking` não zera ao sair da zona.
---@return boolean
function IsLegacyAfkFarming()
    return Hacking and InZone
end

local Teleport = vector3(2157.93,2921,-80.0)

CreateThread(function()
    local Table = {}
    for i=1, #StartCoords do
        Table[i] = {
            StartCoords[i]["x"],
            StartCoords[i]["y"],
            StartCoords[i]["z"],
            50.0,
            KeySwitch,
            _t("start_afk_farm"),
            _t("press_to_open"),
        }
    end
    TriggerEvent("hoverfy:Insert",Table)
    while true do 
        local idle = 2500

        if IsAffiliateWorldActive() then
            if not AfkFarmHoverfyHidden then
                TriggerEvent("hoverfy:removeHoverfy")
                AfkFarmHoverfyHidden = true
            end

        else

        if AfkFarmHoverfyHidden then
            TriggerEvent("hoverfy:returnHoverfy")
            AfkFarmHoverfyHidden = false
        end

        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        if InZone then
            idle = 1
            if InZone and IsControlJustPressed(0,KeySwitchNumber) and not Hacking and not vRP.ReturnNoClip() then
                local isBanAuditBlocked = exports.dashboard:BlockIfInRestrictWorld()

                if not isBanAuditBlocked then
                    idle = 2500
                    Hacking = true
                    LocalPlayer["state"]:set("Buttons",true,true)
                    LocalPlayer["state"]:set("Cancel",true,true)
                    LocalPlayer["state"]:set("Farming",true,true)
                    -- TriggerEvent("Notify","amarelo","Você iniciou o farm afk, basta ficar 05 minutos para receber seus itens.",30000,"FARM")
                    -- TriggerEvent("Notify2","#startFarm")
                    -- TriggerEvent("Notify","amarelo","Você pode farmar enquanto estiver AFK sem morrer de fome ou sede!",60000,"FARM")
                    -- TriggerEvent("Notify2","#suggFarm")
                    CreateThread(function()
                        OnPushGodMode()
                        StartFarming()
                        OnStopGodMode()
                    end)
                end
            end
        end
        end
        Wait(idle)
    end
end)

local Timer = 60*2.5
local Animations = {
    ["bong"] = { dict = "anim@safehouse@bong", anim = "bong_stage1", prop = "prop_bong_01", flag = 49, hand = 18905, pos1 = 0.10, pos2 = -0.25, pos3 = 0.0, pos4 = 95.0, pos5 = 190.0, pos6 = 180.0 },
}

function StartFarming()
    if IsAffiliateWorldActive() then
        return
    end

    TriggerServerEvent("farmer:StartAFKFarming")
    local Ped = PlayerPedId()
    local name = "bong"
    TriggerEvent("hoverfy:removeHoverfy",Timer)
    vRP._playAnim(false,{"anim@safehouse@bong", "bong_stage1"},true)
    TriggerEvent("Progress","Minerando",1000*Timer)
    local Count = 0
    while Hacking do
        Count = Count + 1
        if Count >= Timer then
            break
        end
        Wait(1000)
    end
    if not Hacking then
        return
    end
    local Coords = GetEntityCoords(Ped)
    if InZone then
        vRP.stopAnim(false)
        TriggerServerEvent("farmer:Farming")
        -- TriggerServerEvent("DeleteObject",Network)
        LocalPlayer["state"]:set("Buttons",false,true)
        LocalPlayer["state"]:set("Cancel",false,true)
        TriggerEvent("Progress","Minerando",0)
        StartFarming()
    end
end


AddEventHandler("actions:Cancel",function()
    if Hacking then
        vRP._stopAnim(false)
        LocalPlayer["state"]:set("Buttons",false,true)
        LocalPlayer["state"]:set("Cancel",false,true)
        LocalPlayer["state"]:set("Farming",false,true)
        TriggerEvent("Progress","Cancelando",0)
        TriggerEvent("hoverfy:returnHoverfy")
        Hacking = false
        InZone = false
        Hacking = false
        LapTop = false
        TriggerServerEvent("farmer:ExitAFKFarming")
        OnStopGodMode()
    end
end)
