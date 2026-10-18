-- farmer minigame lifecycle server-side
local minigameNextId = 1
local activeMinigames = {}

lib.callback.register('minigame:request_create', function(source, defIndex, pointIndex)
    local passport = vRP.Passport(source)
    if not passport then return eMinigameCreateStatus.ERR end
    
    local id = minigameNextId
    minigameNextId = minigameNextId + 1
    
    activeMinigames[source] = {
        id = id,
        defIndex = defIndex,
        pointIndex = pointIndex,
        source = source,
        passport = passport,
        started = false
    }
    
    return eMinigameCreateStatus.OK, id
end)

lib.callback.register('minigame:request_create_from_volume', function(source, defIndex, volumeLocalIdx)
    local passport = vRP.Passport(source)
    if not passport then return eMinigameCreateStatus.ERR end
    
    local id = minigameNextId
    minigameNextId = minigameNextId + 1
    
    activeMinigames[source] = {
        id = id,
        defIndex = defIndex,
        volumeLocalIdx = volumeLocalIdx,
        source = source,
        passport = passport,
        started = false
    }
    
    return eMinigameCreateStatus.OK, id
end)

lib.callback.register('minigame:request_start', function(source)
    local mg = activeMinigames[source]
    if not mg then return eMinigameStartStatus.ERR_MINIGAMEPOINT_NOT_FOUND end
    mg.started = true
    mg.startedAt = GetGameTimer()
    return eMinigameStartStatus.OK
end)

lib.callback.register('minigame:request_create_and_start', function(source, defIndex, pointIndex)
    local passport = vRP.Passport(source)
    if not passport then return eMinigameStartStatus.ERR_NOT_ALLOWED end
    
    local id = minigameNextId
    minigameNextId = minigameNextId + 1
    
    activeMinigames[source] = {
        id = id,
        defIndex = defIndex,
        pointIndex = pointIndex,
        source = source,
        passport = passport,
        started = true,
        startedAt = GetGameTimer()
    }
    
    return eMinigameStartStatus.OK, id
end)

lib.callback.register('minigame:end', function(source)
    activeMinigames[source] = nil
    return true
end)

lib.callback.register('minigame:request_complete', function(source)
    local mg = activeMinigames[source]
    if not mg then return eMinigameCompleteStatus.ERR_MINIGAME_NOT_FOUND end
    
    local passport = mg.passport
    activeMinigames[source] = nil
    
    -- Reward
    return eMinigameCompleteStatus.OK
end)
