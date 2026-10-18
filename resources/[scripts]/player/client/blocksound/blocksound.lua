if not lib then return end

---@class ZoneData
---@field points vector3[]
---@field thickness number

---@type ZoneData[]
local blockSoundZones = {
    { -- Pier
        points = {
            vec3(-1665.15, -803.03, 0.0),
            vec3(-1474.24, -965.15, 0.0),
            vec3(-1778.79, -1321.21, 0.0),
            vec3(-1993.94, -1148.48, 0.0)
        },
        thickness = 150
    },
    { -- Praca
        points = {
            vec3(193.94, -716.67, 20.0),
            vec3(340.91, -765.91, 20.0),
            vec3(250.00, -1026.52, 20.0),
            vec3(235.61, -1070.45, 20.0),
            vec3(232.58, -1137.12, 20.0),
            vec3(28.03, -1140.15, 20.0),
            vec3(40.91, -1097.73, 20.0),
            vec3(116.67, -922.73, 20.0)
        },
        thickness = 150
    },
    { -- Hospital
        points = {
            vec3(1085.61, -1447.73, 20.0),
            vec3(1098.48, -1651.52, 20.0),
            vec3(1150.76, -1645.45, 20.0),
            vec3(1262.88, -1493.18, 20.0),
            vec3(1246.97, -1453.03, 20.0)
        },
        thickness = 150
    },
    { -- Mec 1
        points = {
            vec3(-1201.52, -2111.36, 10.0),
            vec3(-1098.48, -2009.85, 10.0),
            vec3(-1034.85, -2085.61, 10.0),
            vec3(-1152.27, -2221.97, 10.0),
            vec3(-1203.79, -2190.91, 10.0)
        },
        thickness = 150
    },
    { -- Mec 2
        points = {
            vec3(843.94, -1000.00, 20.0),
            vec3(981.82, -990.91, 20.0),
            vec3(948.48, -904.55, 20.0),
            vec3(845.45, -909.85, 20.0)
        },
        thickness = 150
    }
}

---createBlockSoundZone
---@param data ZoneData
local function createBlockSoundZone(data)
    lib.zones.poly({
        points = data.points,
        thickness = data.thickness,
		onEnter = function()
            
            --[[
                INFO: Player entrou em zona onde sound é blocked?
                Vamos considerar isso como uma area social
            
                - @TkzDev
            ]]

            StartCountTimeInPlayerPlaytimeSocialArea()

            LocalPlayer.state:set("isLafyMuted", true, true)
		end,
		onExit = function()

            EndCountTimeInPlayerPlaytimeSocialArea()

            LocalPlayer.state:set("isLafyMuted", false, true)
		end,
        -- debug = true
    })
end

CreateThread(function()
    for i = 1, #blockSoundZones do
        local zoneData = blockSoundZones[i]
        createBlockSoundZone(zoneData)
    end
end)