---Variables
local fps = 60
local fpsSum = 0
local fpsCount = 0
local resetInterval = 60 * 60 * 1000 -- 1 hora
local lastReset = GetGameTimer()
local lastAverageFps = nil

---Thread FPS
CreateThread(function()
    while true do
        local startFps = GetFrameCount()

        Wait(1000)

        local endFps = GetFrameCount()

        fps = endFps - startFps

        fpsSum = fpsSum + fps
        fpsCount = fpsCount + 1

        local now = GetGameTimer()
        if (now - lastReset) >= resetInterval then
            if fpsCount > 0 then
                lastAverageFps = fpsSum / fpsCount
                TriggerServerEvent("player:server:updateAverageFps", math.floor(lastAverageFps))
            end

            fpsSum = 0
            fpsCount = 0
            lastReset = now
        end

        Wait(1000)
    end
end)

exports("Fps", function()
    return fps
end)

exports("LastAverageFps", function()
    return lastAverageFps
end)

exports("CurrentAverageFps", function()
    if fpsCount == 0 then
        return fps
    end

    return fpsSum / fpsCount
end)