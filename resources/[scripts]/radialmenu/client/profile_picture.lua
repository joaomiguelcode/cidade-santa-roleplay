local gProfilePictureServer = module("vrp", "lib/Tunnel").getInterface("radialmenu:profilePicture")
local gProfilePictureSessionId = nil
local gProfilePictureOpenData = nil
local gProfilePictureNuiReady = false

---@param sessionId string
local function CloseProfilePicture(sessionId)

    if gProfilePictureSessionId ~= sessionId then
        return
    end

    gProfilePictureSessionId = nil
    gProfilePictureOpenData = nil
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetNuiZindex(88888)
    SendNUIMessage({ action = "profilePicture:close", data = { sessionId = sessionId } })
end

local function ShowProfilePicture()

    if not gProfilePictureNuiReady or not gProfilePictureOpenData then
        return
    end

    game.hideRadial()
    closeProfile()
    SetNuiZindex(9999999)
    SetNuiFocusKeepInput(false)
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "profilePicture:open", data = gProfilePictureOpenData })
end

RegisterNetEvent("radialmenu:profilePictureOpen", function(data)

    if gProfilePictureSessionId then
        CloseProfilePicture(gProfilePictureSessionId)
    end

    gProfilePictureSessionId = data.sessionId
    gProfilePictureOpenData = data
    ShowProfilePicture()
end)

RegisterNUICallback("profilePictureReady", function(_, cb)

    gProfilePictureNuiReady = true
    ShowProfilePicture()
    cb({ ok = true })
end)

RegisterNetEvent("radialmenu:profilePictureClose", function(sessionId)

    CloseProfilePicture(sessionId)
end)

RegisterNetEvent("radialmenu:profilePictureError", function(errorCode)

    local language = GetConvar("language", "pt-br")
    local path = ("locales/frontend-i18n-config/%s/radialmenu.json"):format(language)
    local contents = LoadResourceFile("localization", path)
        or LoadResourceFile("localization", "locales/frontend-i18n-config/pt-br/radialmenu.json")
    local ok, locale = pcall(json.decode, contents or "")
    local errors = ok and locale and locale.profilePicture and locale.profilePicture.saveErrors
    local message = errors and (errors[errorCode] or errors["unavailable"])

    if message then
        TriggerEvent("Notify", "vermelho", message, 5000)
    else
        sx.logger:error(("ProfilePicture: missing localization for error=%s language=%s"):format(tostring(errorCode), language))
    end
end)

RegisterNetEvent("radialmenu:profilePictureChanged", function(passport, avatar)

    SendNUIMessage({ action = "profilePicture:changed", data = { passport = passport, avatar = avatar } })
end)

RegisterNUICallback("profilePictureClose", function(data, cb)

    if type(data) == "table" and data.sessionId == gProfilePictureSessionId then
        CloseProfilePicture(data.sessionId)
        gProfilePictureServer._CloseProfilePicture(data.sessionId)
    end

    cb({ ok = true })
end)

RegisterNUICallback("profilePictureSave", function(data, cb)

    if type(data) ~= "table" or not gProfilePictureSessionId or data.sessionId ~= gProfilePictureSessionId then
        cb({ ok = false, error = "invalid-session" })
        return
    end

    local ok, result = pcall(gProfilePictureServer.SaveProfilePicture, data.sessionId, data.url, data.useDefault)
    cb(ok and result or { ok = false, error = "save-failed" })
end)

AddEventHandler("onResourceStop", function(resourceName)

    if resourceName == GetCurrentResourceName() and gProfilePictureSessionId then
        CloseProfilePicture(gProfilePictureSessionId)
    end
end)
