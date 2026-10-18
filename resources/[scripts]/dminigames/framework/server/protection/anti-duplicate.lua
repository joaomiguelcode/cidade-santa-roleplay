AntiDuplicate = {}
local activeTickets = {}

function AntiDuplicate.Check(passport, actionKey)
    local key = ('%s:%s'):format(passport, actionKey)
    if activeTickets[key] and (GetGameTimer() - activeTickets[key]) < 2000 then
        return false
    end
    activeTickets[key] = GetGameTimer()
    return true
end
