SpamDetector = {}
SpamDetector.recentSubmissions = {}

function SpamDetector.IsSpamming(passport)
    local now = GetGameTimer()
    if SpamDetector.recentSubmissions[passport] and (now - SpamDetector.recentSubmissions[passport]) < 5000 then
        return true
    end
    SpamDetector.recentSubmissions[passport] = now
    return false
end
