---@type number
local TIME_STARTED_COUNTING_TIME_IN_PLAYTIME_SOCIAL_AREA = 0

---@type number
local TIME_VALID_IN_PLAYTIME_SOCIAL_AREA = ( 60000 * 60 )

local function HasReachedSocialAreaPlaytimeThreshold()
    local time = GetNetworkTimeAccurate() - TIME_STARTED_COUNTING_TIME_IN_PLAYTIME_SOCIAL_AREA

    return time > TIME_VALID_IN_PLAYTIME_SOCIAL_AREA
end

function StartCountTimeInPlayerPlaytimeSocialArea()
    TIME_STARTED_COUNTING_TIME_IN_PLAYTIME_SOCIAL_AREA = GetNetworkTimeAccurate()
end

function EndCountTimeInPlayerPlaytimeSocialArea()

    if
        HasReachedSocialAreaPlaytimeThreshold() 
    then

        --[[

            INFO: Player entrou na área social e passou o tempo limite ?
                Vamos capturar o evento!
        
            - @TkzDev
        ]]

        TriggerServerEvent( 'net.player.playtime_socialarea' )
    end

    TIME_STARTED_COUNTING_TIME_IN_PLAYTIME_SOCIAL_AREA = 0
end