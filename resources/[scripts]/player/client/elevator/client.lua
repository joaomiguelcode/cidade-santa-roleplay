local currentElevator = nil
local currentFloorIndex = nil
local lastNotifiedFloor = nil


function DrawText3DElevator(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.20, 0.20)
    SetTextFont(8)
    SetTextOutline()
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local wait = 2500
        local foundFloor = false

        for _, elevator in pairs(Elevators) do
            for i, floor in ipairs(elevator.floors) do
                local dist = #(coords - floor.coords)

                if dist < 10.0 then
                    wait = 0
                    foundFloor = true

                    local mType = elevator.marker and elevator.marker.type or 1
                    local mSize = elevator.marker and elevator.marker.size or 1.0
                    local mColor = elevator.marker and elevator.marker.color or { r = 0, g = 150, b = 255 }

                    DrawMarker(mType, floor.coords.x, floor.coords.y, floor.coords.z - 1.0,
                        0.0, 0.0, 0.0, 0, 0, 0,
                        mSize, mSize, 0.5,
                        mColor.r, mColor.g, mColor.b, 150,
                        false, true, 2, false, nil, nil, false)
                end

                if dist < 1.5 then
                    -- Mostrar o nome do andar apenas se for diferente do último
                    if lastNotifiedFloor ~= floor.label then
                        lastNotifiedFloor = floor.label

                        lib.notify({
                            title = _t("elevator"),
                            description = _t("currentFloor") .. ': ' .. floor.label,
                            type = 'inform'
                        })
                    end

                    --DrawText3DElevator(floor.coords.x, floor.coords.y, floor.coords.z,"~b~[E]~w~ " .. _t("enterElevator"))

                    if IsControlJustReleased(0, 38) then
                        currentElevator = elevator
                        currentFloorIndex = i
                        OpenElevatorMenu(elevator, i)
                    end
                end
            end
        end

        if not foundFloor then
            lastNotifiedFloor = nil
        end

        Wait(wait)
    end
end)

function OpenElevatorMenu(elevator, currentIndex)
    local options = {}

    for i, floor in ipairs(elevator.floors) do
        if i ~= currentIndex then
            table.insert(options, {
                title = floor.label,
                description = _t("goToFloor"),
                icon = "arrow-up",
                onSelect = function()
                    TeleportToFloor(floor.coords)
                end
            })
        end
    end

    lib.registerContext({
        id = 'elevator_menu',
        title = _t("elevator") .. ' - ' .. elevator.name,
        options = options
    })

    lib.showContext('elevator_menu')
end

function TeleportToFloor(coords)
    DoScreenFadeOut(500)
    Wait(700)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    Wait(700)
    DoScreenFadeIn(500)
end
