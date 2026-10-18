local IsPrisoner =  false
local NextJob = 1
local inJob = false
local RemainTime = 0
local Prison = PolyZone:Create({
    vector2(1654.55, 2379.55),
    vector2(1761.36, 2397.73),
    vector2(1825.76, 2465.15),
    vector2(1818.18, 2584.09),
    vector2(1825.00, 2611.36),
    vector2(1850.76, 2687.12),
    vector2(1771.97, 2766.67),
    vector2(1638.64, 2759.09),
    vector2(1554.55, 2676.52),
    vector2(1520.45, 2578.79),
    vector2(1530.30, 2456.06)
}, {
    name="Prison",
    minZ=30,
    maxZ=99
})
-----------------------------------------------------------------------------------------------------------------------------------------
-- STATEBAGHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------

CreateThread(function()
    while true do
        if LocalPlayer["state"]["InPrison"] then
            if not IsPrisoner then
                ExecutePrison()
            end
        end
        Wait(5000)
    end
end)

RegisterNetEvent("police:RemainTime")
AddEventHandler("police:RemainTime",function(Time)
    RemainTime = Time
end)

function CompleteTimersPrison(Seconds)
    local Days = math.floor(Seconds / 86400)
    Seconds = Seconds - Days * 86400
    local Hours = math.floor(Seconds / 3600)
    Seconds = Seconds - Hours * 3600
    local Minutes = math.floor(Seconds / 60)
    Seconds = Seconds - Minutes * 60
    -- Explicitly convert Seconds to an integer to ensure no floating-point representation issues
    Seconds = math.floor(Seconds)

    if Days > 0 then
        return string.format("%d ".._t("days")..", %d ".._t("hours")..", %d ".._t("minutes"), Days, Hours, Minutes)
    elseif Hours > 0 then
        return string.format("%d ".._t("hours")..", %d ".._t("minutes")..", %d ".._t("seconds"), Hours, Minutes, Seconds)
    elseif Minutes > 0 then
        return string.format("%d ".._t("minutes")..", %d ".._t("seconds"), Minutes, Seconds)
    elseif Seconds > 0 then
        return string.format("%d ".._t("seconds"), Seconds)
    end
end


CreateThread(function()
    while true do
        local Idle = 5000
        if IsPrisoner then
            Idle = 1000
            RemainTime = RemainTime - 1
            if RemainTime >= 0 then
                TriggerEvent("Notify:Text", _t("time_remaining_prison"):format(CompleteTimersPrison(RemainTime)))
            else
                TriggerEvent("Notify:Text","")
            end
        end
        Wait(Idle)
    end
end)

function ExecutePrison()
    local Ped = PlayerPedId()
    IsPrisoner = true
    SetEntityCoords(Ped, 1690.55,2561.68,45.54)    
    CreateThread(function()
        while IsPrisoner do
            local Coords = GetEntityCoords(Ped)
            local Health = GetEntityHealth(Ped)
            if Health <= 100 then
                SetEntityCoords(Ped, 1690.55,2561.68,45.54)
                Wait(2500)
                exports["survival"]:Revive(200)
            end
            if not Prison:isPointInside(Coords) then
                SetEntityCoords(Ped, 1690.55,2561.68,45.54)
            end
            Wait(5)
        end
    end)
    CreateThread(function()
        while IsPrisoner do
            local Coords = GetEntityCoords(Ped)
            local Next = vector3(PrisonJobs["Coords"][NextJob]["x"],PrisonJobs["Coords"][NextJob]["y"],PrisonJobs["Coords"][NextJob]["z"])
            local Distance = #(Coords - Next)
            if Distance <= 70.0 and not inJob then
                DrawText(Next.x,Next.y,Next.z,_t("press_to_work"))
                if IsControlJustPressed(0,38) and Distance <= 2.5 then
                    inJob = true
                    if vSERVER.ReduceTime() then
                        NextJob = NextJob + 1
                        if NextJob > #PrisonJobs["Coords"] then
                            NextJob = 1
                        end
                        inJob = false
                    else
                        inJob = false
                    end
                end
            end
            Wait(1)
        end
    end)
end

AddStateBagChangeHandler('InPrison',('player:%s'):format(gPlayerServerId), function(_, _, Value)
    local Ped = PlayerPedId()
    if Value then
        ExecutePrison()
    else
        IsPrisoner = false
        Wait(100)
        --TriggerEvent("Notify","azul","Você cumpriu sua pena.",5000,"Prisão")
        TriggerEvent("Notify2","#servedTime")
        SetEntityCoords(Ped, 1849.35,2586.28,45.66)
    end
end)


local CoordsPrisonPay = {
    vector3(1844.48,2579.33,46.02),
}
CreateThread(function()
    while true do
        local Idle = 2000
        local Ped = PlayerPedId()
        local Coords = GetEntityCoords(Ped)
        for i=1,#CoordsPrisonPay do
            local Distance = #(Coords - CoordsPrisonPay[i])
            if Distance <= 20.0 then
                Idle = 1
                DrawMarker(20,CoordsPrisonPay[i].x,CoordsPrisonPay[i].y,CoordsPrisonPay[i].z-0.5, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.5, 0.45, 0.45, THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, false, true, 2, true, false, false, false)
            end
            if Distance <= 2.0 then
                DrawText(CoordsPrisonPay[i].x,CoordsPrisonPay[i].y,CoordsPrisonPay[i].z,_t("check_prisoners"))
                if IsControlJustPressed(0,38) and not vRP.ReturnNoClip() then
                    print("Checar Prisioneiros")
                    TriggerServerEvent("prison:CheckPrisoners")
                end
            end
        end
        Wait(Idle)
    end
end)
