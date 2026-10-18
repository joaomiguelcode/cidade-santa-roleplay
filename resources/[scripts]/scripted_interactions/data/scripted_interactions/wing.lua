local INTERACTION_NAME = 'wing'
local ATTACH_BONE_ID = 24818
local OFFSET_POSITION = vector3(0.09, -0.35, 0.0)
local OFFSET_ROTATION = vector3(11.11, 90.0, 180.0)
local FLAG = eScriptedInteractionStateFlags.SKIP_ALL_CHECKS | eScriptedInteractionStateFlags.WHEN_FINISHED__DELETE_ALL_PROP

local WING_MODEL_NAMES = {
    ['gndfadaasamaigreen'] = 'gndfadaasamaigreen',
    ['gndfadaasamaipink'] = 'gndfadaasamaipink',
    ['gndfadaasamaipinkbblue'] = 'gndfadaasamaipinkbblue',
    ['gndfadaasamaipinkred'] = 'gndfadaasamaipinkred',
    ['gndfadaasamaipinkwhite'] = 'gndfadaasamaipinkwhite',
    ['gndfadaasamaipurple'] = 'gndfadaasamaipurple',
}

---@param entity number
---@param modelName string
local function OnPlayAnim(entity, modelName)
    local animDict = "clip@" .. modelName

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end

    PlayEntityAnim(entity, modelName, animDict, 1000.0, true, false, true, 0, 0.0)
end

local WING_HASH = {}

for name in pairs(WING_MODEL_NAMES) do
    WING_HASH[GetHashKey(name)] = name
end

---@param modelName string
local function MountWing(modelName)
    return {
        name = modelName,
        props = {
            {
                modelName = modelName,
                boneId = ATTACH_BONE_ID,

                offsetPosition = OFFSET_POSITION,
                offsetRotation = OFFSET_ROTATION,
            }
        },
        flags = FLAG
    }
end

DEFINE_SCRIPTED_INTERACTION 'wing' {
    {
        name = 'idle',
        props = {
            {
                modelName = 'gndfadaasamaigreen',
                boneId = ATTACH_BONE_ID,

                offsetPosition = OFFSET_POSITION,
                offsetRotation = OFFSET_ROTATION,
            }
        },
        flags = FLAG
    },

    MountWing(WING_MODEL_NAMES['gndfadaasamaigreen']),
    MountWing(WING_MODEL_NAMES['gndfadaasamaipink']),
    MountWing(WING_MODEL_NAMES['gndfadaasamaipinkbblue']),
    MountWing(WING_MODEL_NAMES['gndfadaasamaipinkred']),
    MountWing(WING_MODEL_NAMES['gndfadaasamaipinkwhite']),
    MountWing(WING_MODEL_NAMES['gndfadaasamaipurple']),
}


---@param interactionName string
AddEventHandler('scripted_interactions:onLocalScriptedInteractionStarted', function(interactionName)
    if interactionName ~= INTERACTION_NAME then
        return
    end

    for _, entity in pairs(GetGamePool('CObject')) do
        local model = GetEntityModel(entity)
        local wingName = WING_HASH[model]

        if wingName then
            OnPlayAnim(entity, wingName)
        end
    end
end)

---@param interactionName string
AddEventHandler('scripted_interactions:onLocalScriptedInteractionStopped', function(interactionName)
    if interactionName ~= INTERACTION_NAME then
        return
    end
end)