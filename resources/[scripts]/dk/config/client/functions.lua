---Caso você utilize a nativa 'OnesyncEnableRemoteAttachmentSanitization'
Config.attachmentSanitization = true

---Bloquear enquanto durar a animação, ativado em loop.
function Config.blockButtons()
    BlockWeaponWheelThisFrame()
    DisableControlAction(0,29,true)
    DisableControlAction(0,38,true)
    DisableControlAction(0,47,true)
    DisableControlAction(0,56,true)
    DisableControlAction(0,57,true)
    DisableControlAction(0,73,true)
    DisableControlAction(0,137,true)
    DisableControlAction(0,161,true)
    DisableControlAction(0,166,true)
    DisableControlAction(0,167,true)
    DisableControlAction(0,169,true)
    DisableControlAction(0,170,true)
    DisableControlAction(0,182,true)
    DisableControlAction(0,187,true)
    DisableControlAction(0,188,true)
    DisableControlAction(0,189,true)
    DisableControlAction(0,190,true)
    DisableControlAction(0,243,true)
    DisableControlAction(0,245,true)
    DisableControlAction(0,257,true)
    DisableControlAction(0,288,true)
    DisableControlAction(0,289,true)
    DisableControlAction(0,311,true)
    DisableControlAction(0,344,true)	
end

---Verificação em client-side para aceitar a animação.
---@return boolean
function Config.acceptCondition() -- (Opcional) Condição para aceitar as animações.
    if (LocalPlayer.state["minigame:active"] == "deathstatue" or LocalPlayer.state["minigame:active"] == "cargame") then
        return false
    end

    return true
end

---Verificação em client-side para enviar a animação.
---@return boolean
function Config.animCondition() -- Condição para iniciar as animações.
    if (LocalPlayer.state["minigame:active"] == "deathstatue" or LocalPlayer.state["minigame:active"] == "cargame") then
        return false
    end

    return GetEntityHealth(PlayerPedId()) > 101
end

---Função custom para sanitização.
---@param bool boolean - Se a sanitização está ativa ou não.
---@param isAttacher boolean - Se o ped é o que iniciou a animação ou o que recebeu a animação.
---@param targetPed number - O ped alvo da animação.
function Config.sanitize(bool, isAttacher, targetPed)
    if not Config.attachmentSanitization then
        return
    end
    if not isAttacher then
        return
    end
    CreateThread(function()
        if bool then
            while GetEntityAttachedTo(targetPed) == 0 do
                Wait(0)
            end
        end
        OnesyncEnableRemoteAttachmentSanitization(bool)
    end)
end