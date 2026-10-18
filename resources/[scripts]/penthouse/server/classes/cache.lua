PenthouseCache = PenthouseCache or {}
PenthouseCache.properties = {}
PenthouseCache.activeBuckets = {}

function PenthouseCache.Get(propertyId)
    return PenthouseCache.properties[propertyId]
end

function PenthouseCache.Set(propertyId, data)
    PenthouseCache.properties[propertyId] = data
end
