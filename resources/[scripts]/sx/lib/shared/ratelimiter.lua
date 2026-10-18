sx.ratelimiter = { }

local MAX_KEYS = 4000

---@alias sx.RateLimitStrategy<T> { consume: fun ( self: sx.RateLimiter, key: string, cache: sx.lrucache, now: number ): boolean }

---@class sx.RateLimiter
---@field cache sx.lrucache
---@field strategy sx.RateLimitStrategy
local ratelimiter = { }

---@param key string
---@return boolean
function ratelimiter:consume( key )

    local now = GetGameTimer()

    return self.strategy:consume( key, self.cache, now )
end

-- Strategy factory method with better type inference
---@generic T : table
---@param strategyFn fun(): fun(options: T): sx.RateLimitStrategy<T>
---@return fun(options: T): sx.RateLimitStrategy<T>
function sx.ratelimiter.strategy( strategyFn )

    return strategyFn()
end

-- Strategy implementations
sx.ratelimiter.strategies = { }

sx.ratelimiter.strategies.fixedWindow = sx.ratelimiter.strategy(function()

    ---@param options { windowMs: number }
    return function( options )

        return {
            consume = function( self, key, cache, now )

                local cooldown = cache:get( key )

                if cooldown and now <= cooldown then
                    return false
                end

                cache:set( key, now + options.windowMs )

                return true
            end
        }
    end
end)

sx.ratelimiter.strategies.backoff = sx.ratelimiter.strategy(function()

    ---@param options { baseDelayMs?: number, maxDelayMs?: number, multiplier?: number }
    return function( options )

        options.baseDelayMs = options.baseDelayMs or 1000
        options.maxDelayMs  = options.maxDelayMs  or 60000
        options.multiplier  = options.multiplier  or 2

        return {
            consume = function( self, key, cache, now )

                local backoff = cache:get( key )

                if backoff then

                    local delay = math.min(
                        options.baseDelayMs * (options.multiplier ^ backoff.count),
                        options.maxDelayMs
                    )

                    if now <= backoff.nextTry then
                        -- sx.logger:debug(('Backoff ratelimited for key "%s", nextTry=%d, now=%d'):format(key, failure.nextTry or 0, now))

                        -- Increase failure count and set nextTry
                        backoff.count   += 1
                        backoff.nextTry = now + delay

                        cache:set(key, backoff)

                        return false
                    end

                    cache:set(key, { count = 0, nextTry = now + options.baseDelayMs })
                else

                    -- First failure, set up backoff
                    cache:set(key, { count = 0, nextTry = now + options.baseDelayMs })
                end

                return true
            end
        }
    end
end)

sx.ratelimiter.strategies.slidingWindow = sx.ratelimiter.strategy(function()

    ---@param options { maxRequests?: number, windowMs?: number }
    return function( options )

        options.maxRequests = options.maxRequests or 10
        options.windowMs    = options.windowMs    or 1000

        return {
            consume = function( self, key, cache, now )

                local requests = cache:get( key ) or { }

                -- Remove expired requests
                local validRequests = {}

                for _, timestamp in ipairs( requests ) do

                    if now - timestamp < options.windowMs then

                        table.insert( validRequests, timestamp )
                    end
                end

                if #validRequests >= options.maxRequests then
                    return false
                end

                table.insert( validRequests, now )

                cache:set( key, validRequests )

                return true
            end
        }
    end
end)

sx.ratelimiter.strategies.progressiveDelay = sx.ratelimiter.strategy(function()

    ---@param options { windowMs: number, baseDelayMs?: number, maxDelayMs?: number, multiplier?: number, maxMultiplications?: number }
    return function( options )

        options.windowMs = options.windowMs or 5000
        options.baseDelayMs = options.baseDelayMs or 1000
        options.maxDelayMs = options.maxDelayMs or 60000
        options.multiplier = options.multiplier or 2
        options.maxMultiplications = options.maxMultiplications or 5

        return {
            consume = function( self, key, cache, now )
                local state = cache:get( key )

                -- First time, set up initial window
                if not state then

                    cache:set(key, {
                        count = 0,
                        currentDelay = options.baseDelayMs,
                        nextAllowed = now + options.windowMs
                    })
                    return true
                end

                -- Still in delay period, increase the delay
                if now <= state.nextAllowed then
                    local currentDelay = state.currentDelay or options.baseDelayMs
                    
                    -- If already at max delay, just return false without updating cache
                    if currentDelay >= options.maxDelayMs then
                        return false
                    end
                    
                    local newDelay = math.min(
                        currentDelay * options.multiplier,
                        options.maxDelayMs
                    )
                    
                    local newCount = (state.count or 0) + 1
                    
                    cache:set(key, {
                        count = newCount,
                        currentDelay = newDelay,
                        nextAllowed = now + newDelay
                    })
                    
                    return false
                end

                -- Delay period expired, reset to window mode
                cache:set(key, {
                    count = 0,
                    currentDelay = options.baseDelayMs,
                    nextAllowed = now + options.windowMs
                })

                return true
            end
        }
    end
end)

sx.ratelimiter.strategies.tiered = sx.ratelimiter.strategy(function()

    ---@param options { baseLimitMs?: number, requestsPerTier?: number, debtMultiplier?: number, maxTier?: number, decayRate?: number }
    return function( options )

        options.baseLimitMs = options.baseLimitMs or 1000
        options.requestsPerTier = options.requestsPerTier or 3
        options.debtMultiplier = options.debtMultiplier or 2
        options.maxTier = options.maxTier or 5
        options.decayRate = options.decayRate or 100 -- ms per second

        return {
            consume = function( self, key, cache, now )
                local state = cache:get( key ) or { 
                    debt = 0, 
                    lastUpdate = now, 
                    tier = 1,
                    requestsInTier = 0,
                    tierStartTime = now
                }

                -- Decay debt over time
                local timePassed = now - state.lastUpdate
                local newDebt = math.max(0, state.debt - (timePassed * options.decayRate / 1000))

                -- Check if we're still in debt
                if newDebt > 0 then
                    cache:set(key, {
                        debt = newDebt,
                        lastUpdate = now,
                        tier = state.tier,
                        requestsInTier = state.requestsInTier,
                        tierStartTime = state.tierStartTime
                    })
                    return false
                end

                -- Check if tier should reset (enough time has passed)
                local tierDuration = options.baseLimitMs * state.tier
                if now - state.tierStartTime > tierDuration then
                    state.tier = 1
                    state.requestsInTier = 0
                    state.tierStartTime = now
                end

                -- Increment requests in current tier
                state.requestsInTier = state.requestsInTier + 1

                -- Check if we've exceeded requests for this tier
                if state.requestsInTier > options.requestsPerTier then
                    -- Escalate to next tier
                    local newTier = math.min(state.tier + 1, options.maxTier)
                    local debtAmount = options.baseLimitMs * (options.debtMultiplier ^ (newTier - 1))
                    
                    cache:set(key, {
                        debt = debtAmount,
                        lastUpdate = now,
                        tier = newTier,
                        requestsInTier = 1, -- Reset count for new tier
                        tierStartTime = now
                    })
                    
                    return false
                end

                -- Allow request, update state
                cache:set(key, {
                    debt = 0,
                    lastUpdate = now,
                    tier = state.tier,
                    requestsInTier = state.requestsInTier,
                    tierStartTime = state.tierStartTime
                })

                return true
            end
        }
    end
end)

---@generic T : table
---@class sx.RateLimiterOptions
---@field strategy? sx.RateLimitStrategy<T>
---@field strategyOptions? T

---@param options sx.RateLimiterOptions
---@return sx.RateLimiter
function sx.ratelimiter.new( options )

    options = options or {}

    -- Default to fixed window strategy
    local strategy = options.strategy or sx.ratelimiter.strategies.fixedWindow( options.strategyOptions or {
        windowMs = 15 * 1000
    })

    -- sx.logger:debug( ('Created ratelimiter with strategy: %s'):format( tostring( strategy ) ) )

    local maxKeys = options.maxKeys or MAX_KEYS

    ---@type sx.RateLimiter
    local o = setmetatable(
    {
        cache = sx.lrucache.new( maxKeys ),
        strategy = strategy
    }, { __index = ratelimiter })

    return o
end