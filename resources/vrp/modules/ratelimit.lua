-----------------------------------------------------------------------------------------------------------------------------------------
-- RATE LIMIT MODULE
-----------------------------------------------------------------------------------------------------------------------------------------
local RateLimits = {}

function vRP.RateLimit(source, action, limitSeconds)
    if not source or not action then return true end
    limitSeconds = limitSeconds or 1

    local now = os.time()
    if not RateLimits[source] then
        RateLimits[source] = {}
    end

    local last = RateLimits[source][action] or 0
    if (now - last) < limitSeconds then
        return false
    end

    RateLimits[source][action] = now
    return true
end

AddEventHandler("vRP:playerLeave", function(Passport, source)
    if source and RateLimits[source] then
        RateLimits[source] = nil
    end
end)
