
sx.statQueue = {}
function sx.enqueueStatChange(source, key, value)
    if not sx.statQueue[source] then sx.statQueue[source] = {} end
    sx.statQueue[source][key] = value
end
