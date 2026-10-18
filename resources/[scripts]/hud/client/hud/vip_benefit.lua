local allowedCommands = {
    rgbc = true,
    barbershop = true,
    attachs = true,
    kit = true,
    customspawn = true
}

local activeCommand

local function closeBenefit(releaseFocus)
    if not activeCommand then return end
    activeCommand = nil
    SendNUIMessage({ action = "vipBenefit:close" })
    if releaseFocus then
        SetNuiFocus(false, false)
    end
end

RegisterNetEvent("hud:vipBenefit:open", function(command)
    if type(command) ~= "string" or not allowedCommands[command] then return end
    if IsPauseMenuActive() or (IsNuiFocused() and not activeCommand) then return end
    TriggerEvent("ui:exclusiveModalOpened")
    activeCommand = command
    SendNUIMessage({ action = "vipBenefit:open", data = { command = "/" .. command } })
    SetNuiFocus(true, true)
end)

RegisterNUICallback("vipBenefit:cancel", function(_, cb)
    closeBenefit(true)
    cb({ success = true })
end)

RegisterNUICallback("vipBenefit:store", function(_, cb)
    if not activeCommand or GetResourceState("new_hub") ~= "started" then
        cb({ success = false })
        return
    end
    SetNuiFocus(false, false)
    local ok, opened = pcall(function()
        return exports.new_hub:OpenVipStore()
    end)
    if not ok or opened ~= true then
        if activeCommand then SetNuiFocus(true, true) end
        cb({ success = false })
        return
    end
    closeBenefit(false)
    cb({ success = true })
end)

AddEventHandler("ui:exclusiveModalOpened", function()
    closeBenefit(true)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        closeBenefit(true)
    end
end)
