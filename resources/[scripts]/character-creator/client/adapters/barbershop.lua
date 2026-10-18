--[[ codigo simplesmente importado do barbershop ]]

function StartInteraction()
    for id = 1, #LOCATIONS_BARBERSHOP do
        interact.addCoords({
            id = "barbershop:" .. tostring(id),
            coords = LOCATIONS_BARBERSHOP[id].xyz,
            options = {
                {
                    label = _t("open_barbershop"),
                    icon = "scissors",
                    onSelect = function(data)
                        -- if vSERVER.CheckWanted() then --todo:
                        -- end
                        TriggerEvent('net.character-creator.open', eCharacterCreatorCreationState.EDITING)
                    end,
                    canInteract = function(entity, distance, coords, id)
                        return not exports["hud"]:Wanted() and not LocalPlayer["state"]["FFA"] and
                            not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"] and
                            LocalPlayer["state"]["Route"] < 900000
                    end
                }
            },
            renderDistance = 7.5,
            activeDistance = 1.5,
            cooldown = 1500
        })
    end
end

local function AddBarbershop(Name, Coords)
    local Name = "barbershop:" .. Name
    interact.addCoords({
        id = Name,
        coords = vec3(Coords.x, Coords.y, Coords.z),
        options = {
            {
                label = _t("open_barbershop"),
                icon = "scissors",
                onSelect = function(data)
                    if lib.callback.await('net.character-creator.checkWanted', false) then
                        TriggerEvent('net.character-creator.open', eCharacterCreatorCreationState.EDITING)
                    end
                end,
                canInteract = function(entity, distance, coords, id)
                    return not exports["hud"]:Wanted() and not LocalPlayer["state"]["FFA"] and
                        not LocalPlayer["state"]["PVP"] and not GlobalState["Restarting"] and
                        LocalPlayer["state"]["Route"] < 900000
                end
            }
        },
        renderDistance = 7.5,
        activeDistance = 1.5,
        cooldown = 1500
    })
    return Name
end

local function RemoveBarbershop(Name)
    interact.removeById(Name)
end

RegisterNetEvent("barbershop:Open:NPC")
AddEventHandler("barbershop:Open:NPC", function()
    TriggerEvent("talknpc:closeTalk")
    TriggerEvent('net.character-creator.open', eCharacterCreatorCreationState.EDITING)
end)

RegisterNetEvent("barbershop:Open")
AddEventHandler("barbershop:Open", function()
    if exports.inventory:IsPlayerInEvent() then
        return TriggerEvent("Notify2","#cantDoAgain")
    end
    TriggerEvent('net.character-creator.open', eCharacterCreatorCreationState.EDITING)
end)

exports("AddBarbershop", AddBarbershop)
exports("RemoveBarbershop", RemoveBarbershop)

CreateThread(function()
    for _, position in pairs(GetBarbershopLocations()) do
        LOCATIONS_BARBERSHOP[#LOCATIONS_BARBERSHOP + 1] = position
    end
end)

AddEventHandler('playerSpawned', function()
    StartInteraction()
end)

AddEventHandler('onResourceStart', function(resource)
    Wait(1500)
    if resource == "sleepless_interact" then
        StartInteraction()
    end

    if resource == GetCurrentResourceName() then
        StartInteraction()
    end
end)