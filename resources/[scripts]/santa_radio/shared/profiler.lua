---@param scope string
---@return boolean
function SantaRadioProfilerEnter( scope )

    local enabled = PROFILER_RECORDING_STATE == true

    if enabled then
        ProfilerEnterScope( scope )
    end

    return enabled
end

---@param enabled boolean
function SantaRadioProfilerExit( enabled )

    if enabled then
        ProfilerExitScope()
    end
end
