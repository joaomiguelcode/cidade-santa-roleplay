--- @type number
--- @field BankTransferCooldown number
local BankTransferCooldown = GetGameTimer()

--- @type number
--- @field BankTransferCooldownTime number
local BankTransferCooldownTime = 5

--- Register a NUI callback for bank actions.
--- @param Data table - The data sent from the client, containing Amount and Type.
--- @param Callback function - The callback function to return the result to the client.
RegisterNUICallback("bankAction", function(Data, Callback)
    --- @class BankActionData
    --- @field Amount number - The amount of money for the bank action.
    --- @field Type string - The type of bank action ("deposit" or "withdraw").
    
    if GetGameTimer() < BankTransferCooldown then
        local msg = (BankTransferCooldown - GetGameTimer()) / 1000
        msg = math.ceil(msg)
        TriggerEvent("Notify2","#bankTransferCooldown",{msg = msg})
        Callback(false)
        return
    end

    --- Convert Amount to number and remove any commas
    if type(Data.Amount) == "string" then
        Data.Amount = string.gsub(Data.Amount, ",", "")
    end

    local amount = tonumber(Data.Amount)
    if not amount then
        print("Error: Invalid amount received")
        Callback(false)
        return
    end
    
    --- Log the processed data for debugging purposes.
    print("bankAction >> ", json.encode({ Amount = amount, Type = Data.Type }))

    local success = vSERVER.Bank(amount, Data.Type)

    if success then
        BankTransferCooldown = GetGameTimer() + 1000 * BankTransferCooldownTime
    end

    Callback(success)
end)

---@param list any
---@return table
local function AsNuiArray(list)

    local array = setmetatable({}, { __jsontype = "array" })

    if type(list) ~= "table" then
        return array
    end

    for index = 1, #list do
        array[index] = list[index]
    end

    return array
end

---@param roles any
---@return table
local function NormalizeNuiRoles(roles)

    local list = {}

    if type(roles) == "table" then

        for _, role in pairs(roles) do

            if type(role) == "table" then
                local name = tostring(role.name or ""):gsub("^%s+", ""):gsub("%s+$", "")

                if name ~= "" then
                    list[#list + 1] = {
                        id = math.floor(tonumber(role.id) or 0),
                        name = name,
                        role = math.floor(tonumber(role.role) or 0),
                        canWithdraw = role.canWithdraw == true,
                    }
                end
            end
        end
    end

    table.sort(list, function(left, right)

        return left.role < right.role
    end)

    return AsNuiArray(list)
end

---@param players any
---@return table
local function NormalizeNuiPlayers(players)

    local list = {}

    if type(players) == "table" then

        for _, player in pairs(players) do

            if type(player) == "table" then
                local passport = math.floor(tonumber(player.passport) or 0)
                local name = tostring(player.name or ""):gsub("^%s+", ""):gsub("%s+$", "")
                local roleId = math.floor(tonumber(player.roleId) or 0)

                if passport > 0 and name ~= "" and roleId >= 0 then
                    list[#list + 1] = {
                        passport = passport,
                        name = name,
                        roleId = roleId,
                        canWithdraw = player.canWithdraw == true,
                    }
                end
            end
        end
    end

    return AsNuiArray(list)
end

RegisterNUICallback("getBankWithdrawSettingsVisibility", function(Data, Callback)

    local result = vSERVER.GetBankWithdrawSettingsVisibility(Data or {})

    Callback({
        visible = type(result) == "table" and result.visible == true,
    })
end)

RegisterNUICallback("getBankWithdrawPermissions", function(Data, Callback)

    local result = vSERVER.GetBankWithdrawPermissions(Data or {})

    if type(result) ~= "table" then
        Callback(false)

        return
    end

    Callback({
        canManage = result.canManage == true,
        roles = NormalizeNuiRoles(result.roles),
        players = NormalizeNuiPlayers(result.players),
    })
end)

RegisterNUICallback("setBankWithdrawPermissions", function(Data, Callback)

    local result = vSERVER.SetBankWithdrawPermissions(Data or {})

    Callback(result or { success = false })
end)

RegisterNUICallback("getBankWithdrawPlayer", function(Data, Callback)

    local result = vSERVER.GetBankWithdrawPlayer(Data or {})

    if result and result.player then
        Callback(result)

        return
    end

    Callback({ player = json.null })
end)