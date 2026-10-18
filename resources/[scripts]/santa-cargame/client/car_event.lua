if not Config.Enabled then return end

local gCarEventCountdownToken = 0

---Toca um mp3 da contagem (`Config.CountdownSound`) pelo player de audio do `hud`:
---`sounds:Private` aceita URL `http(s)` direto. Respeita quem desligou os sons da HUD.
---@param url? string
local function PlayCountdownSound(url)
    if type(url) ~= "string" or url == "" then return end

    local volume = Config.CountdownSound and tonumber(Config.CountdownSound.Volume) or 0.8
    TriggerEvent("sounds:Private", url, volume)
end

---@param action string
---@param data? table | number | string
function SendCarEvent(action, data)
    SendNUIMessage({
        action = action,
        data = data or {},
    })
end

---@param payload table
function OpenCargameCarEvent(payload)
    SendCarEvent("carEvent:open", payload or {})
end

---@param payload table
function UpdateCargameCarEvent(payload)
    SendCarEvent("carEvent:update", payload or {})
end

---@param payload table
function UpdateCargameCarEventRanking(payload)
    SendCarEvent("carEvent:ranking", payload or {})
end

function HideCargameCarEventCountdown()
    gCarEventCountdownToken = gCarEventCountdownToken + 1
    SendCarEvent("carEvent:countdown:hide", {})
end

function CloseCargameCarEvent()
    HideCargameCarEventCountdown()
    SendCarEvent("carEvent:notify:hide", {})
    SendCarEvent("carEvent:close", {})
end

---@param seconds number
---@param label? string Subtitulo em cima do numero; vai em todo tick porque o NUI troca o payload inteiro.
function RunCargameCarEventCountdown(seconds, label)
    gCarEventCountdownToken = gCarEventCountdownToken + 1
    local token = gCarEventCountdownToken
    local total = math.max(0, math.floor(tonumber(seconds) or 0))

    if total == 0 then return end

    local sound = Config.CountdownSound or {}

    CreateThread(function()
        for value = total, 1, -1 do
            if token ~= gCarEventCountdownToken then return end
            SendCarEvent("carEvent:countdown", { value = value, label = label })
            PlayCountdownSound(sound.TickUrl)
            Wait(1000)
        end

        -- `safeColors`/`gameStarted` costuma chegar junto do 0 e cancelar o GO visual;
        -- o som de largada toca mesmo assim. Cancelado antes do ultimo numero, nao chega aqui.
        PlayCountdownSound(sound.EndUrl)
        if token ~= gCarEventCountdownToken then return end
        -- Sem `label` no GO: o subtitulo so faz sentido enquanto esta contando.
        SendCarEvent("carEvent:countdown", {
            value = "GO",
            displayMs = 1000,
        })
        Wait(1000)

        if token == gCarEventCountdownToken then
            SendCarEvent("carEvent:countdown:hide", {})
        end
    end)
end

RegisterNUICallback("carEvent:exit", function(_, cb)
    if inCargameLobby or gameStarted then
        ExecuteCommand(("eventcargame %s"):format(_t("cmd_leave")))
    end
    if cb then cb({ ok = true }) end
end)

RegisterNUICallback("carEvent:join", function(_, cb)
    ExecuteCommand("cargame.accept")
    if cb then cb({ ok = true }) end
end)

local EXIT_KEY_CONTROLS = {
    g = 47,
}

CargameSetTick(function()
    if not inCargameLobby and not gameStarted then return end

    local exitKey = string.lower(Config.EventHudExitKey or "g")
    local exitControl = EXIT_KEY_CONTROLS[exitKey]
    if exitControl and IsControlJustPressed(0, exitControl) then
        ExecuteCommand(("eventcargame %s"):format(_t("cmd_leave")))
    end
end)
