ChatHelper = {}

function ChatHelper.setDisable()
    TriggerEvent("chat:DisablePreview",true)
end

function ChatHelper.setEnable()
    TriggerEvent("chat:DisablePreview",false)
end