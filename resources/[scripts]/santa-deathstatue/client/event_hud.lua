local eventHudVisible = false
local countdownToken = 0
lightSoundsEnabled = true

local function sendEventHud(action, data)
    SendNUIMessage({
        action = action,
        data = data or {},
    })
end

function hideDeathStatueEventHudLight()
    if not eventHudVisible then return end

    sendEventHud("updateEventHud", { light = "invisible" })
end

function getDeathStatueTotalRounds()
    local rounds = Config.Rounds
    if not rounds then return 0 end

    local n = 0
    for i = 1, 100 do
        if not rounds[i] then break end
        n = i
    end

    return n
end

function getDeathStatueSoundHintPayload()
    return {
        soundKey = Config.EventHudSoundKey or "H",
        soundLabel = lightSoundsEnabled and _t("sound_mute_label") or _t("sound_unmute_label"),
    }
end

function syncDeathStatueSoundHint()
    if not eventHudVisible then return end
    updateDeathStatueEventHud(getDeathStatueSoundHintPayload())
end

function resetDeathStatueLightSounds()
    lightSoundsEnabled = true
end

function openDeathStatueEventHud(payload)
    eventHudVisible = true
    local data = payload or {}
    local soundHint = getDeathStatueSoundHintPayload()
    if data.soundKey == nil then
        data.soundKey = soundHint.soundKey
    end
    if data.soundLabel == nil then
        data.soundLabel = soundHint.soundLabel
    end
    sendEventHud("openEventHud", data)
end

function updateDeathStatueEventHud(payload)
    if not eventHudVisible then return end

    sendEventHud("updateEventHud", payload)
end

function closeDeathStatueEventHud()
    eventHudVisible = false
    hideDeathStatueEventHudCountdown()
    sendEventHud("closeEventHud", {})
end

function showDeathStatueEventHudCountdown(value)
    sendEventHud("showEventHudCountdown", value)
end

function hideDeathStatueEventHudCountdown()
    sendEventHud("hideEventHudCountdown", {})
end

function runDeathStatueEventHudCountdown(seconds)
    local token = countdownToken + 1
    countdownToken = token
    local total = tonumber(seconds) or 0
    if total <= 0 then return end

    Citizen.CreateThread(function()
        for i = total, 1, -1 do
            if countdownToken ~= token then return end

            showDeathStatueEventHudCountdown(i)
            Citizen.Wait(1000)
        end

        if countdownToken ~= token then return end

        showDeathStatueEventHudCountdown({ value = "GO", displayMs = 1200 })
        Citizen.Wait(1200)

        if countdownToken ~= token then return end

        hideDeathStatueEventHudCountdown()
    end)
end

function buildDeathStatueEventHudBase()
    local soundHint = getDeathStatueSoundHintPayload()
    return {
        totalRounds = getDeathStatueTotalRounds(),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
        soundKey = soundHint.soundKey,
        soundLabel = soundHint.soundLabel,
    }
end

RegisterNUICallback("eventHud:exit", function(_, cb)
    if inDeathStatueLobby or gameStarted or betweenRounds then
        ExecuteCommand(("eventstatua %s"):format(_t("cmd_leave")))
    end
    if cb then cb({ ok = true }) end
end)

local EXIT_KEY_CONTROLS = {
    g = 47,
}

local SOUND_KEY_CONTROLS = {
    h = 74,
}

local function toggleDeathStatueLightSounds()
    lightSoundsEnabled = not lightSoundsEnabled
    if not lightSoundsEnabled then
        SendNUIMessage({
            action = "deathstatue:stopLightSound",
            data = {},
        })
    end
    syncDeathStatueSoundHint()
end

Citizen.CreateThread(function()
    while true do
        if inDeathStatueLobby or gameStarted or betweenRounds then
            local exitKey = string.lower(Config.EventHudExitKey or "g")
            local exitControl = EXIT_KEY_CONTROLS[exitKey]
            if exitControl and IsControlJustPressed(0, exitControl) then
                ExecuteCommand(("eventstatua %s"):format(_t("cmd_leave")))
            end

            local soundKey = string.lower(Config.EventHudSoundKey or "h")
            local soundControl = SOUND_KEY_CONTROLS[soundKey]
            if soundControl and IsControlJustPressed(0, soundControl) then
                toggleDeathStatueLightSounds()
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)
