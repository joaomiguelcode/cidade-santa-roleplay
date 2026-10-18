LockManager = {}
LockManager.activeLocks = {}

function LockManager.Acquire(key, durationMs)
    if LockManager.activeLocks[key] and LockManager.activeLocks[key] > GetGameTimer() then
        return false
    end
    LockManager.activeLocks[key] = GetGameTimer() + (durationMs or 5000)
    return true
end

function LockManager.Release(key)
    LockManager.activeLocks[key] = nil
end
