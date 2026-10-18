local gAudioNuiOpen = false
local gAudioPreviewVolume = 0.3

---@param visible boolean
---@param config table | nil
local function SetAudioNuiVisible(visible, config)

    gAudioNuiOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({ action = "toggle", data = { visible = visible, config = config } })
end

-- Toca pelo playSound do hud (sounds:Private), que abre o link do CDN com new Audio().
---@param url any
---@param volume number
local function PlayAudioUrl(url, volume)

    local normalizedUrl = NormalizeAudioUrl(url)

    if not normalizedUrl then
        sx.logger:warn(('audio_scheduler: refusing to play invalid url=%s'):format(tostring(url)))
        return
    end

    TriggerEvent("sounds:Private", normalizedUrl, volume)
end

RegisterNetEvent("audio_scheduler:open", function(config, volume)

    gAudioPreviewVolume = volume or gAudioPreviewVolume
    SetAudioNuiVisible(true, config)
end)

RegisterNetEvent("audio_scheduler:play", function(url, volume)

    PlayAudioUrl(url, volume)
end)

RegisterNUICallback("hideFrame", function(_, cb)

    gAudioNuiOpen = false
    SetNuiFocus(false, false)
    cb(true)
end)

RegisterNUICallback("getCityName", function(_, cb)

    cb(string.lower(GetConvar("cityName", "")))
end)

RegisterNUICallback("getAvailability", function(data, cb)

    local frequency = type(data) == "table" and data.frequency or nil
    local month = type(data) == "table" and data.month or nil
    local audioType = type(data) == "table" and data.type or nil
    local audience = type(data) == "table" and data.audience or nil
    local world = type(data) == "table" and data.world or nil
    local availability = lib.callback.await("audio_scheduler:getAvailability", false, frequency, month, audioType, audience, world)

    cb(availability or { fullDays = {}, busy = {} })
end)

RegisterNUICallback("scheduleAudio", function(data, cb)

    local ok, message = lib.callback.await("audio_scheduler:schedule", false, data)

    cb({ ok = ok == true, message = message })
end)

-- Raw callback: `items` precisa sair como array JSON mesmo vazio, e o cb comum
-- serializa tabela vazia como objeto
RegisterRawNuiCallback("getSchedules", function(_, cb)

    CreateThread(function()

        local items = lib.callback.await("audio_scheduler:getSchedules", false)

        cb({
            status = 200,
            headers = { ["Content-Type"] = "application/json; charset=utf-8" },
            body = json.encode({ items = items or {} }, { empty_table_as_array = true }),
        })
    end)
end)

RegisterNUICallback("cancelSchedule", function(data, cb)

    local id = type(data) == "table" and data.id or nil
    local ok, message = lib.callback.await("audio_scheduler:cancel", false, id)

    cb({ ok = ok == true, message = message })
end)

RegisterNUICallback("playAudioNow", function(data, cb)

    local ok, message = lib.callback.await("audio_scheduler:playNow", false, data)

    cb({ ok = ok == true, message = message })
end)

-- O hud não expõe como parar o áudio; o preview toca o vídeo até o fim
RegisterNUICallback("previewAudio", function(data, cb)

    if type(data) == "table" then
        PlayAudioUrl(data.url, gAudioPreviewVolume)
    end

    cb({})
end)

RegisterNUICallback("stopPreview", function(_, cb)

    cb({})
end)

AddEventHandler("onResourceStop", function(resourceName)

    if resourceName == GetCurrentResourceName() and gAudioNuiOpen then
        SetNuiFocus(false, false)
    end
end)
