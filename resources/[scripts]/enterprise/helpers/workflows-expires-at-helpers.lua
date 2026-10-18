-- workflow expiration helpers
WorkflowHelpers = {}

function WorkflowHelpers.CalculateExpiration(hours)
    return os.time() + (hours * 3600)
end

function WorkflowHelpers.IsExpired(timestamp)
    return os.time() > timestamp
end
