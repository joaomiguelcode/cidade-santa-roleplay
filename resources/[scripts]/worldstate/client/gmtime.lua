local DAYSPERYEAR = 365
local DAYSPER4YEARS = (4*DAYSPERYEAR+1)
local DAYSPER100YEARS = (25*DAYSPER4YEARS-1)
local DAYSPER400YEARS = (4*DAYSPER100YEARS+1)
local SECONDSPERDAY = (24*60*60)
local SECONDSPERHOUR = (60*60)
local LEAPDAY = 59

local DIFFTIME = 0x19db1ded53e8000
local DIFFDAYS = (3 * DAYSPER100YEARS + 17 * DAYSPER4YEARS + 1 * DAYSPERYEAR)

local g_lpmonthdays = {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}

local g_monthdays = {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365}

---@param days number
---@return number
function leapyears_passed( days )

    local quadcenturies = math.floor(days / DAYSPER400YEARS)
    days = days - quadcenturies
    local centuries = math.floor(days / DAYSPER100YEARS)
    days = days + centuries
    local quadyears = math.floor(days / DAYSPER4YEARS)
    return quadyears - centuries + quadcenturies
end

---@param days number
function leapdays_passed( days )
    return leapyears_passed(days + DAYSPERYEAR - LEAPDAY + 1)
end

---@param time number
function gm_time( time )

    if time < 0 then
        return 0
    end

    local days = math.floor(time / SECONDSPERDAY)
    local secondinday = time % SECONDSPERDAY

    days = days + DIFFDAYS

    local leapdays = leapdays_passed(days)
    local leapyears = leapyears_passed(days)

    local padays
    if leapdays > leapyears then
        padays = g_lpmonthdays
    else
        padays = g_monthdays
    end

    local years = math.floor((days - leapdays) / 365)

    local ptm = { }
    ptm.tm_year = years - 299

    local daystoyear = years * 365 + leapyears
    local dayinyear = days - daystoyear

    ptm.tm_isdst = 0

    -- We dont use that, so lets ignore it for now as it requires some more code!
    --[[
    if do_dst then
        local yeartime = dayinyear * SECONDSPERDAY + secondinday
        if yeartime >= dst_begin and yeartime <= dst_end then
            time = time - _dstbias
            days = math.floor(time / SECONDSPERDAY + DIFFDAYS)
            dayinyear = days - daystoyear
            ptm.tm_isdst = 1
        end
    end
    --]]

    ptm.tm_yday = dayinyear

    local month = 0
    while dayinyear >= padays[month+1] do
        month = month + 1
    end

    ptm.tm_mon = month
    ptm.tm_mday = 1 + dayinyear - padays[month]
    ptm.tm_wday = (days + 1) % 7

    local secondinhour = secondinday % SECONDSPERHOUR
    ptm.tm_hour = math.floor(secondinday / SECONDSPERHOUR)
    ptm.tm_min = math.floor(secondinhour / 60)
    ptm.tm_sec = secondinhour % 60

    return ptm
end