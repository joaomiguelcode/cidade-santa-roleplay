-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Default = 1920 / 1080
local OffsetX,OffsetY = 0,0
local ResolutionX,ResolutionY = GetActiveScreenResolution()
local AspectRatio = ResolutionX / ResolutionY
local AspectDiff = Default - AspectRatio
local ForcedMinimapOwners = {}
local ForcedBigmapOwners = {}
local ForcedBigmapRevisions = {}
local ForcedBigmapDistanceByOwner = {}
local HiddenBlipOwners = {}
local HiddenBlipOriginalAlpha = {}

-- The official GTA V list currently ends below this ceiling.
local BLIP_MAX_SPRITE_ID = 1024

function IsHudMinimapForced()
    return next(ForcedMinimapOwners) ~= nil
end

function IsHudBigmapForced()
    return next(ForcedBigmapOwners) ~= nil
end

function IsHudBlipsHidden()
    return next(HiddenBlipOwners) ~= nil
end

---@param firstSprite number
---@param lastSprite number
local function HideBlipsInSpriteRange(firstSprite, lastSprite)
    local mainPlayerBlip = GetMainPlayerBlipId()
    local waypointBlip = IsWaypointActive() and GetFirstBlipInfoId(8) or 0

    for sprite = firstSprite,lastSprite do
        local blip = GetFirstBlipInfoId(sprite)

        while DoesBlipExist(blip) do
            if blip ~= mainPlayerBlip and blip ~= waypointBlip then
                local currentAlpha = GetBlipAlpha(blip)

                if HiddenBlipOriginalAlpha[blip] == nil or currentAlpha > 0 then
                    HiddenBlipOriginalAlpha[blip] = currentAlpha
                end

                if currentAlpha ~= 0 then
                    SetBlipAlpha(blip,0)
                end
            end

            blip = GetNextBlipInfoId(sprite)
        end
    end
end

local function HideAllWorldBlips()
    HideBlipsInSpriteRange(0,BLIP_MAX_SPRITE_ID)
end

local function RestoreWorldBlips()
    for blip,alpha in pairs(HiddenBlipOriginalAlpha) do
        if DoesBlipExist(blip) then
            SetBlipAlpha(blip,alpha)
        end
    end

    HiddenBlipOriginalAlpha = {}
end

---@param owner string
---@param hidden boolean
---@return boolean success
local function SetBlipsHidden(owner, hidden)
    if type(owner) ~= "string" or owner == "" then
        return false
    end

    local wasHidden = IsHudBlipsHidden()

    if hidden then
        HiddenBlipOwners[owner] = true
        HideAllWorldBlips()

        return true
    end

    HiddenBlipOwners[owner] = nil

    if wasHidden and not IsHudBlipsHidden() then
        RestoreWorldBlips()
    end

    return true
end

exports("SetBlipsHidden", SetBlipsHidden)

---@param owner string
---@param forced boolean
---@return boolean success
local function SetMinimapForced(owner, forced)
    if type(owner) ~= "string" or owner == "" then
        return false
    end

    if forced then
        ForcedMinimapOwners[owner] = true
        DisplayRadar(true)
        return true
    end

    ForcedMinimapOwners[owner] = nil

    if not IsHudMinimapForced()
        and (not hudConfiguration or hudConfiguration.minimapStyle == 0)
        and not IsPedInAnyVehicle(PlayerPedId())
    then
        DisplayRadar(false)
    end

    return true
end

exports("SetMinimapForced", SetMinimapForced)

---@param owner string
---@param forced boolean
---@param zoomDistance? number
---@return boolean success
local function SetBigmapForced(owner, forced, zoomDistance)
    if type(owner) ~= "string" or owner == "" then
        return false
    end

    if forced then
        local requestedDistance = math.max(0.0, tonumber(zoomDistance) or 0.0)

        ForcedBigmapOwners[owner] = true
        ForcedBigmapRevisions[owner] = (ForcedBigmapRevisions[owner] or 0) + 1
        ForcedBigmapDistanceByOwner[owner] = requestedDistance

        local revision = ForcedBigmapRevisions[owner]

        DisplayRadar(true)
        SetBigmapActive(true,false)

        CreateThread(function()
            while ForcedBigmapOwners[owner] and ForcedBigmapRevisions[owner] == revision do
                if not IsBigmapActive() then
                    DisplayRadar(true)
                    SetBigmapActive(true,false)
                end

                SetRadarZoomToDistance(ForcedBigmapDistanceByOwner[owner] or 0.0)
                Wait(0)
            end
        end)

        return true
    end

    local wasForced = ForcedBigmapOwners[owner] == true

    ForcedBigmapOwners[owner] = nil
    ForcedBigmapRevisions[owner] = (ForcedBigmapRevisions[owner] or 0) + 1
    ForcedBigmapDistanceByOwner[owner] = nil

    if wasForced and not IsHudBigmapForced() then
        SetRadarZoom(0)

        if IsBigmapActive() then
            SetBigmapActive(false,false)
        end
    end

    return true
end

exports("SetBigmapForced", SetBigmapForced)

AddEventHandler("onResourceStop",function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    if IsHudBigmapForced() then
        SetRadarZoom(0)
        SetBigmapActive(false,false)
    end

    RestoreWorldBlips()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
-- CreateThread(function()
--     if LoadTexture("circleminimap") then
--         SetMinimapClipType(1)
--         UpdatePosition()
--     end

--     while true do
--         local ActualX,ActualY = GetActiveScreenResolution()
--         if ResolutionX ~= ActualX or ResolutionY ~= ActualY then
--             UpdatePosition()
--         end

--         Wait(10000)
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function UpdatePosition()
    ResolutionX,ResolutionY = GetActiveScreenResolution()

    if AspectRatio > Default then
        AspectDiff = Default - AspectRatio
        OffsetX = AspectDiff / 3.6
    end

    AddReplaceTexture("platform:/textures/graphics","radarmasksm","circleminimap","radarmasksm")

    SetMinimapComponentPosition("minimap","L","B",-0.0045 + OffsetX,-0.035 + OffsetY,0.175,0.225)
    SetMinimapComponentPosition("minimap_mask","L","B",0.020 + OffsetX,0.105 + OffsetY,0.110,0.150)
    SetMinimapComponentPosition("minimap_blur","L","B",-0.02 + OffsetX,-0.02 + OffsetY,0.265,0.225)

    SetBigmapActive(true,false)

    if IsHudBigmapForced() then
        return
    end

    repeat
        Wait(100)
        SetBigmapActive(false,false)
    until not IsBigmapActive()
end
