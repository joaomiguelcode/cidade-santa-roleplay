local whatsappPhone = nil
local whatsappCode = nil
local whatsappNotValidated = false

-- New QR flow state — tracked separately from the legacy SMS-code flow so the
-- two can coexist while we migrate consumers.
local phoneNotValidated = false
local phoneVerificationModalOpen = false
local gSantaAppBindModalOpen = false
local gSantaAppBindCompleted = false

RegisterNetEvent("register:openapp", function()

    TriggerServerEvent("register:requestSantaAppBind")
end)

RegisterNetEvent("register:openSantaAppBind", function(qrPayload)

    if not qrPayload or qrPayload == "" then
        sx.logger:warn("register: Santa App bind opened without QR payload")
        TriggerServerEvent("register:finishSantaAppBind")
        return
    end

    gSantaAppBindModalOpen = true
    gSantaAppBindCompleted = false
    SendNUIMessage({ action = "openNewWhatsapp", data = { qrLink = qrPayload } })
    SetNuiFocus(true, true)
end)

RegisterNetEvent("register:openWhatsapp", function()
    SendNUIMessage({
        action = "openWhatsapp"
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("validateWhatsapp", function(data, cb)
    local response = false
    
    if data.whatsapp then
        whatsappPhone = data.whatsapp

        response, code = vSERVER.ValidateWhatsapp(data.whatsapp)
        if response then
            whatsappCode = code
        end
    elseif data.code then
        response = tonumber(data.code) == whatsappCode
        if response then
            TriggerServerEvent("register:updateWhatsapp", whatsappPhone)
        end
    end

    print("validateWhatsapp response", response)

    cb(response)
end)

RegisterNUICallback("closePhoneVerification", function(data, cb)
    SendNUIMessage({
        action = "close"
    })

    SetNuiFocus(false, false)

    cb("ok")
end)

RegisterNetEvent("register:updateWhatsappStatus", function(status)
    whatsappNotValidated = status
end)

function isWhatsappValidated()
    if CitiesWithWhatsappValidation[cityName] then
        return whatsappNotValidated
    end
    
    return false
end
exports("isWhatsappValidated", isWhatsappValidated)

exports("NeedToValidateWhatsapp", function()
    if not CitiesWithWhatsappValidation[cityName] then
        return false, "city_not_found"
    end

    if discordNotValidated then
        return false, "discord_not_validated"
    end

    if exports.player:GetProtectionStatus() then
        return false, "protection_active"
    end

    if not whatsappNotValidated then
        return false, "whatsapp_already_validated"
    end
    
    return true
end)

-- RegisterCommand("testewhatsapp", function()
--     local needToValidate, reason = NeedToValidateWhatsapp()
--     if not needToValidate then
--         print("Não precisa validar o whatsapp: " .. reason)
--         return
--     end

--     TriggerEvent("register:openWhatsapp")
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NEW PHONE LINKING FLOW (QR via external site)
-- Fired from the garage gate (and any future consumer) instead of the legacy
-- SMS flow. Server decides whether the player needs to validate; client is
-- just a dumb bridge into the React NUI.
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNetEvent("register:updatePhoneStatus", function(status)
    phoneNotValidated = status and true or false
end)

RegisterNetEvent("register:openNewWhatsappValidation", function(qrUrl)
    if not qrUrl or qrUrl == "" then
        print("[whatsapp] openNewWhatsappValidation received without URL")
        TriggerEvent("register:phoneModalClosed", false)
        return
    end

    phoneVerificationModalOpen = true

    SendNUIMessage({
        action = "openNewWhatsapp",
        data = { qrLink = qrUrl }
    })
    SetNuiFocus(true, true)
end)

-- Emitted by server when the player is already validated or the session
-- couldn't be created. Same outcome either way: release whatever gate was
-- waiting on the modal.
RegisterNetEvent("register:phoneValidationSkipped", function()
    if phoneVerificationModalOpen then
        phoneVerificationModalOpen = false
        SendNUIMessage({ action = "close" })
        SetNuiFocus(false, false)
    end
    TriggerEvent("register:phoneModalClosed", false)
end)

-- Reused by the React modal's "X" button and the success step's auto-close.
-- Also fires the local event that the garage gate listens for so the
-- pending garage opens regardless of verification outcome.
RegisterNUICallback("closeNewWhatsapp", function(data, cb)
    local wasValidated = data and data.validated and true or false

    if gSantaAppBindModalOpen then
        gSantaAppBindModalOpen = false
        TriggerServerEvent("register:finishSantaAppBind")
        SendNUIMessage({ action = "close" })
        SetNuiFocus(false, false)
        cb("ok")
        return
    end

    phoneVerificationModalOpen = false

    SendNUIMessage({ action = "close" })
    SetNuiFocus(false, false)

    TriggerEvent("register:phoneModalClosed", wasValidated)

    cb("ok")
end)

-- Mirrors validateNewDiscord: the "Liberar Acesso" button asks whether the
-- player finished the phone verification on the site. We first trust the
-- local cache (updated by register:phoneVerificationSuccess fanout from the
-- webhook), then fall back to a server query so the first click right after
-- a verification doesn't show a spurious "Vínculo não encontrado".
-- pcall around vSERVER so a tunnel failure can't leave the React button
-- stuck on "Validando..." — cb must always fire exactly once.
RegisterNUICallback("validateNewWhatsapp", function(data, cb)
    if gSantaAppBindModalOpen then
        local ok, verified = pcall(function()
            return vSERVER.refreshSantaAppBindStatus()
        end)
        gSantaAppBindCompleted = ok and verified and true or false
        cb(gSantaAppBindCompleted)
        return
    end

    if not phoneNotValidated then
        cb(true)
        phoneVerificationModalOpen = false
        SendNUIMessage({ action = "close" })
        SetNuiFocus(false, false)
        TriggerEvent("register:phoneModalClosed", true)
        return
    end

    local ok, serverVerified = pcall(function()
        return vSERVER.refreshPhoneLinkStatus()
    end)

    if not ok then
        print("[whatsapp] refreshPhoneLinkStatus errored:", serverVerified)
        cb(false)
        return
    end

    if serverVerified then
        phoneNotValidated = false
        cb(true)
        phoneVerificationModalOpen = false
        SendNUIMessage({ action = "close" })
        SetNuiFocus(false, false)
        TriggerEvent("register:phoneModalClosed", true)
        return
    end

    cb(false)
end)

-- When the webhook confirms verification (client.lua already forwards
-- register:phoneVerificationSuccess → NUI qrVerificationSuccess), flip the
-- local cache. The modal's success step will then auto-close and trigger the
-- callback above.
RegisterNetEvent("register:phoneVerificationSuccess", function()
    phoneNotValidated = false
end)

---Whether the garage gate (or any other consumer) should show the phone
---verification modal. False while the modal is already open so the gate
---doesn't re-request a new session on a double-interact.
exports("NeedToValidatePhone", function()
    return phoneNotValidated and not phoneVerificationModalOpen
end)

exports("IsPhoneVerificationModalOpen", function()
    return phoneVerificationModalOpen
end)

CreateThread(function()
    while true do
        if gSantaAppBindModalOpen and not gSantaAppBindCompleted then
            local ok, verified = pcall(function()
                return vSERVER.refreshSantaAppBindStatus()
            end)
            if ok and verified then
                gSantaAppBindCompleted = true
                SendNUIMessage({ action = "qrVerificationSuccess", data = { success = true } })
            end
        end
        Wait(gSantaAppBindModalOpen and 2000 or 1000)
    end
end)
