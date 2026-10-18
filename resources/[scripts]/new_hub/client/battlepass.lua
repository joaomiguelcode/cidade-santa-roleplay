local ShouldCheckBattlepass = false
local StartTime = GetGameTimer()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACK
-----------------------------------------------------------------------------------------------------------------------------------------
local IsRedeeming = false
RegisterNUICallback("redeemBattlePass",function(Data,Callback)
    if IsRedeeming then
        Callback(false)
        return
    end
    IsRedeeming = true
    local Success = vSERVER.RedeemBattlePass(Data.id,Data.type)
    IsRedeeming = false
    Callback(Success)
end)

RegisterNUICallback("buyBattlePass",function(Data,Callback)
    local url = BattlePassLink[cityName]
    if url and url ~= "" then
        TriggerEvent("player:OpenURL",url)
    else
        TriggerEvent("player:OpenURL",StoreLink[cityName])
    end
    Callback(true)
end)

local gIsRewardSessionActive = false
local gBattlepassSessionDurationSeconds = 0

local function InitBattlepassRewardSession()

    gIsRewardSessionActive = true

    ---@type number | nil
    local lastSessionDuration = GetResourceKvpInt( 'battlepass_reward_session_duration' )

    print( 'lastSessionDuration', lastSessionDuration )

    gBattlepassSessionDurationSeconds = lastSessionDuration or 0
end

local function SaveBattlepassRewardSession()

    SetResourceKvpIntNoSync( 'battlepass_reward_session_duration', gBattlepassSessionDurationSeconds )
end

CreateThread(
    function()

        while true do

            Wait( 1000 )

            gBattlepassSessionDurationSeconds += 1

            -- print( 'gBattlepassSessionDurationSeconds', gBattlepassSessionDurationSeconds )

            if gBattlepassSessionDurationSeconds == 3600 then

                print( 'ask for reward' )

                vSERVER.AskForReward()

                gBattlepassSessionDurationSeconds = 0
            end

            SaveBattlepassRewardSession()
        end
    end
)

RegisterNetEvent( 'hub.battlepass.init_reward_session', function()

    InitBattlepassRewardSession()
end)

RegisterNetEvent( 'hub.battlepass.reset_reward_session', function()

    gBattlepassSessionDurationSeconds = 0
    gIsRewardSessionActive = true

    SaveBattlepassRewardSession()
end)

RegisterNUICallback("getBattlePassConfig",function(Data,Callback)
    vSERVER.RefreshAvailablePass()

    local remainingSecondsTillSessionReward = 3600 - gBattlepassSessionDurationSeconds
    if not ShouldCheckBattlepass then
        remainingSecondsTillSessionReward = 0
    end
    local Info = {
        free = BattlePassRewards["Free"],
        premium = BattlePassRewards["Premium"],
        timer = BattlePassRewards["Timer"],
        -- TODO: Melhorar, timer vai resetar ao reiniciar o script, usar timetracker?
        nextLevelTimer = remainingSecondsTillSessionReward,
        nextLevelTimerMax = 0,
    }
    -- print("[DEBUG] - getBattlePassConfig", json.encode(Info, {indent = true}))
    Callback(Info)
end)

RegisterNUICallback("getBattlePassInfo",function(Data,Callback)
    local Info = GlobalState["battlepass_info"] or {}
    Info.smallimage = Info.smallimage or Info.image
    Callback(Info)
end)


RegisterNUICallback("openProfile",function(Data,Callback)
    exports['radialmenu']:openProfile(PlayerPedId(), false)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
---@param startTime int
---@param currentTime int
---@return boolean
function CheckTimePlayed(startTime,currentTime)
    local TimePlayed = currentTime - startTime
    TimePlayed = math.floor(TimePlayed / 1000)
    if TimePlayed >= 3600 then
        return true
    else
        return false
    end
end

function TimeLeft(startTime,currentTime)
    local TimePlayed = currentTime - startTime
    TimePlayed = math.floor(TimePlayed / 1000)
    local TimeLeft = 3600 - TimePlayed
    if not ShouldCheckBattlepass then
        return 0
    end
    if TimeLeft <= 0 then
        return 0
    end
    return TimeLeft
end

RegisterNetEvent("battlepass:removeCheckTimePlayed",function()
    ShouldCheckBattlepass = false
end)