-- ============================================================
--  Radio System — Client UI (oxlib inputDialog / alertDialog)
-- ============================================================

--- Duração (ms) da notificação de staff; pode ser redefinida no payload.
local STAFF_NOTIFY_DURATION_MS = 10000

--- Notificação (ox_lib) disparada do servidor (ex.: frequência duplicada).
RegisterNetEvent('radio:client:staffNotify', function(payload)
    if type(payload) ~= 'table' then
        return
    end
    local dur = tonumber(payload.duration)
    if not dur or dur < 1 then
        dur = STAFF_NOTIFY_DURATION_MS
    end
    lib.notify({
        title       = payload.title,
        description = payload.description,
        type        = payload.notifyType or 'error',
        duration    = dur,
    })
end)

---@param frequency number?
---@return table
local function staffFrequencySliderRow(frequency)
    if frequency then
        frequency = math.floor(frequency)
    end

    return {
        type        = 'number',
        label       = _t('radio.staff.create.dialog.frequency'),
        description = _t('radio.staff.create.dialog.frequency_slider_help'),
        --- ox_lib só lê `default` (SliderField + insert do form); `value` não é usado pela UI.
        default     = frequency,
        min         = RADIO_FREQ_MIN,
        max         = RADIO_FREQ_MAX,
        step        = 1,
        required    = true,
    }
end

--- Reabre o menu de staff após `inputDialog` cancelado (definido abaixo de `FORM_TO_MANAGE_RADIO`).
local showRadioRootMenu

--- Garante lista sequencial se o callback devolver object (chaves string) em vez de array.
---@param m { characterId: integer, fullName: string, isOwner: boolean }|nil|table
---@return { characterId: integer, fullName: string, isOwner: boolean }[]
local function normalizeMemberList(m)
    if not m or type(m) ~= 'table' then
        return {}
    end
    if #m > 0 then
        return m
    end
    local out = {}
    for _, v in pairs(m) do
        if type(v) == 'table' and v.characterId ~= nil then
            out[#out + 1] = v
        end
    end
    if #out == 0 then
        return {}
    end
    table.sort(out, function(a, b)
        return a.characterId < b.characterId
    end)
    return out
end

--- Monta o corpo do alerta (só nomes dos membros; o título do diálogo é o nome da rádio).
---@param members { characterId: integer, fullName: string, isOwner: boolean }[]|nil
---@return string
local function buildMemberListContent(members)
    members = normalizeMemberList(members)
    if #members == 0 then
        return _t('radio.staff.list.members.empty')
    end
    local contentParts = {}
    for i = 1, #members do
        local m = members[i]
        local suffix = m.isOwner and _t('radio.staff.list.members.owner_suffix') or ''
        contentParts[#contentParts + 1] = _t('radio.staff.list.members.line'):format(m.fullName, suffix)
    end
    return table.concat(contentParts, '  \n')
end

local function OpenCreateRadioForm()
    local result = lib.inputDialog(_t('radio.staff.create.dialog.heading'), {
        {
            type        = 'input',
            label       = _t('radio.staff.create.dialog.name'),
            placeholder = 'Rádio Cidade FM',
            required    = true,
            max         = RADIO_NAME_MAX_LEN,
        },
        staffFrequencySliderRow(nil),
        {
            type        = 'textarea',
            label       = _t('radio.staff.create.dialog.description'),
            placeholder = _t('radio.staff.create.dialog.description_placeholder'),
            required    = false,
            max         = RADIO_DESCRIPTION_MAX_LEN,
        },
        {
            type        = 'number',
            label       = _t('radio.staff.create.dialog.owner'),
            placeholder = '0',
            required    = true,
            min         = 1,
        },
    })

    if not result then
        return showRadioRootMenu()
    end

    local freq = result[2]

    if not freq then
        return showRadioRootMenu()
    end
    
    ---@type admin.radio.RadioCreatePayload
    local payload = {
        name                 = result[1],
        frequency            = result[2],
        description          = (result[3] ~= '' and result[3]) or nil,
        owner_character_id  = tonumber(result[4]),
    }

    TriggerServerEvent(RADIO_CONSTANTS.STAFF.CREATE, payload)
end

local function OpenDeleteRadioForm(radios)
    if not radios or #radios == 0 then
        lib.alertDialog({
            header  = _t('radio.staff.delete.dialog.heading'),
            content = _t('radio.staff.list.empty'),
            size    = 'sm',
        })
        return
    end

    local options = {}
    for i, radio in ipairs(radios) do
        options[i] = ('%s — %.1f MHz'):format(radio.name, radio.frequency)
    end

    local result = lib.inputDialog(_t('radio.staff.delete.dialog.heading'), {
        {
            type     = 'select',
            label    = _t('radio.staff.delete.dialog.select'),
            options  = (function()
                local mapped = {}
                for i, label in ipairs(options) do
                    mapped[i] = { value = tostring(radios[i].id), label = label }
                end
                return mapped
            end)(),
            required = true,
        },
    })

    if not result then
        return showRadioRootMenu()
    end

    local radioId = tonumber(result[1])
    if not radioId then return end

    local selectedLabel = ''
    for i, r in ipairs(radios) do
        if r.id == radioId then
            selectedLabel = options[i] or ''
            break
        end
    end

    local confirm = lib.alertDialog({
        header   = _t('radio.staff.delete.dialog.confirm.title'),
        content  = _t('radio.staff.delete.dialog.confirm.body'):format(selectedLabel),
        centered = true,
        size     = 'sm',
        cancel   = true,
        labels   = {
            cancel  = _t('ui.cancel'),
            confirm = _t('ui.confirm'),
        },
    })

    if confirm == 'confirm' then
        TriggerServerEvent(RADIO_CONSTANTS.STAFF.DELETE, radioId)
    end
end

local function OpenListRadiosForm(radios)
    if not radios or #radios == 0 then
        return lib.alertDialog({ header = _t('radio.staff.list.dialog.heading'), content = _t('radio.staff.list.empty'), size = 'md' })
    end

    local options = {}
    for _, radio in ipairs(radios) do
        local desc = _t('radio.staff.list.item.subtitle'):format(radio.frequency, radio.id)
        local more = radio.description and ('\n' .. radio.description) or ''
        options[#options + 1] = {
            title       = radio.name,
            description = desc .. more,
            icon        = 'radio',
            onSelect    = function()
                local data = lib.callback.await('radio:server:getRadioMembersForStaff', false, radio.id)
                if not data or not data.ok then
                    if data and data.err == 'not_found' then
                        lib.alertDialog({
                            header   = _t('radio.staff.list.dialog.heading'),
                            content  = _t('radio.error.not_found'),
                            size     = 'sm',
                            centered = true,
                        })
                    end
                    return
                end

                lib.alertDialog({
                    header   = radio.name,
                    content  = buildMemberListContent(data.members),
                    centered = true,
                    size     = 'md',
                    overflow = true,
                })
            end,
        }
    end

    lib.registerContext({
        id      = 'radio.staff.list.context',
        title   = _t('radio.staff.list.dialog.heading'),
        menu    = 'staff.manage.radio',
        options = options,
    })
    lib.showContext('radio.staff.list.context')
end

local function OpenEditRadioForm(radios)
    if not radios or #radios == 0 then
        lib.alertDialog({
            header  = _t('radio.staff.edit.dialog.heading'),
            content = _t('radio.staff.list.empty'),
            size    = 'sm',
        })
        return
    end

    local selectResult = lib.inputDialog(_t('radio.staff.edit.dialog.heading'), {
        {
            type     = 'select',
            label    = _t('radio.staff.edit.dialog.select'),
            options  = (function()
                local mapped = {}
                for i, radio in ipairs(radios) do
                    mapped[i] = {
                        value = tostring(radio.id),
                        label = ('%s — %.1f MHz'):format(radio.name, radio.frequency),
                    }
                end
                return mapped
            end)(),
            required = true,
        },
    })

    if not selectResult then
        return showRadioRootMenu()
    end

    local radioId = tonumber(selectResult[1])
    if not radioId then return end

    local selected
    for _, r in ipairs(radios) do
        if r.id == radioId then
            selected = r; break
        end
    end
    if not selected then return end

    local descPlaceholder = _t('radio.staff.create.dialog.description_placeholder')
    local editResult = lib.inputDialog(
        _t('radio.staff.edit.dialog.form.heading'):format(selected.name),
        {
            {
                type        = 'input',
                label       = _t('radio.staff.create.dialog.name'),
                default     = selected.name,
                placeholder = selected.name,
                required    = true,
                max         = RADIO_NAME_MAX_LEN,
            },
            staffFrequencySliderRow(selected.frequency),
            {
                type        = 'textarea',
                label       = _t('radio.staff.create.dialog.description'),
                default     = selected.description or '',
                placeholder = descPlaceholder,
                required    = false,
                max         = RADIO_DESCRIPTION_MAX_LEN,
            },
            {
                type        = 'number',
                label       = _t('radio.staff.edit.dialog.owner'),
                default     = (type(selected.owner_character_id) == 'number' and selected.owner_character_id) or nil,
                placeholder = '0',
                required    = true,
                min         = 1,
            },
        }
    )

    if not editResult then
        return showRadioRootMenu()
    end

    local rawFreq = tonumber(editResult[2])
    if not rawFreq or rawFreq ~= rawFreq then
        return showRadioRootMenu()
    end
    local editFreq = math.floor(rawFreq + 0.5)

    ---@type admin.radio.RadioEditPayload
    local payload = {
        id = radioId,
        name = editResult[1],
        frequency = editFreq,
        owner_character_id = tonumber(editResult[4]),
    }
    if editResult[3] ~= nil then
        payload.description = editResult[3] ~= '' and editResult[3] or false
    end

    TriggerServerEvent(RADIO_CONSTANTS.STAFF.EDIT, payload)
end

local FORM_TO_MANAGE_RADIO = {
    id      = 'staff.manage.radio',
    title   = _t('staff.manage.radio.title'),
    options = {
        {
            title       = _t('staff.manage.radio.create.title'),
            description = _t('staff.manage.radio.create.description'),
            icon        = 'circle-plus',
            onSelect    = function() OpenCreateRadioForm() end,
        },
        {
            title       = _t('staff.manage.radio.delete.title'),
            description = _t('staff.manage.radio.delete.description'),
            icon        = 'circle-minus',
            onSelect    = function()
                TriggerServerEvent(RADIO_CONSTANTS.STAFF.LIST)
                _pendingListAction = 'delete'
            end,
        },
        {
            title       = _t('staff.manage.radio.list.title'),
            description = _t('staff.manage.radio.list.description'),
            icon        = 'list-ul',
            onSelect    = function()
                TriggerServerEvent(RADIO_CONSTANTS.STAFF.LIST)
                _pendingListAction = 'list'
            end,
        },
        {
            title       = _t('staff.manage.radio.edit.title'),
            description = _t('staff.manage.radio.edit.description'),
            icon        = 'pencil',
            onSelect    = function()
                TriggerServerEvent(RADIO_CONSTANTS.STAFF.LIST)
                _pendingListAction = 'edit'
            end,
        },
    },
}

showRadioRootMenu = function()
    lib.registerContext(FORM_TO_MANAGE_RADIO)
    lib.showContext(FORM_TO_MANAGE_RADIO.id)
end

_pendingListAction = nil

RegisterNetEvent(RADIO_CONSTANTS.CB.LIST_RESULT, function(radios)
    local action = _pendingListAction
    _pendingListAction = nil

    if action == 'delete' then
        OpenDeleteRadioForm(radios)
    elseif action == 'list' then
        OpenListRadiosForm(radios)
    elseif action == 'edit' then
        OpenEditRadioForm(radios)
    end
end)

RegisterNetEvent('radio:client:kicked', function()
    lib.alertDialog({
        header  = _t('radio.member.kicked.title'),
        content = _t('radio.member.kicked.body'),
        size    = 'sm',
    })
end)

-- ============================================================
--  Minhas rádios: membro = entrar na frequência; dono = + gestão
--  Comando: /command.owner.radio (ver translations)
-- ============================================================

local openMyRadioSubmenu

---@param radio { name: string, frequency: number, isOwner: boolean, description: string? }  -- description ignorada no menu
local function buildRadioListItemDescription(radio)
    local freq = tonumber(radio.frequency) or 0
    local line = ('%.1f MHz'):format(freq)
    local role = (radio.isOwner and _t('radio.my.menu.badge_owner')) or ''
    if role ~= '' then
        return line .. '\n' .. role
    end
    return line
end

local function showMyRadioHub()
    local res = lib.callback.await('radio:server:getMyRadios', false)
    if not res or not res.ok then
        lib.alertDialog({
            header   = _t('radio.owner.menu.title'),
            content  = _t('radio.owner.error.nopassport'),
            centered = true,
            size     = 'sm',
        })
        return
    end
    if not res.radios or #res.radios == 0 then
        lib.alertDialog({
            header   = _t('radio.owner.menu.title'),
            content  = _t('radio.owner.menu.empty'),
            centered = true,
            size     = 'sm',
        })
        return
    end
    local options = {}
    for i = 1, #res.radios do
        local radio = res.radios[i]
        options[#options + 1] = {
            title       = radio.name,
            description = buildRadioListItemDescription(radio),
            icon        = 'radio',
            onSelect    = function()
                openMyRadioSubmenu(radio)
            end,
        }
    end
    lib.registerContext({
        id      = 'owner.radio.root',
        title   = _t('radio.owner.menu.title'),
        options = options,
    })
    lib.showContext('owner.radio.root')
end

openMyRadioSubmenu = function(radio)
    local function enterFrequency()
        local f = tonumber(radio.frequency) or radio.frequency
        if type(f) == 'number' and f > 0 then
            TriggerEvent('radio:EnterRadio', f)
        end
    end

    local options = {
        {
            title       = _t('radio.my.menu.enter'),
            description = _t('radio.my.menu.enter_desc'),
            icon        = 'headphones',
            onSelect    = enterFrequency,
        },
    }

    if not radio.isOwner then
        lib.registerContext({
            id      = 'my.radio.actions',
            title   = _t('radio.my.menu.subtitle'):format(radio.name),
            menu    = 'owner.radio.root',
            options = options,
        })
        lib.showContext('my.radio.actions')
        return
    end

    options[#options + 1] = {
        title       = _t('radio.owner.menu.list'),
        description = _t('radio.owner.menu.list_desc'),
        icon        = 'users',
        onSelect    = function()
            local data = lib.callback.await('radio:server:getRadioMembersForOwner', false, radio.id)
            if not data or not data.ok then
                if data and data.err == 'forbidden' then
                    lib.alertDialog({
                        header   = _t('radio.owner.menu.title'),
                        content  = _t('radio.owner.error.forbidden'),
                        size     = 'sm',
                        centered = true,
                    })
                end
                return
            end
            lib.alertDialog({
                header   = radio.name,
                content  = buildMemberListContent(data.members),
                centered = true,
                size     = 'md',
                overflow = true,
            })
        end,
    }
    options[#options + 1] = {
        title       = _t('radio.owner.menu.invite'),
        description = _t('radio.owner.menu.invite_desc'),
        icon        = 'user-plus',
        onSelect    = function()
            local result = lib.inputDialog(_t('radio.owner.ui.invite.heading'), {
                {
                    type        = 'number',
                    label       = _t('radio.owner.ui.invite.passport_label'),
                    placeholder = '0',
                    required    = true,
                    min         = 1,
                },
            })
            if not result then
                openMyRadioSubmenu(radio)
                return
            end
            local target = tonumber(result[1])
            if not target then
                openMyRadioSubmenu(radio)
                return
            end
            TriggerServerEvent(RADIO_CONSTANTS.OWNER.INVITE, { radioId = radio.id, targetCharId = target })
        end,
    }
    options[#options + 1] = {
        title       = _t('radio.owner.menu.kick'),
        description = _t('radio.owner.menu.kick_desc'),
        icon        = 'user-minus',
        onSelect    = function()
            local data = lib.callback.await('radio:server:getRadioMembersForOwner', false, radio.id)
            if not data or not data.ok then
                return
            end
            local list = normalizeMemberList(data.members)
            local kickOptions = {}
            for j = 1, #list do
                local mem = list[j]
                if not mem.isOwner then
                    kickOptions[#kickOptions + 1] = {
                        title       = mem.fullName,
                        description = _t('radio.owner.kick.id_line'):format(mem.characterId),
                        icon        = 'user',
                        onSelect    = function()
                            TriggerServerEvent(RADIO_CONSTANTS.OWNER.KICK, { radioId = radio.id, targetCharId = mem.characterId })
                        end,
                    }
                end
            end
            if #kickOptions == 0 then
                lib.alertDialog({
                    header   = _t('radio.owner.menu.kick'),
                    content  = _t('radio.owner.kick.none'),
                    size     = 'sm',
                    centered = true,
                })
                return
            end
            lib.registerContext({
                id      = 'my.radio.kick',
                title   = _t('radio.owner.menu.kick'),
                menu    = 'my.radio.actions',
                options = kickOptions,
            })
            lib.showContext('my.radio.kick')
        end,
    }

    lib.registerContext({
        id      = 'my.radio.actions',
        title   = _t('radio.my.menu.subtitle'):format(radio.name),
        menu    = 'owner.radio.root',
        options = options,
    })
    lib.showContext('my.radio.actions')
end

RegisterCommand(_t('command.owner.radio'), function()
    showMyRadioHub()
end, false)

RegisterCommand(_t('command.manage.radio'), function()
    local ok = lib.callback.await('radio:server:authorizeStaff', false)
    if not ok then return end
    showRadioRootMenu()
end, false)
