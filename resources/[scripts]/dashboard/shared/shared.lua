Debug = {}
Debug.status = false

Debug.print = function(...)
    if not Debug.status then return end
    local info = debug.getinfo(2, "Sl") 
    local side = IsDuplicityVersion() and "SERVER" or "CLIENT"
    local debugMsg = string.format("[%s] %s:%d", side, info.short_src, info.currentline)
    debugMsg = debugMsg:gsub("@", "")
    print(debugMsg, ...)
end