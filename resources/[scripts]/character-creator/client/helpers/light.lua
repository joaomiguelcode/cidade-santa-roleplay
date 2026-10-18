Light = {}

function Light.draw()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
    local R, G, B = 255, 255, 255
    local DISTANCE = 100.0
    local BRIGHTNESS = 20.0
    local HARDNESS = 10.0
    local RADIUS = 80.0
    local FALLOFF = 1.15

    CreateThread(function()
        while gCamera and DoesCamExist(gCamera) do
            DrawSpotLight(x, y, z + 1.5, 0.0, 0.0, -1.0, R, G, B, DISTANCE, BRIGHTNESS, HARDNESS, RADIUS, FALLOFF)
            Wait(0)
        end
    end)
end