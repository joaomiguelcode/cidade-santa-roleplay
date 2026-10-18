sx.client.visibility = { }

---@type VisibilityManagerHost | nil
gVisibilityManagerHost = nil

---@alias VisibilityOverrideId number

function sx.client.visibility.hasVisibilityOverride()

    return sx.client.visibility.state.hasOverride
end

---@param value boolean
function sx.client.visibility.setHasVisibilityOverride( value )

    sx.client.visibility.state.hasOverride = value
end

---@return VisibilityOverrideId
function sx.client.visibility.beginVisibilityOverride()

    assert( not sx.client.visibility.hasVisibilityOverride(), 'Already has visibility override' )

    sx.client.visibility.setHasVisibilityOverride( true )

    assert( gVisibilityManagerHost == nil, 'Visibility manager host already initialized' )

    gVisibilityManagerHost = CreateVisibilityManagerHost()

    gVisibilityManagerHost:Initialize()

    return -1
end

function sx.client.visibility.endVisibilityOverride()

    assert( sx.client.visibility.hasVisibilityOverride(), 'No visibility override' )

    sx.client.visibility.setHasVisibilityOverride( nil )

    sx.client.visibility.state.excludePlayerIds = nil
end

---@param visibilityOverrideId VisibilityOverrideId unused
---@param playerId number
function sx.client.visibility.addVisibilityOverrideExcludePlayer( visibilityOverrideId, playerId )

    assert( sx.client.visibility.hasVisibilityOverride(), 'No visibility override' )

    assert( GetPlayerServerId( playerId ) ~= -1, ('Player %s is invalid!'):format( playerId ) )

    sx.client.visibility.state.excludePlayerIds = { playerId }
end