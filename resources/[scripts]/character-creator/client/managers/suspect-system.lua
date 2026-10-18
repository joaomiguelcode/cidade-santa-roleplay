cityName = GetConvar("cityName", "")

local gFirstLoginChangesMadeScore = 0
---@type table<string, boolean>
local gFirstLoginScoreKeys = {}
local sentToSx = false

--[[ Sistema de suspeitos feito por @key_value. ]]
SuspectSystem = {}

---@enum character-creator.SuspectScoreKey
local gScoreKeys = {
    PRESET_SELECT = 'presetSelect',
    PRESET_RANDOMIZE = 'presetRandomize',
    GENETIC = 'genetic',
    CUSTOMIZATION = 'customization',
    CHANGE_GENDER = 'changeGender',
    IMPORT_CODE = 'importCode'
}

---@enum character-creator.SuspectCustomizationScoreKey
local gCustomizationScoreKeys = {
    EYE_COLOR = 'eyeColor',
    HAIR = 'hair',
    FACE_NOSE = 'face:nose',
    FACE_EYEBROW = 'face:eyebrow',
    FACE_CHEEK = 'face:cheek',
    FACE_EYE = 'face:eye',
    FACE_LIP = 'face:lip',
    FACE_JAW = 'face:jaw',
    FACE_CHIN = 'face:chin',
    FACE_NECK = 'face:neck'
}

local gGeneticScoreKeys = {
    shapeFirstID = true,
    skinFirstID = true,
    shapeSecondID = true,
    skinSecondID = true,
    shapeMix = true,
    skinMix = true
}

local gFaceFeatureScoreKeys = {
    NOSE_WIDTH = gCustomizationScoreKeys.FACE_NOSE,
    NOSE_PEAK = gCustomizationScoreKeys.FACE_NOSE,
    NOSE_LENGTH = gCustomizationScoreKeys.FACE_NOSE,
    NOSE_BONE_CURVENESS = gCustomizationScoreKeys.FACE_NOSE,
    NOSE_TIP = gCustomizationScoreKeys.FACE_NOSE,
    NOSE_BONE_TWIST = gCustomizationScoreKeys.FACE_NOSE,
    EYEBROW_HEIGHT = gCustomizationScoreKeys.FACE_EYEBROW,
    EYEBROW_DEPTH = gCustomizationScoreKeys.FACE_EYEBROW,
    CHEEK_BONES_HEIGHT = gCustomizationScoreKeys.FACE_CHEEK,
    CHEEK_BONES_WIDTH = gCustomizationScoreKeys.FACE_CHEEK,
    CHEEK_WIDTH = gCustomizationScoreKeys.FACE_CHEEK,
    EYE_OPENING = gCustomizationScoreKeys.FACE_EYE,
    LIP_THICKNESS = gCustomizationScoreKeys.FACE_LIP,
    JAW_BONE_WIDTH = gCustomizationScoreKeys.FACE_JAW,
    JAW_BONE_SHAPE = gCustomizationScoreKeys.FACE_JAW,
    CHIN_HEIGHT = gCustomizationScoreKeys.FACE_CHIN,
    CHIN_LENGTH = gCustomizationScoreKeys.FACE_CHIN,
    CHIN_SHAPE = gCustomizationScoreKeys.FACE_CHIN,
    CHIN_HOLE = gCustomizationScoreKeys.FACE_CHIN,
    NECK_THICKNESS = gCustomizationScoreKeys.FACE_NECK
}

---@type table<character-creator.SuspectScoreKey, number>
SuspectSystem.SCORE_POINTS = {
    [gScoreKeys.PRESET_SELECT] = 0.45,
    [gScoreKeys.PRESET_RANDOMIZE] = 0.20,
    [gScoreKeys.GENETIC] = 0.25,
    [gScoreKeys.CUSTOMIZATION] = 0.20,
    [gScoreKeys.CHANGE_GENDER] = 0.08,
    [gScoreKeys.IMPORT_CODE] = 2.30
}

local NO_EFFORT_MAX_SCORE = 1.70
local GOOD_EFFORT_MIN_SCORE = 2.00

local function isCreationStateValid()
    return next(gCreationState) and (gCreationState.flag & eCharacterCreatorCreationState.CREATING) ~= 0
end

function SuspectSystem.resetScore()
    gFirstLoginChangesMadeScore = 0
    gFirstLoginScoreKeys = {}
    sentToSx = false
end

---@param amount number
function SuspectSystem.addScore(amount)
    if not isCreationStateValid() then
        return
    end
    gFirstLoginChangesMadeScore += amount
end

---@param uniqueKey string
---@param amount number
local function addScoreByUniqueKey(uniqueKey, amount)
    if not isCreationStateValid() then
        return
    end

    if gFirstLoginScoreKeys[uniqueKey] then
        return
    end

    gFirstLoginScoreKeys[uniqueKey] = true
    SuspectSystem.addScore(amount)

    sx.logger:debug(('CharacterCreatorEffortAdd key=%s amount=%s total=%s'):format(
        tostring(uniqueKey), tostring(amount), tostring(gFirstLoginChangesMadeScore)
    ))
end

---@param scope string
---@param name string
---@return string
local function getScopedScoreKey(scope, name)
    return ('%s:%s'):format(scope, name)
end

---@param key character-creator.SuspectScoreKey
local function addUniqueScore(key)
    local amount = SuspectSystem.SCORE_POINTS[key]

    if not amount then
        return
    end

    addScoreByUniqueKey(key, amount)
end

---@param key character-creator.SuspectCustomizationScoreKey | string
local function addUniqueCustomizationScore(key)
    addScoreByUniqueKey(
        ('%s:%s'):format(gScoreKeys.CUSTOMIZATION, key),
        SuspectSystem.SCORE_POINTS[gScoreKeys.CUSTOMIZATION]
    )
end

function SuspectSystem.addPresetSelectScore()
    addUniqueScore(gScoreKeys.PRESET_SELECT)
end

function SuspectSystem.addPresetRandomizeScore()
    addUniqueScore(gScoreKeys.PRESET_RANDOMIZE)
end

function SuspectSystem.addChangeGenderScore()
    addUniqueScore(gScoreKeys.CHANGE_GENDER)
end

function SuspectSystem.addImportCodeScore()
    addUniqueScore(gScoreKeys.IMPORT_CODE)
end

---@param key string
function SuspectSystem.addGeneticScore(key)
    if not gGeneticScoreKeys[key] then
        return
    end

    addUniqueScore(gScoreKeys.GENETIC)
end

---@param nameOverlay string
function SuspectSystem.addOverlayScore(nameOverlay)
    addUniqueCustomizationScore(getScopedScoreKey('overlay', nameOverlay))
end

function SuspectSystem.addEyeColorScore()
    addUniqueCustomizationScore(gCustomizationScoreKeys.EYE_COLOR)
end

---@param key string
function SuspectSystem.addFaceFeatureScore(key)
    addUniqueCustomizationScore(gFaceFeatureScoreKeys[key] or getScopedScoreKey('face', key))
end

---@param nameComponent string
function SuspectSystem.addComponentScore(nameComponent)
    addUniqueCustomizationScore(getScopedScoreKey('component', nameComponent))
end

function SuspectSystem.addHairScore()
    addUniqueCustomizationScore(gCustomizationScoreKeys.HAIR)
end

function SuspectSystem.onSendToSx()
    if not isCreationStateValid() then
        return
    end

    if sentToSx then
        return
    end

    sentToSx = true

    local elapsedMs = GetGameTimer() - gCreationState.startAt
    local isNoEffort = gFirstLoginChangesMadeScore <= NO_EFFORT_MAX_SCORE
    local isLowEffort = (not isNoEffort) and gFirstLoginChangesMadeScore < GOOD_EFFORT_MIN_SCORE

    sx.logger:debug(('isNoEffortFinished isNoEffort=%s isLowEffort=%s score=%s elapsedMs=%s'):format(
        tostring(isNoEffort), tostring(isLowEffort), tostring(gFirstLoginChangesMadeScore), tostring(elapsedMs)
    ))

    xpcall(function()
        if isNoEffort then
            -- sx.client.stats.v2.set( 'is_no_effort', 1 )
            sx.client.stats.v2.increment('misconduct_points', GlobalState["MISCONDUCT_NO_EFFORT_PUNISH_BY"] or 15)
            sx.client.stats.v2.set('misconduct_punished_by', 'effort_none')
            sx.client.stats.v2.set('misconduct_punished_at_world', vRP.GetCurrentRoutingBucket())
        elseif isLowEffort then
            -- sx.client.stats.v2.set( 'is_low_effort', 1 )
            sx.client.stats.v2.increment('misconduct_points', GlobalState["MISCONDUCT_LOW_EFFORT_PUNISH_BY"] or 10)
            sx.client.stats.v2.set('misconduct_punished_by', 'effort_low')
            sx.client.stats.v2.set('misconduct_punished_at_world', vRP.GetCurrentRoutingBucket())
        end
    end, function(err)
        sx.logger:error('SuspectSystem.onSendToSx :: error', err)
    end)
end
