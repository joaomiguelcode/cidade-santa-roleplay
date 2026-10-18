local AirdropServerRPC = Tunnel.getInterface('airdrop')

---@class ClientAirdrop : Airdrop
---@field blipId number
---@field radialBlipId number

---@type ClientAirdrop | nil
local gOpeningAirdrop = nil

---@param id AirdropId
---@return ClientAirdrop
function GetClientAirdrop( id )
    local airdrop = GetAirdrop( id )

    return airdrop --[[ @as ClientAirdrop ]]
end

---@param airdrop ClientAirdrop
local function UpdateAirdropBlip( airdrop )
    SetBlipColour(airdrop.blipId, airdrop.isOpening and 1 or 28)
end

---@param airdrop ClientAirdrop
local function CreateAirdropBlip( airdrop )
    local blipId = AddBlipForCoord( airdrop.positionEnd.x, airdrop.positionEnd.y, airdrop.positionEnd.z )
    SetBlipSprite( blipId, 94 )
    SetBlipAsShortRange( blipId, true )
    SetBlipColour( blipId, 28 )
    SetBlipScale( blipId, 1.5 )
    BeginTextCommandSetBlipName( "STRING" )
    AddTextComponentSubstringPlayerName( "~o~EVENTO~w~ Airdrop" )
    EndTextCommandSetBlipName( blipId )

    local radialBlipId = AddBlipForRadius(airdrop.positionEnd.x, airdrop.positionEnd.y, airdrop.positionEnd.z, 130.0)
    SetBlipColour(radialBlipId, 1)
    SetBlipAlpha(radialBlipId, 255)
    SetBlipAsShortRange(radialBlipId, true)

    airdrop.blipId = blipId
    airdrop.radialBlipId = radialBlipId

    UpdateAirdropBlip( airdrop )
end

---@param airdrop ClientAirdrop
local function DeleteAirdropBlip(airdrop)
    RemoveBlip(airdrop.radialBlipId)
    RemoveBlip(airdrop.blipId)
end

---@param id AirdropId
---@param positionEnd   vector3
---@param createdAt     number
---@param isOpening     boolean
function CreateClientAirdrop( id, positionEnd, createdAt, isOpening )
    local airdrop = AddAirdrop( id, positionEnd, createdAt, isOpening) --[[ @as ClientAirdrop ]]

    CreateAirdropBlip( airdrop )

    EnsureAirdropSystem()
end

---@param airdrop ClientAirdrop
function DeleteClientAirdrop( airdrop )
    RemoveAirdrop( airdrop )

    DeleteAirdropBlip( airdrop )

    StopAirdropStreamIn( airdrop )
end

---@param airdrop ClientAirdrop
function SetClientAirdropAsOpening( airdrop, isOpening )
    airdrop.isOpening = isOpening

    UpdateAirdropBlip( airdrop )
end

local function StopOpeningClientAirdrop()

    local airdrop = gOpeningAirdrop

    assert( airdrop )

    gOpeningAirdrop = nil

    vRP.stopAnim()

    TriggerEvent("Notify:Text", "")

    FreezeEntityPosition(PlayerPedId(), false)
end

function OpenClientAirdropFromEntity( entityId )
    local streamedInState = GetAirdropStreamedInStateFromEntity( entityId )

    local airdropId = streamedInState.airdropId

    local airdrop = GetClientAirdrop( airdropId )

    if not AirdropServerRPC.OpenServerAirdrop( airdropId ) then
        return
    end

    gOpeningAirdrop = airdrop

    FreezeEntityPosition(PlayerPedId(), true)

    TriggerEvent("Progress", "Abrindo", AIRDROP_OPEN_DURATION * 1000 )
    TriggerEvent("Notify:Text", "F6 para cancelar")

    vRP.playAnim(false, { "amb@medic@standing@tendtodead@idle_a", "idle_a" }, true)
end

AddEventHandler("actions:Cancel",function()
    if gOpeningAirdrop then
        TriggerServerEvent("Airdrop:StopOpening", gOpeningAirdrop.id)
    end
end)

RegisterNetEvent('Airdrop:StoppedOpening', function()
    StopOpeningClientAirdrop()
end)

AddEventHandler('Airdrop:TryToOpen', function( entityId )
    OpenClientAirdropFromEntity( entityId )
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for _, airdrop in ipairs( GetAirdrops() ) do
        DeleteClientAirdrop( airdrop )
    end

    if gOpeningAirdrop then
        StopOpeningClientAirdrop( )
    end
end)

AddEventHandler('playerSpawned', function(resource)
    interact.addGlobalModel({
        id = "Airdrops",
        models = {
            {model = "p_secret_weapon_02", offset = vec3(0, 0, 0.80)},
        },
        options = {
            {
                label = _t("loot"),
                icon = "fighter-jet",
                onSelect = function(data)
                    TriggerEvent("Airdrop:TryToOpen", data.entity)
                end,
                canInteract = function(entity, distance, coords, id)
                    return not gOpeningAirdrop
                end
            },
        },
        renderDistance = 10.0,
        activeDistance = 2.0,
        cooldown = 1500
    })
end)