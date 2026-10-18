local Events = {}
local OpeningEventEvent = false
local EventBlips = {}

RegisterNetEvent("blipEvent:Start")
AddEventHandler("blipEvent:Start",function(Data,Bucket)
    if Bucket then
        if LocalPlayer["state"]["Route"] ~= Bucket then
            return
        end
    end
    local eventID = Data["id"]
    local eventCoords = Data["coords"]
    Events[eventID] = eventCoords
    CreateEventBlip(eventID,eventCoords)
end)


function CreateEventBlip(eventID,eventCoords)
    local blipId = AddBlipForCoord( eventCoords.x, eventCoords.y, eventCoords.z )
    SetBlipSprite( blipId, 570 )
    SetBlipAsShortRange( blipId, true )
    SetBlipColour( blipId, 28 )
    SetBlipScale( blipId, 1.5 )
    BeginTextCommandSetBlipName( "STRING" )
    AddTextComponentSubstringPlayerName( "~o~EVENTO~w~ Blip" )
    EndTextCommandSetBlipName( blipId )
    EventBlips[eventID] = blipId
end

function RemoveEventBlip(eventID)
    RemoveBlip(EventBlips[eventID])
    EventBlips[eventID] = nil
end

RegisterNetEvent("blipEvent:StartGrab")
AddEventHandler("blipEvent:StartGrab",function(eventID)
    FreezeEntityPosition(PlayerPedId(), true)
    OpeningEvent = eventID
    TriggerEvent("Notify:Text", "F6 para cancelar")
    vRP.playAnim(false, { "amb@medic@standing@tendtodead@idle_a", "idle_a" }, true)
end)

RegisterNetEvent("blipEvent:StopGrab")
AddEventHandler("blipEvent:StopGrab",function(eventID)
    OpeningEvent = false
    TriggerEvent("Notify:Text", "")
    vRP.stopAnim()
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerEvent("Progress","Cancelando",0)
end)

AddEventHandler("actions:Cancel",function()
    if OpeningEvent then
        TriggerServerEvent("blipEvent:StopGrab", OpeningEvent)
    end
end)

RegisterNetEvent("blipEvent:Remove")
AddEventHandler("blipEvent:Remove",function(eventID)
    Events[eventID] = nil
    RemoveEventBlip(eventID)
end)

CreateThread(function()
    while true do
        local Idle = 1000
        local ped = PlayerPedId()
        local Coords = GetEntityCoords(ped)
        if not OpeningEvent then
            for eventID,eventCoords in pairs(Events) do
                local Distance = #(Coords - eventCoords)
                if Distance <= 50.0 then
                    Idle = 0
                    local _,Ground = GetGroundZFor_3dCoord(eventCoords.x, eventCoords.y, eventCoords.z)
                    DrawMarker(20,eventCoords.x,eventCoords.y,eventCoords.z-0.5, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 1)
                    DrawMarker(23, eventCoords.x,eventCoords.y, Ground + 0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 0)
                    DrawText(eventCoords["x"],eventCoords["y"],eventCoords["z"],"~r~[E]~w~ Iniciar Coleta")
                    if Distance <= 2.0 then
                        if IsControlJustPressed(0,38) then
                            TriggerServerEvent("blipEvent:StartGrab", eventID)
                        end
                    end
                end
            end
        end
        Wait(Idle)
    end
end)