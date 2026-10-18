local LIST_EVENTS_KEYS = {
    "GunGame",
    "Arena",
    "Rolling",
    "Domination",
    "DropKill",
    "WarSystem",
    "FFA",
    "WorldPVP",
    "1x1",
    "Event",
}

local INVENTORY_ALLOWED_ACTIVE_MINIGAMES = {
    ["Domination"] = true,
    ["Royale"] = true,
}

local LIST_BUCKETS_EVENTS = {
    2, -- mundo guerra
    20, -- mundo pvp
    25, -- mundo royale
    
    904236, -- mundo fuzil
    903235, -- mundo pistola

    904238, -- cidade nobre ( CidadeNobre ( lobao ) )
    904237, -- cidade nobre ( CidadeNobre ( domn ) )
    904239, -- grande ( Wellington )
}

local LOOKUP_BUCKETS_EVENTS = {} do 
    for _, bucket in pairs(LIST_BUCKETS_EVENTS) do
        LOOKUP_BUCKETS_EVENTS[bucket] = true
    end
end

local LOOKUP_EVENTS_KEYS = {} do 
    for _, key in pairs(LIST_EVENTS_KEYS) do
        LOOKUP_EVENTS_KEYS[key] = true
    end
end

---@param source Source?
---@param key string
---@return boolean
local function GetPlayerState(source, key)
    if IsDuplicityVersion() and source then
        return Player(source).state[key]
    end
    return LocalPlayer.state[key]
end

---@param source number
local function IsPlayerInBucketEvent(source)
    if IsDuplicityVersion() and source then
        return LOOKUP_BUCKETS_EVENTS[GetPlayerRoutingBucket(source)]
    end
    return LOOKUP_BUCKETS_EVENTS[vRP.GetCurrentRoutingBucket()]
end

---@param source Source?
function IsPlayerInEvent(source)
    for _, key in pairs(LIST_EVENTS_KEYS) do
        if GetPlayerState(source, key) then
            return true
        end
    end

    if IsPlayerInBucketEvent(source) then
        return true
    end

    return false
end

---@param source Source?
---@return boolean
function IsInventoryBlockedByMinigame(source)
    local activeMinigame = GetPlayerState(source, "minigame:active")

    if not activeMinigame then
        return false
    end

    return INVENTORY_ALLOWED_ACTIVE_MINIGAMES[tostring(activeMinigame)] ~= true
end

-- Excecoes server-side de storage exigem membership real, nunca apenas o state replicado.
---@param source Source
---@return boolean allowed
function CanUseRoyaleStorage( source )

    if not IsDuplicityVersion() or not source or GetResourceState( "dminigames" ) ~= "started" then return false end

    local succeeded, allowed = pcall( function()
        return exports.dminigames:CanUseRoyaleStorage( source )
    end )

    return succeeded and allowed == true
end

exports("IsPlayerInEvent", IsPlayerInEvent)

exports("GetLookupBucketsEvents", function()
    return LOOKUP_BUCKETS_EVENTS
end)

exports("GetLookupEventsKeysState", function()
    return LOOKUP_EVENTS_KEYS
end)
