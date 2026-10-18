-- character-creator session server-side
CreatorSessions = {}

function StartCreatorSession(source, passport)
    CreatorSessions[source] = {
        source = source,
        passport = passport,
        startedAt = GetGameTimer(),
        bucket = 8000 + source
    }
    SetPlayerRoutingBucket(source, CreatorSessions[source].bucket)
end

function EndCreatorSession(source)
    CreatorSessions[source] = nil
    SetPlayerRoutingBucket(source, 0)
end
