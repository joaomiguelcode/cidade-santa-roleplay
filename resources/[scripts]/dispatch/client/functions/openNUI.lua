---@return void
openNUI = function()
    
    if (LocalPlayer["state"]["minigame:active"] or LocalPlayer["state"]["cargame:joined"]) then
        return
    end

    if exports.dashboard:BlockIfInRestrictWorld() then
        return
    end

    local playerPed = PlayerPedId()
    if GetEntityHealth(playerPed) <= 100 then
        return
    end
    
    if (not hasReceiverGroup()) then
        return
    end

    if (hasBlacklistedGroup()) then
        return
    end

    if (IsPauseMenuActive()) then
        return
    end

    SetNuiFocus(true, true)

    SendNUIMessage(
        {
            action = 'toggleNotificationMenu',
            data = true
        }
    )
end

-- Fecha o dispatch se o player entrar em minigame (ex: santa-cargame) com o menu aberto
AddStateBagChangeHandler('minigame:active', ('player:%d'):format(GetPlayerServerId(PlayerId())), function(_, _, value)
    if value then
        closeNUI()
    end
end)

RegisterCommand('dispatch', openNUI)
RegisterKeyMapping('dispatch', 'Dispatch menu', 'keyboard', 'F2')