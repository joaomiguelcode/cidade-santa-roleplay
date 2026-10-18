
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORREÇÃO: Sistema de notificações independente do HUD2
-- Problema: Quando hud:Hud2 era executado com toggleHud2 = false, as notificações paravam de funcionar
-- Solução: Criada variável NotificationsEnabled para controlar notificações independentemente do HUD2
-- Agora as notificações só são desativadas quando HUD2 está ativo, e reativadas quando HUD2 é desativado
-- e o HUD principal está ativo
Display = false
local DisableSounds = false
local ActiveMic = true
local NotificationsEnabled = true -- Nova variável para controlar notificações independentemente
isNuiReady = false
Player = GetPlayerServerId(PlayerId())
inMap = false

AddEventHandler("skinshop:save-temporary-customization", function(_cloth, context)
    if context ~= 'hud.ctx' then
        return
    end
	print(':: hud:save-temporary-customization hud.ctx ::', _cloth, context)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Road = "Alta-Street"
local Crossing = "Hawick Avenue"
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Health = 999
local Armour = 999
local Stamine = 999
local Hood = false
local Hours = 0
local Minutes = 0
local BlockHud = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
local Thirst = nil
local ThirstTimer = nil
if GlobalState["Hunger"] then
    Thirst = 999
    ThirstTimer = GetGameTimer()
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
local Wanted = 0
local WantedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
local Reposed = 0
local ReposedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
local PlayerTalking = {}
local PlayerName = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
local Hunger = 999
local HungerTimer = GetGameTimer()
local TableRoad,TableCross = {},{}
local RoadsTxt,CrossTxt = "",""
cityName = GetConvar("cityName", "")
local Logos = {
    ["Dev-Season3"] = "./assets/images/logo.webp",
    ["Santa"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/santanew.png",
    ["Grande"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/grande2.png",
    ["Alexandria"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/alexandria2.png",
    ["Maresia"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/newmaresia.png",
    ["Galaxy"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/galaxy.png",
    ["Universo"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/universo2.png",
    ["Gaules"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/santanew.png",
    ["Fronteira"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/fronteira.png",
    ["CidadeNobre"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/nobre_2.png",
    ["Boomerang"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/boomerang.webp",
    ["Malta"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/new_malta.png",	
    ["Kingdom"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/knglogo.png",
    ["Imperium"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/imperium.png",
    ["GoatRP"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/goatrp.png",
    ["District99"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/District99.png",
    ["Krown"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/krown.png",
    ["Orizon"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/Orizon.png",
    ["Liberty99"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/Liberty99.png",
    ["Royal"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/new_royal.png",
    ["Real"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/real.webp",
    ["Prime"] = "https://santaimagens.roleplayrp.com/img/imagens_hud/prime.png",
}
--[[
local Day = 1
local Month = 1
local MonthsText = {
    [1] = "JAN",
    [2] = "FEV",
    [3] = "MAR",
    [4] = "ABR",
    [5] = "MAI",
    [6] = "JUN",
    [7] = "JUL",
    [8] = "AGO",
    [9] = "SET",
    [10] = "OUT",
    [11] = "NOV",
    [12] = "DEZ",
}
--]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
local WORLD_CLOCK_TIME_SCALE = 48.0

function GetRealWorldMillisecondsUntilGameHours(timeNow, minutesNow, rangeStart, rangeEnd)
    local nowInMinutes = (timeNow * 60) + minutesNow
    local endBoundaryMinutes = rangeEnd * 60

    local diffMinutes

    if rangeStart <= rangeEnd then
        diffMinutes = endBoundaryMinutes - nowInMinutes
        if diffMinutes < 0 then
            diffMinutes = diffMinutes + (24 * 60)
        end
    else
        if timeNow >= rangeStart then
            diffMinutes = (24 * 60 - nowInMinutes) + endBoundaryMinutes
        else
            diffMinutes = endBoundaryMinutes - nowInMinutes
        end
    end

    local realSecondsPerGameMinute = 60 / WORLD_CLOCK_TIME_SCALE -- 1.25

    return diffMinutes * realSecondsPerGameMinute * 1000
end

local function IsTimeInRange(currentHour, startHour, endHour)
    if startHour <= endHour then
        return currentHour >= startHour and currentHour < endHour
    end

    return currentHour >= startHour or currentHour < endHour
end

local isDisplayingZone = false
local function ShowZone(zoneName, hours, minutes, rangeStart, rangeEnd)
    if isDisplayingZone and isDisplayingZone == zoneName then
        return
    end
    local timeBetween = GetRealWorldMillisecondsUntilGameHours(hours, minutes, rangeStart, rangeEnd)
    SendNUIMessage({ 
      action = "Zone", 
      data = { Area = zoneName, time = timeBetween } 
    })
    isDisplayingZone = zoneName
end

function RobberyTime()
    if GlobalState["DisableRobberyTime"] then
        SendNUIMessage({ action = "Zone", data = { Area = "none" } })
        isDisplayingZone = false
        return
    end

    local robberyTime = GlobalState["RobberyTime"]
    if not robberyTime or not robberyTime["North"] or not robberyTime["South"] then
        SendNUIMessage({ action = "Zone", data = { Area = "none" } })
        isDisplayingZone = false
        return 
    end
    
    local north = robberyTime["North"]
    local south = robberyTime["South"]

    local inZone = false

    if north.Start and north.End then
        if IsTimeInRange(Hours, north.Start, north.End) then
            ShowZone("norte", Hours, Minutes, north.Start, north.End)
            inZone = true
            return
        end
    end
    
    if south.Start and south.End then
        if IsTimeInRange(Hours, south.Start, south.End) then
            ShowZone("sul", Hours, Minutes, south.Start, south.End)
            inZone = true
            return
        end
    end
    
    if not inZone then
        SendNUIMessage({ action = "Zone", data = { Area = "none" } })
        isDisplayingZone = false
    end
end

---@param event WorldClockUpdatedEvent
AddEventHandler( 'worldstate:clock_updated', function( event )

    Hours   = event.hours
    Minutes = event.minutes
    Day     = event.day
    Month   = event.monthLabel
end)

HudStyle = {
    ["Maresia"] = "santa",
    ["Alexandria"] = "santa",
    ["Universo"] = "santa",
    ["Santa"] = "santa",
    ["CidadeNobre"] = "santa",
    ["Boomerang"] = "santa",
    ["Grande"] = "santa",
    ["Fronteira"] = "santa",
    ["Malta"] = "santa",
    ["Kingdom"] = "santa",
    ["Imperium"] = "santa",
    ["GoatRP"] = "santa",
    ["District99"] = "santa",
    ["Krown"] = "santa",
    ["Orizon"] = "santa",
    ["Royal"] = "santa",
    ["Real"] = "santa",
    ["Prime"] = "santa",
}

SpeedometerUnit = {
    ["Maresia"] = "KM/H",
    ["Alexandria"] = "KM/H",
    ["Universo"] = "KM/H",
    ["Santa"] = "KM/H",
    ["CidadeNobre"] = "KM/H",
    ["Boomerang"] = "MP/H",
    ["Grande"] = "KM/H",
    ["Fronteira"] = "KM/H",
    ["Malta"] = "KM/H",
    ["Kingdom"] = "MP/H",
    ["Imperium"] = "MP/H",
    ["GoatRP"] = "MP/H",
    ["District99"] = "MP/H",
    ["Krown"] = "MP/H",
    ["Orizon"] = "MP/H",
    ["Royal"] = "MP/H",
    ["Real"] = "MP/H",
    ["Prime"] = "MP/H",
}

RegisterNUICallback("nuiIsReady",function(Data,Callback)
    SendNUIMessage({
        action = "closePromotionCountDown",
        data = true
    })
    isNuiReady = true
    if LocalPlayer["state"]["Active"] then
        SendNUIMessage({ action = "SetHudType", data = { City = HudStyle[cityName] or "santa" } })
        SendNUIMessage({ action = "UpdateSpeedometerUnit", data = { Unit = SpeedometerUnit[cityName] or "KM/H" }})
        CreateThread(function()
            if LocalPlayer["state"]["Active"] then
                SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
                SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
                Display = not BlockHud
                ActiveMic = Display
                SendNUIMessage({ action = "Toggle", data = { toggle = true }})
                -- sx.logger:debug( ( "hud NUI ready city=%s display=%s blocked=%s" ):format(
                    -- tostring( GlobalState["Hud"] or "santa" ),
                    -- tostring( Display ),
                    -- tostring( BlockHud )
                -- ) )
                SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa"  }})
                Wait(100)
                if Display then
                    if not hudConfiguration.hideCompleteHud then
                        SendNUIMessage({ action = "Body", data = { Status = Display } })
                    end
                else
                    SendNUIMessage({ action = "Body", data = { Status = Display } })
                end
                SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
                SendNUIMessage({ action = "Hood", data = { hood = Hood }})
                TriggerEvent("hud2:remPromo", not Display)
                SendNUIMessage({ action = "Tutorial", Status  = Display })
                if not Display then
                    if IsMinimapRendering() then
                        DisplayRadar(false)
                    end
                else
                    if GlobalState["WarMode"] then
                        SendNUIMessage({ action = "Safe", data = { Status = (LocalPlayer["state"]["InSafeZone"] or LocalPlayer["state"]["inSafeMode"] or false) or false }})
                        SendNUIMessage({ action = "Newbie", data = { Status = false }})
                    else
                        SendNUIMessage({ action = "Safe", data = { Status = (value or LocalPlayer["state"]["inSafeMode"] or LocalPlayer["state"]["Newbie"]) or false }})
                        SendNUIMessage({ action = "Newbie", data = { Status = LocalPlayer["state"]["Newbie"] or false }})
                    end
                end
                if not GlobalState["Premios"] then
                    SendNUIMessage({ action = "RewardsDisable", data = { Status = true } })
                end
                if not GlobalState["AssaultHourDisable"] then
                    SendNUIMessage({ action = "AssaultHourDisable", data = { Status = true }})
                end
                SendNUIMessage({ action = "Toggle", data = { toggle = true }})
                Wait(100)
                local customPassport = exports.admin:GetCustomPassportLabel(LocalPlayer["state"]["Passport"]) or LocalPlayer["state"]["Passport"]
                SendNUIMessage({ action = "Passport", data = { Number = customPassport }})
                SendNUIMessage({ action = "ToggleNotify", data = {toggle = true} })
            end
        end)
        SendNUIMessage({ action = "Tutorial", data = { Status = false }})
    end
    CreateThread(function()
        while true do
            if LocalPlayer["state"]["Creating"] then
                while LocalPlayer["state"]["Creating"] do
                    Display = false
                    NotificationsEnabled = false
                    SendNUIMessage({ action = "Toggle", data = { toggle = Display } })
                    SendNUIMessage({ action = "Body", data = { Status = Display } })
                    TriggerEvent("chat:Toggle", Display)
                    TriggerEvent("notify:Toggle", false)
                    Wait(100)
                end
                -- Display = true
                -- NotificationsEnabled = true
                -- SendNUIMessage({ action = "Toggle", data = { toggle = Display } })
                -- SendNUIMessage({ action = "Body", data = { Status = Display } })
                -- TriggerEvent("chat:Toggle", Display)
                -- TriggerEvent("notify:Toggle", true)
            end
            if BlockHud == true then
                if Display then
                    Display = false
                    NotificationsEnabled = false
                    SendNUIMessage({ action = "Toggle", data = { toggle = Display } })
                    SendNUIMessage({ action = "Body", data = { Status = Display } })
                    TriggerEvent("chat:Toggle", Display)
                    TriggerEvent("notify:Toggle", false)
                end
                goto blockHud
            end

            if LocalPlayer["state"]["Active"] then
                local Ped = PlayerPedId()
                RobberyTime()
                if Display then
                    local Coords = GetEntityCoords(Ped)
                    local Armouring = GetPedArmour(Ped)
                    local Healing = GetEntityHealth(Ped) - 100
                    local MinRoad,MinCross = GetStreetNameAtCoord(Coords["x"],Coords["y"],Coords["z"])
                    local FullRoad = GetStreetNameFromHashKey(MinRoad)
                    local FullCross = GetStreetNameFromHashKey(MinCross)
                    local CurrentStamine = GetPlayerStamina(PlayerId())
    
                    if LocalPlayer["state"]["Route"] == 5 then
                        SendNUIMessage({ action = "WorldWarn", data = { WorldWarn = true }})
                    else
                        SendNUIMessage({ action = "WorldWarn", data = { WorldWarn = false }})
                    end
                    
                    if Health ~= Healing then
                        if Healing < 0 then
                            Healing = 0
                        end
    
                        SendNUIMessage({ action = "Health", data = { Number = Healing / 3 }})
                        Health = Healing
                    end
    
                    if Armour ~= Armouring then
                        SendNUIMessage({ action = "Armour", data = { Number = Armouring }})
                        Armour = Armouring
                    end
    
                    if Stamine ~= CurrentStamine then
                        SendNUIMessage({ action = "Stamine", data = { Number = parseInt(CurrentStamine) }})
                        Stamine = CurrentStamine
                    end
    
                    if FullRoad ~= "" and Road ~= FullRoad then
                        SendNUIMessage({ action = "Road", data = { Name = FullRoad }})
                        Road = FullRoad
                    end
    
                    if FullCross ~= "" and Crossing ~= FullCross then
                        SendNUIMessage({ action = "Crossing", data = { Name = FullCross }})
                        Crossing = FullCross
                    end
    
                    SendNUIMessage({ action = "Clock", data = { Hours = Hours, Minutes = Minutes, Day = Day, Month = Month } })
                end
    
                local Talking = {}
                for Source,Info in pairs(PlayerTalking) do
                    table.insert(Talking,Info)
                end
                SendNUIMessage({ action = "RadioTalking", data = { info = Talking }})
    
                if GlobalState["Hunger"] then
                    -- if HungerTimer <= GetGameTimer() then
                    --     HungerTimer = GetGameTimer() + 10000
    
                    --     if Hunger < 25 and GetEntityHealth(Ped) > 100 then
                    --         ApplyDamageToPed(Ped,math.random(2),false)
                    --         TriggerEvent("Notify","fome","Sofrendo com a fome.",2500,"FOME")
                    --     end
                    -- end
    
                    -- if ThirstTimer <= GetGameTimer() then
                    --     ThirstTimer = GetGameTimer() + 10000
    
                    --     if Thirst < 25 and GetEntityHealth(Ped) > 100 then
                    --         ApplyDamageToPed(Ped,math.random(2),false)
                    --         TriggerEvent("Notify","sede","Sofrendo com a sede.",2500,"SEDE")
                    --     end
                    -- end
                end
    
    
    
                if Wanted > 0 and WantedTimer <= GetGameTimer() then
                    Wanted = Wanted - 1
                    WantedTimer = GetGameTimer() + 1000
                end
    
                if Reposed > 0 and ReposedTimer <= GetGameTimer() then
                    Reposed = Reposed - 1
                    ReposedTimer = GetGameTimer() + 1000
                end
            end
            ::blockHud::
            Wait(1000)
        end
    end)
    Callback(true)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Passport")
AddEventHandler("hud:Passport",function(Number)
    local customPassport = exports.admin:GetCustomPassportLabel(Number) or Number
	SendNUIMessage({ action = "Passport", data = { Number = customPassport }})
    SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
    SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voip")
AddEventHandler("hud:Voip",function(Number)
	SendNUIMessage({ action = "Voip", data = { Voip = Number }})
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
    -- Hood = not Hood

    -- if Hood then
    --     TriggerEvent("radio:RadioClean")
    -- end

	--SendNUIMessage({ action = "Hood", data = { hood = Hood }})
end)

-- RegisterCommand("hood",function()
--     TriggerEvent('hud:toggleHood')
--     -- Hood = not Hood
--     -- print("test hood")
--     -- SendNUIMessage({ action = "Hood", hood = Hood })
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:inMap")
AddEventHandler("hud:inMap",function()
    if LocalPlayer["state"]["hud4"] then
        return
    end

	inMap = true
    Display = true
    ActiveMic = true
    SendNUIMessage({ action = "Body", data = { Status = false }})
    Wait(250)
    while inMap do
        if not IsPauseMenuActive()then
            inMap = false
            -- ENG-3972: o hud:Active(false) do hub (ESC > Mapa) chega depois do inMap; Display volta junto com o Body.
            Display = true
            if not hudConfiguration.hideCompleteHud then
                SendNUIMessage({ action = "Body", data = { Status = true } })
            end
            SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
        end
        Wait(50)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:PAUSEMENU
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENG-3972: o P abre o mapa nativo sem passar pelo hub. Reaproveita o hud:inMap do ESC > Mapa para o Body
-- e avisa as NUIs fora dele (cards do Fac/Legal em Foco no dashboard) para sumirem enquanto o mapa estiver aberto.
CreateThread(function()
    local pauseMenuOpen = false

    while true do
        local isOpen = IsPauseMenuActive()

        if isOpen ~= pauseMenuOpen then
            pauseMenuOpen = isOpen

            if isOpen and Display and not inMap then
                TriggerEvent("hud:inMap")
            end

            TriggerEvent("hud:pauseMenu:visibilityChanged", isOpen)
        end

        Wait(100)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("hud:updateLife",function()
    local Ped = PlayerPedId()
    local Armouring = GetPedArmour(Ped)
    local Healing = GetEntityHealth(Ped) - 100
    if Health ~= Healing then
        if Healing < 0 then
            Healing = 0
        end

        SendNUIMessage({ action = "Health", data = { Number = Healing / 3 } })
        Health = Healing
    end

    if Armour ~= Armouring then
        SendNUIMessage({ action = "Armour", data = { Number = Armouring }})
        Armour = Armouring
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active",function(Status)
    if LocalPlayer["state"]["hud2"] or LocalPlayer["state"]["hud4"] then
        return
    end

    if BlockHud and Status == true then
        return
    end


    if Status then
        if not hudConfiguration.hideCompleteHud then
            SendNUIMessage({ action = "Body", data = { Status = Status } })
            SendNUIMessage({ action = "Toggle", data = { toggle = Status }})
        end
        SendNUIMessage({ action = "DisplayLogo", data = { Status = true } })
    else
        SendNUIMessage({ action = "Body", data = { Status = Status } })
        SendNUIMessage({ action = "Toggle", data = { toggle = Status }})
        SendNUIMessage({ action = "DisplayLogo", data = { Status = false } })
    end
    SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
	Display = Status
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:TOGGLE a priority above HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Toggle")
AddEventHandler("hud:Toggle",function(toggle)
    SendNUIMessage({ action = "Toggle", data = { toggle = toggle } })
    TriggerEvent("chat:Toggle", toggle)
    
    -- Controlar notificações baseado no estado do HUD e HUD2
    if toggle and not toggleHud2 then
        TriggerEvent("notify:Toggle", true)
    else
        TriggerEvent("notify:Toggle", false)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("hud",function()

-- end)

RegisterNetEvent("hud:toggleHud")
AddEventHandler("hud:toggleHud",function(Boolean)
    Display = Boolean
    ActiveMic = Display
    NotificationsEnabled = Boolean -- Atualizar estado das notificações
    SendNUIMessage({ action = "Toggle", data = { toggle = true }})

    SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
    Wait(100)
    if Display then
        if not hudConfiguration.hideCompleteHud then
            SendNUIMessage({ action = "Body", data = { Status = Display } })
        end
    else
        SendNUIMessage({ action = "Body", data = { Status = Display } })
    end
    SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
    SendNUIMessage({ action = "Hood", data = { hood = Hood }})
    TriggerEvent("hud2:remPromo", not Display)
    SendNUIMessage({ action = "Tutorial", Status = Display })
    TriggerEvent("hud2:remPromo", Display)
    
    -- Controlar notificações baseado no estado do HUD e HUD2
    if Display and not toggleHud2 then
        TriggerEvent("notify:Toggle", true)
    else
        TriggerEvent("notify:Toggle", false)
    end
    
    TriggerEvent("chat:DisablePreview", Display)
    if not Display then
        if IsMinimapRendering() then
            DisplayRadar(false)
        end
    else
        if GlobalState["WarMode"] then
            SendNUIMessage({ action = "Safe", data = { Status = (LocalPlayer["state"]["InSafeZone"] or LocalPlayer["state"]["inSafeMode"] or false) or false }})
            SendNUIMessage({ action = "Newbie", data = { Status = false }})
        else
            SendNUIMessage({ action = "Safe", data = { Status = (value or LocalPlayer["state"]["inSafeMode"] or LocalPlayer["state"]["Newbie"]) or false }})
            SendNUIMessage({ action = "Newbie", data = { Status = LocalPlayer["state"]["Newbie"] or false }})
        end
        if hudConfiguration.minimapStyle == 1 then
            DisplayRadar(true)
        end
    end
    if not GlobalState["Premios"] then
        SendNUIMessage({ action = "RewardsDisable", data = { Status = true } })
    end
    if not GlobalState["AssaultHourDisable"] then
        SendNUIMessage({ action = "AssaultHourDisable", data = { Status = true }})
    end
end)

RegisterNetEvent("hud:setHudStatus")
AddEventHandler("hud:setHudStatus",function(Boolean)
    BlockHud = not Boolean
    Display = Boolean
    ActiveMic = Display
    NotificationsEnabled = Boolean -- Atualizar estado das notificações
    print('hud:setHudStatus', Boolean, BlockHud, Display, ActiveMic)
    SendNUIMessage({ action = "Toggle", data = { toggle = true }})

    SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
    Wait(100)
    if Display then
        if not hudConfiguration.hideCompleteHud then
            SendNUIMessage({ action = "Body", data = { Status = Display } })
        end
    else
        SendNUIMessage({ action = "Body", data = { Status = Display } })
    end
    SendNUIMessage({ action = "Logo", data = { Logo = Logos[cityName] }})
    SendNUIMessage({ action = "Hood", data = { hood = Hood }})
    TriggerEvent("hud2:remPromo", not Display)
    SendNUIMessage({ action = "Tutorial", Status = Display })
    TriggerEvent("hud2:remPromo", Display)
    
    -- Controlar notificações baseado no estado do HUD e HUD2
    if Display and not toggleHud2 then
        TriggerEvent("notify:Toggle", true)
    else
        TriggerEvent("notify:Toggle", false)
    end
    
    TriggerEvent("chat:DisablePreview", Display)
    TriggerEvent("chat:Toggle", Display)
    if not Display then
        if IsMinimapRendering() then
            DisplayRadar(false)
        end
    else
        if GlobalState["WarMode"] then
            SendNUIMessage({ action = "Safe", data = { Status = (LocalPlayer["state"]["InSafeZone"] or LocalPlayer["state"]["inSafeMode"] or false) or false }})
            SendNUIMessage({ action = "Newbie", data = { Status = false }})
        else
            SendNUIMessage({ action = "Safe", data = { Status = (value or LocalPlayer["state"]["inSafeMode"] or LocalPlayer["state"]["Newbie"]) or false }})
            SendNUIMessage({ action = "Newbie", data = { Status = LocalPlayer["state"]["Newbie"] or false }})
        end
        if hudConfiguration and hudConfiguration.minimapStyle == 1 then
            DisplayRadar(true)
        end
    end
    if not GlobalState["Premios"] then
        SendNUIMessage({ action = "RewardsDisable", data = { Status = true } })
    end
    if not GlobalState["AssaultHourDisable"] then
        SendNUIMessage({ action = "AssaultHourDisable", data = { Status = true }})
    end
end)



AddEventHandler("RewardsDisable",function(Status)
    SendNUIMessage({ action = "RewardsDisable", data = { Status = Status }})
end)

AddEventHandler("AssaultHourDisable",function(Status)
    SendNUIMessage({ action = "AssaultHourDisable", data = { Status = Status } })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD2
-----------------------------------------------------------------------------------------------------------------------------------------

local Discords = {
	["Santa"] = "discord.gg/cidadesanta",
	["Grande"] = "discord.gg/granderp",
	["Alexandria"] = "discord.gg/alexandria-rp",
	["Maresia"] = "discord.gg/cidademaresia",
	["Galaxy"] = "discord.gg/galaxy-rp",
    ["Universo"] = "discord.gg/universo-rp",
    ["Gaules"] = "discord.gg/",
    ["Fronteira"] = "discord.gg/fronteiraroleplay",
    ["CidadeNobre"] = "discord.gg/cidadenobre",
    ["Boomerang"] = "discord.gg/boomerang-rp",
    ["Malta"] = "discord.gg/malta-rp",
    ["Kingdom"] = "discord.gg/kngestate",
    ["Imperium"] = "discord.gg/imperium",
    ["GoatRP"] = "discord.gg/goatrp",
    ["District99"] = "discord.gg/d-99",
    ["Kingdom"] = "discord.gg/kngestate",
    ["Krown"] = "discord.gg/krownrp",
    ["Orizon"] = "discord.gg/taaGvEtbMv",
    ["Liberty99"] = "discord.gg/l99",
    ["Royal"] = "discord.gg/royaluk",
    ["Real"] = "discord.gg/realrp",
    ["Prime"] = "discord.gg/ciudadprime",
}

local toggleHud2 = false
RegisterNetEvent("hud:Hud2")
AddEventHandler("hud:Hud2",function()
	toggleHud2 = not toggleHud2
    DisableSounds = toggleHud2
    ActiveMic = true
    SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
    SendNUIMessage({ action = "hideAllButLogo", data = { Status = toggleHud2 }})
    SendNUIMessage({ action = "DisablePreview", data = { toggle = toggleHud2 }})
    SendNUIMessage({ action = "Logo", data = { Logo = not toggleHud2 and Logos[cityName] }})
    SendNUIMessage({ action = "UpdateDiscord", data = { discord = Discords[cityName] }})
    SendNUIMessage({ action = "OfflineDisable", data = { Status = toggleHud2 }})
    SendNUIMessage({ action = "hidePassportDiv", data = { Status = toggleHud2 }})
    TriggerEvent("chat:DisablePreview", toggleHud2)
    TriggerEvent("hud2:remPromo", toggleHud2)
    
    -- Controlar notificações baseado no estado do HUD principal
    if toggleHud2 then
        -- HUD2 ativado: desativar notificações
        TriggerEvent("notify:RemoveTicket")
        TriggerEvent("notify:Toggle", false)
    else
        -- HUD2 desativado: reativar notificações se o HUD principal estiver ativo
        if Display and NotificationsEnabled then
            TriggerEvent("notify:Toggle", true)
        end
    end
    
    TriggerEvent("promotion_button:RemAudio", DisableSounds)
	if not Display then
		if IsMinimapRendering() then
			DisplayRadar(false)
		end
	end
end)

local toggleHud3 = false
RegisterNetEvent("hud:Hud3")
AddEventHandler("hud:Hud3",function()
	toggleHud3 = not toggleHud3
    DisableSounds = toggleHud3
    ActiveMic = true
    SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
    SendNUIMessage({ action = "hideAllButLogo", data = { Status = toggleHud3 }})
    SendNUIMessage({ action = "DisablePreview", data = { toggle = toggleHud3 }})
    SendNUIMessage({ action = "UpdateDiscord", data = { discord = Discords[cityName] }})
    SendNUIMessage({ action = "OfflineDisable", data = { Status = toggleHud3 }})
    SendNUIMessage({ action = "hidePassportDiv", data = { Status = toggleHud3 }})
    TriggerEvent("chat:DisablePreview", toggleHud3)
    TriggerEvent("hud2:remPromo", toggleHud3)
    
    -- Controlar notificações baseado no estado do HUD principal
    if toggleHud3 then
        -- HUD2 ativado: desativar notificações
        TriggerEvent("notify:RemoveTicket")
        TriggerEvent("notify:Toggle", false)
    else
        -- HUD2 desativado: reativar notificações se o HUD principal estiver ativo
        if Display and NotificationsEnabled then
            TriggerEvent("notify:Toggle", true)
        end
    end
    
    TriggerEvent("promotion_button:RemAudio", DisableSounds)
	if not Display then
		if IsMinimapRendering() then
			DisplayRadar(false)
		end
	end
end)

local toggleHud4 = false
RegisterNetEvent("hud:Hud4")
AddEventHandler("hud:Hud4",function()
	toggleHud4 = not toggleHud4
    DisableSounds = toggleHud4
    ActiveMic = true
    SendNUIMessage({ action = "City", data = { Status = GlobalState["Hud"] or "santa" }})
    SendNUIMessage({ action = "hideAllButLogo", data = { Status = toggleHud4 }})
    SendNUIMessage({ action = "DisablePreview", data = { toggle = toggleHud4 }})
    SendNUIMessage({ action = "UpdateDiscord", data = { discord = Discords[cityName] }})
    SendNUIMessage({ action = "OfflineDisable", data = { Status = toggleHud4 }})
    SendNUIMessage({ action = "hidePassportDiv", data = { Status = toggleHud4 }})
    TriggerEvent("chat:DisablePreview", toggleHud4)
    TriggerEvent("hud2:remPromo", toggleHud4)
    
    -- Controlar notificações baseado no estado do HUD principal
    if toggleHud4 then
        -- HUD2 ativado: desativar notificações
        TriggerEvent("notify:RemoveTicket")
        TriggerEvent("notify:Toggle", false)
    else
        -- HUD2 desativado: reativar notificações se o HUD principal estiver ativo
        if Display and NotificationsEnabled then
            TriggerEvent("notify:Toggle", true)
        end
    end
    
    TriggerEvent("promotion_button:RemAudio", DisableSounds)
	if not Display then
		if IsMinimapRendering() then
			DisplayRadar(false)
		end
	end

    if toggleHud4 then
        hudConfiguration.hud4 = true
    else
        hudConfiguration.hud4 = false
    end
    SetHudConfig(hudConfiguration)
    SetResourceKvp("hudConfig",json.encode(hudConfiguration))

end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("roads",function()
    TriggerServerEvent("hud:roads",RoadsTxt,CrossTxt)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(Message,Timer, CustomMessage)
	SendNUIMessage({ action = "Progress", data = { Message = Message, Timer = Timer, CustomMessage = CustomMessage }})
end)

RegisterCommand("testprogress",function()
    TriggerEvent("Progress","teste",10000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(Number,Number2)
    if GlobalState["Hunger"] then
        if Thirst ~= Number and Hunger ~= Number2 then
            SendNUIMessage({ action = "Thirst", data = { Number = Number }})
            Thirst = Number
            SendNUIMessage({ action = "Hunger", data = { Number = Number2 }})
            Hunger = Number2
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
local Frequencys = {
    [10] = _t("staff"),
    [999] = _t("leaders")
}
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio",function(Frequency)
    PlayerTalking = {}
    if Frequencys[Frequency] then
        SendNUIMessage({ action = "Frequency", data = { Frequency = Frequencys[Frequency] } })
    else
        local FrequencyName = exports["santa_radio"]:GetFrequencyName(Frequency)
        if FrequencyName then
            local OrgName = GlobalState["AliasGroup"][FrequencyName] or FrequencyName
            local NumberFrequency = exports["santa_radio"]:NumberOfGroupFrequency(Frequency)
            local FrequencyString = OrgName.." "..NumberFrequency.." ["..Frequency.."]"
            SendNUIMessage({ action = "Frequency", data = { Frequency = FrequencyString }})
        else
            SendNUIMessage({ action = "Frequency", data = { Frequency = Frequency }})
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:SAFE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Safe")
AddEventHandler("hud:Safe",function(Status)
	SendNUIMessage({ action = "Safe", data = { Status = Status }})
    SendNUIMessage({ action = "Newbie", data = { Status = LocalPlayer["state"]["Newbie"] or false }})

    if Status then
        CreateThread(function()
            Wait(5000)

            if LocalPlayer["state"]["InSafeZone"] then
                SendNUIMessage({ action = "SafeZone", data = { Status = true, Variant = "shield" }})
            end
        end)
    else
        SendNUIMessage({ action = "SafeZone", data = { Status = false, Variant = "full" }})
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATES
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler('inSafeMode',('player:%s'):format(Player) , function(_, _, value)
    if value then
        TriggerEvent("inventory:CleanWeapons")
    end
    Wait(250)
    if GlobalState["WarMode"] then
        SendNUIMessage({ action = "Safe",data = {  Status = LocalPlayer["state"]["inSafeMode"]  }})
        SendNUIMessage({ action = "Newbie", data = { Status = false }})
    else
        SendNUIMessage({ action = "Safe", data = { Status = LocalPlayer["state"]["inSafeMode"]  }})
        SendNUIMessage({ action = "Newbie", data = { Status = LocalPlayer["state"]["Newbie"] or false }})
    end
end)

AddStateBagChangeHandler('Newbie',('player:%s'):format(Player) , function(_, _, value)
    if value then
        TriggerEvent("inventory:CleanWeapons")
    end
    if GlobalState["WarMode"] then
        SendNUIMessage({ action = "Safe", data = { Status = LocalPlayer["state"]["inSafeMode"]  }})
        SendNUIMessage({ action = "Newbie", data = { Status = false }})
    else
        SendNUIMessage({ action = "Safe", data = { Status = LocalPlayer["state"]["inSafeMode"] } })
        SendNUIMessage({ action = "Newbie", data = { Status = value or false }})
    end
end)

AddStateBagChangeHandler('WarMode',('player:%s'):format(Player) , function(_, _, value)
    SendNUIMessage({ action = "WarMode", data = { Status = value or false }})
end)

-- CreateThread(function() 
--     while true do
--         local Ped = PlayerPedId()
--         local Coords = GetEntityCoords(Ped)
--         local Armouring = GetPedArmour(Ped)
--         local Healing = GetEntityHealth(Ped) - 100
--         local ground,z = GetGroundZFor_3dCoord(Coords["x"],Coords["y"],Coords["z"])
--         if ground then
--             Coords["z"] = z
--         end
--         local MinRoad,MinCross = GetStreetNameAtCoord(Coords["x"],Coords["y"],Coords["z"])
--         local FullRoad = GetStreetNameFromHashKey(MinRoad)
--         local FullCross = GetStreetNameFromHashKey(MinCross)
--         local NotMapped = false
        
--         for i=1,#Streets do
--             if Streets[i].hash == MinRoad then
--                 NotMapped = true
--             end

--             if Streets[i].hash == MinCross then
--                 NotMapped = true
--             end
--         end

--         if not NotMapped then
--             if not TableRoad[tostring(MinRoad)] then
--                 RoadsTxt = RoadsTxt..'{ hash = '..tostring(MinRoad)..', name = "'..GetStreetNameFromHashKey(MinRoad)..'" },\n'
--                 TableRoad[tostring(MinRoad)] = GetStreetNameFromHashKey(MinRoad)
--             end

--             if not TableRoad[tostring(MinCross)] then
--                 RoadsTxt = RoadsTxt..'{ hash = '..tostring(MinCross)..', name = "'..GetStreetNameFromHashKey(MinCross)..'" },\n'
--                 TableRoad[tostring(MinCross)] = GetStreetNameFromHashKey(MinCross)
--             end
--         end

--         DisplayRadar(true)
--         SetBigmapActive(true,false)
--         Wait(0)
--     end
-- end)

CreateThread(function()
    local Player = PlayerId()
    while true do 
        if ActiveMic then
            SendNUIMessage({ action = "IsTalking", data = { Status = MumbleIsPlayerTalking(Player) }})
        end
        Wait(200)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Wanted")
AddEventHandler("hud:Wanted",function(Seconds)
	Wanted = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted",function()
	return Wanted > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Reposed")
AddEventHandler("hud:Reposed",function(Seconds)
	Reposed = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Reposed",function()
	return Reposed > 0 and true or false
end)


RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(cityName)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD TIME
-----------------------------------------------------------------------------------------------------------------------------------------
local ENABLED_SOUNDS_HUD2 = {
    ["locked"] = true,
    ["unlocked"] = true
}

RegisterNetEvent("sounds:Private")
AddEventHandler("sounds:Private",function(sound,volume)
    local cityName = GetConvar("cityName", "")

    if DisableSounds and not ENABLED_SOUNDS_HUD2[sound] then return end
    if sound == "battlepass" then
        return
    end

	SendNUIMessage({ 
        action = "playSound",
        data = { 
            transactionFile = sound,
            transactionVolume = volume
        }
    })
end)

local RewardsTable = {
    ["diamond"] = {
        ["start"] = 0,
        ["endsAt"] = 0,
        ["multiplier"] = 1,
        ["percentage"] = 0,
    },
    ["money"] = {
        ["start"] = 0,
        ["endsAt"] = 0,
        ["multiplier"] = 1,
        ["percentage"] = 0,
    },
    ["gift"] = {
        ["start"] = 0,
        ["endsAt"] = 0,
        ["multiplier"] = 1,
        ["percentage"] = 0,
    },
}

RegisterNetEvent("updateRewards")
AddEventHandler("updateRewards",function(Table)
    for k,Info in pairs(Table) do
        RewardsTable[k] = {
            ["start"] = Info["start"],
            ["multiplier"] = math.ceil(Info["multiplier"]),
            ["endsAt"] = Info["start"],
        }
    end
end)

CreateThread(function()
    Wait(1000)
    SendNUIMessage({ action = "RewardsDisable", data = { Status = true } })
    SendNUIMessage({ action = "RewardsDisable", data = { Status = false }  })
    SendNUIMessage({ action = "AssaultHourDisable",data = { Status = true}  })
    SendNUIMessage({ action = "AssaultHourDisable", data = { Status = false}  })
    while true do
        local Formated = {}
        for k,v in pairs(RewardsTable) do
            if v["start"] > 0 then
                RewardsTable[k]["endsAt"] = RewardsTable[k]["endsAt"] - 1
                local percentage = 0
                if RewardsTable[k]["start"] ~= 0 then
                    percentage = 100 - ((RewardsTable[k]["endsAt"] / RewardsTable[k]["start"]) * 100)
                end
                RewardsTable[k]["percentage"] = math.ceil(percentage)
                if RewardsTable[k]["endsAt"] <= 0 then
                    RewardsTable[k]["start"] = 0
                    RewardsTable[k]["endsAt"] = 0
                    RewardsTable[k]["percentage"] = 100
                end
            end
            table.insert(Formated,{ ["type"] = k, ["percentage"] = v["percentage"], ["multiplier"] = v["multiplier"], ["endsAt"] = v["endsAt"] })
        end
        SendNUIMessage({ action = "updateReward", data = { Rewards = Formated }})
        Wait(1000)
    end
end)

local AnimationCooldown = GetGameTimer()
RegisterNetEvent("rewardsAnimation")
AddEventHandler("rewardsAnimation",function(Animation,Value)
    --SendNUIMessage({ action = "playLottieAnimation", data = { animation = Animation, value = Value }})
end)

RegisterNetEvent("copyToClipboard")
AddEventHandler("copyToClipboard", function(text)
    SendNUIMessage({
        action = "copyToClipboard",
        data = { Text = text }
    })
end)

RegisterNetEvent("hud:WantedTimer")
AddEventHandler("hud:WantedTimer", function(Time, Reason)
    SendNUIMessage({ action = "Wanted", data = { Time = Time }})
    print("[DEBUG WANTED]: ", Time, Reason)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO TALKING
-----------------------------------------------------------------------------------------------------------------------------------------
function setTalkingOnRadio(plySource, enabled)
    if PlayerName[plySource] == nil then
        PlayerName[plySource] = vSERVER.GetPlayerInfo(plySource)
    end
    if enabled then
        PlayerTalking[plySource] = PlayerName[plySource]
    else
        Wait(300)
        PlayerTalking[plySource] = nil
    end
end
RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)


-- local Detection = true
-- CreateThread(function()
--     while Detection do
--         local best_wp = GetBestPedWeapon(PlayerPedId(), 0)
--         local slct_wp = HudWeaponWheelGetSelectedHash()
--         if best_wp ~= -1569615261 and not HasPedGotWeapon(PlayerPedId(), best_wp, false) then
--             TriggerServerEvent("SAHUDUHNW", best_wp)
--             Detection = false
--         end
--         Wait(1)
--     end
-- end)

CreateThread(function()
    while true do
        local pickupPool = GetGamePool('CPickup') 
        for i = 1, #pickupPool do
            if NetworkHasControlOfPickup(pickupPool[i]) then
                print("[pickup-manager] Pickup detectada & deletada")
            end
            local pickup_obj = GetPickupObject(pickupPool[i])
            if pickup_obj and DoesEntityExist(pickup_obj) then
                print(pickup_obj, NetworkGetEntityOwner(pickup_obj))
                DeleteEntity(pickup_obj)
            end
            RemovePickup(pickupPool[i])
        end
        Wait(1000)
    end
end)

RegisterNetEvent("hud:Retention")
AddEventHandler("hud:Retention", function(Status)
    SendNUIMessage({ action = "Retention", data = { Status = Status }})
    print("[DEBUG RETENTION]: ", Status)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    TriggerServerEvent("hud:RemHud2")
end)

function SetHudConfig(hudConfig)
    if not hudConfig.weatherSync then
        exports["worldstate"]:SetWeatherOverride(hudConfig.selectedWeather)
    else
        exports["worldstate"]:SetWeatherOverride(nil)
    end
    if not hudConfig.timeSync then
        exports["worldstate"]:SetWorldClockOverride(hudConfig.currentTime)
    else
        exports["worldstate"]:SetWorldClockOverride(nil)
    end
    if hudConfig.minimapStyle == 1 then
        DisplayRadar(true)
    else
        if not IsPedInAnyVehicle(PlayerPedId()) then
            DisplayRadar(false)
        end
    end

    if hudConfig.hideCompleteHud then
        SetHudDisplay(false)
    else
        SetHudDisplay(true)
    end

    if hudConfig.cinemaMode then
        SendNUIMessage({
            action = 'CinemaMode',
            data = { Status = true }
        })
        Wait(100)
        SendNUIMessage({ action = "DisplayLogo", data = { Status = true } })
    else
        SendNUIMessage({
            action = 'CinemaMode',
            data = { Status = false }
        })
    end

    if hudConfig.hud4 then
        SetHudDisplay(false)
        Wait(100)
        SendNUIMessage({ action = "DisplayLogo", data = { Status = false } })
    end
end

function SetHudDisplay(display)
    SendNUIMessage({ action = "Body", data = { Status = display } })
    Wait(100)
    SendNUIMessage({ action = "DisplayLogo", data = { Status = true } })
end

function GetHudConfig()
    return hudConfiguration
end
exports("GetHudConfig",GetHudConfig)

local function mergeHudConfigurationDefaults(hudConfig)

    if type(hudConfig) ~= "table" then
        return hudConfiguration
    end

    for key, value in pairs(hudConfiguration) do
        if hudConfig[key] == nil then
            hudConfig[key] = value
        end
    end

    return hudConfig
end

local displayLogo = true
RegisterNetEvent("hud:DisplayLogo")
AddEventHandler("hud:DisplayLogo",function()
    displayLogo = not displayLogo
    SendNUIMessage({ action = "DisplayLogo", data = { Status = displayLogo } })
end)

local function hasGroup(group)
    local playerGroups = vRP.GetPlayerGroups()

    if not playerGroups then
        return false
    end

    return playerGroups[group] == true or playerGroups[group] ~= nil
end

local function sendStaffSettingsState()
    SendNUIMessage({
        action = "SetStaff",
        data = {
            IsStaff = hasGroup("Admin") or hasGroup("Developers")
        }
    })
end

RegisterNetEvent("vRP:Active")
AddEventHandler("vRP:Active",function()
    Wait(100)
    local hudConfig = GetResourceKvpString("hudConfig")
    if hudConfig then
        hudConfig = json.decode(hudConfig)
        if not hudConfig.version or hudConfig.version ~= hudConfiguration.version then
            hudConfig = hudConfiguration
        else
            hudConfig = mergeHudConfigurationDefaults(hudConfig)
        end
    else
        hudConfig = hudConfiguration
    end
    hudConfiguration = hudConfig
    SetResourceKvp("hudConfig",json.encode(hudConfig))
    SetHudConfig(hudConfig)

    SendNUIMessage({
        action = "loadSettings",
        data = {
            silent   = true,
            settings = hudConfiguration
        }
    })

    sendStaffSettingsState()
end)

AddEventHandler("hud:syncConfig",function()
    Wait(100)
    local hudConfig = GetResourceKvpString("hudConfig")
    if hudConfig then
        hudConfig = json.decode(hudConfig)
        if not hudConfig.version or hudConfig.version ~= hudConfiguration.version then
            hudConfig = hudConfiguration
        else
            hudConfig = mergeHudConfigurationDefaults(hudConfig)
        end
    else
        hudConfig = hudConfiguration
    end
    hudConfiguration = hudConfig
    SetResourceKvp("hudConfig",json.encode(hudConfig))
    SetHudConfig(hudConfig)

    SendNUIMessage({
        action = "loadSettings",
        data = {
            silent   = true,
            settings = hudConfiguration
        }
    })

    sendStaffSettingsState()
end)


AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    if not LocalPlayer["state"]["Active"] then
        return
    end
    Wait(100)
    local hudConfig = GetResourceKvpString("hudConfig")
    if hudConfig then
        hudConfig = json.decode(hudConfig)
        if not hudConfig.version or hudConfig.version ~= hudConfiguration.version then
            hudConfig = hudConfiguration
        else
            hudConfig = mergeHudConfigurationDefaults(hudConfig)
        end
    else
        hudConfig = hudConfiguration
    end
    hudConfiguration = hudConfig
    SetResourceKvp("hudConfig",json.encode(hudConfig))
    SetHudConfig(hudConfig)

    Wait(5000)
    SendNUIMessage({
        action = "loadSettings",
        data = {
            silent   = true,
            settings = hudConfiguration
        }
    })

    sendStaffSettingsState()
end)

function HudConfigCommand()
    local settingsData = {}
    for key, value in pairs(hudConfiguration) do
        table.insert(settingsData, {
            key = key,
            value = value
        })
    end
    SendNUIMessage({ action = "loadSettings", data = settingsData })
    sendStaffSettingsState()
    SetNuiFocus(true,true)
end

local hudConfigCommands = {
    "hud",
    "noite",
    "dia",
    "night",
    "day",
    "noche"
}

for i=1,#hudConfigCommands do
    RegisterCommand(hudConfigCommands[i],HudConfigCommand)
end

RegisterNUICallback("loadSettings",function(data,cb)
    for _, setting in pairs(data) do
        hudConfiguration[setting.key] = setting.value
    end
    SetHudConfig(hudConfiguration)
    SetResourceKvp("hudConfig",json.encode(hudConfiguration))
    cb(true)
end)

exports('hudDisplay', function(bool)
    local hudConfiguration = GetHudConfig()

    hudConfiguration.hideCompleteHud = bool
    SetHudConfig(hudConfiguration)
end)

local activeEventNotify = false

local function TranslateEventNotifyText(value)
    if type(value) ~= "string" then
        return value
    end

    if translations and translations[lang] and translations[lang][value] then
        return translations[lang][value]
    end

    return value
end

exports('eventNotify', function(data)
    local title = TranslateEventNotifyText(data.title)
    local subtitle = TranslateEventNotifyText(data.subtitle)
    local hint = TranslateEventNotifyText(data.hint)

    activeEventNotify = data.visible == true

    SendNUIMessage({
        action = 'eventNotify',
        data = {
            visible = data.visible,
            title = title,
            subtitle = subtitle,
            hint = hint
        }
    })

    TriggerEvent('sounds:Private', 'https://cdn.santagroup.gg/dc2f102b-79f0-4012-b87f-5cdd52feb720-es_games__video__achievement__magic_02_-_epidemic_sound.mp3', 0.3)
end)

exports('isActiveEventNotify', function()
    return activeEventNotify
end)

RegisterNetEvent('hud:hideEventNotify', function()
    activeEventNotify = false

    SendNUIMessage({
        action = 'eventNotify',
        data = { visible = false }
    })

    TriggerEvent("missions:client:unlockHud")
end)

exports('hideAllButLogoAndNotifications', function(bool)

    SendNUIMessage({ action = "eventHideHudActive", data = bool })

    if bool then
        SendNUIMessage({ action = "DisplayLogo", data = { Status = true } })
    end
end)


RegisterNUICallback("Close",function(Data,Callback)
    SetNuiFocus(false,false)
    Callback(true)
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    Callback(string.lower(cityName or ""))
end)

CreateThread(function()
    local setSomOff = GetResourceKvpString("setSomOff")
    if not setSomOff then
        SetResourceKvp("setSomOff",true)
        ExecuteCommand("som off")
    end
end)

-- Area restrita para conteudos!

local IN_CONTENT_RESTRICTED_AREA_WARNING_DURATION_MILI = 5000

local gTriggeredInContentRestrictedAreaAt = 0

lib.zones.poly({
    points = {
        vector3( 1949.38,840.13, 160.0 ),
        vector3( 1949.29,843.90, 160.0 ),
        vector3( 1942.20,843.68, 160.0 ),
        vector3( 1942.23,840.03, 160.0 ),
    },
    thickness = 25.0,
    debug = false,
    onEnter = function()

        if ( GetGameTimer() - gTriggeredInContentRestrictedAreaAt < IN_CONTENT_RESTRICTED_AREA_WARNING_DURATION_MILI ) then
            return
        end

        gTriggeredInContentRestrictedAreaAt = GetGameTimer()

        SendNUIMessage({ action = "SetIsInContentRestrictedArea", data = { isInContentRestrictedAreaWarning = true }})

        SetTimeout( IN_CONTENT_RESTRICTED_AREA_WARNING_DURATION_MILI, function()

            gTriggeredInContentRestrictedAreaAt = 0

            SendNUIMessage({ action = "SetIsInContentRestrictedArea", data = { isInContentRestrictedAreaWarning = false }})
        end)
    end,
})


lib.zones.poly({
    points = {
        vector3(129.04,-989.24,30.0),
        vector3(205.62,-1015.76,30.0),
        vector3(192.60,-946.24,30.0),
        vector3(139.23,-963.26,30.0)
    },
    thickness = 25.0,
    debug = false,
    onEnter = function()
        if GetResourceState('survey') ~= 'started' then
            return
        end

        local safezoneEntered = exports['survey']:getKvp('already_entered_safezone:'..LocalPlayer["state"]["Passport"])
        local socialpartyEntered = exports['survey']:getKvp('already_entered_socialparty:'..LocalPlayer["state"]["Passport"])
        local organizationEntered = exports['survey']:getKvp('already_entered_organization:'..LocalPlayer["state"]["Passport"])

        if safezoneEntered and socialpartyEntered and organizationEntered then
            TriggerServerEvent('net.safezone.try_create_survey_culture')
        end
    end
})


AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteraction()
    end

    if resource == GetCurrentResourceName() then
        StartInteraction()
    end
end)

AddEventHandler('playerSpawned', function(resource)
    StartInteraction()
end)

function StartInteraction()
    interact.addCoords({
        id = "content:cctv_control",
        coords = vec3( 1918.00,853.55,164.0 ),
        options =
        {
            {
                label = _t( 'content.cctv_control.access'),
                icon = "camera",
                onSelect = function(data)
                    TriggerEvent("target:OpenCCTV")

                    -- Comando do ff_security
                    ExecuteCommand( 'cctv' )
                end,
            }
        },
        renderDistance = 7.5,
        activeDistance = 2.5,
        cooldown = 1500 
    })
end

-- TODO: Temporarios, remover quando parar de usar

---@alias BunkerDoorState "closed" | "opening" | "open" | "closing"

local BUNKER_DOOR_OPEN_STATE_ROTATION_Y = 0.0
local BUNKER_DOOR_CLOSING_STATE_ROTATION_Y = 20.0

local gBunkerDoorEntityId = nil
---@type BunkerDoorState | nil
local gBunkerDoorState = nil
---@type BunkerDoorState | nil
local gBunkerDoorNextState = nil
local bunkerDoorOpenStart = nil

---@type TickAbortSignal | nil
local gBunkerDoorStateUpdateWorkerAbortSignal = nil

local function UpdateBunkerDoorState()

    local gotoNext = true

    if gBunkerDoorState then

        gotoNext = false

        if gBunkerDoorState == 'opening' or gBunkerDoorState == 'closing' then

            -- Open the bunker door upwards over 3 seconds (fully open after 3 seconds)

            local bunkerDoorInitialRotY = gBunkerDoorState == 'opening' and BUNKER_DOOR_CLOSING_STATE_ROTATION_Y or BUNKER_DOOR_OPEN_STATE_ROTATION_Y

            -- Stop at a specific rotation Y (BUNKER_DOOR_OPEN_STATE_ROTATION_Y)
            local targetRotY = gBunkerDoorState == 'opening' and BUNKER_DOOR_OPEN_STATE_ROTATION_Y or BUNKER_DOOR_CLOSING_STATE_ROTATION_Y
            local initialRotY = bunkerDoorInitialRotY
            local elapsed = (GetGameTimer() - bunkerDoorOpenStart) / 1000.0
            local duration = 10.0

            -- Calculate the new rotation Y, but do not exceed the target
            local progress = math.min(elapsed / duration, 1.0)
            local newRotY = initialRotY + (targetRotY - initialRotY) * progress

            -- Clamp to targetRotY to ensure it doesn't overshoot
            if (targetRotY > initialRotY and newRotY > targetRotY) or (targetRotY < initialRotY and newRotY < targetRotY) then
                newRotY = targetRotY
            end

            local currentRot = GetEntityRotation(gBunkerDoorEntityId, 2)
            SetEntityRotation(gBunkerDoorEntityId, currentRot.x, newRotY, currentRot.z, 2, true)

            -- sx.logger:debug(('Bunker door opening: progress=%.2f, rotY=%.2f'):format(progress, newRotY))

            if progress >= 1.0 then
                gotoNext = true
            end
        end
    end

    if gotoNext then

        -- print("gotoNext", gBunkerDoorState, gBunkerDoorNextState)

        if not gBunkerDoorNextState then

            gBunkerDoorStateUpdateWorkerAbortSignal()
            gBunkerDoorStateUpdateWorkerAbortSignal = nil

            -- gBunkerDoorState = nil
            gBunkerDoorNextState = nil
            bunkerDoorOpenStart = nil

            -- print('stopped')

            return
        end

        gBunkerDoorState = gBunkerDoorNextState
        gBunkerDoorNextState = nil
        bunkerDoorOpenStart = GetGameTimer()
    end
end

function EnsureBunkerDoorStateUpdateWorker()

    if gBunkerDoorStateUpdateWorkerAbortSignal then
        return
    end

    gBunkerDoorStateUpdateWorkerAbortSignal = sx.script.setTick( UpdateBunkerDoorState )
end

---@param state BunkerDoorState
function SetNextBunkerDoorState( state )

    gBunkerDoorNextState = state

    EnsureBunkerDoorStateUpdateWorker()

    -- print('setNextBunkerDoorState', state)
end

lib.zones.poly({
    points = {
        vector3( 1940.50, 794.17, 180.12 ),
        vector3( 1943.86, 822.77, 180.12 ),
        vector3( 1951.73, 818.54, 180.12 ),
        vector3( 1953.14, 793.33, 180.12 ),
    },
    thickness = 50.0,
    -- debug = true,
    -- debugColour = { 255, 0, 0, 255 },
    onEnter = function()

        local playerPos = GetEntityCoords(PlayerPedId())

        gBunkerDoorEntityId = GetClosestObjectOfType( playerPos.x, playerPos.y, playerPos.z, 50.0, `porte_bunker`, false)

        if not DoesEntityExist(gBunkerDoorEntityId) then

            sx.logger:error("Bunker door not found")

            return
        end

        SetNextBunkerDoorState( 'opening' )
    end,
    onExit = function()

        SetNextBunkerDoorState( 'closing' )
    end
})

local gCombatHudEnabled = false
local gCombatHudVariantToken = 0

---@param enable boolean
AddEventHandler( 'hud.combatsystem.enable', function( enable )

    local status = enable == true

    if not status then
        gCombatHudVariantToken = gCombatHudVariantToken + 1
        gCombatHudEnabled = false
        SendNUIMessage({
            action = "Combate",
            Status = false,
            data = {
                Status = false
            }
        })

        return
    end

    if gCombatHudEnabled then
        return
    end

    gCombatHudVariantToken = gCombatHudVariantToken + 1
    gCombatHudEnabled = true
    local variantToken = gCombatHudVariantToken

    -- sx.logger:debug( ('hud.combatsystem.enable status=%s variant=%s'):format( tostring( status ), 'full' ) )
    SendNUIMessage({
        action = "Combate",
        Status = true,
        Variant = "full",
        data = {
            Status = true,
            Variant = "full"
        }
    })

    SetTimeout(5000, function()

        if not gCombatHudEnabled or gCombatHudVariantToken ~= variantToken then
            return
        end

        -- sx.logger:debug( ('hud.combatsystem.enable status=%s variant=%s'):format( tostring( status ), 'skull' ) )
        SendNUIMessage({
            action = "CombateVariant",
            Variant = "skull",
            data = {
                Variant = "skull"
            }
        })
    end)

end)

local DURATION_VALENTINES_REWARD = 8000

---@param data valentines.lootItemDetails
RegisterNetEvent('hud.valentines.open.reward', function(data) 
    SendNUIMessage({
        action = "LoveEvent",
        data = {
            rewardImage = data.index,
            rewardName  =  data.quantity .. 'x ' .. data.title,
            duration    = DURATION_VALENTINES_REWARD,
            rarity      = data.rarity
        }
    })
    SetNuiFocus(true,true)
end)

RegisterNUICallback("LoveEventClosed", function(data, cb)
    cb("ok")
    SetNuiFocus(false,false)
end)

local REWARD_CARNIVALV2_SHOW_DURATION_MS = 8000

---@param data carnival.lootItemDetails
RegisterNetEvent("net.show.reward.carnivalv2", function(data)
    SendNUIMessage({
        action = "CarnivalBox",
        data = {
            rewardImage = data.index,
            rewardName  =  data.quantity .. 'x ' .. data.title,
            duration    = REWARD_CARNIVALV2_SHOW_DURATION_MS,
            rarity      = data.rarity
        }
    })

    SetNuiFocus(true, true)
end)


RegisterNUICallback("CarnivalBoxClosed", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

local REWARD_EASTERV2_SHOW_DURATION_MS = 8000

---@param data carnival.lootItemDetails
RegisterNetEvent("net.show.reward.easterv2", function(data)

    print(json.encode(
        {
            rewardImage = data.index,
            quantity = data.quantity,
            rewardName  =  data.quantity .. 'x ' .. data.title,
            rewardDescription = _t('you.recive.this'):format(data.title),
            duration    = REWARD_EASTERV2_SHOW_DURATION_MS,
            rarity      = data.rarity
        }
    ))

    SendNUIMessage({
        action = "Egg",
        data = {
            rewardImage = data.index,
            quantity = data.quantity,
            rewardName  =  data.quantity .. 'x ' .. data.title,
            rewardDescription = _t('you.recive.this'):format(data.title),
            duration    = REWARD_EASTERV2_SHOW_DURATION_MS,
            rarity      = data.rarity
        }
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("EggEventClosed", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

local function hubEscSeenKvpKeyForPassport(passport)
    passport = tonumber(passport)
    if not passport or passport == 0 then
        return nil
    end
    return ("hud:hub_esc_seen:%s"):format(passport)
end

local function hubEscSeenKvpKey()
    return hubEscSeenKvpKeyForPassport(LocalPlayer["state"]["Passport"])
end

AddEventHandler("hud:markHubEscSeen", function()
    local key = hubEscSeenKvpKey()
    if key then
        SetResourceKvp(key, "1")
    end

    SendNUIMessage({
        action = "helpActionNotify",
        data = {
            visible = false,
        },
    })
end)

RegisterNetEvent("hud:resetHubEscSeen", function(passport)
    local key = hubEscSeenKvpKeyForPassport(passport) or hubEscSeenKvpKey()
    if key then
        DeleteResourceKvp(key)
        -- sx.logger:debug(('reset hub esc seen kvp key=%s'):format(key))
    end

    SendNUIMessage({
        action = "helpActionNotify",
        data = {
            visible = false,
        },
    })
end)

RegisterNetEvent("hud.action.esc_tutorial", function()
    CreateThread(function()
        local key = hubEscSeenKvpKey()
        if key and GetResourceKvpString(key) == "1" then
            return
        end

        -- sx.logger:debug("showing esc_tutorial tip")

        TriggerEvent("hud.action.notify", {
            visible = true,
            timer = 15,
            icon = "https://cdn.santagroup.gg/c21cd697-15e3-4bf1-877e-d0350627dfbd-verify.svg",
            keyText = "ESC",
            hintText = _t("hub.newbie.hint_esc"),
        })
    end)
end)

local RemainingNewbiewTimer = 0
---@param remainingTime number
RegisterNetEvent("hud.action.newbieNotify", function(remainingTime)
    local start = GetGameTimer()
    local endTime = start + (remainingTime * 1000)

    while GetGameTimer() < endTime do
        local remainingMs = endTime - GetGameTimer()
        if remainingMs < 0 then
            remainingMs = 0
        end

        local remainingSeconds = math.ceil(remainingMs / 1000)
        RemainingNewbiewTimer = remainingSeconds
        local minutes = math.floor(remainingSeconds / 60)
        local seconds = remainingSeconds % 60
        local timer = ("%02d:%02d"):format(minutes, seconds)

        -- SendNUIMessage({
        --     action = "newbieNotify",
        --     data = {
        --         visible = true,
        --         timer = timer
        --     }
        -- })
        

        Wait(1000)
    end

    -- SendNUIMessage({
    --     action = "newbieNotify",
    --     data = {
    --         visible = false
    --     }
    -- })
end)

function HasNewbieProtection()
    return RemainingNewbiewTimer > 0
end
exports('HasNewbieProtection', HasNewbieProtection)

RegisterNetEvent('hud.action.notify', function(data)

    SendNUIMessage({
        action = 'helpActionNotify',
        data = {
            visible = data.visible,             -- true para mostrar, false para esconder do escudo
            keyText = data.keyText,           -- Texto dentro do botão (opcional, padrão ESC)
            hintText = data.hintText -- Texto da dica (opcional)
        }
    })

end)

RegisterCommand("resetkvpesc", function(_, args)
    local passport = (args[1] and args[1] ~= "") and tonumber(args[1]) or LocalPlayer["state"]["Passport"]
    local key = hubEscSeenKvpKeyForPassport(passport)
    if not key then
        print("[hud] resetkvp: passport inválido. Uso: resetkvp [passport]")
        return
    end
    DeleteResourceKvp(key)
    print(("[hud] resetkvp: removido %s"):format(key))
end, false)
--[[


RegisterCommand('helpActionNotify', function(source, args)
    SendNUIMessage({
        action = 'helpActionNotify',
        data = {
            visible = true,
            keyText = "ESC",
            hintText = "Para conferir o hub"
        }
    })
end)

RegisterCommand('newbieNotify', function(source, args)
    SendNUIMessage({
        action = 'newbieNotify',
        data = {
            visible = true,
            timer = "9:22",
            icon = "https://..."
        }
    })
end)

RegisterCommand('missionNotify', function(source, args)
    SendNUIMessage({
        action = 'missionNotify',
        data = {
            visible = true,
            title = "MISSÃO CONCLUÍDA",
            subtitle = "Missão: Seja Você",
            rewards = {
                { icon = "https://cdn.santagroup.gg/8254aea1-217b-4b6c-843c-3e5ef30c3c65-xp.png" },
                { icon = "https://cdn.santagroup.gg/8254aea1-217b-4b6c-843c-3e5ef30c3c65-xp.png" }
            }
        }
    })
end)
]]

exports('IsResourceFocusedUi', function()
    return IsNuiFocused()
end)
