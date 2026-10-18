RegisterNuiCallback('tutorialAccepted', function(data, cb)
    if (data.accepted) then
        tutorial:start()
        TriggerServerEvent("spawn:acceptTutorial")
    else
        tutorial:setVisible(false)
        TriggerServerEvent("spawn:refuseTutorial")
    end
    cb(data.accepted)
end)

cityName = GetConvar("cityName", "")

RegisterNUICallback("getCityName",function(Data,Callback)
    -- print('cityName', cityName)
    Callback(cityName)
end)

RegisterNUICallback("getCityId",function(Data,Callback)
    -- print('cityName', cityName)
    Callback(cityName or "")
end)


RegisterNUICallback('getServerHost', function(Data, Callback)
    local api_url = GetConvar("api_url", "")
    -- print("[DEBUG] - GET SERVER HOST, api_url: " .. api_url)
    Callback(api_url)
end)

requestTutorial = function(source)
    setVisible(true)
end

exports('requestTutorial', requestTutorial)

---@param id tutorial.ui.TutorialId
local function CanStartUiTutorial(id)
    return lib.callback.await('net.tutorial.ui.can-start-tutorial', false, id)
end

---@param id tutorial.ui.TutorialId
local function SendFinishedUiTutorial(id)
    TriggerServerEvent('net.tutorial.ui.finish-tutorial', id)
    RemoveTutorialWaypoints(id)
end

exports('CanStartUiTutorial', CanStartUiTutorial)
exports('SendFinishedUiTutorial', SendFinishedUiTutorial)