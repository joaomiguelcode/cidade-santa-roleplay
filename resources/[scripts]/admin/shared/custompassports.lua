cityName = GetConvar("cityName", "")

---@type table<string, table<number, string>>
customPassportsCitys = {
    ["CidadeNobre"] = {
        [75] = "JESUS",
        [269] = "Dead",
        [1533] = "Zé Pilintra",
        [50] = "Leoziinho",
        [45] = "decibel",
        [71] = "Igu",
    },
    ["Santa"] = {
        -- [2] = "Domn",
        [10] = "GIN",
        [15] = "VG",
        [50] = "Leoziinho",
        [75] = "JESUS",
        [45] = "decibel",
        [71] = "Igu",
        [1309] = "MIKE",
    },
    ["Grande"] = {
        [50] = "Leoziinho",
    },
    ["Maresia"] = {
        [50] = "Leoziinho",
    },
    ["District99"] = {
        [3333] = "ATL",
        [166640] = "Sera",
    },
}

---@type table<number, string>
customPassports = customPassportsCitys[cityName] or {}
---@type table<string, number>
customPassportsLabels = {}

CreateThread(function()
    for passport, customPassport in pairs(customPassports) do
        customPassportsLabels[customPassport] = passport
    end
end)

---Get the custom passport label for a given passport
---@param passport number
---@return string
function GetCustomPassportLabel(passport)
    return customPassports[passport]
end exports("GetCustomPassportLabel", GetCustomPassportLabel)

---Get the custom passport for a given label
---@param label string
---@return number
function GetCustomPassport(label)
    return customPassportsLabels[label]
end exports("GetCustomPassport", GetCustomPassport)
