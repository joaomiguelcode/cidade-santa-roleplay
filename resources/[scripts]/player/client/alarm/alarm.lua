local alreadyInside = false
local insideHouse
local house
local hasPerm = {}
local Zones = {}
local damageThreadActive = false

local blockBuckets = {
    [25] = true,
    [26] = true,
    [27] = true, -- SKORPION
}

local function IsPlayerActive()
    return LocalPlayer.state.Active == true
end

local function IsMatchCityAlarmExempt()
    return LocalPlayer.state['minigame:active'] == 'neighbor'
        and LocalPlayer.state['matchcity:house'] == true
end

CreateThread(function()
    for i=1,#Homes do
        local minZ = Homes[i]["minZ"]
        local maxZ = Homes[i]["maxZ"]
        local options = {
            debugGrid = false
        }
        if minZ and maxZ then
            options.minZ = minZ
            options.maxZ = maxZ
        end
        local Zone = PolyZone:Create(Homes[i]["Zone"],options)
        Zones[i] = Zone
    end
end)

CreateThread(function()
    local lastHealth = 0
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local health = GetEntityHealth(ped)
        local Idle = 5000
        
        if health <= 100 or LocalPlayer.state.newHubTutorial or not IsPlayerActive()
            or IsMatchCityAlarmExempt() then
            if alreadyInside or insideHouse or damageThreadActive then
                alreadyInside = false
                insideHouse = nil
                damageThreadActive = false
            end
            lastHealth = health
        elseif health > 100 and lastHealth <= 100 then
            lastHealth = health
            if IsPlayerActive() and not IsMatchCityAlarmExempt() and not alreadyInside
                and not blockBuckets[LocalPlayer.state.Route] and not IsPedInAnyVehicle(ped)
                and not LocalPlayer.state.newHubTutorial then
                for i=1,#Homes do
                    local v = Zones[i]
                    local k = i
                    if v and v:isPointInside(coords) then
                        insideHouse = v
                        house = k
                        if not hasPerm[k] then
                            local isOwner = vSERVER.notifyOwner(house,"Uma pessoa invadiu sua residência "..house..".")
                            if not isOwner then
                                TriggerEvent("Notify2","#saiaPropriPrivada")
                                alreadyInside = true
                                CreateThread(function()
                                    TimerLeaveMansion()
                                end)
                            else
                                hasPerm[k] = true
                            end
                        end
                        break
                    end
                end
            end
        else
            lastHealth = health
        end
        
        if IsPlayerActive() and not IsMatchCityAlarmExempt() and not blockBuckets[LocalPlayer.state.Route]
            and health > 101 and not IsPedInAnyVehicle(ped) and not LocalPlayer.state.newHubTutorial then
            if not alreadyInside then
                for i=1,#Homes do
                    local v = Zones[i]
                    local k = i
                    if v and v:isPointInside(coords) then
                        insideHouse = v
                        house = k
                        if not hasPerm[k] then
                            local isOwner = vSERVER.notifyOwner(house,"Uma pessoa invadiu sua residência "..house..".")
                            if not isOwner then
                                TriggerEvent("Notify2","#saiaPropriPrivada")
                                alreadyInside = true
                                CreateThread(function()
                                    TimerLeaveMansion()
                                end)
                            else
                                hasPerm[k] = true
                            end
                        end
                    end
                end
            else
                Idle = 1
                local coords = GetEntityCoords(ped)
                if not insideHouse or not insideHouse:isPointInside(coords) or health <= 100 then
                    alreadyInside = false
                    insideHouse = nil
                    damageThreadActive = false
                end
            end
        end
        Wait(Idle)
    end
end) 

function TimerLeaveMansion()
    if damageThreadActive then
        return
    end
    
    damageThreadActive = true
    local ped = PlayerPedId()
    
    if not IsPlayerActive() or IsMatchCityAlarmExempt() or not insideHouse then
        alreadyInside = false
        insideHouse = nil
        damageThreadActive = false
        return
    end
    
    local Timer = 15
    TriggerEvent("Progress","Propriedade",Timer*1000)
    
    while alreadyInside and insideHouse do
        local health = GetEntityHealth(ped)
        local coords = GetEntityCoords(ped)
        
        if not IsPlayerActive() or IsMatchCityAlarmExempt() or health <= 100 then
            alreadyInside = false
            insideHouse = nil
            damageThreadActive = false
            TriggerEvent("Progress","Cancelando",0)
            TriggerEvent("Notify:Text","")
            return
        end
        
        if not insideHouse:isPointInside(coords) then
            alreadyInside = false
            insideHouse = nil
            damageThreadActive = false
            TriggerEvent("Progress","Cancelando",0)
            TriggerEvent("Notify:Text","")
            return
        end
        
        if Timer > 0 then
            Timer = Timer - 1
        else
            break
        end
        
        Wait(1000)
    end
    
    TriggerEvent("Progress","Cancelando",0)
    TriggerEvent("Notify:Text","")
    
    if not IsPlayerActive() or IsMatchCityAlarmExempt() or not alreadyInside or not insideHouse then
        alreadyInside = false
        insideHouse = nil
        damageThreadActive = false
        return
    end
    
    local coords = GetEntityCoords(ped)
    local health = GetEntityHealth(ped)
    
    while alreadyInside and insideHouse do
        coords = GetEntityCoords(ped)
        health = GetEntityHealth(ped)
        
        if not IsPlayerActive() or IsMatchCityAlarmExempt() or health <= 100 then
            alreadyInside = false
            insideHouse = nil
            damageThreadActive = false
            break
        end
        
        if not insideHouse:isPointInside(coords) then
            alreadyInside = false
            insideHouse = nil
            damageThreadActive = false
            break
        end
        
        if LocalPlayer["state"]["ParamedicRevive"] then
            Wait(1000)
        else
            local newHealth = health - 7
            if newHealth > 100 then
                SetEntityHealth(ped, newHealth)
            else
                SetEntityHealth(ped, 100)
                alreadyInside = false
                insideHouse = nil
                damageThreadActive = false
                break
            end
            Wait(1000)
        end
    end
    
    damageThreadActive = false
    
    if alreadyInside then
        alreadyInside = false
        insideHouse = nil
    end
end

RegisterNetEvent("mansion_alarm:Reset")
AddEventHandler("mansion_alarm:Reset",function()
    damageThreadActive = false
    alreadyInside = false
    insideHouse = nil
    house = nil
    hasPerm = {}
    Zones = {}
    for i=1,#Homes do
        local Zone = PolyZone:Create(Homes[i]["Zone"],{debugGrid = false})
        Zones[i] = Zone
    end
end)

RegisterNetEvent("survival:reviveAnim")
AddEventHandler("survival:reviveAnim",function()
    damageThreadActive = false
    Wait(500)
    
    if not IsPlayerActive() or IsMatchCityAlarmExempt() then
        alreadyInside = false
        insideHouse = nil
        return
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local health = GetEntityHealth(ped)
    
    if health > 100 then
        for i=1,#Homes do
            local v = Zones[i]
            if v and v:isPointInside(coords) then
                local isOwner = vSERVER.notifyOwner(i,"Uma pessoa invadiu sua residência "..i..".")
                if not isOwner then
                    insideHouse = v
                    house = i
                    alreadyInside = true
                    CreateThread(function()
                        TimerLeaveMansion()
                    end)
                else
                    hasPerm[i] = true
                end
                break
            end
        end
    else
        alreadyInside = false
        insideHouse = nil
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if not IsPlayerActive() or IsMatchCityAlarmExempt() then
            alreadyInside = false
            insideHouse = nil
            damageThreadActive = false
        elseif health > 100 and alreadyInside then
            if not insideHouse or not insideHouse:isPointInside(GetEntityCoords(ped)) then
                alreadyInside = false
                insideHouse = nil
            end
        end
    end
end)
