local Teleport = vector3(2157.93,2921,-80.0)
local OnTeleport = vector3(-1471.5,-920.37,10.01)

CreateThread(function()
    while true do
        local Idle = 2500
        local Coords = GetEntityCoords(PlayerPedId())
        local Distance = #(Coords - Teleport)

        local isInMinigame = LocalPlayer["state"]["minigame:active"]

        if not isInMinigame then

            if Distance <= 100.0 then
                Idle = 0
                local _,Ground = GetGroundZFor_3dCoord(Teleport.x,Teleport.y,Teleport.z)
                DrawText3D(Teleport.x, Teleport.y, Teleport.z - 0.9, _t("exit_mining"))
                DrawMarker(22,Teleport["x"], Teleport["y"], Teleport["z"] - 0.9,0,0,0,vec3(0.0, 180.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
                DrawMarker(27, Teleport.x,Teleport.y, Ground + 0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 0)
            end
            local Distance = #(Coords - OnTeleport)
            if Distance <= 50.0 then
                Idle = 0
                local _,Ground = GetGroundZFor_3dCoord(OnTeleport.x,OnTeleport.y,OnTeleport.z)
                DrawText3D(OnTeleport.x, OnTeleport.y, OnTeleport.z + 0.5, _t("enter_mining"))
                DrawMarker(22,OnTeleport["x"], OnTeleport["y"], OnTeleport["z"],0,0,0,vec3(0.0, 180.0, 0.0),vec3(1.0, 1.0, 1.0),THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100,false,false,2,true,nil,nil,false)
                DrawMarker(27, OnTeleport.x,OnTeleport.y, Ground + 0.03, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5,THEME.rgb.r, THEME.rgb.g, THEME.rgb.b, 100, 0, 0, 0, 0)
            end

        end

        Wait(Idle)
    end
end)