local PVP_DAY_CLOCK_HOUR = 12

function PvpApplyDayClock()
    if GetResourceState( 'worldstate' ) ~= 'started' then return end

    exports['worldstate']:SetWorldClockOverride( PVP_DAY_CLOCK_HOUR )
end
