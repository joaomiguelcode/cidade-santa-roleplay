local nuiFocusOpen = false
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

RegisterNUICallback("getCityName", function(data, cb)
    local city = (cityName and cityName ~= "" and cityName) or GetConvar("cityName", "Santa")
    cb(city)
end)

RegisterNUICallback("getCityId", function(data, cb)
    local city = (cityName and cityName ~= "" and cityName) or GetConvar("cityName", "Santa")
    cb(city)
end)

local function sendEstatuaNui(action, data)
    SendNUIMessage({
        action = action,
        data = data or {},
    })
end

local function setEstatuaNuiFocus(hasFocus, hasCursor)
    nuiFocusOpen = hasFocus == true
    SetNuiFocus(hasFocus == true, hasCursor == true)
end

function closeEstatuaMortalUi()
    tutorialVisible = false
    tutorialHideToken = tutorialHideToken + 1
    sendEstatuaNui("estatuaMortal:close", {})
    setEstatuaNuiFocus(false, false)
end

function showEstatuaAnnounce(payload)
    sendEstatuaNui("estatuaMortal:announce", payload or {})
end

function clearEstatuaAnnounceUi()
    sendEstatuaNui("estatuaMortal:close", {})
    tutorialVisible = false
    tutorialHideToken = tutorialHideToken + 1
    setEstatuaNuiFocus(false, false)
end

function showEstatuaTutorial(payload)
    tutorialVisible = true
    tutorialHideToken = tutorialHideToken + 1
    local hideToken = tutorialHideToken

    sendEstatuaNui("estatuaMortal:tutorial", payload or {
        name = _t("tutorial_leader_name"),
        text = _t("tutorial_text"),
        exitKey = Config.EventHudExitKey or "G",
        exitLabel = _t("tutorial_exit_label"),
    })

    local autoHideSecs = math.max(1, tonumber(Config.TutorialAutoHideSecs) or 15)
    Citizen.SetTimeout(autoHideSecs * 1000, function()
        if tutorialVisible and tutorialHideToken == hideToken then
            hideEstatuaTutorial()
        end
    end)
end

function hideEstatuaTutorial()
    if not tutorialVisible then
        sendEstatuaNui("estatuaMortal:tutorial:hide", {})
        return
    end

    tutorialVisible = false
    tutorialHideToken = tutorialHideToken + 1
    sendEstatuaNui("estatuaMortal:tutorial:hide", {})
    if nuiFocusOpen then
        setEstatuaNuiFocus(false, false)
    end
end

function showEstatuaLobby(payload)
    sendEstatuaNui("estatuaMortal:lobby", payload or {})
end

function updateEstatuaLobby(payload)
    sendEstatuaNui("estatuaMortal:lobby:update", payload or {})
end

function hideEstatuaLobby()
    sendEstatuaNui("estatuaMortal:lobby:hide", {})
end

function showEstatuaResult(payload)
    tutorialVisible = false
    tutorialHideToken = tutorialHideToken + 1
    sendEstatuaNui("estatuaMortal:result", payload or {})
    setEstatuaNuiFocus(true, true)
end

function hideEstatuaResult()
    sendEstatuaNui("estatuaMortal:result:hide", {})
    setEstatuaNuiFocus(false, false)
end

function showEstatuaRanking(payload)
    tutorialVisible = false
    tutorialHideToken = tutorialHideToken + 1
    sendEstatuaNui("estatuaMortal:ranking", payload or {})
    setEstatuaNuiFocus(true, true)
end

function updateEstatuaRanking(payload)
    sendEstatuaNui("estatuaMortal:ranking:update", payload or {})
end

function hideEstatuaRanking()
    sendEstatuaNui("estatuaMortal:ranking:hide", {})
    setEstatuaNuiFocus(false, false)
end

RegisterNUICallback("estatuaMortal:tutorial:skip", function(_, cb)
    hideEstatuaTutorial()
    if cb then cb("ok") end
end)

RegisterNUICallback("estatuaMortal:exit", function(_, cb)
    hideEstatuaTutorial()
    hideEstatuaLobby()
    setEstatuaNuiFocus(false, false)
    if inDeathStatueLobby or gameStarted or betweenRounds then
        ExecuteCommand(("eventstatua %s"):format(_t("cmd_leave")))
    end
    if cb then cb("ok") end
end)

RegisterNUICallback("estatuaMortal:result:close", function(_, cb)
    closeEstatuaMortalUi()
    if cb then cb("ok") end
end)

RegisterNUICallback("estatuaMortal:ranking:close", function(_, cb)
    hideEstatuaRanking()
    if cb then cb("ok") end
end)

RegisterNUICallback("estatuaMortal:ranking:page", function(data, cb)
    local page = tonumber(data and data.page) or 1
    local payload = lib.callback.await("deathstatue:server:getRankingPage", false, page)
    if type(payload) == "table" then
        updateEstatuaRanking(payload)
    end

    if cb then cb("ok") end
end)

Citizen.CreateThread(function()
    while true do
        if tutorialVisible then
            DisableControlAction(0, 22, true)
            if IsDisabledControlJustPressed(0, 22) then
                hideEstatuaTutorial()
            end

            Citizen.Wait(0)
        else
            Citizen.Wait(400)
        end
    end
end)

AddEventHandler("onResourceStop", function(name)
    if GetCurrentResourceName() ~= name then return end

    if nuiFocusOpen then
        SetNuiFocus(false, false)
    end
end)
