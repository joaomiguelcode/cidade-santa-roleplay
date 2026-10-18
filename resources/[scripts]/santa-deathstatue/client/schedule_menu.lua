local openScheduleContext

local function scheduleTimeSortKey(value)
    local hour, minute = string.match(value, "^(%d%d):(%d%d)$")
    if not hour then return 0 end
    return tonumber(hour) * 60 + tonumber(minute)
end

local function sortScheduleTimesDescending(times)
    table.sort(times, function(a, b)
        return scheduleTimeSortKey(a) > scheduleTimeSortKey(b)
    end)
end

openScheduleContext = function()
    local ok, times = lib.callback.await("deathstatue:server:getAutoScheduleTimes", false)
    if not ok then
        return
    end

    times = times or {}
    sortScheduleTimesDescending(times)

    local options = {
        {
            title = _t("schedule_add_new"),
            description = _t("schedule_add_label"),
            icon = "plus",
            onSelect = function()
                local input = lib.inputDialog(_t("schedule_add_title"), {
                    {
                        type = "input",
                        label = _t("schedule_add_label"),
                        placeholder = "18:00",
                        required = true,
                    },
                })

                if not input or not input[1] then
                    openScheduleContext()
                    return
                end

                local added, err = lib.callback.await("deathstatue:server:addAutoScheduleTime", false, input[1])
                if added then
                    lib.notify({ description = _t("schedule_added"), type = "success" })
                elseif err == "invalid_format" then
                    lib.notify({ description = _t("schedule_invalid_format"), type = "error" })
                elseif err == "duplicate" then
                    lib.notify({ description = _t("schedule_duplicate"), type = "error" })
                end

                openScheduleContext()
            end,
        },
    }

    if #times == 0 then
        options[#options + 1] = {
            title = _t("schedule_empty"),
            disabled = true,
        }
    end

    for i = 1, #times do
        local scheduleTime = times[i]
        options[#options + 1] = {
            title = scheduleTime,
            description = _t("schedule_remove_hint"),
            icon = "clock",
            onSelect = function()
                local removed = lib.callback.await("deathstatue:server:removeAutoScheduleTime", false, scheduleTime)
                if removed then
                    lib.notify({ description = _t("schedule_removed"), type = "success" })
                end
                openScheduleContext()
            end,
        }
    end

    lib.registerContext({
        id = "deathstatue:schedule_menu",
        title = _t("schedule_menu_title"),
        options = options,
    })
    lib.showContext("deathstatue:schedule_menu")
end

RegisterNetEvent("deathstatue:client:openScheduleMenu", function()
    openScheduleContext()
end)
