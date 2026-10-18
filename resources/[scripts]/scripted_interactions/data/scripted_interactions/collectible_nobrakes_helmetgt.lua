DEFINE_SCRIPTED_INTERACTION 'collectible_nobrakes_helmetgt' {
    {
        name = 'idle',

        flags = eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP | eScriptedInteractionStateFlags.SKIP_ALL_CHECKS,

        props =
        {
            {
                modelName = 'capacetenobrakes',
                boneId = 31086,

                offsetPosition = vector3( 0.05, 0.01, 0.0 ),
                offsetRotation = vector3( -180.0, -90.0, 0.0 ),

                animDict = 'clip@capacetenobrakes',
                animName = 'hash_9A2DE4FC',
            }
        }
    }
}

if IsDuplicityVersion() then
    return
end

local MASK_COMPONENT_ID = 1
local HAIR_COMPONENT_ID = 2

local HAT_PROP_ID = 0
local GLASSES_PROP_ID = 1

local EMPTY_COMPONENT_DRAWABLE_ID = 0
local EMPTY_COMPONENT_TEXTURE_ID = 0

---@class NoBrakesHelmetAppearanceSnapshot
---@field maskDrawableId number
---@field maskTextureId number
---@field maskPaletteId number
---@field hairDrawableId number
---@field hairTextureId number
---@field hairPaletteId number
---@field hatPropId number
---@field hatTextureId number
---@field glassesPropId number
---@field glassesTextureId number

---@type table<number, NoBrakesHelmetAppearanceSnapshot>
local gNoBrakesHelmetAppearanceByEntityId = {}

---@param entityId number
---@return boolean
local function IsNoBrakesHelmetLocalOwnerEntity( entityId )

    if not DoesEntityExist( entityId ) then
        sx.logger:warn( ( 'ScriptedInteraction NoBrakes Helmet :: entity does not exist entity=%s' ):format( tostring( entityId ) ) )
        return false
    end

    return entityId == PlayerPedId() or NetworkGetEntityOwner( entityId ) == PlayerId()
end

---@param entityId number
local function SaveNoBrakesHelmetAppearance( entityId )

    if gNoBrakesHelmetAppearanceByEntityId[ entityId ] then
        return
    end

    gNoBrakesHelmetAppearanceByEntityId[ entityId ] = {
        maskDrawableId = GetPedDrawableVariation( entityId, MASK_COMPONENT_ID ),
        maskTextureId = GetPedTextureVariation( entityId, MASK_COMPONENT_ID ),
        maskPaletteId = GetPedPaletteVariation( entityId, MASK_COMPONENT_ID ),
        hairDrawableId = GetPedDrawableVariation( entityId, HAIR_COMPONENT_ID ),
        hairTextureId = GetPedTextureVariation( entityId, HAIR_COMPONENT_ID ),
        hairPaletteId = GetPedPaletteVariation( entityId, HAIR_COMPONENT_ID ),
        hatPropId = GetPedPropIndex( entityId, HAT_PROP_ID ),
        hatTextureId = GetPedPropTextureIndex( entityId, HAT_PROP_ID ),
        glassesPropId = GetPedPropIndex( entityId, GLASSES_PROP_ID ),
        glassesTextureId = GetPedPropTextureIndex( entityId, GLASSES_PROP_ID ),
    }
end

---@param entityId number
local function HideNoBrakesHelmetAppearance( entityId )

    SaveNoBrakesHelmetAppearance( entityId )

    local snapshot = gNoBrakesHelmetAppearanceByEntityId[ entityId ]

    ClearPedProp( entityId, HAT_PROP_ID )
    ClearPedProp( entityId, GLASSES_PROP_ID )
    SetPedComponentVariation( entityId, MASK_COMPONENT_ID, EMPTY_COMPONENT_DRAWABLE_ID, EMPTY_COMPONENT_TEXTURE_ID, snapshot.maskPaletteId )
    SetPedComponentVariation( entityId, HAIR_COMPONENT_ID, EMPTY_COMPONENT_DRAWABLE_ID, EMPTY_COMPONENT_TEXTURE_ID, snapshot.hairPaletteId )
end

---@param entityId number
---@param propId number
---@param drawableId number
---@param textureId number
local function RestoreNoBrakesHelmetProp( entityId, propId, drawableId, textureId )

    if drawableId >= 0 then
        SetPedPropIndex( entityId, propId, drawableId, textureId, true )
    else
        ClearPedProp( entityId, propId )
    end
end

---@param entityId number
---@return boolean success
local function RestoreNoBrakesHelmetAppearance( entityId )

    local snapshot = gNoBrakesHelmetAppearanceByEntityId[ entityId ]
    if not snapshot then
        return false
    end

    gNoBrakesHelmetAppearanceByEntityId[ entityId ] = nil

    if not DoesEntityExist( entityId ) then
        sx.logger:warn( ( 'ScriptedInteraction NoBrakes Helmet :: cannot restore missing entity entity=%s' ):format( tostring( entityId ) ) )
        return false
    end

    SetPedComponentVariation(
        entityId,
        MASK_COMPONENT_ID,
        snapshot.maskDrawableId,
        snapshot.maskTextureId,
        snapshot.maskPaletteId
    )

    SetPedComponentVariation(
        entityId,
        HAIR_COMPONENT_ID,
        snapshot.hairDrawableId,
        snapshot.hairTextureId,
        snapshot.hairPaletteId
    )

    RestoreNoBrakesHelmetProp( entityId, HAT_PROP_ID, snapshot.hatPropId, snapshot.hatTextureId )
    RestoreNoBrakesHelmetProp( entityId, GLASSES_PROP_ID, snapshot.glassesPropId, snapshot.glassesTextureId )

    return true
end

local function RestoreAllNoBrakesHelmetAppearances()

    local pendingEntityIds = {}

    for entityId in pairs( gNoBrakesHelmetAppearanceByEntityId ) do
        table.insert( pendingEntityIds, entityId )
    end

    for _, entityId in ipairs( pendingEntityIds ) do
        RestoreNoBrakesHelmetAppearance( entityId )
    end
end

---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStarted', function( interactionName, entityId )

    if interactionName ~= 'collectible_nobrakes_helmetgt' then
        return
    end

    if not IsNoBrakesHelmetLocalOwnerEntity( entityId ) then
        return
    end

    HideNoBrakesHelmetAppearance( entityId )
end )

---@param interactionName string
---@param entityId number
AddEventHandler( 'scripted_interactions:onLocalScriptedInteractionStopped', function( interactionName, entityId )

    if interactionName ~= 'collectible_nobrakes_helmetgt' then
        return
    end

    RestoreNoBrakesHelmetAppearance( entityId )
end )

AddEventHandler( 'onClientResourceStop', function( resourceName )

    if resourceName ~= GetCurrentResourceName() then
        return
    end

    RestoreAllNoBrakesHelmetAppearances()
end )
