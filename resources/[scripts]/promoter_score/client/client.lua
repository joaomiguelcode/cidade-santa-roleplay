-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Client = {}
Tunnel.bindInterface("promoter_score",Client)
vSERVER = Tunnel.getInterface("promoter_score")
vKEYBOARD = Proxy.getInterface("keyboard", 'keyboard')
cityName = GetConvar("cityName", "")
REQUEST = Proxy.getInterface("request", 'request')
FinishPromoter = false
local AdminRate = false
local AdminRateInfo = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONFIG QUESTION
-----------------------------------------------------------------------------------------------------------------------------------------
QuestionConfig = {
    ["Admin"] = {
        [1] = _t("admin_question_1"),
        [2] = _t("admin_question_2"),
        [3] = _t("admin_question_3"),
        [4] = _t("admin_question_4"),
        [5] = _t("admin_question_5"),
        [6] = _t("admin_question_6"),
        [7] = _t("admin_question_7"),
        [8] = _t("admin_question_8"),
        [9] = _t("admin_question_9"),
        [10] = _t("admin_question_10"),
    },
    ["Default"] = {
        [1] = _t("default_question_1"),
        [2] = _t("default_question_2"),
        [3] = _t("default_question_3"),
        [4] = _t("default_question_4"),
        [5] = _t("default_question_5"),
        [6] = _t("default_question_6"),
        [7] = _t("default_question_7"),
        [8] = _t("default_question_8"),
        [9] = _t("default_question_9"),
        [10] = _t("default_question_10"),
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local firstActvation = 0
local Timer = GetGameTimer()
function openNui()
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/'
        }
    })
    Wait(1000)
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = 'setVisible',
        data = true
    })
end

RegisterNUICallback('hideFrame', function(_, cb)
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/'
        }
    })
    SendNUIMessage({
        action = "setVisible",
        data = false
    })
    SetNuiFocus(false,false)
    AdminRate = false
    AdminRateInfo = false
end)

-- RegisterNetEvent("promoter_score:Open")
-- AddEventHandler("promoter_score:Open",function(Type)
--     if cityName == "Fronteira" then
--         return
--     end
--     if LocalPlayer["state"]["temporaryBanned"] then
--         return
--     end
--     if LocalPlayer["state"]["Route"] ~= 1 then
--         return
--     end
--     if not Type then
--         firstActivation = 1
--         Timer = GetGameTimer()
--         local Ok = exports["hud"]:Request(_t("rateCity"), 30)
--         if Ok then
--             Wait(100)
--             openNui()
--         else
--             vSERVER.setRate(0,firstActivation,"")
--         end
--     else
--         local Ok = exports["hud"]:Request(_t("rateCity"), 30)
--         if Ok then
--             Wait(100)
--             openNui()
--         else
--             vSERVER.setRate(0,firstActivation,"")
--         end
--     end
-- end)

local CooldownRate = GetGameTimer()
RegisterNUICallback('setRate', function(data, cb)
    if not data then
        return
    end
    local Rate = parseInt(data["rate"])
    local FeedBack = data["feedback"]
    FinishPromoter = true
    if Rate then
        Wait(2000)
        SendNUIMessage({
            action = 'setVisible',
            data = false
        })
        SetNuiFocus(false,false)
        Wait(1000)
        firstActivation = 0
        if parseInt(Rate) == 0 then
            return
        end
        if CooldownRate > GetGameTimer() then
            return
        end
        CooldownRate = GetGameTimer() + 1000*30
        print("setRate",json.encode(data))
        vSERVER.setRate(Rate,firstActivation,FeedBack)
    end
end)

RegisterNUICallback("getCityName",function(Data,Callback)
    cityName = GetConvar("cityName", "")
    Callback(string.lower(cityName))
end)

RegisterNUICallback("setRateAdmin",function(Data,Callback)
    local Rate = parseInt(Data["rate"])
    local FeedBack = Data["feedback"]
    if Rate and FeedBack then
        AdminRateInfo = {Rate = Rate,FeedBack = FeedBack}
        AdminRate = false
    end
    print("setRateAdmin",json.encode(Data))
    Wait(1500)
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/'
        }
    })
    Wait(250)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
    SetNuiFocus(false,false)
end)

function scoreAdmin(TicketID)
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/scoreAdmin',
        }
    })
    Wait(200)
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = 'setVisible',
        data = true
    })
    AdminRate = true
    while AdminRate do
        Wait(1)
    end
    local Info = AdminRateInfo
    if not Info then return end
    if parseInt(Info["Rate"]) == 0 then
        return
    end
    AdminRateInfo = nil
    return Info
end
exports("scoreAdmin",scoreAdmin)

function scoreOrg(TicketID)
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/scoreOrg',
        }
    })
    Wait(200)
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = 'setVisible',
        data = true
    })
    AdminRate = true
    while AdminRate do
        Wait(1)
    end
    local Info = AdminRateInfo
    if not Info then return end
    if parseInt(Info["Rate"]) == 0 then
        return
    end
    AdminRateInfo = nil
    return Info
end
exports("scoreOrg",scoreOrg)


RegisterNUICallback("setRatePlayer",function(Data,Callback)
    local Rate = parseInt(Data["rate"])
    local FeedBack = Data["feedback"]
    if Rate and FeedBack then
        AdminRateInfo = { Rate = Rate, FeedBack = FeedBack }
        AdminRate = false
    end
    print("setRatePlayer",json.encode(Data))
    Wait(1500)
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/'
        }
    })
    Wait(250)
    SendNUIMessage({
        action = 'setVisible',
        data = false
    })
    SetNuiFocus(false,false)
end)

function scorePlayer()
    SendNUIMessage({
        action = 'router',
        data = {
            path = '/scorePlayer',
        }
    })
    Wait(200)
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = 'setVisible',
        data = true
    })
    AdminRate = true
    while AdminRate do
        Wait(1)
    end
    local Info = AdminRateInfo
    if not Info then return end
    if parseInt(Info["Rate"]) == 0 then
        return
    end
    AdminRateInfo = nil
    return Info
end
exports("scorePlayer",scorePlayer)

function Client.RatePlayer()
    local Info = scorePlayer()
    return Info
end

RegisterNUICallback("getQuestion",function(Data,Callback)
    print("getQuestion",json.encode(Data))
    local Rate = parseInt(Data["score"])
    local Mode = Data["mode"]
    if Rate then
        local Question = QuestionConfig[Mode][Rate] or "Explique seu feedback?"
        Callback(Question)
    end
end)
