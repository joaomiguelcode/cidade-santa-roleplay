local hintUISettings = require 'config'
local currentDescription = ""
local isOpenNui = false
local forceClose = false
local canPlayerDismiss = true

--- @param action string
--- @param data any
local function nuiMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

--- @param desc string
--- @param title? string
--- @param force? boolean
--- @param hideClose? boolean When true, hides the close hint and prevents the player from dismissing it
function Show(desc, title, force, hideClose)
    if forceClose then
        if force then
            forceClose = false
        else
            return
        end
    end

    canPlayerDismiss = not hideClose

	nuiMessage('show', {
        desc = desc,
        title = title or hintUISettings.title,
        hideClose = hideClose or false,
    })

    if canPlayerDismiss then
        nuiMessage('updateTextClose', { text = _t('close.hint.text') })
    end

    currentDescription = desc
	isOpenNui = true
end

exports('Show', Show)

--- @param desc string
--- @param title? string
function UpdateText(desc, title)
    nuiMessage('updateText', {desc = desc, title = title or hintUISettings.title})
    currentDescription = desc
end
exports('UpdateText', UpdateText)

function Hide(force)
	nuiMessage('hide')
    currentDescription = ""
    isOpenNui = false
    canPlayerDismiss = true
    forceClose = force or false
end

exports('Hide', Hide)

function isOpen()
    return isOpenNui
end

exports('isOpen', isOpen)

function currentText()
    return currentDescription
end

exports('currentText', currentText)

local keybind = lib.addKeybind({
    name = hintUISettings.hide.name,
    description = hintUISettings.hide.description,
    defaultKey = hintUISettings.hide.defaultKey,
    onPressed = function()
        if not isOpenNui or not canPlayerDismiss then return end
        Hide(true)
    end
})

if hintUISettings.testCommand.status then
    RegisterCommand(hintUISettings.testCommand.name, function()
        Show(hintUISettings.testCommand.description, 'Test title')
    end)
end

-- CreateThread(function()
--     Wait(500)
--     exports['hint']:Show("Teste", "Dicas")
-- end)