local ROOT_MENU_ID = "admin.protid.root"
local LIST_MENU_ID = "admin.protid.list"
local ENTRY_MENU_ID = "admin.protid.entry"
local ACTIONS_MENU_ID = "admin.protid.actions"

local gProtIdCityName = ""
local gProtIdActionList = {}
local gProtIdNotifyActions = {}
local gProtIdEntries = {}
local gProtIdEditPassport = nil
local gProtIdEditSelected = {}
local gProtIdActionsBackMenu = ROOT_MENU_ID

local function CanActionShowNotify(action)
    return gProtIdNotifyActions[action] == true
end

local function FormatActionsDescription(actions)
    if type(actions) ~= "table" then
        return _t("protid.actions.none")
    end

    local parts = {}
    for i = 1, #gProtIdActionList do
        local action = gProtIdActionList[i]
        local config = actions[action]
        if config then
            parts[#parts + 1] = _t("protid.actions.summary_notify"):format(action)
        end
    end

    if #parts == 0 then
        return _t("protid.actions.none")
    end

    if #parts == #gProtIdActionList then
        return _t("protid.actions.all")
    end

    return table.concat(parts, ", ")
end

local function ActionsToSelectedMap(actions)
    local selected = {}

    if actions == true then
        for i = 1, #gProtIdActionList do
            local action = gProtIdActionList[i]
            selected[action] = { notify = CanActionShowNotify(action) }
        end
        return selected
    end

    if type(actions) ~= "table" then
        return selected
    end

    if actions[1] ~= nil then
        for _, action in ipairs(actions) do
            if type(action) == "string" then
                selected[action] = { notify = CanActionShowNotify(action) }
            end
        end
        return selected
    end

    for action in pairs(actions) do
        selected[action] = { notify = CanActionShowNotify(action) }
    end

    return selected
end

local function CountSelectedActions()
    local count = 0
    for i = 1, #gProtIdActionList do
        if gProtIdEditSelected[gProtIdActionList[i]] then
            count = count + 1
        end
    end
    return count
end

local function AreAllActionsSelected()
    return CountSelectedActions() == #gProtIdActionList
end

local function SelectedMapToActionsPayload()
    local payload = {}
    local count = 0
    for i = 1, #gProtIdActionList do
        local action = gProtIdActionList[i]
        local config = gProtIdEditSelected[action]
        if config then
            payload[action] = {
                notify = CanActionShowNotify(action) and config.notify == true,
            }
            count = count + 1
        end
    end
    if count == 0 then
        return {}
    end
    return payload
end

local function GetActionOptionTitle(action)
    local config = gProtIdEditSelected[action]
    if not config then
        return _t("protid.actions.action_off"):format(action)
    end

    return _t("protid.actions.action_notify_on"):format(action)
end

local function CycleActionState(action)
    local config = gProtIdEditSelected[action]

    if not config then
        gProtIdEditSelected[action] = { notify = CanActionShowNotify(action) }
        return
    end

    gProtIdEditSelected[action] = nil
end

local function NotifyProtId(key)
    TriggerEvent("Notify2", key)
end

local function NotifyResult(ok, errKey, successKey)
    if ok then
        NotifyProtId(successKey or "#protidSaved")
        return
    end
    NotifyProtId(errKey or "#protidFailed")
end

local OpenRootMenu
local OpenListMenu
local OpenEntryMenu
local OpenActionsMenu

local function RefreshListData()
    local result = lib.callback.await("admin:protectedClients:list", false)
    if not result then
        return false
    end

    gProtIdCityName = result.cityName or ""
    gProtIdActionList = result.actions or {}
    gProtIdNotifyActions = result.notifyActions or {}
    gProtIdEntries = result.entries or {}
    return true
end

OpenActionsMenu = function()
    local allSelected = AreAllActionsSelected()
    local options = {
        {
            title = allSelected and _t("protid.actions.all_on") or _t("protid.actions.all_off"),
            description = _t("protid.actions.all_desc"),
            icon = allSelected and "toggle-on" or "toggle-off",
            onSelect = function()
                if allSelected then
                    gProtIdEditSelected = {}
                else
                    gProtIdEditSelected = {}
                    for i = 1, #gProtIdActionList do
                        local action = gProtIdActionList[i]
                        gProtIdEditSelected[action] = { notify = CanActionShowNotify(action) }
                    end
                end
                OpenActionsMenu()
            end,
        },
    }

    for i = 1, #gProtIdActionList do
        local action = gProtIdActionList[i]
        local enabled = gProtIdEditSelected[action] ~= nil
        options[#options + 1] = {
            title = GetActionOptionTitle(action),
            icon = enabled and "check" or "xmark",
            onSelect = function()
                CycleActionState(action)
                OpenActionsMenu()
            end,
        }
    end

    options[#options + 1] = {
        title = _t("protid.actions.save"),
        description = _t("protid.actions.id_desc"):format(tostring(gProtIdEditPassport)),
        icon = "floppy-disk",
        onSelect = function()
            local payload = SelectedMapToActionsPayload()
            local count = 0
            for _ in pairs(payload) do
                count = count + 1
            end
            if count == 0 then
                NotifyProtId("#protidNoActions")
                OpenActionsMenu()
                return
            end

            local ok, errKey = lib.callback.await(
                "admin:protectedClients:upsert",
                false,
                gProtIdEditPassport,
                payload
            )
            NotifyResult(ok, errKey, "#protidSaved")
            if ok then
                OpenRootMenu()
            else
                OpenActionsMenu()
            end
        end,
    }

    lib.registerContext({
        id = ACTIONS_MENU_ID,
        title = _t("protid.actions.title"):format(tostring(gProtIdEditPassport)),
        menu = gProtIdActionsBackMenu,
        options = options,
    })
    lib.showContext(ACTIONS_MENU_ID)
end

OpenEntryMenu = function(passport)
    gProtIdEditPassport = passport

    local entryActions = {}
    for i = 1, #gProtIdEntries do
        if gProtIdEntries[i].passport == passport then
            entryActions = gProtIdEntries[i].actions
            break
        end
    end

    gProtIdEditSelected = ActionsToSelectedMap(entryActions)

    lib.registerContext({
        id = ENTRY_MENU_ID,
        title = _t("protid.entry.title"):format(tostring(passport)),
        menu = LIST_MENU_ID,
        options = {
            {
                title = _t("protid.entry.edit_actions"),
                description = _t("protid.entry.edit_actions_desc"),
                icon = "sliders",
                onSelect = function()
                    gProtIdActionsBackMenu = ENTRY_MENU_ID
                    OpenActionsMenu()
                end,
            },
            {
                title = _t("protid.entry.remove"),
                description = _t("protid.entry.remove_desc"),
                icon = "trash",
                onSelect = function()
                    local confirm = lib.alertDialog({
                        header = _t("protid.remove.confirm.title"),
                        content = _t("protid.remove.confirm.body"):format(tostring(passport)),
                        centered = true,
                        cancel = true,
                        labels = {
                            cancel = _t("ui.cancel"),
                            confirm = _t("ui.confirm"),
                        },
                    })
                    if confirm ~= "confirm" then
                        OpenEntryMenu(passport)
                        return
                    end

                    local ok, errKey = lib.callback.await("admin:protectedClients:remove", false, passport)
                    NotifyResult(ok, errKey, "#protidRemoved")
                    OpenListMenu()
                end,
            },
        },
    })
    lib.showContext(ENTRY_MENU_ID)
end

OpenListMenu = function()
    if not RefreshListData() then
        NotifyProtId("#protidNoPerm")
        return
    end

    local options = {}

    if #gProtIdEntries == 0 then
        options[#options + 1] = {
            title = _t("protid.list.empty"),
            description = _t("protid.list.empty_desc"),
            icon = "info",
            disabled = true,
        }
    else
        for i = 1, #gProtIdEntries do
            local entry = gProtIdEntries[i]
            options[#options + 1] = {
                title = _t("protid.entry.title"):format(tostring(entry.passport)),
                description = FormatActionsDescription(entry.actions),
                icon = "shield-halved",
                onSelect = function()
                    OpenEntryMenu(entry.passport)
                end,
            }
        end
    end

    lib.registerContext({
        id = LIST_MENU_ID,
        title = _t("protid.list.title"),
        menu = ROOT_MENU_ID,
        options = options,
    })
    lib.showContext(LIST_MENU_ID)
end

local function OpenAddIdFlow()
    local input = lib.inputDialog(_t("protid.add.dialog.heading"), {
        {
            type = "number",
            label = _t("protid.add.dialog.passport"),
            description = _t("protid.add.dialog.passport_desc"),
            required = true,
            min = 1,
        },
    })

    if not input or not input[1] then
        OpenRootMenu()
        return
    end

    local passport = math.floor(tonumber(input[1]) or 0)
    if passport <= 0 then
        NotifyProtId("#protidInvalidPassport")
        OpenRootMenu()
        return
    end

    gProtIdEditPassport = passport
    gProtIdEditSelected = {}
    gProtIdActionsBackMenu = ROOT_MENU_ID
    for i = 1, #gProtIdActionList do
        local action = gProtIdActionList[i]
        gProtIdEditSelected[action] = { notify = CanActionShowNotify(action) }
    end

    OpenActionsMenu()
end

OpenRootMenu = function()
    if not RefreshListData() then
        NotifyProtId("#protidNoPerm")
        return
    end

    lib.registerContext({
        id = ROOT_MENU_ID,
        title = _t("protid.root.title"):format(gProtIdCityName ~= "" and gProtIdCityName or "?"),
        options = {
            {
                title = _t("protid.add.title"),
                description = _t("protid.add.description"):format(gProtIdCityName ~= "" and gProtIdCityName or "?"),
                icon = "circle-plus",
                onSelect = function()
                    OpenAddIdFlow()
                end,
            },
            {
                title = _t("protid.edit_ids.title"),
                description = _t("protid.edit_ids.description"),
                icon = "pen-to-square",
                onSelect = function()
                    OpenListMenu()
                end,
            },
        },
    })
    lib.showContext(ROOT_MENU_ID)
end

RegisterCommand("staffprotid", function()
    local ok = lib.callback.await("admin:protectedClients:authorize", false)
    if not ok then
        NotifyProtId("#protidNoPerm")
        return
    end

    OpenRootMenu()
end, false)
