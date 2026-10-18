PlaytimeTracker = {}
local OnlineSessions = {}

RegisterNetEvent('new_hub:startSession', function()
    local src = source
    OnlineSessions[src] = os.time()
end)

AddEventHandler('playerDropped', function()
    local src = source
    OnlineSessions[src] = nil
end)
