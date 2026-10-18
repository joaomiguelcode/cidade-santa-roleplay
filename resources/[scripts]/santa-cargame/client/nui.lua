if not Config.Enabled then return end

-- Todas as telas do evento (convite, tutorial, sala de espera e rodada) vivem no
-- mesmo namespace `carEvent:*` do front. Nenhuma delas pede foco de NUI: as teclas
-- continuam sendo tratadas no jogo.
local tutorialVisible = false
local tutorialHideToken = 0

RegisterNUICallback("getLang", function(data, cb)
    local name = (type(data) == "table" and data.resourceName)
        or (type(data) == "string" and data)
        or GetCurrentResourceName()
    local targetLang = GetConvar("language", "pt-br")

    local fileUrl = ("locales/frontend-i18n-config/%s/%s.json"):format(targetLang, name)
    local contents = LoadResourceFile("localization", fileUrl)

    if not contents then
        contents = LoadResourceFile(
            "localization",
            ("locales/frontend-i18n-config/en-us/%s.json"):format(name)
        )
    end

    if not contents then
        contents = LoadResourceFile(
            "localization",
            ("locales/frontend-i18n-config/pt-br/%s.json"):format(name)
        )
    end

    cb(contents and json.decode(contents) or {})
end)

---@param payload table
function showCargameAnnounce(payload)
    SendCarEvent("carEvent:announce", payload or {})
end

function clearCargameAnnounceUi()
    SendCarEvent("carEvent:announce:hide", {})
end

---@param payload? table
function showCargameTutorial(payload)
    tutorialVisible = true
    tutorialHideToken = tutorialHideToken + 1
    local hideToken = tutorialHideToken

    SendCarEvent("carEvent:tutorial", payload or {
        name = _t("tutorial_leader_name"),
        text = _t("tutorial_text"),
        skipLabel = _t("tutorial_skip_label"),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    })

    local autoHideSecs = math.max(1, tonumber(Config.TutorialAutoHideSecs) or 15)
    Citizen.SetTimeout(autoHideSecs * 1000, function()
        if tutorialVisible and tutorialHideToken == hideToken then
            hideCargameTutorial()
        end
    end)
end

function hideCargameTutorial()
    tutorialVisible = false
    tutorialHideToken = tutorialHideToken + 1
    SendCarEvent("carEvent:tutorial:hide", {})
end

---@param payload table
function showCargameLobby(payload)
    SendCarEvent("carEvent:lobby", payload or {})
end

---@param payload table
function updateCargameLobby(payload)
    SendCarEvent("carEvent:lobby:update", payload or {})
end

function hideCargameLobby()
    SendCarEvent("carEvent:lobby:hide", {})
end

RegisterNUICallback("carEvent:tutorial:skip", function(_, cb)
    hideCargameTutorial()
    if cb then cb({ ok = true }) end
end)

CargameSetTick(function()
    if not tutorialVisible then return end

    DisableControlAction(0, 22, true)
    if IsDisabledControlJustPressed(0, 22) then
        hideCargameTutorial()
    end
end)
