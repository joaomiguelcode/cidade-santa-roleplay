---@class FeedbackTimeApi
FeedbackTime = {}

local TIME_UNIT_IN_MILLISECONDS = {
    ms = 1,
    s = 1000,
    m = 60 * 1000,
    h = 60 * 60 * 1000,
}

---@param duration string
---@return integer milliseconds
function FeedbackTime.ToMilliseconds( duration )
    assert( type( duration ) == "string", "gamified feedback duration must be a string" )

    local value, unit = duration:match( "^(%d+)(%a+)$" )
    local multiplier = TIME_UNIT_IN_MILLISECONDS[unit]

    assert( value and multiplier, ( "invalid gamified feedback duration: %s" ):format( duration ) )

    return math.floor( tonumber( value ) * multiplier )
end

---@param duration string
---@return integer seconds
function FeedbackTime.ToSeconds( duration )
    return math.floor( FeedbackTime.ToMilliseconds( duration ) / 1000 )
end

---@param minimum string
---@param maximum string
---@return integer milliseconds
function FeedbackTime.RandomMilliseconds( minimum, maximum )
    local minimumMs = FeedbackTime.ToMilliseconds( minimum )
    local maximumMs = FeedbackTime.ToMilliseconds( maximum )

    if minimumMs > maximumMs then
        minimumMs, maximumMs = maximumMs, minimumMs
    end

    return math.random( minimumMs, maximumMs )
end
