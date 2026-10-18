DebugConfigStatus = false

-- Cache for nearby items (within 50m)
local nearbyGarages = {}
local nearbyChests = {}
local nearbyDoors = {}
local nearbyBarbershop = {}
local nearbyCrafting = {}
function EnableConfigDebug()
    CreateThread(function()
        while DebugConfigStatus do
            UpdateNearbyConfigs()
            Wait(2500)
        end
    end)

    CreateThread(function()
        while DebugConfigStatus do
            DrawNearbyConfigs()
            Wait(0)
        end
    end)
end

function UpdateNearbyConfigs()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    nearbyGarages = {}
    local garages = exports["garages"]:GetGarages()

    for i = 1, #garages do
        local garage = garages[i]
        local info = garage["Spawns"]
        local start = vector3(info["Open"]["x"], info["Open"]["y"], info["Open"]["z"])
        local distance = #(coords - start)

        if distance <= 50.0 then
            table.insert(nearbyGarages, {
                index = i,
                name = garage["Info"]["Name"],
                perm = garage["Info"]["Perm"] or "PUBLIC",
                coords = start,
                distance = distance
            })
        end
    end

    nearbyChests = {}
    local chests = exports["inventory"]:GetChests()

    for i = 1, #chests do
        local chest = chests[i]
        local chestCoords = vector3(chest["Coords"][1], chest["Coords"][2], chest["Coords"][3])
        local distance = #(coords - chestCoords)

        if distance <= 50.0 then
            table.insert(nearbyChests, {
                index = i,
                name = chest["Name"],
                coords = chestCoords,
                distance = distance
            })
        end
    end

    nearbyDoors = {}
    local doors = exports["doors"]:GetDoors()

    for id, info in pairs(doors) do
        local position = info["position"]
        local distance = #(coords - position)

        if distance <= 50.0 then
            table.insert(nearbyDoors, {
                id = id,
                hash = tostring(info["modelHash"]),
                perm = info["authorizedGroup"],
                coords = position,
                distance = distance
            })
        end
    end

    nearbyBarbershop = {}
    local barbershop = exports["character-creator"]:GetBarbershopLocations()
    for id, info in pairs(barbershop) do
        local position = vector3(info[1], info[2], info[3])
        local distance = #(coords - position)
        if distance <= 50.0 then
            table.insert(nearbyBarbershop, {
                id = id,
                coords = position,
                distance = distance
            })
        end
    end

    nearbyCrafting = {}
    local crafting = exports["crafting"]:GetCraftingLocations()
    for id, info in pairs(crafting) do
        local position = vector3(info[1].x, info[1].y, info[1].z)
        local distance = #(coords - position)
        if distance <= 50.0 then
            table.insert(nearbyCrafting, {
                id = id,
                name = info[2],
                coords = position,
                distance = distance
            })
        end
    end
end

function DrawNearbyConfigs()
    -- Draw all nearby garages
    for _, g in ipairs(nearbyGarages) do
        local text = "~g~GARAGE: (" .. g.index .. ") ~w~" .. g.name ..
                     "\n~g~DIST: ~w~" .. tD(g.distance) ..
                     "\n~g~CDS: ~w~" .. tD(g.coords.x) .. "," .. tD(g.coords.y) .. "," .. tD(g.coords.z) ..
                     "\n~g~PERM: ~w~" .. g.perm
        DrawText3Dss(g.coords.x, g.coords.y, g.coords.z, text, 350)
    end

    -- Draw all nearby chests
    for _, c in ipairs(nearbyChests) do
        local text = "~r~CHEST: (" .. c.index .. ") ~w~" .. c.name ..
                     "\n~r~DIST: ~w~" .. tD(c.distance) ..
                     "\n~r~CDS: ~w~" .. tD(c.coords.x) .. "," .. tD(c.coords.y) .. "," .. tD(c.coords.z)
        DrawText3Dss(c.coords.x, c.coords.y, c.coords.z, text, 350)
    end

    -- Draw all nearby doors
    for _, d in ipairs(nearbyDoors) do
        local text = "~b~DOOR: (" .. d.id .. ") ~w~" .. d.hash ..
                     "\n~b~DIST: ~w~" .. tD(d.distance) ..
                     "\n~b~CDS: ~w~" .. tD(d.coords.x) .. "," .. tD(d.coords.y) .. "," .. tD(d.coords.z) ..
                     "\n~b~PERM: ~w~" .. d.perm
        DrawText3Dss(d.coords.x, d.coords.y, d.coords.z, text, 350)
    end

    for _, b in ipairs(nearbyBarbershop) do
        local text = "~y~BARBERSHOP: (" .. b.id .. ") ~w~"..
                     "\n~y~DIST: ~w~" .. tD(b.distance).."m"..
                     "\n~y~CDS: ~w~" .. tD(b.coords.x) .. "," .. tD(b.coords.y) .. "," .. tD(b.coords.z)
        DrawText3Dss(b.coords.x, b.coords.y, b.coords.z, text, 350)
    end

    for _, c in ipairs(nearbyCrafting) do
        local text = "~o~CRAFTING: (" .. c.id .. ") ~w~"..c.name..
                     "\n~o~DIST: ~w~" .. tD(c.distance).."m"..
                     "\n~o~CDS: ~w~" .. tD(c.coords.x) .. "," .. tD(c.coords.y) .. "," .. tD(c.coords.z)
        DrawText3Dss(c.coords.x, c.coords.y, c.coords.z, text, 350)
    end
end

RegisterNetEvent("net.admin.debugconfigs", function()
    DebugConfigStatus = not DebugConfigStatus
    if DebugConfigStatus then
        EnableConfigDebug()
    else
        -- Clear caches when disabled
        nearbyGarages = {}
        nearbyChests = {}
        nearbyDoors = {}
        nearbyBarbershop = {}
        nearbyCrafting = {}
    end
end)
